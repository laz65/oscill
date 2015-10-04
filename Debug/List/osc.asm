
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R3
	.DEF _i_msb=R4
	.DEF _a=R5
	.DEF _a_msb=R6
	.DEF _n=R7
	.DEF _n_msb=R8

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _twi_int_handler
	JMP  0x00

_0x3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x80
	.DB  0x80,0x80,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0x80,0xC0,0xC0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x80,0xC0,0xE0,0xF0
	.DB  0xF8,0xFC,0xF8,0xE0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0x80,0x80
	.DB  0x80,0x80,0x0,0x80,0x80,0x0,0x0,0x0
	.DB  0x0,0x80,0x80,0x80,0x80,0x80,0x0,0xFF
	.DB  0xFF,0xFF,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x80,0x80,0x0,0x0,0x80,0x80,0x0,0x0
	.DB  0x80,0xFF,0xFF,0x80,0x80,0x0,0x80,0x80
	.DB  0x0,0x80,0x80,0x80,0x80,0x0,0x80,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0x80,0x0
	.DB  0x0,0x8C,0x8E,0x84,0x0,0x0,0x80,0xF8
	.DB  0xF8,0xF8,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0xF0,0xF0,0xF0,0xF0,0xF0,0xF0,0xF0,0xF0
	.DB  0xF0,0xF0,0xF0,0xF0,0xE0,0xE0,0xC0,0x80
	.DB  0x0,0xE0,0xFC,0xFE,0xFF,0xFF,0xFF,0x7F
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFE,0xFF,0xC7,0x1,0x1
	.DB  0x1,0x1,0x83,0xFF,0xFF,0x0,0x0,0x7C
	.DB  0xFE,0xC7,0x1,0x1,0x1,0x1,0x83,0xFF
	.DB  0xFF,0xFF,0x0,0x38,0xFE,0xC7,0x83,0x1
	.DB  0x1,0x1,0x83,0xC7,0xFF,0xFF,0x0,0x0
	.DB  0x1,0xFF,0xFF,0x1,0x1,0x0,0xFF,0xFF
	.DB  0x7,0x1,0x1,0x1,0x0,0x0,0x7F,0xFF
	.DB  0x80,0x0,0x0,0x0,0xFF,0xFF,0x7F,0x0
	.DB  0x0,0xFF,0xFF,0xFF,0x0,0x0,0x1,0xFF
	.DB  0xFF,0xFF,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x3,0xF,0x3F,0x7F,0x7F,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xE7,0xC7,0xC7,0x8F
	.DB  0x8F,0x9F,0xBF,0xFF,0xFF,0xC3,0xC0,0xF0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFC,0xFC,0xFC
	.DB  0xFC,0xFC,0xFC,0xFC,0xFC,0xF8,0xF8,0xF0
	.DB  0xF0,0xE0,0xC0,0x0,0x1,0x3,0x3,0x3
	.DB  0x3,0x3,0x1,0x3,0x3,0x0,0x0,0x0
	.DB  0x0,0x1,0x3,0x3,0x3,0x3,0x1,0x1
	.DB  0x3,0x1,0x0,0x0,0x0,0x1,0x3,0x3
	.DB  0x3,0x3,0x1,0x1,0x3,0x3,0x0,0x0
	.DB  0x0,0x3,0x3,0x0,0x0,0x0,0x3,0x3
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x3,0x3,0x3,0x3,0x3,0x1,0x0,0x0
	.DB  0x0,0x1,0x3,0x1,0x0,0x0,0x0,0x3
	.DB  0x3,0x1,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x80,0xC0,0xE0,0xF0,0xF9
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x3F,0x1F,0xF
	.DB  0x87,0xC7,0xF7,0xFF,0xFF,0x1F,0x1F,0x3D
	.DB  0xFC,0xF8,0xF8,0xF8,0xF8,0x7C,0x7D,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x7F
	.DB  0x3F,0xF,0x7,0x0,0x30,0x30,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xFE,0xFE,0xFC,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xE0,0xC0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x30,0x30,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xC0,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x7F,0x7F,0x3F,0x1F
	.DB  0xF,0x7,0x1F,0x7F,0xFF,0xFF,0xF8,0xF8
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xF8,0xE0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xFE,0xFE,0x0,0x0
	.DB  0x0,0xFC,0xFE,0xFC,0xC,0x6,0x6,0xE
	.DB  0xFC,0xF8,0x0,0x0,0xF0,0xF8,0x1C,0xE
	.DB  0x6,0x6,0x6,0xC,0xFF,0xFF,0xFF,0x0
	.DB  0x0,0xFE,0xFE,0x0,0x0,0x0,0x0,0xFC
	.DB  0xFE,0xFC,0x0,0x18,0x3C,0x7E,0x66,0xE6
	.DB  0xCE,0x84,0x0,0x0,0x6,0xFF,0xFF,0x6
	.DB  0x6,0xFC,0xFE,0xFC,0xC,0x6,0x6,0x6
	.DB  0x0,0x0,0xFE,0xFE,0x0,0x0,0xC0,0xF8
	.DB  0xFC,0x4E,0x46,0x46,0x46,0x4E,0x7C,0x78
	.DB  0x40,0x18,0x3C,0x76,0xE6,0xCE,0xCC,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x7,0xF,0x1F
	.DB  0x1F,0x3F,0x3F,0x3F,0x3F,0x1F,0xF,0x3
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xF,0xF,0x0,0x0
	.DB  0x0,0xF,0xF,0xF,0x0,0x0,0x0,0x0
	.DB  0xF,0xF,0x0,0x0,0x3,0x7,0xE,0xC
	.DB  0x18,0x18,0xC,0x6,0xF,0xF,0xF,0x0
	.DB  0x0,0x1,0xF,0xE,0xC,0x18,0xC,0xF
	.DB  0x7,0x1,0x0,0x4,0xE,0xC,0x18,0xC
	.DB  0xF,0x7,0x0,0x0,0x0,0xF,0xF,0x0
	.DB  0x0,0xF,0xF,0xF,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xF,0xF,0x0,0x0,0x0,0x7
	.DB  0x7,0xC,0xC,0x18,0x1C,0xC,0x6,0x6
	.DB  0x0,0x4,0xE,0xC,0x18,0xC,0xF,0x7
_0x4:
	.DB  0x80,0xAE,0x80,0xD5,0x80,0x80,0x80,0xA8
	.DB  0x80,0x3F,0x80,0xD3,0x80,0x0,0x80,0x40
	.DB  0x80,0x8D,0x80,0x14,0x80,0x20,0x80,0x0
	.DB  0x80,0xA1,0x80,0xC8,0x80,0xDA,0x80,0x12
	.DB  0x80,0x81,0x80,0xCF,0x80,0xD9,0x80,0xF1
	.DB  0x80,0xDB,0x80,0x40,0x80,0xA4,0x80,0xA6
	.DB  0x80,0xAF
_0x2000003:
	.DB  0x7

__GLOBAL_INI_TBL:
	.DW  0x380
	.DW  _buffer
	.DW  _0x3*2

	.DW  0x32
	.DW  _tx_data0
	.DW  _0x4*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 04.02.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;// Declare your global variables here
;int i,a,n;
;unsigned char buffer[1024] =  {
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
;0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x80, 0x80, 0xC0, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xF8, 0xE0, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80,
;0x80, 0x80, 0x00, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0x80, 0x80, 0x00, 0xFF,
;0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0x80, 0x00, 0x00, 0x80, 0x80, 0x00, 0x00,
;0x80, 0xFF, 0xFF, 0x80, 0x80, 0x00, 0x80, 0x80, 0x00, 0x80, 0x80, 0x80, 0x80, 0x00, 0x80, 0x80,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x00, 0x00, 0x8C, 0x8E, 0x84, 0x00, 0x00, 0x80, 0xF8,
;0xF8, 0xF8, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xF0, 0xE0, 0xE0, 0xC0, 0x80,
;0x00, 0xE0, 0xFC, 0xFE, 0xFF, 0xFF, 0xFF, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0xC7, 0x01, 0x01,
;0x01, 0x01, 0x83, 0xFF, 0xFF, 0x00, 0x00, 0x7C, 0xFE, 0xC7, 0x01, 0x01, 0x01, 0x01, 0x83, 0xFF,
;0xFF, 0xFF, 0x00, 0x38, 0xFE, 0xC7, 0x83, 0x01, 0x01, 0x01, 0x83, 0xC7, 0xFF, 0xFF, 0x00, 0x00,
;0x01, 0xFF, 0xFF, 0x01, 0x01, 0x00, 0xFF, 0xFF, 0x07, 0x01, 0x01, 0x01, 0x00, 0x00, 0x7F, 0xFF,
;0x80, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x7F, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x01, 0xFF,
;0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x03, 0x0F, 0x3F, 0x7F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xE7, 0xC7, 0xC7, 0x8F,
;0x8F, 0x9F, 0xBF, 0xFF, 0xFF, 0xC3, 0xC0, 0xF0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xFC, 0xFC,
;0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xF8, 0xF8, 0xF0, 0xF0, 0xE0, 0xC0, 0x00, 0x01, 0x03, 0x03, 0x03,
;0x03, 0x03, 0x01, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03, 0x03, 0x03, 0x01, 0x01,
;0x03, 0x01, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03, 0x03, 0x03, 0x01, 0x01, 0x03, 0x03, 0x00, 0x00,
;0x00, 0x03, 0x03, 0x00, 0x00, 0x00, 0x03, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
;0x03, 0x03, 0x03, 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x01, 0x03, 0x01, 0x00, 0x00, 0x00, 0x03,
;0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0xF9, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3F, 0x1F, 0x0F,
;0x87, 0xC7, 0xF7, 0xFF, 0xFF, 0x1F, 0x1F, 0x3D, 0xFC, 0xF8, 0xF8, 0xF8, 0xF8, 0x7C, 0x7D, 0xFF,
;0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x0F, 0x07, 0x00, 0x30, 0x30, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0xFE, 0xFE, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0xC0, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x30, 0x30, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0xC0, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x7F, 0x3F, 0x1F,
;0x0F, 0x07, 0x1F, 0x7F, 0xFF, 0xFF, 0xF8, 0xF8, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xF8, 0xE0,
;0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0xFE, 0x00, 0x00,
;0x00, 0xFC, 0xFE, 0xFC, 0x0C, 0x06, 0x06, 0x0E, 0xFC, 0xF8, 0x00, 0x00, 0xF0, 0xF8, 0x1C, 0x0E,
;0x06, 0x06, 0x06, 0x0C, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0xFE, 0xFE, 0x00, 0x00, 0x00, 0x00, 0xFC,
;0xFE, 0xFC, 0x00, 0x18, 0x3C, 0x7E, 0x66, 0xE6, 0xCE, 0x84, 0x00, 0x00, 0x06, 0xFF, 0xFF, 0x06,
;0x06, 0xFC, 0xFE, 0xFC, 0x0C, 0x06, 0x06, 0x06, 0x00, 0x00, 0xFE, 0xFE, 0x00, 0x00, 0xC0, 0xF8,
;0xFC, 0x4E, 0x46, 0x46, 0x46, 0x4E, 0x7C, 0x78, 0x40, 0x18, 0x3C, 0x76, 0xE6, 0xCE, 0xCC, 0x80,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x01, 0x07, 0x0F, 0x1F, 0x1F, 0x3F, 0x3F, 0x3F, 0x3F, 0x1F, 0x0F, 0x03,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00, 0x00,
;0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00, 0x00, 0x03, 0x07, 0x0E, 0x0C,
;0x18, 0x18, 0x0C, 0x06, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x01, 0x0F, 0x0E, 0x0C, 0x18, 0x0C, 0x0F,
;0x07, 0x01, 0x00, 0x04, 0x0E, 0x0C, 0x18, 0x0C, 0x0F, 0x07, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00,
;0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x07,
;0x07, 0x0C, 0x0C, 0x18, 0x1C, 0x0C, 0x06, 0x06, 0x00, 0x04, 0x0E, 0x0C, 0x18, 0x0C, 0x0F, 0x07,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
;}, rx_data[1],bufer[129], tx_data0[50] = {0x80, 0xAE, 0x80, 0xD5,0x80, 0x80,0x80, 0xA8,0x80, 0x3F,0x80, 0xD3,

	.DSEG
;0x80, 0x0,0x80, 0x40,0x80, 0x8D,0x80, 0x14,0x80, 0x20,0x80, 0x00,0x80,  0xA1, 0x80, 0xC8,0x80,
;0xDA,0x80, 0x12,0x80, 0x81,0x80, 0xCF,0x80, 0xD9,0x80, 0xF1,0x80, 0xDB,0x80, 0x40,0x80, 0xA4,
;0x80, 0xA6, 0x80, 0xAF };
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0067 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0068 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	STS  124,R30
; 0000 0069 // Delay needed for the stabilization of the ADC input voltage
; 0000 006A delay_us(10);
	__DELAY_USB 27
; 0000 006B // Start the AD conversion
; 0000 006C ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 006D // Wait for the AD conversion to complete
; 0000 006E while ((ADCSRA & (1<<ADIF))==0);
_0x5:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x5
; 0000 006F ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 0070 return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	ADIW R28,1
	RET
; 0000 0071 }
; .FEND
;
;
;// TWI functions
;#include <twi.h>
;
;void clearDisplay(void)
; 0000 0078 {
_clearDisplay:
; .FSTART _clearDisplay
; 0000 0079     for(i=0; i<1024;i++) buffer[i] = 0;
	CLR  R3
	CLR  R4
_0x9:
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	CP   R3,R30
	CPC  R4,R31
	BRGE _0xA
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R3
	ADC  R27,R4
	ST   X,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	RJMP _0x9
_0xA:
; 0000 007A }
	RET
; .FEND
;
;void display(void)
; 0000 007D {
_display:
; .FSTART _display
; 0000 007E     bufer[0] = 0x80;
	LDI  R30,LOW(128)
	STS  _bufer,R30
; 0000 007F     bufer[1] = 0x21;
	LDI  R30,LOW(33)
	__PUTB1MN _bufer,1
; 0000 0080     bufer[2] = 0x80;
	LDI  R30,LOW(128)
	__PUTB1MN _bufer,2
; 0000 0081     bufer[3] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _bufer,3
; 0000 0082     bufer[4] = 0x80;
	LDI  R30,LOW(128)
	__PUTB1MN _bufer,4
; 0000 0083     bufer[5] = 127;
	LDI  R30,LOW(127)
	__PUTB1MN _bufer,5
; 0000 0084     bufer[6] = 0x80;
	LDI  R30,LOW(128)
	__PUTB1MN _bufer,6
; 0000 0085     bufer[7] = 0x22;
	LDI  R30,LOW(34)
	__PUTB1MN _bufer,7
; 0000 0086     bufer[8] = 0x80;
	LDI  R30,LOW(128)
	__PUTB1MN _bufer,8
; 0000 0087     bufer[9] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _bufer,9
; 0000 0088     bufer[10] = 0x80;
	LDI  R30,LOW(128)
	__PUTB1MN _bufer,10
; 0000 0089     bufer[11] = 7  ;
	LDI  R30,LOW(7)
	__PUTB1MN _bufer,11
; 0000 008A     twi_master_trans(0x3C, bufer, 12, rx_data, 0) ;
	CALL SUBOPT_0x0
	LDI  R30,LOW(12)
	CALL SUBOPT_0x1
; 0000 008B 
; 0000 008C        for (i=0; i<1024; ) {
	CLR  R3
	CLR  R4
_0xC:
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	CP   R3,R30
	CPC  R4,R31
	BRGE _0xD
; 0000 008D       // send a bunch of data in one xmission
; 0000 008E         bufer[0] = 0x40;
	LDI  R30,LOW(64)
	STS  _bufer,R30
; 0000 008F         for (n=0; n<128; n++) {
	CLR  R7
	CLR  R8
_0xF:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R7,R30
	CPC  R8,R31
	BRGE _0x10
; 0000 0090         bufer[n+1] = buffer[i++];
	__GETW1R 7,8
	__ADDW1MN _bufer,1
	MOVW R26,R30
	__GETW1R 3,4
	ADIW R30,1
	__PUTW1R 3,4
	SBIW R30,1
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LD   R30,Z
	ST   X,R30
; 0000 0091         }
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
	RJMP _0xF
_0x10:
; 0000 0092 
; 0000 0093         twi_master_trans(0x3C, bufer, 129, rx_data, 0) ;
	CALL SUBOPT_0x0
	LDI  R30,LOW(129)
	CALL SUBOPT_0x1
; 0000 0094     }
	RJMP _0xC
_0xD:
; 0000 0095 }
	RET
; .FEND
;
;
;
;
;
;
;
;void drawPixel(int x, int y, int color) {
; 0000 009D void drawPixel(int x, int y, int color) {
_drawPixel:
; .FSTART _drawPixel
; 0000 009E   if ((x < 0) || (x >= 128) || (y < 0) || (y >= 64))
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+4
;	y -> Y+2
;	color -> Y+0
	LDD  R26,Y+5
	TST  R26
	BRMI _0x12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRGE _0x12
	LDD  R26,Y+3
	TST  R26
	BRMI _0x12
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x11
_0x12:
; 0000 009F     return;
	RJMP _0x2040003
; 0000 00A0 
; 0000 00A1   // check rotation, move pixel around if necessary
; 0000 00A2 
; 0000 00A3 //    swap(x, y);
; 0000 00A4 //    x = WIDTH - x - 1;
; 0000 00A5 
; 0000 00A6 
; 0000 00A7     x = 128 - x - 1;
_0x11:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	SUB  R30,R26
	SBC  R31,R27
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00A8     y = 64 - y - 1;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	SUB  R30,R26
	SBC  R31,R27
	SBIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00A9 
; 0000 00AA //    swap(x, y);
; 0000 00AB //    y = 64 - y - 1;
; 0000 00AC 
; 0000 00AD 
; 0000 00AE 
; 0000 00AF   // x is which column
; 0000 00B0     switch (color)
	LD   R30,Y
	LDD  R31,Y+1
; 0000 00B1     {
; 0000 00B2       case 1:   buffer[x+ (y/8)*128] |=  (1 << (y&7)); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17
	CALL SUBOPT_0x2
	OR   R30,R1
	RJMP _0x2A
; 0000 00B3       case 0:   buffer[x+ (y/8)*128] &= ~(1 << (y&7)); break;
_0x17:
	SBIW R30,0
	BRNE _0x18
	CALL SUBOPT_0x2
	COM  R30
	AND  R30,R1
	RJMP _0x2A
; 0000 00B4       case 2:  buffer[x+ (y/8)*128] ^=  (1 << (y&7)); break;
_0x18:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x16
	CALL SUBOPT_0x2
	EOR  R30,R1
_0x2A:
	MOVW R26,R22
	ST   X,R30
; 0000 00B5     }
_0x16:
; 0000 00B6 
; 0000 00B7 }
_0x2040003:
	ADIW R28,6
	RET
; .FEND
;
;void main(void)
; 0000 00BA {
_main:
; .FSTART _main
; 0000 00BB // Declare your local variables here
; 0000 00BC int x=0,y;
; 0000 00BD // Crystal Oscillator division factor: 1
; 0000 00BE #pragma optsize-
; 0000 00BF CLKPR=(1<<CLKPCE);
;	x -> R16,R17
;	y -> R18,R19
	__GETWRN 16,17,0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00C0 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00C1 #ifdef _OPTIMIZE_SIZE_
; 0000 00C2 #pragma optsize+
; 0000 00C3 #endif
; 0000 00C4 
; 0000 00C5 // Input/Output Ports initialization
; 0000 00C6 // Port B initialization
; 0000 00C7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C8 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (3<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(24)
	OUT  0x4,R30
; 0000 00C9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CA PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 00CB 
; 0000 00CC // Port C initialization
; 0000 00CD // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CE DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x7,R30
; 0000 00CF // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D0 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x8,R30
; 0000 00D1 
; 0000 00D2 // Port D initialization
; 0000 00D3 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D4 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 00D5 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D6 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00D7 
; 0000 00D8 // Timer/Counter 0 initialization
; 0000 00D9 // Clock source: System Clock
; 0000 00DA // Clock value: Timer 0 Stopped
; 0000 00DB // Mode: Normal top=0xFF
; 0000 00DC // OC0A output: Disconnected
; 0000 00DD // OC0B output: Disconnected
; 0000 00DE TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 00DF TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 00E0 TCNT0=0x00;
	OUT  0x26,R30
; 0000 00E1 OCR0A=0x00;
	OUT  0x27,R30
; 0000 00E2 OCR0B=0x00;
	OUT  0x28,R30
; 0000 00E3 
; 0000 00E4 // Timer/Counter 1 initialization
; 0000 00E5 // Clock source: System Clock
; 0000 00E6 // Clock value: Timer1 Stopped
; 0000 00E7 // Mode: Normal top=0xFFFF
; 0000 00E8 // OC1A output: Disconnected
; 0000 00E9 // OC1B output: Disconnected
; 0000 00EA // Noise Canceler: Off
; 0000 00EB // Input Capture on Falling Edge
; 0000 00EC // Timer1 Overflow Interrupt: Off
; 0000 00ED // Input Capture Interrupt: Off
; 0000 00EE // Compare A Match Interrupt: Off
; 0000 00EF // Compare B Match Interrupt: Off
; 0000 00F0 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00F1 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00F2 TCNT1H=0x00;
	STS  133,R30
; 0000 00F3 TCNT1L=0x00;
	STS  132,R30
; 0000 00F4 ICR1H=0x00;
	STS  135,R30
; 0000 00F5 ICR1L=0x00;
	STS  134,R30
; 0000 00F6 OCR1AH=0x00;
	STS  137,R30
; 0000 00F7 OCR1AL=0x00;
	STS  136,R30
; 0000 00F8 OCR1BH=0x00;
	STS  139,R30
; 0000 00F9 OCR1BL=0x00;
	STS  138,R30
; 0000 00FA 
; 0000 00FB // Timer/Counter 2 initialization
; 0000 00FC // Clock source: System Clock
; 0000 00FD // Clock value: 16000,000 kHz
; 0000 00FE // Mode: Fast PWM top=0xFF
; 0000 00FF // OC2A output: Non-Inverted PWM
; 0000 0100 // OC2B output: Non-Inverted PWM
; 0000 0101 // Timer Period: 0,016 ms
; 0000 0102 // Output Pulse(s):
; 0000 0103 // OC2A Period: 0,016 ms Width: 0 us
; 0000 0104 // OC2B Period: 0,016 ms Width: 0 us
; 0000 0105 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0106 TCCR2A=(1<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
	LDI  R30,LOW(163)
	STS  176,R30
; 0000 0107 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
	LDI  R30,LOW(1)
	STS  177,R30
; 0000 0108 TCNT2=0x00;
	LDI  R30,LOW(0)
	STS  178,R30
; 0000 0109 OCR2A=0x00;
	CALL SUBOPT_0x3
; 0000 010A OCR2B=0x00;
; 0000 010B 
; 0000 010C // Timer/Counter 0 Interrupt(s) initialization
; 0000 010D TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	LDI  R30,LOW(0)
	STS  110,R30
; 0000 010E 
; 0000 010F // Timer/Counter 1 Interrupt(s) initialization
; 0000 0110 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	STS  111,R30
; 0000 0111 
; 0000 0112 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0113 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 0114 
; 0000 0115 // External Interrupt(s) initialization
; 0000 0116 // INT0: Off
; 0000 0117 // INT1: Off
; 0000 0118 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0119 // Interrupt on any change on pins PCINT8-14: Off
; 0000 011A // Interrupt on any change on pins PCINT16-23: Off
; 0000 011B EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 011C EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 011D PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 011E 
; 0000 011F // USART initialization
; 0000 0120 // USART disabled
; 0000 0121 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 0122 
; 0000 0123 // Analog Comparator initialization
; 0000 0124 // Analog Comparator: Off
; 0000 0125 // The Analog Comparator's positive input is
; 0000 0126 // connected to the AIN0 pin
; 0000 0127 // The Analog Comparator's negative input is
; 0000 0128 // connected to the AIN1 pin
; 0000 0129 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 012A ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 012B // Digital input buffer on AIN0: On
; 0000 012C // Digital input buffer on AIN1: On
; 0000 012D DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 012E 
; 0000 012F // ADC initialization
; 0000 0130 // ADC disabled
; 0000 0131 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 0132 
; 0000 0133 // SPI initialization
; 0000 0134 // SPI disabled
; 0000 0135 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0136 
; 0000 0137 
; 0000 0138 // ADC initialization
; 0000 0139 // ADC Clock frequency: 1000,000 kHz
; 0000 013A // ADC Voltage Reference: AVCC pin
; 0000 013B // ADC Auto Trigger Source: ADC Stopped
; 0000 013C // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 013D // ADC4: On, ADC5: On
; 0000 013E DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 013F ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 0140 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 0141 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0142 
; 0000 0143 
; 0000 0144 // TWI initialization
; 0000 0145 // Mode: TWI Master
; 0000 0146 // Bit Rate: 400 kHz
; 0000 0147 twi_master_init(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _twi_master_init
; 0000 0148 
; 0000 0149 // Global enable interrupts
; 0000 014A #asm("sei")
	sei
; 0000 014B delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 014C 
; 0000 014D twi_master_trans(0x3C, tx_data0, 50, rx_data, 0);
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(_tx_data0)
	LDI  R31,HIGH(_tx_data0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	CALL SUBOPT_0x1
; 0000 014E 
; 0000 014F while (1)
_0x1A:
; 0000 0150 {
; 0000 0151     clearDisplay();
	RCALL _clearDisplay
; 0000 0152     for(a = 63; a >= 0; a--)
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	__PUTW1R 5,6
_0x1E:
	CLR  R0
	CP   R5,R0
	CPC  R6,R0
	BRLT _0x1F
; 0000 0153     {
; 0000 0154 //        delay_us(3);
; 0000 0155         OCR2A = 0;
	CALL SUBOPT_0x4
; 0000 0156         OCR2B = a*4;
; 0000 0157         x = read_adc(0)/16;
	CALL SUBOPT_0x5
	MOVW R16,R30
; 0000 0158         y = read_adc(1)/16;
	CALL SUBOPT_0x6
	MOVW R18,R30
; 0000 0159         x = x-y+64;
	CALL SUBOPT_0x7
; 0000 015A         y = y + 32 ;
; 0000 015B         drawPixel(x,y,1);
; 0000 015C 
; 0000 015D     }
	__GETW1R 5,6
	SBIW R30,1
	__PUTW1R 5,6
	RJMP _0x1E
_0x1F:
; 0000 015E     for(a = 0; a < 64; a++)
	CLR  R5
	CLR  R6
_0x21:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CP   R5,R30
	CPC  R6,R31
	BRGE _0x22
; 0000 015F     {
; 0000 0160 //        delay_ms(3);
; 0000 0161         OCR2A = a*4;
	MOV  R30,R5
	LSL  R30
	LSL  R30
	CALL SUBOPT_0x3
; 0000 0162         OCR2B = 0;
; 0000 0163         y = read_adc(0)/16;
	CALL SUBOPT_0x5
	MOVW R18,R30
; 0000 0164         x = read_adc(1)/16;
	CALL SUBOPT_0x6
	MOVW R16,R30
; 0000 0165         x = y-x+64;
	CALL SUBOPT_0x8
; 0000 0166         y = 32-y;
; 0000 0167         drawPixel(x,y,1);
; 0000 0168 
; 0000 0169     }
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
	RJMP _0x21
_0x22:
; 0000 016A     drawPixel(64,0,1);
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xA
; 0000 016B     drawPixel(64,15,1);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0xA
; 0000 016C     drawPixel(64,30,1);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0xA
; 0000 016D     drawPixel(64,34,1);
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0xA
; 0000 016E     drawPixel(64,49,1);
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CALL SUBOPT_0xA
; 0000 016F     drawPixel(64,63,1);
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	CALL SUBOPT_0xB
; 0000 0170     drawPixel(77,30,1);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0xB
; 0000 0171     drawPixel(77,34,1);
	CALL SUBOPT_0xC
; 0000 0172     drawPixel(51,30,1);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0173     drawPixel(25,30,1);
	CALL SUBOPT_0xE
; 0000 0174     drawPixel(25,34,1);
	CALL SUBOPT_0xC
; 0000 0175     drawPixel(12,30,1);
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0xF
; 0000 0176     drawPixel(12,34,1);
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x10
; 0000 0177     drawPixel(103,30,1);
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	CALL SUBOPT_0xF
; 0000 0178     drawPixel(103,34,1);
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	CALL SUBOPT_0x10
; 0000 0179     drawPixel(116,30,1);
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0xF
; 0000 017A     drawPixel(116,34,1);
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x10
; 0000 017B     drawPixel(51,34,1);
	CALL SUBOPT_0xD
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0xB
; 0000 017C     drawPixel(77,49,1);
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CALL SUBOPT_0xB
; 0000 017D     drawPixel(77,15,1);
	CALL SUBOPT_0x11
; 0000 017E     drawPixel(51,49,1);
	CALL SUBOPT_0xD
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _drawPixel
; 0000 017F     drawPixel(51,15,1);
	CALL SUBOPT_0xD
	CALL SUBOPT_0x11
; 0000 0180     drawPixel(90,30,1);
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0xF
; 0000 0181     drawPixel(90,34,1);
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x10
; 0000 0182     drawPixel(38,30,1);
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0xF
; 0000 0183     drawPixel(38,34,1);
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x10
; 0000 0184     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0185 
; 0000 0186     for(a = 63; a >= 0; a--)
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	__PUTW1R 5,6
_0x24:
	CLR  R0
	CP   R5,R0
	CPC  R6,R0
	BRLT _0x25
; 0000 0187     {
; 0000 0188 //        delay_ms(3);
; 0000 0189         OCR2A = a*4;
	MOV  R30,R5
	LSL  R30
	LSL  R30
	CALL SUBOPT_0x3
; 0000 018A         OCR2B = 0;
; 0000 018B         x = read_adc(1)/16;
	CALL SUBOPT_0x6
	MOVW R16,R30
; 0000 018C         y = read_adc(0)/16;
	CALL SUBOPT_0x5
	MOVW R18,R30
; 0000 018D         x = y-x+64;
	CALL SUBOPT_0x8
; 0000 018E         y = 32-y;
; 0000 018F         drawPixel(x,y,1);
; 0000 0190 
; 0000 0191     }
	__GETW1R 5,6
	SBIW R30,1
	__PUTW1R 5,6
	RJMP _0x24
_0x25:
; 0000 0192     for(a = 0; a < 64; a++)
	CLR  R5
	CLR  R6
_0x27:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CP   R5,R30
	CPC  R6,R31
	BRGE _0x28
; 0000 0193     {
; 0000 0194 //        delay_ms(3);
; 0000 0195         OCR2A = 0;
	CALL SUBOPT_0x4
; 0000 0196         OCR2B = a * 4;
; 0000 0197         y = read_adc(1)/16;
	CALL SUBOPT_0x6
	MOVW R18,R30
; 0000 0198         x = read_adc(0)/16;
	CALL SUBOPT_0x5
	MOVW R16,R30
; 0000 0199         x = x-y+64;
	CALL SUBOPT_0x7
; 0000 019A         y = y + 32 ;
; 0000 019B         drawPixel(x,y,1);
; 0000 019C 
; 0000 019D     }
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
	RJMP _0x27
_0x28:
; 0000 019E //    clearDisplay();
; 0000 019F     display();
	RCALL _display
; 0000 01A0 
; 0000 01A1       // Place your code here
; 0000 01A2 
; 0000 01A3       }
	RJMP _0x1A
; 0000 01A4 
; 0000 01A5 }
_0x29:
	RJMP _0x29
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
_twi_master_init:
; .FSTART _twi_master_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x1E,1
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDI  R30,LOW(0)
	STS  _twi_slave_rx_handler_G100,R30
	STS  _twi_slave_rx_handler_G100+1,R30
	STS  _twi_slave_tx_handler_G100,R30
	STS  _twi_slave_tx_handler_G100+1,R30
	SBI  0x8,4
	SBI  0x8,5
	STS  188,R30
	LDS  R30,185
	ANDI R30,LOW(0xFC)
	STS  185,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDI  R26,LOW(4000)
	LDI  R27,HIGH(4000)
	CALL __DIVW21U
	MOV  R17,R30
	CPI  R17,8
	BRLO _0x2000006
	SUBI R17,LOW(8)
_0x2000006:
	STS  184,R17
	LDS  R30,188
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  188,R30
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_twi_master_trans:
; .FSTART _twi_master_trans
	ST   -Y,R26
	SBIW R28,4
	SBIS 0x1E,1
	RJMP _0x2000007
	LDD  R30,Y+10
	LSL  R30
	STS  _slave_address_G100,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STS  _twi_tx_buffer_G100,R30
	STS  _twi_tx_buffer_G100+1,R31
	LDI  R30,LOW(0)
	STS  _twi_tx_index,R30
	LDD  R30,Y+7
	STS  _bytes_to_tx_G100,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _twi_rx_buffer_G100,R30
	STS  _twi_rx_buffer_G100+1,R31
	LDI  R30,LOW(0)
	STS  _twi_rx_index,R30
	LDD  R30,Y+4
	STS  _bytes_to_rx_G100,R30
	LDI  R30,LOW(6)
	STS  _twi_result,R30
	sei
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2000008
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x2000009
	RJMP _0x2040002
_0x2000009:
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x200000B
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BREQ _0x200000C
_0x200000B:
	RJMP _0x200000A
_0x200000C:
	RJMP _0x2040002
_0x200000A:
	SBI  0x1E,0
	RJMP _0x200000F
_0x2000008:
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x2000010
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,0
	BREQ _0x2040002
	LDS  R30,_slave_address_G100
	ORI  R30,1
	STS  _slave_address_G100,R30
	CBI  0x1E,0
_0x200000F:
	CBI  0x1E,1
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	__GETD1N 0x7A120
	CALL __PUTD1S0
_0x2000016:
	SBIC 0x1E,1
	RJMP _0x2000018
	CALL __GETD1S0
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTD1S0
	BRNE _0x2000019
	LDI  R30,LOW(5)
	STS  _twi_result,R30
	SBI  0x1E,1
	RJMP _0x2040002
_0x2000019:
	RJMP _0x2000016
_0x2000018:
_0x2000010:
	LDS  R26,_twi_result
	LDI  R30,LOW(0)
	CALL __EQB12
	RJMP _0x2040001
_0x2000007:
_0x2040002:
	LDI  R30,LOW(0)
_0x2040001:
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G100
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G100
	LDS  R27,_twi_rx_buffer_G100+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,185
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2000023
	LDI  R18,LOW(0)
	RJMP _0x2000024
_0x2000023:
	CPI  R30,LOW(0x10)
	BRNE _0x2000025
_0x2000024:
	LDS  R30,_slave_address_G100
	RJMP _0x2000080
_0x2000025:
	CPI  R30,LOW(0x18)
	BREQ _0x2000029
	CPI  R30,LOW(0x28)
	BRNE _0x200002A
_0x2000029:
	CP   R16,R19
	BRSH _0x200002B
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2000080:
	STS  187,R30
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x200002C
_0x200002B:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x200002D
	LDS  R30,_slave_address_G100
	ORI  R30,1
	STS  _slave_address_G100,R30
	CBI  0x1E,0
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  188,R30
	RJMP _0x2000022
_0x200002D:
	RJMP _0x2000030
_0x200002C:
	RJMP _0x2000022
_0x200002A:
	CPI  R30,LOW(0x50)
	BRNE _0x2000031
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x40)
	BRNE _0x2000033
_0x2000032:
	LDS  R30,_bytes_to_rx_G100
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2000034
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000081
_0x2000034:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2000081:
	STS  188,R30
	RJMP _0x2000022
_0x2000033:
	CPI  R30,LOW(0x58)
	BRNE _0x2000036
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2000037
_0x2000036:
	CPI  R30,LOW(0x20)
	BRNE _0x2000038
_0x2000037:
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x30)
	BRNE _0x200003A
_0x2000039:
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x48)
	BRNE _0x200003C
_0x200003B:
	CPI  R18,0
	BRNE _0x200003D
	SBIS 0x1E,0
	RJMP _0x200003E
	CP   R16,R19
	BRLO _0x2000040
	RJMP _0x2000041
_0x200003E:
	LDS  R30,_bytes_to_rx_G100
	CP   R17,R30
	BRSH _0x2000042
_0x2000040:
	LDI  R18,LOW(4)
_0x2000042:
_0x2000041:
_0x200003D:
_0x2000030:
	RJMP _0x2000082
_0x200003C:
	CPI  R30,LOW(0x38)
	BRNE _0x2000045
	LDI  R18,LOW(2)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000083
_0x2000045:
	CPI  R30,LOW(0x68)
	BREQ _0x2000048
	CPI  R30,LOW(0x78)
	BRNE _0x2000049
_0x2000048:
	LDI  R18,LOW(2)
	RJMP _0x200004A
_0x2000049:
	CPI  R30,LOW(0x60)
	BREQ _0x200004D
	CPI  R30,LOW(0x70)
	BRNE _0x200004E
_0x200004D:
	LDI  R18,LOW(0)
_0x200004A:
	LDI  R17,LOW(0)
	CBI  0x1E,0
	LDS  R30,_twi_rx_buffer_size_G100
	CPI  R30,0
	BRNE _0x2000051
	LDI  R18,LOW(1)
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2000084
_0x2000051:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2000084:
	STS  188,R30
	RJMP _0x2000022
_0x200004E:
	CPI  R30,LOW(0x80)
	BREQ _0x2000054
	CPI  R30,LOW(0x90)
	BRNE _0x2000055
_0x2000054:
	SBIS 0x1E,0
	RJMP _0x2000056
	LDI  R18,LOW(1)
	RJMP _0x2000057
_0x2000056:
	LDS  R30,187
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G100
	CP   R17,R30
	BRSH _0x2000058
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BRNE _0x2000059
	LDI  R18,LOW(6)
	RJMP _0x2000057
_0x2000059:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G100,0
	CPI  R30,0
	BREQ _0x200005A
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	RJMP _0x2000022
_0x200005A:
	RJMP _0x200005B
_0x2000058:
	SBI  0x1E,0
_0x200005B:
	RJMP _0x200005E
_0x2000055:
	CPI  R30,LOW(0x88)
	BRNE _0x200005F
_0x200005E:
	RJMP _0x2000060
_0x200005F:
	CPI  R30,LOW(0x98)
	BRNE _0x2000061
_0x2000060:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  188,R30
	RJMP _0x2000022
_0x2000061:
	CPI  R30,LOW(0xA0)
	BRNE _0x2000062
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	SBI  0x1E,1
	LDS  R30,_twi_slave_rx_handler_G100
	LDS  R31,_twi_slave_rx_handler_G100+1
	SBIW R30,0
	BREQ _0x2000065
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G100,0
	RJMP _0x2000066
_0x2000065:
	LDI  R18,LOW(6)
_0x2000066:
	RJMP _0x2000022
_0x2000062:
	CPI  R30,LOW(0xB0)
	BRNE _0x2000067
	LDI  R18,LOW(2)
	RJMP _0x2000068
_0x2000067:
	CPI  R30,LOW(0xA8)
	BRNE _0x2000069
_0x2000068:
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x200006A
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G100,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x200006C
	LDI  R18,LOW(0)
	RJMP _0x200006D
_0x200006A:
_0x200006C:
	LDI  R18,LOW(6)
	RJMP _0x2000057
_0x200006D:
	LDI  R16,LOW(0)
	CBI  0x1E,0
	RJMP _0x2000070
_0x2000069:
	CPI  R30,LOW(0xB8)
	BRNE _0x2000071
_0x2000070:
	SBIS 0x1E,0
	RJMP _0x2000072
	LDI  R18,LOW(1)
	RJMP _0x2000057
_0x2000072:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G100
	LDS  R27,_twi_tx_buffer_G100+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  187,R30
	CP   R16,R19
	BRSH _0x2000073
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x2000085
_0x2000073:
	SBI  0x1E,0
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x2000085:
	STS  188,R30
	RJMP _0x2000022
_0x2000071:
	CPI  R30,LOW(0xC0)
	BREQ _0x2000078
	CPI  R30,LOW(0xC8)
	BRNE _0x2000079
_0x2000078:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  188,R30
	LDS  R30,_twi_slave_tx_handler_G100
	LDS  R31,_twi_slave_tx_handler_G100+1
	SBIW R30,0
	BREQ _0x200007A
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G100,0
_0x200007A:
	RJMP _0x2000043
_0x2000079:
	CPI  R30,0
	BRNE _0x2000022
	LDI  R18,LOW(3)
_0x2000057:
_0x2000082:
	LDS  R30,188
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x2000083:
	STS  188,R30
_0x2000043:
	SBI  0x1E,1
_0x2000022:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G100,R19
	CALL __LOADLOCR6
	ADIW R28,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG

	.DSEG
_buffer:
	.BYTE 0x400
_rx_data:
	.BYTE 0x1
_bufer:
	.BYTE 0x81
_tx_data0:
	.BYTE 0x32
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_slave_address_G100:
	.BYTE 0x1
_twi_tx_buffer_G100:
	.BYTE 0x2
_bytes_to_tx_G100:
	.BYTE 0x1
_twi_rx_buffer_G100:
	.BYTE 0x2
_bytes_to_rx_G100:
	.BYTE 0x1
_twi_rx_buffer_size_G100:
	.BYTE 0x1
_twi_slave_rx_handler_G100:
	.BYTE 0x2
_twi_slave_tx_handler_G100:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(_bufer)
	LDI  R31,HIGH(_bufer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R30,LOW(_rx_data)
	LDI  R31,HIGH(_rx_data)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _twi_master_trans

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	CALL __LSLW3
	CALL __LSLW4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R22,R30
	LD   R1,Z
	LDD  R30,Y+2
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	STS  179,R30
	LDI  R30,LOW(0)
	STS  180,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	STS  179,R30
	MOV  R30,R5
	LSL  R30
	LSL  R30
	STS  180,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(0)
	CALL _read_adc
	CALL __LSRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(1)
	CALL _read_adc
	CALL __LSRW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	MOVW R30,R16
	SUB  R30,R18
	SBC  R31,R19
	SUBI R30,LOW(-64)
	SBCI R31,HIGH(-64)
	MOVW R16,R30
	__ADDWRN 18,19,32
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _drawPixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x8:
	MOVW R30,R18
	SUB  R30,R16
	SBC  R31,R17
	SUBI R30,LOW(-64)
	SBCI R31,HIGH(-64)
	MOVW R16,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	SUB  R30,R18
	SBC  R31,R19
	MOVW R18,R30
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _drawPixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _drawPixel
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _drawPixel
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _drawPixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _drawPixel
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _drawPixel

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _drawPixel


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
