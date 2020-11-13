;
; AssemblerApplication1.asm
;
; Created: 7/11/2020 2:40:15 PM
; Author : imanz
;

.def temp = r16
.def b_pressed = r17 
.def eoReg = r18 

main:
		LDI		temp, 0xFE
		OUT		DDRC, temp					;set pinc (PC0) as input (push button pin)

        sbi     DDRB,PB0					;set PB0 as output (led pin)
		LDI		temp, 0b00011100			;Load the immedate value into register 17
		OUT		DDRD, temp					;set PD2,PD3,PD4

loop:   
        rcall   debounce					;call function debounce
        brcc    else						;check carry, if carry is clear, go to else.
        tst     b_pressed					;if b_pressed is not equal to 1
		brne    loop						;looping until button is pressed
		call	led1						;call function led1 (PB0)
		call	led2						;call function led2 (PD2)
		call	led3						;call function led3 (PD3)
		call	led4						;call function led4 (PD4)
		call	led3						;call function led3 (PD3)
		call	led2						;call function led2 (PD2)
        rjmp    loop						;continuous loop

else:
        ldi     b_pressed,0					;let b_pressed = 1
        rjmp	loop						

debounce:
		.equ	d_time = 1000				;set delay time
        sbic    PINC,pc0					;check PC0, if it is clear, skip bitset
        rjmp    bitSet						;jump to bitset if PC0 is set
        ldi     r25,high(d_time)			;set max time
        ldi     r24,low(d_time)				;set min time
delay:  
		sbiw    r25:r24,1					;subtract value
        brne    delay				
        sbic    PINC,PC0					;button still pressed?
        rjmp    bitSet
        sec									;set carry
        ret 

bitSet:
        clc									;clear carry
        ret

led1:	
		in      temp,PORTB					;read current state portb
        ldi     eoReg,(1 << PB0)			;set PB0 in eoReg
        eor     temp,eoReg					;xor eoReg and temp (toggle led1 state)
        out     PORTB,temp					
		call	delay_led
		cbi		portb,0						;off led1
		ret

led2:
		in      temp,PORTD					;read current state portd
        ldi     eoReg,(1 << PD2)			;set PD2 in eoReg
        eor     temp,eoReg					;xor eoReg and temp (toggle led2 state)
        out     PORTD,temp
		call	delay_led
		cbi		portd,2						;off led2
		ret

led3:
		in      temp,PORTD					;read current state portd
        ldi     eoReg,(1 << PD3)			;set PD3 in eoReg
        eor     temp,eoReg					;xor eoReg and temp (toggle led3 state)
        out     PORTD,temp
		call	delay_led
		cbi		portd,3						;off led3
		ret

led4:
		in      temp,PORTD					;read current state portd
        ldi     eoReg,(1 << PD4)			;set PD4 in eoReg
        eor     temp,eoReg					;xor eoReg and temp (toggle led4 state)
        out     PORTD,temp
		call	delay_led
		cbi		portd,4						;off led3
		ret

delay_led:									;delay loop
		 LDI	R24,50
		 LDI	R23,100
		 LDI	R22,10

L1: 
		 DEC	R22
		 BRNE	L1
		 DEC	R23
		 BRNE	L1
		 DEC	R24
		 BRNE	L1
		 NOP
		 RET