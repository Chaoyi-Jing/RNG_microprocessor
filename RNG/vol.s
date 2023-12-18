#include <xc.inc>

global  Voltage_Setup ;, Voltage_Comparator
    
psect	vol_code, class=CODE
    
Voltage_Setup:
	;clrf TRISA ; refernce voltage setup
	;bsf  TRISA, A
	    
	;bsf TRISA, 3 ;V_ref +
	;bsf TRIS2, 2 ; V_ref -
	
	
	; set up voltage ref pg365
	; set V_ref to be half of v_ref+ and v_ref-
	; binary 10000
	
	; should give 2.5V 
	banksel CVRCON
	bsf CVRCON, 7 ; vref power on
	bsf CVRCON, 6 ; output enable, RF5
	bcf CVRCON, 5 ; use reference source
	bsf CVRCON, 4 ; hex 10000, being 16, halves internal v of 5V
	bcf CVRCON, 3
	bcf CVRCON, 2
	bcf CVRCON, 1
	bcf CVRCON, 0
	return
	