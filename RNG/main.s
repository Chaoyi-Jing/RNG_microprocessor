#include <xc.inc>

;extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex ; external LCD subroutines
;extrn	ADC_Setup, ADC_Read		   ; external ADC subroutines
   
    
extrn	Voltage_Setup
extrn	Comparator_Setup, ANSEL_Setup
extrn	UART_Setup, UART_Transmit_Message, UART_Transmit_Byte  ; external uart subroutines
global RESULT, COMPARISON_RESULT, COMPARISON_RESULT
	
psect	udata_acs   ; reserve data space in access ram

delay_count:ds 1    ; reserve one byte for counter in the delay routine
delay_count1: ds 1
RESULT: ds 1
COMPARISON_RESULT: ds 1

psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
; Define global variables
COMPARISON_BIT equ 0


psect code, abs

org 0x0000
 rst: goto 0x100

 org  0x100
start:
   
    setf TRISF, A ; set all pins as tristate
    clrf LATF, A
    
    bcf TRISF, 1 ;c2out
    bcf TRISF, 2
    bcf TRISF, 5
    ;bsf TRISF, 3   8
    bcf TRISD, 0
    
    bcf CFGS
    bsf EEPGD
    
    
    call Comparator_Setup
    call ANSEL_Setup
    call Voltage_Setup
    call UART_Setup
    call loop

    
loopit:    
    call loop
    goto loopit    
    

Read_Comparator:
    ; need to put delay loops in here 
    ;compare the pins voltage
    
    call Delay
    
    
    ; Implement comparison with Vref here.
    btfsc CMP2OUT
    bra	  zero_bit
    bsf COMPARISON_RESULT, COMPARISON_BIT, A ; If high, 1
    bsf RD0
    movlw 0x31 ; load ASCII 1 in w reg '1'
    return
zero_bit:
    bcf COMPARISON_RESULT, COMPARISON_BIT, A ; If low, 0
    bcf RD0
    movlw 0x30 ; load ASCII 0
    return

loop:
    ;call Delay
    call Read_Comparator
    call UART_Transmit_Byte
    movlw 0x0A ; put space in between ascii ' '
    call UART_Transmit_Byte
    return
    
    
Delay:
    movlw 255
    movwf delay_count, A
Delayloop:
    decfsz delay_count, A
    return
    movlw 255
    movwf delay_count1, A
    call delay_loop  
    bra Delayloop
           
    
delay_loop:
    decfsz delay_count1, A 
    bra delay_loop       
    return                                                                                                                                                        
         


