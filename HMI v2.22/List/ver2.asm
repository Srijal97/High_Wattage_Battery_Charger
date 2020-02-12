
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	.DEF _Screen=R4
	.DEF _Screen_msb=R5
	.DEF _Current_Screen=R6
	.DEF _Current_Screen_msb=R7
	.DEF _Pointer_horiz=R8
	.DEF _Pointer_horiz_msb=R9
	.DEF _Pointer_vert=R10
	.DEF _Pointer_vert_msb=R11
	.DEF _Pt=R12
	.DEF _Pt_msb=R13

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
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30
_0x0:
	.DB  0x3C,0x30,0x30,0x31,0x3E,0x0,0x3C,0x30
	.DB  0x30,0x32,0x3E,0x0,0x3C,0x30,0x30,0x33
	.DB  0x3E,0x0,0x3C,0x30,0x31,0x30,0x3E,0x0
	.DB  0x3C,0x30,0x31,0x31,0x3E,0x0,0x3C,0x30
	.DB  0x31,0x34,0x2D,0x25,0x30,0x34,0x64,0x3E
	.DB  0x0,0x3C,0x30,0x31,0x35,0x2D,0x25,0x30
	.DB  0x34,0x64,0x3E,0x0,0x49,0x6E,0x76,0x61
	.DB  0x6C,0x69,0x64,0x20,0x63,0x6F,0x6D,0x6D
	.DB  0x61,0x6E,0x64,0x20,0x72,0x65,0x63,0x65
	.DB  0x69,0x76,0x65,0x64,0x0,0x20,0x0,0x5E
	.DB  0x0,0x25,0x30,0x33,0x64,0x0,0x25,0x30
	.DB  0x32,0x64,0x0,0x4D,0x61,0x69,0x6E,0x20
	.DB  0x53,0x63,0x72,0x65,0x65,0x6E,0x0,0x56
	.DB  0x6F,0x6C,0x74,0x61,0x67,0x65,0x20,0x73
	.DB  0x65,0x74,0x20,0x74,0x6F,0x3A,0x0,0x56
	.DB  0x0,0x53,0x65,0x74,0x20,0x76,0x61,0x6C
	.DB  0x75,0x65,0x20,0x73,0x68,0x6F,0x75,0x6C
	.DB  0x64,0x0,0x62,0x65,0x20,0x62,0x65,0x74
	.DB  0x77,0x65,0x65,0x6E,0x20,0x31,0x31,0x30
	.DB  0x2D,0x0,0x31,0x33,0x35,0x20,0x76,0x6F
	.DB  0x6C,0x74,0x73,0x0,0x43,0x75,0x72,0x72
	.DB  0x65,0x6E,0x74,0x20,0x73,0x65,0x74,0x20
	.DB  0x74,0x6F,0x3A,0x0,0x41,0x0,0x62,0x65
	.DB  0x20,0x62,0x65,0x74,0x77,0x65,0x65,0x6E
	.DB  0x20,0x31,0x30,0x2D,0x0,0x32,0x30,0x20
	.DB  0x61,0x6D,0x70,0x73,0x0,0x57,0x65,0x6C
	.DB  0x63,0x6F,0x6D,0x65,0x20,0x74,0x6F,0x20
	.DB  0x48,0x4D,0x49,0x0,0x53,0x65,0x74,0x20
	.DB  0x50,0x61,0x72,0x61,0x6D,0x65,0x74,0x65
	.DB  0x72,0x73,0x0,0x50,0x41,0x52,0x41,0x4D
	.DB  0x45,0x54,0x45,0x52,0x53,0x0,0x56,0x6F
	.DB  0x6C,0x74,0x61,0x67,0x65,0x20,0x28,0x56
	.DB  0x4F,0x4C,0x54,0x53,0x29,0x0,0x43,0x75
	.DB  0x72,0x72,0x65,0x6E,0x74,0x20,0x28,0x41
	.DB  0x4D,0x50,0x53,0x29,0x0,0x53,0x65,0x74
	.DB  0x20,0x76,0x6F,0x6C,0x74,0x61,0x67,0x65
	.DB  0x3A,0x0,0x53,0x65,0x74,0x20,0x63,0x75
	.DB  0x72,0x72,0x65,0x6E,0x74,0x3A,0x0,0x53
	.DB  0x56,0x3A,0x0,0x53,0x42,0x43,0x3A,0x0
	.DB  0x41,0x56,0x3A,0x0,0x41,0x42,0x43,0x3A
	.DB  0x0,0x41,0x49,0x56,0x3A,0x0,0x41,0x4F
	.DB  0x43,0x3A,0x0,0x46,0x61,0x75,0x6C,0x74
	.DB  0x20,0x49,0x44,0x3A,0x0,0x30,0x30,0x30
	.DB  0x0,0x4D,0x61,0x63,0x68,0x69,0x6E,0x65
	.DB  0x20,0x3A,0x20,0x4F,0x4E,0x20,0x0,0x4D
	.DB  0x61,0x63,0x68,0x69,0x6E,0x65,0x20,0x3A
	.DB  0x20,0x4F,0x46,0x46,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2080003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _fltArray
	.DW  _0x3*2

	.DW  0x01
	.DW  _0xA
	.DW  _0x0*2+5

	.DW  0x01
	.DW  _0xB
	.DW  _0x0*2+5

	.DW  0x10
	.DW  _0x73
	.DW  _0x0*2+103

	.DW  0x10
	.DW  _0x8C
	.DW  _0x0*2+164

	.DW  0x0F
	.DW  _0x94
	.DW  _0x0*2+205

	.DW  0x0A
	.DW  _0xAA
	.DW  _0x0*2+331

	.DW  0x04
	.DW  _0xAA+10
	.DW  _0x0*2+341

	.DW  0x04
	.DW  _0xAA+14
	.DW  _0x0*2+341

	.DW  0x04
	.DW  _0xAA+18
	.DW  _0x0*2+341

	.DW  0x04
	.DW  _0xAA+22
	.DW  _0x0*2+341

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G104
	.DW  _0x2080003*2

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
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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

	OUT  RAMPZ,R24

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
	.ORG 0x500

	.CSEG
;/*
;PORTE.5 == KEYPAD 2
;PORTE.7 == KEYPAD 1
;PORTD.2 == KEYPAD 4
;PORTB.3 == KEYPAD 3
;*/
;
;
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <Math.h>
;#include <String.h>
;#include "commands.c"
;/*
; * commands.c
; *
; *  Created on: Jan 10, 2020
; *      Author: Mr.Yash
; */
;
;//#include <Serial.h>
;#include <commands.h>
;#include <alcd.h>
;#include <ver1.h>
;//#include <variables.h>
;
;int Screen = 1;
;int Current_Screen = 0;
;int Pointer_horiz = 0, Pointer_vert = 0, Pt;
;
;
;long set_voltage = 000;
;long set_current = 000;
;static int actual_voltage = 000;
;static int actual_btcurrent = 000;
;static int actual_ipvoltage = 000;
;static int actual_opcurrent = 000;
;
;int set_flag=0;
;int flag = 0;
;
;int n=0;                    //Input function parameter in screen functions
;int main_screen_trigger;  //to return to main screen
;int ms_update_flag = 0;
;int current_mainscreen_flag = 0;
;int status = 0;
;int fault_flag = 0;
;
;
;flash char* txVoltCom;
;flash char* txAmpCom;
;
;char fltArray[9] = {'0','0','0','0','0','0','0','0','\0'};

	.DSEG
;char disp_volt[3];
;char disp_current[3];
;char disp_set_voltage[3];
;char disp_set_btcurrent[4];
;char disp_actual_voltage[3];
;char disp_actual_btcurrent[4];
;char disp_actual_ipvoltage[3];
;char disp_actual_opcurrent[4];
;char disp_fault[];
;flash char *msg;
;flash char *xmitMsg;
;flash char *rec;
;flash char *rdata;
;//char sdataA[20];    // Send data for SCI-A
;char rdataA[20]; // Received data for SCI-A
;int comStart;
;
;int i = 0;
;
;    //commands will be given a 3 digit numeric code based on the button pressed;
;    //Stored values for the particular option-
;
;    //    000-  noOp
;    //    001-  mainOn
;    //    002-  mainOff
;    //    003-  resetFault
;    //    004-  faultDetect
;    //    005-  txSetVoltage
;    //    006-  txSetCurrent
;    //    007-
;    //    008-
;    //    009-
;    //    010-  read output voltage
;    //    011-  read battery current
;    //    012-  read input voltage
;    //    013-  read output current
;    //    014-  set output voltage
;    //    015-  set battery current
;    //    016-
;    //    017-
;    //    018-
;    //    019-
;    //    020-
;    //    021-
;    //    022-
;    //    023-
;    //    024-
;    //    025-
;    //    026-
;    //    027-
;    //    028-
;    //    029-
;    //    030-
;    //    031-
;    //    032-
;    //    033-
;    //    034-
;    //    035-
;    //    036-
;    //    037-
;    //    038-
;    //    039-
;
;void xmitString(flash char * xmitMsg)
; 0000 0010 {

	.CSEG
_xmitString:
; .FSTART _xmitString
;    int i =0;
;    for(i = 0;*(xmitMsg+i)!= '\0';i++)
	CALL SUBOPT_0x0
;	*xmitMsg -> Y+2
;	i -> R16,R17
_0x5:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x6
;    {
;         putchar(xmitMsg[i]);
	MOVW R30,R16
	ADD  R30,R26
	ADC  R31,R27
	LPM  R26,Z
	RCALL _putchar
;
;    }
	__ADDWRN 16,17,1
	RJMP _0x5
_0x6:
;
;
;
;}
	RJMP _0x212000F
; .FEND
;
;void xmitStringnf(char * xmitMsgnf)
;{
_xmitStringnf:
; .FSTART _xmitStringnf
;    int i =0;
;    for(i = 0;*(xmitMsgnf+i)!= '\0';i++)
	CALL SUBOPT_0x0
;	*xmitMsgnf -> Y+2
;	i -> R16,R17
_0x8:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ _0x9
;    {
;         putchar(xmitMsgnf[i]);
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
;
;    }
	__ADDWRN 16,17,1
	RJMP _0x8
_0x9:
;
;
;
;}
_0x212000F:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void noOp()
;{
_noOp:
; .FSTART _noOp
;
;}
	RET
; .FEND
;
;void mainOn()
;{
_mainOn:
; .FSTART _mainOn
;
;    xmitMsg ="<001>";
	__POINTW1FN _0x0,0
	RJMP _0x212000E
;    xmitString(xmitMsg);
;
;}
; .FEND
;
;void mainOff()
;{
_mainOff:
; .FSTART _mainOff
;
;    xmitMsg = "<002>";
	__POINTW1FN _0x0,6
	RJMP _0x212000E
;    xmitString(xmitMsg);
;
;}
; .FEND
;
;void resetFault()
;{
_resetFault:
; .FSTART _resetFault
;    xmitMsg = "<003>";
	__POINTW1FN _0x0,12
_0x212000E:
	STS  _xmitMsg,R30
	STS  _xmitMsg+1,R31
;    xmitString(xmitMsg);
	LDS  R26,_xmitMsg
	LDS  R27,_xmitMsg+1
	RCALL _xmitString
;}
	RET
; .FEND
;
;void readOutputVolt()
;{
;    xmitMsg = "<010>";
;    xmitString(xmitMsg);
;
;}
;
;void readBatteryAmp()
;{
;    xmitMsg = "<011>";
;    xmitString(xmitMsg);
;
;}
;
;void txSetVoltage(int setVoltVal)
;{
_txSetVoltage:
; .FSTART _txSetVoltage
;    int cpyVolt = setVoltVal;
;    char* msg1 = "";
;    sprintf(msg1,"<014-%04d>",cpyVolt);
	CALL SUBOPT_0x1
;	setVoltVal -> Y+4
;	cpyVolt -> R16,R17
;	*msg1 -> R18,R19
	__POINTWRMN 18,19,_0xA,0
	ST   -Y,R19
	ST   -Y,R18
	__POINTW1FN _0x0,30
	RJMP _0x212000D
;    xmitStringnf(msg1);
;}
; .FEND

	.DSEG
_0xA:
	.BYTE 0x1
;
;void txSetCurrent(int setAmpVal)
;{

	.CSEG
_txSetCurrent:
; .FSTART _txSetCurrent
;    int cpyAmp = setAmpVal;
;    char*msg1 = "";
;    sprintf(msg1,"<015-%04d>",cpyAmp);
	CALL SUBOPT_0x1
;	setAmpVal -> Y+4
;	cpyAmp -> R16,R17
;	*msg1 -> R18,R19
	__POINTWRMN 18,19,_0xB,0
	ST   -Y,R19
	ST   -Y,R18
	__POINTW1FN _0x0,41
_0x212000D:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x2
;    xmitStringnf(msg1);
	MOVW R26,R18
	RCALL _xmitStringnf
;
;}
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND

	.DSEG
_0xB:
	.BYTE 0x1
;/*static void (*tx_function[100])() = {
;    noOp,  // 0
;    mainOn,  // 1
;    mainOff,  // 2
;    resetFault,  // 3
;    faultDetect, //4
;    noOp,
;    noOp,
;    noOp,
;    noOp,
;    noOp,
;    readOutputVolt,//10
;    readBatteryAmp,//11
;    //readInputVolt,//12
;    //xreadOutputCurrent,//13
;};*/
;
;
;
;
;
;//On receiving response from the TMS, further actions are taken by recFunc array
;
;
;
;
;void rxnoOp()
;{

	.CSEG
;}
;
;
;void rxmainOn()
;{
_rxmainOn:
; .FSTART _rxmainOn
;    current_mainscreen_flag = 1;
	CALL SUBOPT_0x3
;    PORTC.3 = 0;
	CBI  0x15,3
;    status = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _status,R30
	STS  _status+1,R31
;}
	RET
; .FEND
;
;void rxmainOff()
;{
_rxmainOff:
; .FSTART _rxmainOff
;    current_mainscreen_flag = 1;
	CALL SUBOPT_0x3
;    status = 0;
	LDI  R30,LOW(0)
	STS  _status,R30
	STS  _status+1,R30
;    PORTC.3 = 1;
	SBI  0x15,3
;
;}
	RET
; .FEND
;
;void rxresetFault()
;{
_rxresetFault:
; .FSTART _rxresetFault
;   fault_flag = 0;
	LDI  R30,LOW(0)
	STS  _fault_flag,R30
	STS  _fault_flag+1,R30
;   current_mainscreen_flag = 1;
	RJMP _0x212000A
;}
; .FEND
;
;void rxfaultDetect(int val)
;{
_rxfaultDetect:
; .FSTART _rxfaultDetect
;    int i = 0,j,k=0;
;    int fault = 0, cpyFault;
;    int fltBit[8],tmpBit[8];
;    fault = val;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,36
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+35,R30
	CALL __SAVELOCR6
;	val -> Y+42
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	fault -> Y+40
;	cpyFault -> Y+38
;	fltBit -> Y+22
;	tmpBit -> Y+6
	__GETWRN 16,17,0
	__GETWRN 20,21,0
	LDD  R30,Y+42
	LDD  R31,Y+42+1
	STD  Y+40,R30
	STD  Y+40+1,R31
;
;    if(fault!=0)
	SBIW R30,0
	BREQ _0x10
;    {
;        PORTF &= ~0x40;
	LDS  R30,98
	ANDI R30,0xBF
	STS  98,R30
;        fault_flag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _fault_flag,R30
	STS  _fault_flag+1,R31
;        mainOff();
	RCALL _mainOff
;
;    }
;    for(i=0;i<8;i++)
_0x10:
	__GETWRN 16,17,0
_0x12:
	__CPWRN 16,17,8
	BRGE _0x13
;    {
;        fltArray[7-i] = fault%2 + 48;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R16
	SBC  R31,R17
	SUBI R30,LOW(-_fltArray)
	SBCI R31,HIGH(-_fltArray)
	MOVW R0,R30
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	SUBI R30,-LOW(48)
	MOVW R26,R0
	ST   X,R30
;        fault = fault >> 1;
	LDD  R30,Y+40
	LDD  R31,Y+40+1
	ASR  R31
	ROR  R30
	STD  Y+40,R30
	STD  Y+40+1,R31
;
;    }
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
;
;//    numFlt = fltBit[0]+(fltBit[1]*10)+(fltBit[2]*100)
;//    +(fltBit[3]*1000)+(fltBit[4]*10000)+(fltBit[5]*100000)+(fltBit[1]*1000000)+(fltBit[1]*10000000);
;
;//    if(fltBit[0] == 1)PORTC.3 = 0;
;//    if(fltBit[1] == 1)PORTC.3 = 1;
;//    if(fltBit[2] == 1)PORTF &= ~0x80;;
;//    if(fltBit[3] == 1)PORTC.3 = 1  ;
;//    if(fltBit[4] == 1)PORTC.3 = 1   ;
;//    if(fltBit[5] == 1)PORTC.3 = 1    ;
;//    if(fltBit[6] == 1)PORTC.3 = 1     ;
;//    if(fltBit[7] == 1)PORTC.3 = 1      ;
;//
;
;
;
;}
	CALL __LOADLOCR6
	ADIW R28,44
	RET
; .FEND
;
;void rxreadOutputVolt(int val)
;{
_rxreadOutputVolt:
; .FSTART _rxreadOutputVolt
;    actual_voltage = val;
	CALL SUBOPT_0x4
;	val -> Y+0
	STS  _actual_voltage_G000,R30
	STS  _actual_voltage_G000+1,R31
;}
	RJMP _0x212000B
; .FEND
;
;
;
;void rxreadBatteryAmp(int val)
;{
_rxreadBatteryAmp:
; .FSTART _rxreadBatteryAmp
;    actual_btcurrent = val;
	CALL SUBOPT_0x4
;	val -> Y+0
	STS  _actual_btcurrent_G000,R30
	STS  _actual_btcurrent_G000+1,R31
;}
	RJMP _0x212000B
; .FEND
;
;void rxreadInputVolt(int val)
;{
_rxreadInputVolt:
; .FSTART _rxreadInputVolt
;    actual_ipvoltage = val;
	CALL SUBOPT_0x4
;	val -> Y+0
	STS  _actual_ipvoltage_G000,R30
	STS  _actual_ipvoltage_G000+1,R31
;}
	RJMP _0x212000B
; .FEND
;
;void rxreadOutputCurrent(int val)
;{
_rxreadOutputCurrent:
; .FSTART _rxreadOutputCurrent
;    actual_opcurrent = val;
	CALL SUBOPT_0x4
;	val -> Y+0
	STS  _actual_opcurrent_G000,R30
	STS  _actual_opcurrent_G000+1,R31
;}
	RJMP _0x212000B
; .FEND
;
;
;/*static void (*rx_function[100])() = {
;    rxnoOp,  // 0
;    rxmainOn,  // 1
;    rxmainOff,  // 2
;    rxresetFault,  // 3
;    rxfaultDetect, //4
;    rxnoOp,
;    rxnoOp,
;    rxnoOp,
;    rxnoOp,
;    rxnoOp,
;    rxreadOutputVolt,//10
;    rxreadBatteryAmp,//11
;    rxreadInputVolt,//12
;    rexreadOutputCurrent,//13
;};*/
;
;
;
;void comDecode(char * rec)
;{
_comDecode:
; .FSTART _comDecode
;
;    char cmd[3] = {'0','0','0'};
;    char data[4] = {'0','0','0','0'};
;    int icmd = 0;
;    int idata = 0;
;    int i;
;
;    for(i = 1; i < 4; i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,7
	LDI  R30,LOW(48)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	CALL __SAVELOCR6
;	*rec -> Y+13
;	cmd -> Y+10
;	data -> Y+6
;	icmd -> R16,R17
;	idata -> R18,R19
;	i -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,1
_0x15:
	__CPWRN 20,21,4
	BRGE _0x16
;    {
;       cmd[i-1] = rec[i];
	MOVW R30,R20
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x5
;    }
	__ADDWRN 20,21,1
	RJMP _0x15
_0x16:
;
;    for(i = 5; i < 9; i++)
	__GETWRN 20,21,5
_0x18:
	__CPWRN 20,21,9
	BRGE _0x19
;    {
;       data[i-5] = rec[i];
	MOVW R30,R20
	SBIW R30,5
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x5
;    }
	__ADDWRN 20,21,1
	RJMP _0x18
_0x19:
;
;
;    icmd = (cmd[2]-'0') + ((cmd[1] - '0')*10) + ((cmd[0]-'0')*100);
	LDD  R30,Y+12
	LDI  R31,0
	SBIW R30,48
	MOVW R22,R30
	LDD  R30,Y+11
	CALL SUBOPT_0x6
	LDD  R30,Y+10
	CALL SUBOPT_0x7
	ADD  R30,R22
	ADC  R31,R23
	MOVW R16,R30
;    idata = (data[3]-'0') + ((data[2] - '0')*10) + ((data[1]-'0')*100) + ((data[0]-'0')*1000);
	LDD  R30,Y+9
	LDI  R31,0
	SBIW R30,48
	MOVW R22,R30
	LDD  R30,Y+8
	CALL SUBOPT_0x6
	LDD  R30,Y+7
	CALL SUBOPT_0x7
	__ADDWRR 22,23,30,31
	LDD  R30,Y+6
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R18,R30
;
;   //rx_function[icmd]();
;   switch(icmd)
	MOVW R30,R16
;   {
;        case 0:  noOp();                    break;
	SBIW R30,0
	BRNE _0x1D
	RCALL _noOp
	RJMP _0x1C
;        case 1:  rxmainOn();                break;
_0x1D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
	RCALL _rxmainOn
	RJMP _0x1C
;        case 2:  rxmainOff();               break;
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
	RCALL _rxmainOff
	RJMP _0x1C
;        case 3:  rxresetFault();            break;
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20
	RCALL _rxresetFault
	RJMP _0x1C
;        case 4:  rxfaultDetect(idata);      break;
_0x20:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x21
	MOVW R26,R18
	RCALL _rxfaultDetect
	RJMP _0x1C
;        case 5:  noOp();                    break;
_0x21:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x22
	RCALL _noOp
	RJMP _0x1C
;        case 6:  noOp();                    break;
_0x22:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x23
	RCALL _noOp
	RJMP _0x1C
;        case 7:  noOp();                    break;
_0x23:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x24
	RCALL _noOp
	RJMP _0x1C
;        case 8:  noOp();                    break;
_0x24:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x25
	RCALL _noOp
	RJMP _0x1C
;        case 9:  noOp();                    break;
_0x25:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x26
	RCALL _noOp
	RJMP _0x1C
;        case 10: rxreadOutputVolt(idata);   break;
_0x26:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x27
	MOVW R26,R18
	RCALL _rxreadOutputVolt
	RJMP _0x1C
;        case 11: rxreadBatteryAmp(idata);   break;
_0x27:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x28
	MOVW R26,R18
	RCALL _rxreadBatteryAmp
	RJMP _0x1C
;        case 12: rxreadInputVolt(idata);    break;
_0x28:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x29
	MOVW R26,R18
	RCALL _rxreadInputVolt
	RJMP _0x1C
;        case 13: rxreadOutputCurrent(idata);break;
_0x29:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x2A
	MOVW R26,R18
	RCALL _rxreadOutputCurrent
	RJMP _0x1C
;        case 14: noOp();                    break;
_0x2A:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x2B
	RCALL _noOp
	RJMP _0x1C
;        case 15: noOp();                    break;
_0x2B:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x2C
	RCALL _noOp
	RJMP _0x1C
;        case 16: noOp();                    break;
_0x2C:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x2D
	RCALL _noOp
	RJMP _0x1C
;        case 17: noOp();                    break;
_0x2D:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x2F
	RCALL _noOp
	RJMP _0x1C
;        default: xmitString("Invalid command received");
_0x2F:
	__POINTW2FN _0x0,52
	RCALL _xmitString
;   }
_0x1C:
;
;//    if (icmd == 1) {  // <001>
;//        rxmainOn();
;//    }
;//    else if (icmd == 2) {
;//        rxmainOff();
;//    }
;//    else if (icmd == 3 ) {
;//        rxresetFault();
;//
;//    }
;//    else if (icmd == 4) {
;//       rxfaultDetect(idata);
;//    }
;//
;//    else if (icmd == 10 ){
;//        rxreadOutputVolt(idata);
;//
;//    }
;//    else if (icmd == 11 ){
;//        rxreadBatteryAmp(idata);
;//    }
;//    else if (icmd == 12 ){
;//        rxreadInputVolt(idata);
;//    }
;//    else if (icmd == 13 ){
;//        rxreadOutputCurrent(idata);
;//    }
;
;
;}
	CALL __LOADLOCR6
	ADIW R28,15
	RET
; .FEND
;
;
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;
;int data_received = 0;
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 32
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;
;
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 005D {
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
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
; 0000 005E char status,data;
; 0000 005F status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0060 data=UDR0;
	IN   R16,12
; 0000 0061 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x30
; 0000 0062    {
; 0000 0063    rx_buffer0[rx_wr_index0++]=data;
	LDS  R30,_rx_wr_index0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0064      if(data == '<') {
	CPI  R16,60
	BRNE _0x31
; 0000 0065         comStart = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _comStart,R30
	STS  _comStart+1,R31
; 0000 0066         i = 0;
	CALL SUBOPT_0x8
; 0000 0067 
; 0000 0068     }
; 0000 0069     else if(data == '>') {
	RJMP _0x32
_0x31:
	CPI  R16,62
	BRNE _0x33
; 0000 006A             *(rdataA+i) = data;
	CALL SUBOPT_0x9
; 0000 006B             comStart = 0;
	LDI  R30,LOW(0)
	STS  _comStart,R30
	STS  _comStart+1,R30
; 0000 006C             i = 0;
	CALL SUBOPT_0x8
; 0000 006D             comDecode(rdataA);
	LDI  R26,LOW(_rdataA)
	LDI  R27,HIGH(_rdataA)
	RCALL _comDecode
; 0000 006E     }
; 0000 006F     if (comStart == 1) {
_0x33:
_0x32:
	LDS  R26,_comStart
	LDS  R27,_comStart+1
	SBIW R26,1
	BRNE _0x34
; 0000 0070             *(rdataA+i) = data;  // Read data
	CALL SUBOPT_0x9
; 0000 0071             i++;
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL SUBOPT_0xA
; 0000 0072             if(i==9){i=0;}
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,9
	BRNE _0x35
	CALL SUBOPT_0x8
; 0000 0073     }
_0x35:
; 0000 0074 
; 0000 0075 
; 0000 0076 //#if RX_BUFFER_SIZE0 == 256
; 0000 0077 //   // special case for receiver buffer size=256
; 0000 0078 //   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0079 //#else
; 0000 007A    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
_0x34:
	LDS  R26,_rx_wr_index0
	CPI  R26,LOW(0x20)
	BRNE _0x36
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 007B    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x36:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x20)
	BRNE _0x37
; 0000 007C       {
; 0000 007D       rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 007E       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 007F       }
; 0000 0080 //#endif
; 0000 0081    }//data_received = 1;
_0x37:
; 0000 0082 }
_0x30:
	LD   R16,Y+
	LD   R17,Y+
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
;
;#ifndef _DEBUG_TERMINAL_IO_
;
;
;
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 008C {
; 0000 008D char data;
; 0000 008E while (rx_counter0==0);
;	data -> R17
; 0000 008F data=rx_buffer0[rx_rd_index0++];
; 0000 0090 #if RX_BUFFER_SIZE0 != 256
; 0000 0091 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 0092 #endif
; 0000 0093 #asm("cli")
; 0000 0094 --rx_counter0;
; 0000 0095 #asm("sei")
; 0000 0096 return data;
; 0000 0097 }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 64
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0=0,tx_rd_index0=0;
;#else
;unsigned int tx_wr_index0=0,tx_rd_index0=0;
;#endif
;
;#if TX_BUFFER_SIZE0 < 256
;unsigned char tx_counter0=0;
;#else
;unsigned int tx_counter0=0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 00AD {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00AE if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x3C
; 0000 00AF    {
; 0000 00B0    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 00B1    UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00B2 #if TX_BUFFER_SIZE0 != 256
; 0000 00B3    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0x3D
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 00B4 #endif
; 0000 00B5    }
_0x3D:
; 0000 00B6 }
_0x3C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00BF {
_putchar:
; .FSTART _putchar
; 0000 00C0 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x3E:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x3E
; 0000 00C1 #asm("cli")
	cli
; 0000 00C2 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x42
	SBIC 0xB,5
	RJMP _0x41
_0x42:
; 0000 00C3    {
; 0000 00C4    tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00C5 #if TX_BUFFER_SIZE0 != 256
; 0000 00C6    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x44
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00C7 #endif
; 0000 00C8    ++tx_counter0;
_0x44:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00C9    }
; 0000 00CA else
	RJMP _0x45
_0x41:
; 0000 00CB    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00CC #asm("sei")
_0x45:
	sei
; 0000 00CD }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;int on_pressed = 0;
;int off_pressed = 0;
;int reset_pressed = 0;
;short int on_button_state = 0x0000;
;short int off_button_state = 0x0000;
;short int reset_button_state = 0x0000;
;
;// Timer3 overflow interrupt service routine
;interrupt[TIM3_OVF] void timer3_ovf_isr(void) {
; 0000 00D9 interrupt[30] void timer3_ovf_isr(void) {
_timer3_ovf_isr:
; .FSTART _timer3_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00DA 
; 0000 00DB     // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF
; 0000 00DC 
; 0000 00DD     // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-softwar ...
; 0000 00DE     // 16 bit shifts = approx 130msec debounce delay
; 0000 00DF on_button_state = (0x8000 | !PINE.4) | (on_button_state << 1);
	LDI  R30,0
	SBIS 0x1,4
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	LDS  R30,_on_button_state
	LDS  R31,_on_button_state+1
	CALL SUBOPT_0xB
	STS  _on_button_state,R30
	STS  _on_button_state+1,R31
; 0000 00E0     if(on_button_state == 0xC000) {
	LDS  R26,_on_button_state
	LDS  R27,_on_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x46
; 0000 00E1        on_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R31
; 0000 00E2 
; 0000 00E3     }
; 0000 00E4 
; 0000 00E5     off_button_state = (0x8000 | !PINE.6) | (off_button_state << 1);
_0x46:
	LDI  R30,0
	SBIS 0x1,6
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	LDS  R30,_off_button_state
	LDS  R31,_off_button_state+1
	CALL SUBOPT_0xB
	STS  _off_button_state,R30
	STS  _off_button_state+1,R31
; 0000 00E6     if(off_button_state == 0xC000 ) {
	LDS  R26,_off_button_state
	LDS  R27,_off_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x47
; 0000 00E7         off_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _off_pressed,R30
	STS  _off_pressed+1,R31
; 0000 00E8     }
; 0000 00E9 
; 0000 00EA     reset_button_state = (0x8000 | !PIND.4) | (reset_button_state << 1);
_0x47:
	LDI  R30,0
	SBIS 0x10,4
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	LDS  R30,_reset_button_state
	LDS  R31,_reset_button_state+1
	CALL SUBOPT_0xB
	STS  _reset_button_state,R30
	STS  _reset_button_state+1,R31
; 0000 00EB     if(reset_button_state == 0xC000 ) {
	LDS  R26,_reset_button_state
	LDS  R27,_reset_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x48
; 0000 00EC         reset_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _reset_pressed,R30
	STS  _reset_pressed+1,R31
; 0000 00ED     }
; 0000 00EE 
; 0000 00EF }
_0x48:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;// SPI functions
;#include <spi.h>
;//---------------THERMOCOUPLE------------
;#include "Thermocouple.c"
;//ThermoInit(void);
;/*
;/*
; *  Define literals for the SPI port accesses and the thermocouple chip
; *  select line.
; */
;#define  PORT_THERMO_CS           PORTE
;#define  DDR_THERMO_CS            DDRE
;#define  BIT_THERMO_CS            3
;#define  MASK_THERMO_CS           (1<<BIT_THERMO_CS)
;
;#define  PORT_SPI                 PORTB
;#define  DDR_SPI                  DDRB
;#define  BIT_SPI_SCK              1
;#define  MASK_SPI_SCK             (1<<BIT_SPI_SCK)
;#define  BIT_SPI_SS               0
;#define  MASK_SPI_SS              (1<<BIT_SPI_SS)
;#define  BIT_SPI_MISO             3
;#define  MASK_SPI_MISO            (1<<BIT_SPI_MISO)
;
;/*
; *  ThermoInit      set up hardware for using the MAX31855
; *
; *  This routine configures the SPI as a master for exchanging
; *  data with the MAX31855 thermocouple converter.  All pins
; *  and registers for accessing the various port lines are
; *  defined at the top of this code as named literals.
; */
;/*
;void  ThermoInit(void)
;{
;    PORT_THERMO_CS |= MASK_THERMO_CS;        // start with CS high
;    DDR_THERMO_CS |= MASK_THERMO_CS;         // now make that line an output
;
;    PORT_SPI |= MASK_SPI_SS;                 // SS* is not used but must be driven high
;    DDR_SPI |= MASK_SPI_SS;                  // SS* is not used but must be driven high
;    PORT_SPI &= ~MASK_SPI_SCK;               // drive SCK low
;    DDR_SPI |= MASK_SPI_SCK;                 // now make SCK an output
;
;    SPCR = (1<<SPE) | (1<<MSTR) | (1<<SPR0) | (1<<SPR1) | (1<<CPHA);
;                                             // enable SPI as master, slowest clock,
;                                             // data active on trailing edge of SCK
;}
;
;
;/*
; *  ThermoReadRaw      return 32-bit raw value from MAX31855
; *
; *  This routine uses a four-byte SPI exchange to collect a
; *  raw reading from the MAX31855 thermocouple converter.  That
; *  value is returned unprocessed to the calling routine.
; *
; *  Note that this routine does NO processing.  It does not
; *  check for error flags or reasonable data ranges.
;
;//  d = 0x01900000;            // thermocouple = +25C, reference = 0C, no faults
;//  d = 0xfff00000;            // thermocouple = -1C, reference = 0C, no faults
;//  d = 0xf0600000;            // thermocouple = -250C, reference = 0C, no faults
;//  d = 0x00010001;            // thermocouple = N/A, reference = N/A, open fault
;//  d = 0x00010002;            // thermocouple = N/A, reference = N/A, short to GND
;//  d = 0x00010004;            // thermocouple = N/A, refernece = N/A, short to VCC
;*/
;
;/*
;signed int  ThermoReadRaw (void)
;{
;    signed int                   d;
;    unsigned char                n;
;
;    PORT_THERMO_CS &= ~MASK_THERMO_CS;    // pull thermo CS low
;    d = 0;                                // start with nothing
;    for (n=3; n!=0xff; n--)
;    {
;        SPDR = 0;                         // send a null byte
;        while ((SPSR & (1<<SPIF)) == 0)  ;    // wait until transfer ends
;        d = (d<<8) + SPDR;                // add next byte, starting with MSB
;    }
;    PORT_THERMO_CS |= MASK_THERMO_CS;     // done, pull CS high
;    return  d;
;}
;
;/*
; *  ThermoReadC      return thermocouple temperature in degrees C
; *
; *  This routine takes a raw reading from the thermocouple converter
; *  and translates that value into a temperature in degrees C.  That
; *  value is returned to the calling routine as an integer value,
; *  rounded.
; *
; *  The thermocouple value is stored in bits 31-18 as a signed 14-bit
; *  value, where the LSB represents 0.25 degC.  To convert to an
; *  integer value with no intermediate float operations, this code
; *  shifts the value 20 places right, rather than 18, effectively
; *  dividing the raw value by 4 and scaling it to unit degrees.
; *
; *  Note that this routine does NOT check the error flags in the
; *  raw value.  This would be a nice thing to add later, when I've
; *  figured out how I want to propagate the error conditions...
; */
; /*
;int  ThermoReadC(void)
;{
;    signed int d;
;    int neg;
;
;
;    neg = 0;                    // assume a positive raw value
;    d = ThermoReadRaw();        // get a raw value
;    d = ((d >> 10) & 0x3fff);   // leave only thermocouple value in d
;    if (d & 0x2000)             // if thermocouple reading is negative...
;    {
;        d = -d & 0x3fff;        // always work with positive values
;        neg = 1;                // but note original value was negative
;    }
;    d = d + 2;                  // round up by 0.5 degC (2 LSBs)
;    d = d >> 2;                 // now convert from 0.25 degC units to degC
;    if (neg)  d = -d;           // convert to negative if needed
;    return  d;                  // return as integer
;}
;   */
;
;/*
; *  ThermoReadF      return thermocouple temperature in degrees F
; *
; *  This routine takes a reading from the thermocouple converter in
; *  degC and converts it to degF.
; *
; *  Note that this routine simply calls ThermoReadC and converts
; *  from degC to degF using integer math.  This routine does not
; *  see the raw converter value and cannot do any error checking.
; */
;/*int  ThermoReadF(void)
;{
;    int t;
;
;    t = ThermoReadC();           // get the value in degC
;    t = ((t * 90) / 50) + 32;    // convert to degF
;    return  t;                   // all done
;}*/
;
;
;//---------------Variables---------------
;#include <variables.h>
;//-------------Display Functions---------
;#include "Display_functions.c"
;//#include <variables.h>
;
;void pointer_display_horiz()                          //checks the cursor position.
; 0000 00F9 {
_pointer_display_horiz:
; .FSTART _pointer_display_horiz
;    lcd_gotoxy(0,2);
	CALL SUBOPT_0xC
;    lcd_putsf(" ");
;    lcd_gotoxy(1,2);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
;    lcd_putsf(" ");
;    lcd_gotoxy(2,2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0xD
;    lcd_putsf(" ");
;    lcd_gotoxy(3,2);
	LDI  R30,LOW(3)
	CALL SUBOPT_0xD
;    lcd_putsf(" ");
;    lcd_gotoxy(Pointer_horiz,2);                      //Pointer displays arrow at that position
	ST   -Y,R8
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
;    lcd_putsf("^");
	__POINTW2FN _0x0,79
	RJMP _0x212000C
;}
; .FEND
;
;void pointer_display_vert()                          //checks the cursor position.
;{
_pointer_display_vert:
; .FSTART _pointer_display_vert
;    lcd_gotoxy(0,0);
	CALL SUBOPT_0xE
;    lcd_putsf(" ");
	CALL SUBOPT_0xF
;    lcd_gotoxy(0,1);
	CALL SUBOPT_0x10
;    lcd_putsf(" ");
	CALL SUBOPT_0xF
;    lcd_gotoxy(0,2);
	CALL SUBOPT_0xC
;    lcd_putsf(" ");
;    lcd_gotoxy(0,3);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x11
;    lcd_putsf(" ");
	CALL SUBOPT_0xF
;    lcd_gotoxy(0,Pointer_vert);                      //Pointer displays arrow at that position
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R10
	CALL _lcd_gotoxy
;    lcd_putsf(">");
	__POINTW2FN _0x0,4
_0x212000C:
	CALL _lcd_putsf
;}
	RET
; .FEND
;
;
;
;void show_volt()
;{
_show_volt:
; .FSTART _show_volt
;    sprintf(disp_volt,"%03d",set_voltage);
	LDI  R30,LOW(_disp_volt)
	LDI  R31,HIGH(_disp_volt)
	CALL SUBOPT_0x12
;    lcd_gotoxy(0,1);
	CALL SUBOPT_0x10
;    lcd_puts(disp_volt);
	LDI  R26,LOW(_disp_volt)
	LDI  R27,HIGH(_disp_volt)
	RJMP _0x2120008
;}
; .FEND
;void show_current()
;{
_show_current:
; .FSTART _show_current
;    sprintf(disp_current,"%02d",set_current);
	LDI  R30,LOW(_disp_current)
	LDI  R31,HIGH(_disp_current)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,86
	CALL SUBOPT_0x13
;    lcd_gotoxy(0,1);
	CALL SUBOPT_0x10
;    lcd_puts(disp_current);
	LDI  R26,LOW(_disp_current)
	LDI  R27,HIGH(_disp_current)
	RJMP _0x2120008
;}
; .FEND
;
;//----Input and val change functions-----
;#include "Change.c"
;#include "Inputs.c"
;//#include <variables.h>
;
;
;
;void input(int next)                         //next recieves value no of options we will have in the next menu
; 0000 00FC {
_input:
; .FSTART _input
;    Pt = Pointer_vert;
	ST   -Y,R27
	ST   -Y,R26
;	next -> Y+0
	MOVW R12,R10
;    pointer_display_vert();
	RCALL _pointer_display_vert
;    delay_ms(100);
	CALL SUBOPT_0x14
;    if (PINE.7 == 0)                                            //UP
	SBIC 0x1,7
	RJMP _0x49
;       {
;        while(PINE.7 == 0);
_0x4A:
	SBIS 0x1,7
	RJMP _0x4A
;        Pt--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
;        Pointer_vert = ((Pt < 0) ? (next+Pt): Pt) % next;
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRGE _0x4D
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x4E
_0x4D:
	MOVW R30,R12
_0x4E:
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	CALL __MODW21
	MOVW R10,R30
;        pointer_display_vert();
	RCALL _pointer_display_vert
;       }
;
;    if (PINE.5 == 0)                                            //DOWN
_0x49:
	SBIC 0x1,5
	RJMP _0x50
;       {
;        while(PINE.5 == 0);
_0x51:
	SBIS 0x1,5
	RJMP _0x51
;        Pointer_vert++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
;        Pointer_vert = Pointer_vert % next;
	LD   R30,Y
	LDD  R31,Y+1
	MOVW R26,R10
	CALL __MODW21
	MOVW R10,R30
;        pointer_display_vert();
	RCALL _pointer_display_vert
;       }
;
;    if (PINB.3 == 0)                                            //ENTER
_0x50:
	SBIC 0x16,3
	RJMP _0x54
;       {
;        while(PINB.3 == 0);
_0x55:
	SBIS 0x16,3
	RJMP _0x55
;        if(Screen < 10)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x58
;        {
;            Screen = ((Screen+1)*10) + Pointer_vert;
	MOVW R30,R4
	ADIW R30,1
	RJMP _0xBC
;        }
;        else
_0x58:
;        {
;            Screen = ((Screen)*10) + Pointer_vert;
	MOVW R30,R4
_0xBC:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R10
	ADC  R31,R11
	MOVW R4,R30
;        }
;
;
;       }
;
;    if (PIND.2 == 0)                                            //ESCAPE
_0x54:
	SBIC 0x10,2
	RJMP _0x5A
;       {
;        while(PIND.2 == 0);
_0x5B:
	SBIS 0x10,2
	RJMP _0x5B
;
;            if (Screen == 2)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x5E
;            {
;              lcd_clear();
	CALL SUBOPT_0x15
;              lcd_gotoxy(0,0);
;              lcd_putsf("Main Screen");
	__POINTW2FN _0x0,91
	CALL _lcd_putsf
;              delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
;              main_screen_trigger = 1;
	CALL SUBOPT_0x16
;              current_mainscreen_flag = 1;
	CALL SUBOPT_0x3
;              Current_Screen = 0;
	CLR  R6
	CLR  R7
;              set_flag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _set_flag,R30
	STS  _set_flag+1,R31
;
;            }
;            else if(Screen > 100)
	RJMP _0x5F
_0x5E:
	CALL SUBOPT_0x17
	BRGE _0x60
;            {
;                Screen = Screen/10;
	CALL SUBOPT_0x18
	RJMP _0xBD
;            }
;            else
_0x60:
;            {
;                Screen = (Screen/10)-1;
	CALL SUBOPT_0x18
	SBIW R30,1
_0xBD:
	MOVW R4,R30
;            }
_0x5F:
;
;
;       }
;
;}
_0x5A:
_0x212000B:
	ADIW R28,2
	RET
; .FEND
;
;
;void input_volt(int next)
;{
_input_volt:
; .FSTART _input_volt
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
	CALL SUBOPT_0x19
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.7 == 0)                                            //UP     1
	SBIC 0x1,7
	RJMP _0x62
;       {
;        while(PINE.7 == 0);
_0x63:
	SBIS 0x1,7
	RJMP _0x63
;        if(change == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x66
;        {set_voltage = set_voltage + (change);}
	MOVW R30,R16
	CALL SUBOPT_0x1A
	RJMP _0xBE
;        else
_0x66:
;        {set_voltage = set_voltage + 1 + (change);}
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
_0xBE:
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x1D
;        set_voltage = set_voltage % 1000;
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
;        show_volt();
	RCALL _show_volt
;        pointer_display_horiz();
	RCALL _pointer_display_horiz
;       }
;
;    if (PINE.5 == 0)                                            //Next   2
_0x62:
	SBIC 0x1,5
	RJMP _0x68
;       {
;        while(PINE.5 == 0);
_0x69:
	SBIS 0x1,5
	RJMP _0x69
;        Pointer_horiz++;
	CALL SUBOPT_0x1F
;
;        Pointer_horiz = Pointer_horiz % next;
;        pointer_display_horiz();
;       }
;
;    if (PINB.3 == 0)                                             //ENTER 3
_0x68:
	SBIC 0x16,3
	RJMP _0x6C
;        {
;         while(PINB.3 == 0);
_0x6D:
	SBIS 0x16,3
	RJMP _0x6D
;         if(110 <= set_voltage && set_voltage <= 135)
	CALL SUBOPT_0x1B
	__CPD1N 0x6E
	BRLT _0x71
	CALL SUBOPT_0x1A
	__CPD2N 0x88
	BRLT _0x72
_0x71:
	RJMP _0x70
_0x72:
;         {
;            lcd_clear();
	CALL SUBOPT_0x15
;            lcd_gotoxy(0,0);
;            lcd_puts("Voltage set to:");
	__POINTW2MN _0x73,0
	CALL SUBOPT_0x20
;            lcd_gotoxy(4,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
;            lcd_putsf("V");
	__POINTW2FN _0x0,119
	CALL _lcd_putsf
;            show_volt();
	RCALL _show_volt
;
;            //Voltage = temp_volt;
;            flag = 11;
	CALL SUBOPT_0x21
;            Screen = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	MOVW R4,R30
;
;
;           // delay_ms(2000);
;
;            txSetVoltage(set_voltage);
	LDS  R26,_set_voltage
	LDS  R27,_set_voltage+1
	RCALL _txSetVoltage
;         }
;         else
	RJMP _0x74
_0x70:
;         {
;            lcd_clear();
	CALL SUBOPT_0x15
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
	CALL SUBOPT_0x22
;            lcd_gotoxy(0,1);
;            lcd_putsf("be between 110-");
	__POINTW2FN _0x0,138
	CALL SUBOPT_0x23
;            lcd_gotoxy(0,2);
;            lcd_putsf("135 volts");
	__POINTW2FN _0x0,154
	CALL _lcd_putsf
;            set_voltage = 000;
	LDI  R30,LOW(0)
	STS  _set_voltage,R30
	STS  _set_voltage+1,R30
	STS  _set_voltage+2,R30
	STS  _set_voltage+3,R30
;            Screen = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	MOVW R4,R30
;            flag = 11;
	CALL SUBOPT_0x21
;            delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
;         }
_0x74:
;
;        }
;
;    if (PIND.2 == 0)                                            //ESCAPE 4
_0x6C:
	SBIC 0x10,2
	RJMP _0x75
;       {
;        while(PIND.2 == 0);
_0x76:
	SBIS 0x10,2
	RJMP _0x76
;        flag = 11;
	CALL SUBOPT_0x21
;        if(Screen > 100)
	CALL SUBOPT_0x17
	BRGE _0x79
;        {Screen = Screen/10;}
	CALL SUBOPT_0x18
	RJMP _0xBF
;        else
_0x79:
;        {Screen = (Screen/10)-1;}
	CALL SUBOPT_0x18
	SBIW R30,1
_0xBF:
	MOVW R4,R30
;        //flag = 1;
;       }
;}
_0x75:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120006
; .FEND

	.DSEG
_0x73:
	.BYTE 0x10
;
;void input_current(int next)
;{

	.CSEG
_input_current:
; .FSTART _input_current
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
	CALL SUBOPT_0x19
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.7 == 0)                                            //UP     1
	SBIC 0x1,7
	RJMP _0x7B
;       {
;        while(PINE.7 == 0);
_0x7C:
	SBIS 0x1,7
	RJMP _0x7C
;        if(change == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x7F
;        {set_current = set_current + (change);}
	MOVW R30,R16
	CALL SUBOPT_0x24
	RJMP _0xC0
;        else
_0x7F:
;        {set_current = set_current + 1 + (change);}
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1C
_0xC0:
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x26
;        set_current = set_current % 1000;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x26
;        show_current();
	RCALL _show_current
;        pointer_display_horiz();
	RCALL _pointer_display_horiz
;       }
;
;    if (PINE.5 == 0)                                            //Next   2
_0x7B:
	SBIC 0x1,5
	RJMP _0x81
;       {
;        while(PINE.5 == 0);
_0x82:
	SBIS 0x1,5
	RJMP _0x82
;        Pointer_horiz++;
	CALL SUBOPT_0x1F
;
;        Pointer_horiz = Pointer_horiz % next;
;        pointer_display_horiz();
;       }
;
;    if (PINB.3 == 0)                                             //ENTER 3
_0x81:
	SBIC 0x16,3
	RJMP _0x85
;        {
;         while(PINB.3 == 0);
_0x86:
	SBIS 0x16,3
	RJMP _0x86
;         if(10 <= set_current && set_current <= 20)
	CALL SUBOPT_0x25
	__CPD1N 0xA
	BRLT _0x8A
	CALL SUBOPT_0x24
	__CPD2N 0x15
	BRLT _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
;         {
;            lcd_clear();
	CALL SUBOPT_0x15
;            lcd_gotoxy(0,0);
;            lcd_puts("Current set to:");
	__POINTW2MN _0x8C,0
	CALL SUBOPT_0x27
;            lcd_gotoxy(3,1);
;            lcd_putsf("A");
	__POINTW2FN _0x0,180
	CALL _lcd_putsf
;            show_current();
	RCALL _show_current
;            flag = 11;
	CALL SUBOPT_0x21
;            Screen = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	MOVW R4,R30
;            txSetCurrent(set_current);
	LDS  R26,_set_current
	LDS  R27,_set_current+1
	RCALL _txSetCurrent
;            delay_ms(2000);
	RJMP _0xC1
;
;         }
;         else
_0x89:
;         {
;            lcd_clear();
	CALL SUBOPT_0x15
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
	CALL SUBOPT_0x22
;            lcd_gotoxy(0,1);
;            lcd_putsf("be between 10-");
	__POINTW2FN _0x0,182
	CALL SUBOPT_0x23
;            lcd_gotoxy(0,2);
;            lcd_putsf("20 amps");
	__POINTW2FN _0x0,197
	CALL _lcd_putsf
;            set_current = 000;
	LDI  R30,LOW(0)
	STS  _set_current,R30
	STS  _set_current+1,R30
	STS  _set_current+2,R30
	STS  _set_current+3,R30
;            Screen = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	MOVW R4,R30
;            flag = 11;
	CALL SUBOPT_0x21
;            delay_ms(2000);
_0xC1:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
;         }
;        }
;
;    if (PIND.2 == 0)                                            //ESCAPE 4
_0x85:
	SBIC 0x10,2
	RJMP _0x8E
;       {
;        while(PIND.2 == 0);
_0x8F:
	SBIS 0x10,2
	RJMP _0x8F
;        flag = 11;
	CALL SUBOPT_0x21
;        if(Screen > 100)
	CALL SUBOPT_0x17
	BRGE _0x92
;        {Screen = Screen/10;}
	CALL SUBOPT_0x18
	RJMP _0xC2
;        else
_0x92:
;        {Screen = (Screen/10)-1;}
	CALL SUBOPT_0x18
	SBIW R30,1
_0xC2:
	MOVW R4,R30
;        //flag = 1;
;       }
;
;
;}
_0x8E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120006
; .FEND

	.DSEG
_0x8C:
	.BYTE 0x10
;
;
;
;
;void Screen1()
; 0000 0102 {

	.CSEG
_Screen1:
; .FSTART _Screen1
; 0000 0103     //Screen = 1;
; 0000 0104     Pointer_horiz = 0;
	CLR  R8
	CLR  R9
; 0000 0105     Pointer_vert = 0;
	CLR  R10
	CLR  R11
; 0000 0106     lcd_clear();
	CALL SUBOPT_0x15
; 0000 0107     lcd_gotoxy(0,0);
; 0000 0108     lcd_puts("Welcome to HMI");
	__POINTW2MN _0x94,0
	CALL _lcd_puts
; 0000 0109     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 010A     Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 010B     Current_Screen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 010C     main_screen_trigger = 1;
	CALL SUBOPT_0x16
; 0000 010D     current_mainscreen_flag = 1;
_0x212000A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _current_mainscreen_flag,R30
	STS  _current_mainscreen_flag+1,R31
; 0000 010E }
	RET
; .FEND

	.DSEG
_0x94:
	.BYTE 0xF
;
;void Screen2()
; 0000 0111 {

	.CSEG
_Screen2:
; .FSTART _Screen2
; 0000 0112     lcd_clear();
	CALL _lcd_clear
; 0000 0113     //Screen = 2;
; 0000 0114     Pointer_vert = 0;
	CLR  R10
	CLR  R11
; 0000 0115     Pointer_horiz= 0;
	CLR  R8
	CLR  R9
; 0000 0116 
; 0000 0117         lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x28
; 0000 0118         lcd_putsf("Set Parameters");
	__POINTW2FN _0x0,220
	CALL _lcd_putsf
; 0000 0119         n = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _n,R30
	STS  _n+1,R31
; 0000 011A         Current_Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120009
; 0000 011B }
; .FEND
;
;
;
;void Screen30()
; 0000 0120 {
_Screen30:
; .FSTART _Screen30
; 0000 0121     lcd_clear();
	CALL _lcd_clear
; 0000 0122     lcd_gotoxy(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x11
; 0000 0123     lcd_putsf("PARAMETERS");
	__POINTW2FN _0x0,235
	CALL _lcd_putsf
; 0000 0124     lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x28
; 0000 0125     lcd_putsf("Voltage (VOLTS)");
	__POINTW2FN _0x0,246
	CALL _lcd_putsf
; 0000 0126     lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x29
; 0000 0127     lcd_putsf("Current (AMPS)");
	__POINTW2FN _0x0,262
	CALL _lcd_putsf
; 0000 0128     n = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _n,R30
	STS  _n+1,R31
; 0000 0129     Current_Screen = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x2120009
; 0000 012A }
; .FEND
;
;void Screen300()      //SET VOLTAGE
; 0000 012D {
_Screen300:
; .FSTART _Screen300
; 0000 012E     lcd_clear();
	CALL SUBOPT_0x15
; 0000 012F     lcd_gotoxy(0,0);
; 0000 0130     lcd_putsf("Set voltage:");
	__POINTW2FN _0x0,277
	CALL _lcd_putsf
; 0000 0131     show_volt();
	RCALL _show_volt
; 0000 0132     while(flag != 11)
_0x95:
	LDS  R26,_flag
	LDS  R27,_flag+1
	SBIW R26,11
	BREQ _0x97
; 0000 0133     {
; 0000 0134         input_volt(3);
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _input_volt
; 0000 0135     }
	RJMP _0x95
_0x97:
; 0000 0136     flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 0137     Current_Screen = 300;
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP _0x2120009
; 0000 0138 }
; .FEND
;void Screen301()     //SET CURRENT
; 0000 013A {
_Screen301:
; .FSTART _Screen301
; 0000 013B 
; 0000 013C     lcd_clear();
	CALL SUBOPT_0x15
; 0000 013D     lcd_gotoxy(0,0);
; 0000 013E     lcd_putsf("Set current:");
	__POINTW2FN _0x0,290
	CALL _lcd_putsf
; 0000 013F     show_current();
	RCALL _show_current
; 0000 0140     while(flag != 11)
_0x98:
	LDS  R26,_flag
	LDS  R27,_flag+1
	SBIW R26,11
	BREQ _0x9A
; 0000 0141     {
; 0000 0142         input_current(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _input_current
; 0000 0143     }
	RJMP _0x98
_0x9A:
; 0000 0144     flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 0145     Current_Screen = 301;
	LDI  R30,LOW(301)
	LDI  R31,HIGH(301)
_0x2120009:
	MOVW R6,R30
; 0000 0146 }
	RET
; .FEND
;
;
;void Main_Screen()
; 0000 014A {
_Main_Screen:
; .FSTART _Main_Screen
; 0000 014B     lcd_clear();
	CALL SUBOPT_0x15
; 0000 014C 
; 0000 014D     lcd_gotoxy(0,0);
; 0000 014E     lcd_putsf("SV:");
	__POINTW2FN _0x0,303
	CALL _lcd_putsf
; 0000 014F 
; 0000 0150     lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x28
; 0000 0151     lcd_putsf("SBC:");
	__POINTW2FN _0x0,307
	CALL _lcd_putsf
; 0000 0152 
; 0000 0153     lcd_gotoxy(0,1);
	CALL SUBOPT_0x10
; 0000 0154     lcd_putsf("AV:");
	__POINTW2FN _0x0,312
	CALL _lcd_putsf
; 0000 0155 
; 0000 0156     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x29
; 0000 0157     lcd_putsf("ABC:");
	__POINTW2FN _0x0,316
	CALL SUBOPT_0x23
; 0000 0158 
; 0000 0159     lcd_gotoxy(0,2);
; 0000 015A     lcd_putsf("AIV:");
	__POINTW2FN _0x0,321
	CALL _lcd_putsf
; 0000 015B 
; 0000 015C     lcd_gotoxy(8,2);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2A
; 0000 015D     lcd_putsf("AOC:");
	__POINTW2FN _0x0,326
	CALL _lcd_putsf
; 0000 015E 
; 0000 015F     lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x28
; 0000 0160     sprintf(disp_set_voltage,"%03d",set_voltage);
	LDI  R30,LOW(_disp_set_voltage)
	LDI  R31,HIGH(_disp_set_voltage)
	CALL SUBOPT_0x12
; 0000 0161     lcd_puts(disp_set_voltage);
	LDI  R26,LOW(_disp_set_voltage)
	LDI  R27,HIGH(_disp_set_voltage)
	CALL _lcd_puts
; 0000 0162 
; 0000 0163     lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x28
; 0000 0164     sprintf(disp_set_btcurrent,"%03d",set_current);
	LDI  R30,LOW(_disp_set_btcurrent)
	LDI  R31,HIGH(_disp_set_btcurrent)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x13
; 0000 0165     lcd_puts(disp_set_btcurrent);
	LDI  R26,LOW(_disp_set_btcurrent)
	LDI  R27,HIGH(_disp_set_btcurrent)
_0x2120008:
	CALL _lcd_puts
; 0000 0166 
; 0000 0167    // current_mainscreen_flag = 0;
; 0000 0168 
; 0000 0169 
; 0000 016A 
; 0000 016B 
; 0000 016C }
	RET
; .FEND
;
;void Screen_sel()
; 0000 016F {
_Screen_sel:
; .FSTART _Screen_sel
; 0000 0170 
; 0000 0171     if (Screen == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9B
; 0000 0172     {
; 0000 0173         Screen1();
	RCALL _Screen1
; 0000 0174     }
; 0000 0175     if (Screen == 2)
_0x9B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9C
; 0000 0176     {
; 0000 0177         Screen2();
	RCALL _Screen2
; 0000 0178     }
; 0000 0179     if (Screen == 30)
_0x9C:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9D
; 0000 017A     {
; 0000 017B         Screen30();
	RCALL _Screen30
; 0000 017C     }
; 0000 017D     if (Screen == 300)
_0x9D:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9E
; 0000 017E     {
; 0000 017F         Screen300();
	RCALL _Screen300
; 0000 0180     }
; 0000 0181     if (Screen == 301)
_0x9E:
	LDI  R30,LOW(301)
	LDI  R31,HIGH(301)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x9F
; 0000 0182     {
; 0000 0183         Screen301();
	RCALL _Screen301
; 0000 0184     }
; 0000 0185 
; 0000 0186 }
_0x9F:
	RET
; .FEND
;
;void machine_state()
; 0000 0189 {
_machine_state:
; .FSTART _machine_state
; 0000 018A      if(fault_flag == 1)
	CALL SUBOPT_0x2C
	BRNE _0xA0
; 0000 018B      {
; 0000 018C         mainOff();
	RCALL _mainOff
; 0000 018D         on_pressed = 0;
	LDI  R30,LOW(0)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R30
; 0000 018E      }
; 0000 018F      else
	RJMP _0xA1
_0xA0:
; 0000 0190      {
; 0000 0191         PORTF |= 0x40;
	LDS  R30,98
	ORI  R30,0x40
	STS  98,R30
; 0000 0192 
; 0000 0193         if(on_pressed == 1)
	LDS  R26,_on_pressed
	LDS  R27,_on_pressed+1
	SBIW R26,1
	BRNE _0xA2
; 0000 0194         {
; 0000 0195             mainOn();
	RCALL _mainOn
; 0000 0196             on_pressed = 0;
	LDI  R30,LOW(0)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R30
; 0000 0197             //status = 1;
; 0000 0198         }
; 0000 0199         else if(off_pressed == 1)
	RJMP _0xA3
_0xA2:
	LDS  R26,_off_pressed
	LDS  R27,_off_pressed+1
	SBIW R26,1
	BRNE _0xA4
; 0000 019A         {
; 0000 019B             mainOff();
	RCALL _mainOff
; 0000 019C             off_pressed = 0;
	LDI  R30,LOW(0)
	STS  _off_pressed,R30
	STS  _off_pressed+1,R30
; 0000 019D             //status = 0;
; 0000 019E         }
; 0000 019F      }
_0xA4:
_0xA3:
_0xA1:
; 0000 01A0 
; 0000 01A1 //    if(data_received == 1)
; 0000 01A2 //    {
; 0000 01A3 //        recOp();
; 0000 01A4 //        data_received = 0;
; 0000 01A5 //        ms_update_flag = 1;
; 0000 01A6 //        //current_mainscreen_flag = 0;
; 0000 01A7 //    }
; 0000 01A8     if(reset_pressed == 1)
	LDS  R26,_reset_pressed
	LDS  R27,_reset_pressed+1
	SBIW R26,1
	BRNE _0xA5
; 0000 01A9     {
; 0000 01AA         resetFault();
	RCALL _resetFault
; 0000 01AB         reset_pressed = 0;
	LDI  R30,LOW(0)
	STS  _reset_pressed,R30
	STS  _reset_pressed+1,R30
; 0000 01AC     }
; 0000 01AD 
; 0000 01AE 
; 0000 01AF }
_0xA5:
	RET
; .FEND
;
;void main(void)
; 0000 01B2 {
_main:
; .FSTART _main
; 0000 01B3 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01B4 DDRA=0x00;
	OUT  0x1A,R30
; 0000 01B5 
; 0000 01B6 PORTB=0x08;
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 01B7 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 01B8 
; 0000 01B9 PORTC=0x08;
	LDI  R30,LOW(8)
	OUT  0x15,R30
; 0000 01BA DDRC=0x08;
	OUT  0x14,R30
; 0000 01BB 
; 0000 01BC PORTD=0xDC;
	LDI  R30,LOW(220)
	OUT  0x12,R30
; 0000 01BD DDRD=0x08;
	LDI  R30,LOW(8)
	OUT  0x11,R30
; 0000 01BE 
; 0000 01BF PORTE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x3,R30
; 0000 01C0 DDRE=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 01C1 
; 0000 01C2 PORTF=0xFF;
	LDI  R30,LOW(255)
	STS  98,R30
; 0000 01C3 DDRF=0xFF;
	STS  97,R30
; 0000 01C4 
; 0000 01C5 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 01C6 DDRG=0x00;
	STS  100,R30
; 0000 01C7 
; 0000 01C8 TCCR3A=0x00;
	STS  139,R30
; 0000 01C9 TCCR3B=0x09;
	LDI  R30,LOW(9)
	STS  138,R30
; 0000 01CA TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 01CB TCNT3L=0x00;
	STS  136,R30
; 0000 01CC ICR3H=0x00;
	STS  129,R30
; 0000 01CD ICR3L=0x00;
	STS  128,R30
; 0000 01CE OCR3AH=0xFF;
	LDI  R30,LOW(255)
	STS  135,R30
; 0000 01CF OCR3AL=0xFF;
	STS  134,R30
; 0000 01D0 OCR3BH=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 01D1 OCR3BL=0x00;
	STS  132,R30
; 0000 01D2 OCR3CH=0x00;
	STS  131,R30
; 0000 01D3 OCR3CL=0x00;
	STS  130,R30
; 0000 01D4 
; 0000 01D5 // External Interrupt(s) initialization
; 0000 01D6 //EICRA=0x00;
; 0000 01D7 //EICRB=0xAA;
; 0000 01D8 //EIMSK=0xF0;
; 0000 01D9 //EIFR=0xF0;
; 0000 01DA 
; 0000 01DB // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01DC TIMSK=0x00;
	OUT  0x37,R30
; 0000 01DD ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 01DE 
; 0000 01DF 
; 0000 01E0 // USART0 initialization
; 0000 01E1 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E2 // USART0 Receiver: On
; 0000 01E3 // USART0 Transmitter: On
; 0000 01E4 // USART0 Mode: Asynchronous
; 0000 01E5 // USART0 Baud Rate: 9600
; 0000 01E6 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01E7 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01E8 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01E9 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 01EA UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01EB 
; 0000 01EC 
; 0000 01ED 
; 0000 01EE lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 01EF 
; 0000 01F0 // Global enable interrupts
; 0000 01F1 #asm("sei")
	sei
; 0000 01F2 
; 0000 01F3 
; 0000 01F4     while(1)
_0xA6:
; 0000 01F5         {
; 0000 01F6             if(fault_flag == 1)
	CALL SUBOPT_0x2C
	BRNE _0xA9
; 0000 01F7             {
; 0000 01F8                 lcd_clear();
	CALL SUBOPT_0x15
; 0000 01F9                 lcd_gotoxy(0,0);
; 0000 01FA                 lcd_puts("Fault ID:");
	__POINTW2MN _0xAA,0
	CALL SUBOPT_0x20
; 0000 01FB                 lcd_gotoxy(4,2);
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 01FC 
; 0000 01FD 
; 0000 01FE                 lcd_puts(fltArray);
	LDI  R26,LOW(_fltArray)
	LDI  R27,HIGH(_fltArray)
	CALL _lcd_puts
; 0000 01FF 
; 0000 0200                 while(fault_flag == 1)machine_state();
_0xAB:
	CALL SUBOPT_0x2C
	BRNE _0xAD
	RCALL _machine_state
	RJMP _0xAB
_0xAD:
; 0000 0201 }
; 0000 0202 
; 0000 0203             if (Screen == 1)        //runs only at start
_0xA9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0xAE
; 0000 0204             {Screen1();}
	RCALL _Screen1
; 0000 0205 
; 0000 0206 
; 0000 0207 
; 0000 0208             if (main_screen_trigger == 1) //| ms_update_flag == 1)
_0xAE:
	LDS  R26,_main_screen_trigger
	LDS  R27,_main_screen_trigger+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xAF
; 0000 0209             {
; 0000 020A                 if(current_mainscreen_flag == 1)
	LDS  R26,_current_mainscreen_flag
	LDS  R27,_current_mainscreen_flag+1
	SBIW R26,1
	BRNE _0xB0
; 0000 020B                 {Main_Screen();}      //Function to display all values
	RCALL _Main_Screen
; 0000 020C 
; 0000 020D                 lcd_gotoxy(3,1);
_0xB0:
	LDI  R30,LOW(3)
	CALL SUBOPT_0x29
; 0000 020E                 sprintf(disp_actual_voltage,"%03d",actual_voltage);
	LDI  R30,LOW(_disp_actual_voltage)
	LDI  R31,HIGH(_disp_actual_voltage)
	CALL SUBOPT_0x2B
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_actual_voltage_G000
	LDS  R31,_actual_voltage_G000+1
	CALL SUBOPT_0x2
; 0000 020F                 lcd_puts("000");
	__POINTW2MN _0xAA,10
	CALL SUBOPT_0x27
; 0000 0210                 lcd_gotoxy(3,1);
; 0000 0211                 lcd_puts(disp_actual_voltage);
	LDI  R26,LOW(_disp_actual_voltage)
	LDI  R27,HIGH(_disp_actual_voltage)
	CALL _lcd_puts
; 0000 0212 
; 0000 0213                 lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x29
; 0000 0214                 sprintf(disp_actual_btcurrent,"%03d",actual_btcurrent);
	LDI  R30,LOW(_disp_actual_btcurrent)
	LDI  R31,HIGH(_disp_actual_btcurrent)
	CALL SUBOPT_0x2B
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_actual_btcurrent_G000
	LDS  R31,_actual_btcurrent_G000+1
	CALL SUBOPT_0x2
; 0000 0215                 lcd_puts("000");
	__POINTW2MN _0xAA,14
	CALL _lcd_puts
; 0000 0216                 lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x29
; 0000 0217                 lcd_puts(disp_actual_btcurrent);
	LDI  R26,LOW(_disp_actual_btcurrent)
	LDI  R27,HIGH(_disp_actual_btcurrent)
	CALL SUBOPT_0x20
; 0000 0218 
; 0000 0219                 lcd_gotoxy(4,2);
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 021A                 sprintf(disp_actual_ipvoltage,"%03d",actual_ipvoltage);
	LDI  R30,LOW(_disp_actual_ipvoltage)
	LDI  R31,HIGH(_disp_actual_ipvoltage)
	CALL SUBOPT_0x2B
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_actual_ipvoltage_G000
	LDS  R31,_actual_ipvoltage_G000+1
	CALL SUBOPT_0x2
; 0000 021B                 lcd_puts("000");
	__POINTW2MN _0xAA,18
	CALL SUBOPT_0x20
; 0000 021C                 lcd_gotoxy(4,2);
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 021D                 lcd_puts(disp_actual_ipvoltage);
	LDI  R26,LOW(_disp_actual_ipvoltage)
	LDI  R27,HIGH(_disp_actual_ipvoltage)
	CALL _lcd_puts
; 0000 021E 
; 0000 021F                 lcd_gotoxy(12,2);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x2A
; 0000 0220                 sprintf(disp_actual_opcurrent,"%03d",actual_opcurrent);
	LDI  R30,LOW(_disp_actual_opcurrent)
	LDI  R31,HIGH(_disp_actual_opcurrent)
	CALL SUBOPT_0x2B
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_actual_opcurrent_G000
	LDS  R31,_actual_opcurrent_G000+1
	CALL SUBOPT_0x2
; 0000 0221                 lcd_puts("000");
	__POINTW2MN _0xAA,22
	CALL _lcd_puts
; 0000 0222                 lcd_gotoxy(12,2);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x2A
; 0000 0223                 lcd_puts(disp_actual_opcurrent);
	LDI  R26,LOW(_disp_actual_opcurrent)
	LDI  R27,HIGH(_disp_actual_opcurrent)
	CALL _lcd_puts
; 0000 0224                 if (status == 1)
	LDS  R26,_status
	LDS  R27,_status+1
	SBIW R26,1
	BRNE _0xB1
; 0000 0225                 {
; 0000 0226                 lcd_gotoxy(1,3);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x11
; 0000 0227                 lcd_putsf("Machine : ON ");
	__POINTW2FN _0x0,345
	RJMP _0xC3
; 0000 0228                 }
; 0000 0229                 else if (status == 0)
_0xB1:
	LDS  R30,_status
	LDS  R31,_status+1
	SBIW R30,0
	BRNE _0xB3
; 0000 022A                 {
; 0000 022B                     lcd_gotoxy(1,3);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x11
; 0000 022C                     lcd_putsf("Machine : OFF");
	__POINTW2FN _0x0,359
_0xC3:
	CALL _lcd_putsf
; 0000 022D                 }
; 0000 022E                 ms_update_flag = 0;
_0xB3:
	LDI  R30,LOW(0)
	STS  _ms_update_flag,R30
	STS  _ms_update_flag+1,R30
; 0000 022F                 //main_screen_trigger = 0;
; 0000 0230                 current_mainscreen_flag = 0;
	STS  _current_mainscreen_flag,R30
	STS  _current_mainscreen_flag+1,R30
; 0000 0231             }
; 0000 0232 
; 0000 0233             machine_state();    //Check for ON,OFF,reset  button press
_0xAF:
	RCALL _machine_state
; 0000 0234 
; 0000 0235             if (PIND.2 == 0)    //When 4 pressed
	SBIC 0x10,2
	RJMP _0xB4
; 0000 0236             {
; 0000 0237                 main_screen_trigger = 0;
	LDI  R30,LOW(0)
	STS  _main_screen_trigger,R30
	STS  _main_screen_trigger+1,R30
; 0000 0238                 while(set_flag != 1)
_0xB5:
	LDS  R26,_set_flag
	LDS  R27,_set_flag+1
	SBIW R26,1
	BREQ _0xB7
; 0000 0239                 {
; 0000 023A                 while(Screen != Current_Screen)
_0xB8:
	__CPWRR 6,7,4,5
	BREQ _0xBA
; 0000 023B                 {
; 0000 023C                     Screen_sel();       //Screen selection
	RCALL _Screen_sel
; 0000 023D                 }
	RJMP _0xB8
_0xBA:
; 0000 023E                 input(n);
	LDS  R26,_n
	LDS  R27,_n+1
	RCALL _input
; 0000 023F                 machine_state();
	RCALL _machine_state
; 0000 0240                 }
	RJMP _0xB5
_0xB7:
; 0000 0241                 set_flag = 0;
	LDI  R30,LOW(0)
	STS  _set_flag,R30
	STS  _set_flag+1,R30
; 0000 0242                 Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0243                 lcd_clear();
	CALL _lcd_clear
; 0000 0244             }
; 0000 0245 
; 0000 0246 
; 0000 0247         }
_0xB4:
	RJMP _0xA6
; 0000 0248 
; 0000 0249 }
_0xBB:
	RJMP _0xBB
; .FEND

	.DSEG
_0xAA:
	.BYTE 0x1A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0xA
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0xA
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x2D
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x2D
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x2E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2F
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x2D
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x2F
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2F
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x32
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x32
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x33
	RJMP _0x2120006
__floor1:
    brtc __floor0
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
_0x2120006:
	ADIW R28,4
	RET
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x35
	CALL __CPD02
	BRLT _0x204000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2120005
_0x204000C:
	CALL SUBOPT_0x36
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x37
	CALL SUBOPT_0x35
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x204000D
	CALL SUBOPT_0x38
	CALL __ADDF12
	CALL SUBOPT_0x37
	__SUBWRN 16,17,1
_0x204000D:
	CALL SUBOPT_0x36
	CALL SUBOPT_0x34
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x36
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	__GETD2N 0x3F654226
	CALL SUBOPT_0x3A
	__GETD1N 0x4054114E
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x35
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3C
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x2120005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x3D
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x204000F
	CALL SUBOPT_0x3E
	RJMP _0x2120004
_0x204000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2040010
	__GETD1N 0x3F800000
	RJMP _0x2120004
_0x2040010:
	CALL SUBOPT_0x3D
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040011
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120004
_0x2040011:
	CALL SUBOPT_0x3D
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x3D
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x3D
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x3B
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x35
	CALL __MULF12
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3C
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x36
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3C
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x2120004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x3F
	CALL __CPD10
	BRNE _0x2040012
	CALL SUBOPT_0x3E
	RJMP _0x2120003
_0x2040012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2040013
	CALL SUBOPT_0x40
	CALL __CPD10
	BRNE _0x2040014
	__GETD1N 0x3F800000
	RJMP _0x2120003
_0x2040014:
	__GETD2S 8
	CALL SUBOPT_0x41
	RCALL _exp
	RJMP _0x2120003
_0x2040013:
	CALL SUBOPT_0x40
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x33
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x40
	CALL __CPD12
	BREQ _0x2040015
	CALL SUBOPT_0x3E
	RJMP _0x2120003
_0x2040015:
	CALL SUBOPT_0x3F
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x41
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2040016
	CALL SUBOPT_0x3F
	RJMP _0x2120003
_0x2040016:
	CALL SUBOPT_0x3F
	CALL __ANEGF1
_0x2120003:
	ADIW R28,12
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G104:
; .FSTART __lcd_write_nibble_G104
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 27
	SBI  0x15,2
	__DELAY_USB 27
	CBI  0x15,2
	__DELAY_USB 27
	RJMP _0x2120001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G104
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G104
	__DELAY_USW 200
	RJMP _0x2120001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G104)
	SBCI R31,HIGH(-__base_y_G104)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x42
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x42
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2080004
_0x2080005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2080007
	RJMP _0x2120001
_0x2080007:
_0x2080004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2120001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2080008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x208000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2080008
_0x208000A:
	RJMP _0x2120002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x208000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x208000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x208000B
_0x208000D:
_0x2120002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G104,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G104,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x43
	CALL SUBOPT_0x43
	CALL SUBOPT_0x43
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G104
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2120001:
	ADIW R28,1
	RET
; .FEND

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_set_voltage:
	.BYTE 0x4
_set_current:
	.BYTE 0x4
_actual_voltage_G000:
	.BYTE 0x2
_actual_btcurrent_G000:
	.BYTE 0x2
_actual_ipvoltage_G000:
	.BYTE 0x2
_actual_opcurrent_G000:
	.BYTE 0x2
_set_flag:
	.BYTE 0x2
_flag:
	.BYTE 0x2
_n:
	.BYTE 0x2
_main_screen_trigger:
	.BYTE 0x2
_ms_update_flag:
	.BYTE 0x2
_current_mainscreen_flag:
	.BYTE 0x2
_status:
	.BYTE 0x2
_fault_flag:
	.BYTE 0x2
_fltArray:
	.BYTE 0x9
_disp_volt:
	.BYTE 0x3
_disp_current:
	.BYTE 0x3
_disp_set_voltage:
	.BYTE 0x3
_disp_set_btcurrent:
	.BYTE 0x4
_disp_actual_voltage:
	.BYTE 0x3
_disp_actual_btcurrent:
	.BYTE 0x4
_disp_actual_ipvoltage:
	.BYTE 0x3
_disp_actual_opcurrent:
	.BYTE 0x4
_xmitMsg:
	.BYTE 0x2
_rdataA:
	.BYTE 0x14
_comStart:
	.BYTE 0x2
_i:
	.BYTE 0x2
_rx_buffer0:
	.BYTE 0x20
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x1
_tx_buffer0:
	.BYTE 0x40
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
_on_pressed:
	.BYTE 0x2
_off_pressed:
	.BYTE 0x2
_reset_pressed:
	.BYTE 0x2
_on_button_state:
	.BYTE 0x2
_off_button_state:
	.BYTE 0x2
_reset_button_state:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4
__base_y_G104:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
	__GETWRS 16,17,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _current_mainscreen_flag,R30
	STS  _current_mainscreen_flag+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ST   -Y,R27
	ST   -Y,R26
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R20
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDS  R30,_i
	LDS  R31,_i+1
	SUBI R30,LOW(-_rdataA)
	SBCI R31,HIGH(-_rdataA)
	ST   Z,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LSL  R30
	ROL  R31
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
	__POINTW2FN _0x0,77
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
	__POINTW2FN _0x0,77
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__POINTW2FN _0x0,77
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	LDI  R26,LOW(3)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,81
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_set_voltage
	LDS  R31,_set_voltage+1
	LDS  R22,_set_voltage+2
	LDS  R23,_set_voltage+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_set_current
	LDS  R31,_set_current+1
	LDS  R22,_set_current+2
	LDS  R23,_set_current+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x15:
	CALL _lcd_clear
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _main_screen_trigger,R30
	STS  _main_screen_trigger+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	MOVW R26,R4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x19:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	__GETD1N 0x41200000
	CALL __PUTPARD1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUB  R26,R8
	SBC  R27,R9
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL _pow
	CALL __CFD1U
	MOVW R16,R30
	CALL _pointer_display_horiz
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDS  R26,_set_voltage
	LDS  R27,_set_voltage+1
	LDS  R24,_set_voltage+2
	LDS  R25,_set_voltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDS  R30,_set_voltage
	LDS  R31,_set_voltage+1
	LDS  R22,_set_voltage+2
	LDS  R23,_set_voltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	__ADDD1N 1
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	STS  _set_voltage,R30
	STS  _set_voltage+1,R31
	STS  _set_voltage+2,R22
	STS  _set_voltage+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETD1N 0x3E8
	CALL __MODD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	MOVW R26,R8
	CALL __MODW21
	MOVW R8,R30
	JMP  _pointer_display_horiz

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	CALL _lcd_puts
	LDI  R30,LOW(4)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _flag,R30
	STS  _flag+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__POINTW2FN _0x0,121
	CALL _lcd_putsf
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDS  R26,_set_current
	LDS  R27,_set_current+1
	LDS  R24,_set_current+2
	LDS  R25,_set_current+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDS  R30,_set_current
	LDS  R31,_set_current+1
	LDS  R22,_set_current+2
	LDS  R23,_set_current+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	STS  _set_current,R30
	STS  _set_current+1,R31
	STS  _set_current+2,R22
	STS  _set_current+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	CALL _lcd_puts
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,81
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDS  R26,_fault_flag
	LDS  R27,_fault_flag+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2D:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x35:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x36
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x43:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G104
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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
