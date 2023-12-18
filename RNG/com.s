#include <xc.inc>
    
global Comparator_Setup, ANSEL_Setup

; psect	udata_acs   ; reserve data space in access ram
psect	com_code,class=CODE
    
; ref voltage, 2.5V
; if want to output has to be PORTF pin 5

Comparator_Setup:
    ; port F C1IB5/pin 5
    banksel CM2CON
    bsf CM2CON, 7 ; Enable the comparator
    bsf CM2CON, 6 ; output shown on c2out, pin RF1
    bcf CM2CON, 5 ; non inverted
    bcf CM2CON, 4 ; no interupt
    bcf CM2CON, 3
    bsf CM2CON, 2 ; set ref v
    bsf CM2CON, 1 ; pin 5 compare
    bcf CM2CON, 0 ; CxIND  RH5 pin 3, Vin-
    banksel 0
    return
    
ANSEL_Setup:
    ; need to pick a ansel from ancon
    ;bcf ANSEL7
    ;bcf ANSEL, 6
    banksel ANCON1
    bsf ANSEL6
    bsf ANSEL9
    bsf ANSEL10 ;enable bit 5 to be analogue input
    bsf ANSEL13
    banksel 0
    ;bcf ANSEL, 4 ; rest digital
    ;bcf ANSEL, 3
    ;bcf ANSEL, 2
    ;bcf ANSEL, 1
    ;bcf ANSEL, 0
    return