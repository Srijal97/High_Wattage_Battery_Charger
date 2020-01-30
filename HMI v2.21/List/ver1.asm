
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
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
	.DEF _msg=R4
	.DEF _msg_msb=R5
	.DEF _xmitMsg=R6
	.DEF _xmitMsg_msb=R7
	.DEF _rec=R8
	.DEF _rec_msb=R9
	.DEF _rdata=R10
	.DEF _rdata_msb=R11
	.DEF _data=R13
	.DEF _rx_wr_index0=R12

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
	JMP  _ext_int4_isr
	JMP  _ext_int5_isr
	JMP  _ext_int6_isr
	JMP  _ext_int7_isr
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
	.DB  0x0

_0x6:
	.DB  LOW(_noOp),HIGH(_noOp),LOW(_mainOn),HIGH(_mainOn),LOW(_mainOff),HIGH(_mainOff),LOW(_resetFault),HIGH(_resetFault)
	.DB  LOW(_readVolt),HIGH(_readVolt),LOW(_readAmp),HIGH(_readAmp)
_0xF:
	.DB  LOW(_rnoOp),HIGH(_rnoOp),LOW(_rmainOn),HIGH(_rmainOn),LOW(_rmainOff),HIGH(_rmainOff),LOW(_rresetFault),HIGH(_rresetFault)
	.DB  LOW(_rreadVolt),HIGH(_rreadVolt),LOW(_rreadAmp),HIGH(_rreadAmp)
_0x35:
	.DB  0x1
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x69,0x6E,0x67
	.DB  0x20,0x53,0x6F,0x66,0x74,0x2D,0x53,0x74
	.DB  0x61,0x72,0x74,0x0,0x3C,0x30,0x30,0x31
	.DB  0x3E,0x0,0x45,0x6E,0x74,0x65,0x72,0x69
	.DB  0x6E,0x67,0x20,0x53,0x6F,0x66,0x74,0x2D
	.DB  0x53,0x74,0x6F,0x70,0x0,0x3C,0x30,0x30
	.DB  0x32,0x3E,0x0,0x52,0x65,0x73,0x65,0x74
	.DB  0x74,0x69,0x6E,0x67,0x20,0x46,0x61,0x75
	.DB  0x6C,0x74,0x73,0x0,0x3C,0x30,0x30,0x33
	.DB  0x3E,0x0,0x3C,0x30,0x30,0x34,0x3E,0x0
	.DB  0x3C,0x30,0x30,0x35,0x3E,0x0,0x54,0x68
	.DB  0x65,0x20,0x53,0x79,0x73,0x74,0x65,0x6D
	.DB  0x20,0x68,0x61,0x73,0x20,0x74,0x75,0x72
	.DB  0x6E,0x65,0x64,0x20,0x6F,0x6E,0x0,0x54
	.DB  0x68,0x65,0x20,0x53,0x79,0x73,0x74,0x65
	.DB  0x6D,0x20,0x68,0x61,0x73,0x20,0x74,0x75
	.DB  0x72,0x6E,0x65,0x64,0x20,0x6F,0x66,0x66
	.DB  0x0,0x46,0x61,0x75,0x6C,0x74,0x73,0x20
	.DB  0x68,0x61,0x76,0x65,0x20,0x62,0x65,0x65
	.DB  0x6E,0x20,0x72,0x65,0x73,0x65,0x74,0x0
	.DB  0x63,0x6F,0x6D,0x6D,0x61,0x6E,0x64,0x20
	.DB  0x73,0x74,0x61,0x72,0x74,0x0,0x63,0x6F
	.DB  0x6D,0x6D,0x61,0x6E,0x64,0x20,0x65,0x6E
	.DB  0x64,0x0,0x20,0x0,0x5E,0x0,0x25,0x30
	.DB  0x33,0x64,0x0,0x56,0x6F,0x6C,0x74,0x61
	.DB  0x67,0x65,0x20,0x73,0x65,0x74,0x20,0x74
	.DB  0x6F,0x3A,0x0,0x53,0x65,0x74,0x20,0x76
	.DB  0x61,0x6C,0x75,0x65,0x20,0x73,0x68,0x6F
	.DB  0x75,0x6C,0x64,0x0,0x62,0x65,0x20,0x62
	.DB  0x65,0x74,0x77,0x65,0x65,0x6E,0x20,0x31
	.DB  0x31,0x30,0x2D,0x0,0x31,0x33,0x35,0x20
	.DB  0x76,0x6F,0x6C,0x74,0x73,0x0,0x43,0x75
	.DB  0x72,0x72,0x65,0x6E,0x74,0x20,0x73,0x65
	.DB  0x74,0x20,0x74,0x6F,0x3A,0x0,0x62,0x65
	.DB  0x20,0x62,0x65,0x74,0x77,0x65,0x65,0x6E
	.DB  0x20,0x31,0x30,0x2D,0x0,0x32,0x30,0x20
	.DB  0x61,0x6D,0x70,0x73,0x0,0x57,0x65,0x6C
	.DB  0x63,0x6F,0x6D,0x65,0x20,0x74,0x6F,0x20
	.DB  0x48,0x4D,0x49,0x0,0x53,0x65,0x74,0x20
	.DB  0x50,0x61,0x72,0x61,0x6D,0x65,0x74,0x65
	.DB  0x72,0x73,0x0,0x53,0x65,0x6E,0x73,0x6F
	.DB  0x72,0x20,0x56,0x61,0x6C,0x75,0x65,0x73
	.DB  0x0,0x50,0x41,0x52,0x41,0x4D,0x45,0x54
	.DB  0x45,0x52,0x53,0x0,0x56,0x6F,0x6C,0x74
	.DB  0x61,0x67,0x65,0x20,0x28,0x56,0x4F,0x4C
	.DB  0x54,0x53,0x29,0x0,0x43,0x75,0x72,0x72
	.DB  0x65,0x6E,0x74,0x20,0x28,0x41,0x4D,0x50
	.DB  0x53,0x29,0x0,0x53,0x65,0x74,0x20,0x76
	.DB  0x6F,0x6C,0x74,0x61,0x67,0x65,0x3A,0x0
	.DB  0x53,0x65,0x74,0x20,0x63,0x75,0x72,0x72
	.DB  0x65,0x6E,0x74,0x3A,0x0,0x53,0x45,0x4E
	.DB  0x53,0x4F,0x52,0x53,0x0,0x41,0x6E,0x61
	.DB  0x6C,0x6F,0x67,0x0,0x44,0x69,0x67,0x69
	.DB  0x74,0x61,0x6C,0x0,0x54,0x68,0x65,0x72
	.DB  0x6D,0x6F,0x63,0x6F,0x75,0x70,0x6C,0x65
	.DB  0x0,0x4E,0x6F,0x20,0x66,0x75,0x6E,0x63
	.DB  0x74,0x69,0x6F,0x6E,0x73,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x61
	.DB  0x64,0x64,0x65,0x64,0x20,0x79,0x65,0x74
	.DB  0x0,0x43,0x68,0x30,0x3A,0x0,0x43,0x68
	.DB  0x31,0x3A,0x0,0x43,0x68,0x32,0x3A,0x0
	.DB  0x43,0x68,0x33,0x3A,0x0,0x43,0x68,0x34
	.DB  0x3A,0x0,0x43,0x68,0x35,0x3A,0x0,0x43
	.DB  0x68,0x36,0x3A,0x0,0x43,0x68,0x37,0x3A
	.DB  0x0,0x45,0x72,0x72,0x6F,0x72,0x2E,0x0
	.DB  0x52,0x65,0x73,0x74,0x61,0x72,0x74,0x69
	.DB  0x6E,0x67,0x20,0x69,0x6E,0x20,0x35,0x20
	.DB  0x73,0x65,0x63,0x6F,0x6E,0x64,0x73,0x2E
	.DB  0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  0x0C
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _Screen
	.DW  _0x35*2

	.DW  0x10
	.DW  _0x5E
	.DW  _0x0*2+195

	.DW  0x10
	.DW  _0x77
	.DW  _0x0*2+254

	.DW  0x0F
	.DW  _0x7F
	.DW  _0x0*2+293

	.DW  0x07
	.DW  _0xA8
	.DW  _0x0*2+513

	.DW  0x19
	.DW  _0xA8+7
	.DW  _0x0*2+520

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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
;flash char *msg;
;flash char *xmitMsg;
;flash char *rec;
;flash char *rdata;
;char sdataA[5];    // Send data for SCI-A
;char rdataA[4]; // Received data for SCI-A
;char data;
;int comStart;
;int i = 0;
;
;    //commands will be given a 3 digit numeric code based on the button pressed;
;    //Stored values for the particular option-
;
;    //    000-  noOp
;    //    001-  mainOn
;    //    002-  mainOff
;    //    003-  resetFault
;    //    004-  readVolt
;    //    005-  readAmp
;    //    006-
;    //    007-
;    //    008-
;    //    009-
;    //    010-
;    //    011-
;    //    012-
;    //    013-
;    //    014-
;    //    015-
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
; 0000 0007 {

	.CSEG
_xmitString:
; .FSTART _xmitString
;    int i =0;
;    for(i = 0;*(xmitMsg+i)!= '\0';i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*xmitMsg -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x4:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x5
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
	RJMP _0x4
_0x5:
;
;
;
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120004
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
;    lcd_clear();
	CALL _lcd_clear
;    lcd_putsf("Entering Soft-Start");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
;    xmitMsg ="<001>";
	__POINTW1FN _0x0,20
	RJMP _0x2120007
;    xmitString(xmitMsg);
;    delay_ms(500);
;
;    lcd_clear();
;
;
;}
; .FEND
;
;void mainOff()
;{
_mainOff:
; .FSTART _mainOff
;    lcd_clear();
	CALL _lcd_clear
;    lcd_putsf("Entering Soft-Stop");
	__POINTW2FN _0x0,26
	CALL _lcd_putsf
;    xmitMsg = "<002>";
	__POINTW1FN _0x0,45
_0x2120007:
	MOVW R6,R30
;    xmitString(xmitMsg);
	MOVW R26,R6
	RCALL _xmitString
;    delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
;    lcd_clear();
	CALL _lcd_clear
;}
	RET
; .FEND
;
;void resetFault()
;{
_resetFault:
; .FSTART _resetFault
;    lcd_putsf("Resetting Faults");
	__POINTW2FN _0x0,51
	CALL _lcd_putsf
;    xmitMsg = "<003>";
	__POINTW1FN _0x0,68
	RJMP _0x2120006
;    xmitString(xmitMsg);
;
;}
; .FEND
;
;void readVolt()
;{
_readVolt:
; .FSTART _readVolt
;    xmitMsg = "<004>";
	__POINTW1FN _0x0,74
	RJMP _0x2120006
;    xmitString(xmitMsg);
;    //voltVal = recVolt();
;    //msg = sprintf("\nVoltage is: %d",voltVal);
;    //lcd_putsf(msg);
;
;}
; .FEND
;
;void readAmp()
;{
_readAmp:
; .FSTART _readAmp
;    xmitMsg = "<005>";
	__POINTW1FN _0x0,80
_0x2120006:
	MOVW R6,R30
;    xmitString(xmitMsg);
	MOVW R26,R6
	RCALL _xmitString
;    //ampVal = recAmp();
;    //msg = sprintf("\nCurrent is: %d",ampVal);
;    //lcd_putsf(msg);
;}
	RET
; .FEND
;
;static void (*xmitFunc[100])() = {
;    noOp,mainOn,mainOff,resetFault,readVolt,readAmp
;    };

	.DSEG
;
;
;
;
;//On receiving response from the TMS, further actions are taken by recFunc array
;void rnoOp()
;{

	.CSEG
_rnoOp:
; .FSTART _rnoOp
;
;}
	RET
; .FEND
;
;
;void rmainOn()
;{
_rmainOn:
; .FSTART _rmainOn
;    flash char*msg ="The System has turned on";
;    lcd_putsf(msg);                            //function to display message on the lcd
	ST   -Y,R17
	ST   -Y,R16
;	*msg -> R16,R17
	__POINTWRFN 16,17,_0x0,86
	MOVW R26,R16
	CALL _lcd_putsf
;
;}
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void rmainOff()
;{
_rmainOff:
; .FSTART _rmainOff
;    msg = "The System has turned off";
	__POINTW1FN _0x0,111
	RJMP _0x2120005
;    lcd_putsf(msg);
;
;}
; .FEND
;
;void rresetFault()
;{
_rresetFault:
; .FSTART _rresetFault
;    msg = "Faults have been reset";
	__POINTW1FN _0x0,137
_0x2120005:
	MOVW R4,R30
;    lcd_putsf(msg);
	MOVW R26,R4
	CALL _lcd_putsf
;
;}
	RET
; .FEND
;
;void rreadVolt()
;{
_rreadVolt:
; .FSTART _rreadVolt
;    int i;flash char *tempRdata;
;    for(i=5;*(rec+i-1)!='\0';i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	*tempRdata -> R18,R19
	__GETWRN 16,17,5
_0x8:
	CALL SUBOPT_0x0
	BREQ _0x9
;    {
;        tempRdata= (rec+i);
	CALL SUBOPT_0x1
;        if(i==5)  rdata = tempRdata;
	BRNE _0xA
	MOVW R10,R18
;        tempRdata++;
_0xA:
	__ADDWRN 18,19,1
;    }
	__ADDWRN 16,17,1
	RJMP _0x8
_0x9:
;
;    msg = rdata;
	RJMP _0x2120003
;    lcd_putsf(msg);
;
;}
; .FEND
;
;void rreadAmp()
;{
_rreadAmp:
; .FSTART _rreadAmp
;    int i;flash char *tempRdata;
;    for(i=5;*(rec+i-1)!='\0';i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	*tempRdata -> R18,R19
	__GETWRN 16,17,5
_0xC:
	CALL SUBOPT_0x0
	BREQ _0xD
;    {
;        tempRdata= (rec+i);
	CALL SUBOPT_0x1
;        if(i==5)  rdata = tempRdata;
	BRNE _0xE
	MOVW R10,R18
;        tempRdata++;
_0xE:
	__ADDWRN 18,19,1
;    }
	__ADDWRN 16,17,1
	RJMP _0xC
_0xD:
;    msg = rdata;
_0x2120003:
	MOVW R4,R10
;    lcd_putsf(msg);
	MOVW R26,R4
	CALL _lcd_putsf
;
;}
	CALL __LOADLOCR4
_0x2120004:
	ADIW R28,4
	RET
; .FEND
;
;
;static void (*recFunc[100])() = {rnoOp,rmainOn,rmainOff,rresetFault,rreadVolt,rreadAmp
;    };

	.DSEG
;
;
;void recOp()
;{

	.CSEG
;                                                                                                   /* char recArray[100] ...
;                                                                                                    char cmd[3]={'','',' ...
;                                                                                                    int icmd = 0;
;                                                                                                    int i = 0;
;                                                                                                    //char tempRec[100];
;                                                                                                    do
;                                                                                                    {
;                                                                                                        recArray[i++] =  ...
;
;                                                                                                    }while(recArray[i]!= ...
;                                                                                                //    char *rec = "<001- ...
;                                                                                                    for(i=1;i<4;i++)
;                                                                                                    {
;                                                                                                       cmd[i-1] = *(recA ...
;                                                                                                    }
;
;                                                                                                    icmd = cmd[2]-'0'+(( ...
;                                                                                                    putchar(icmd);
;                                                                                                    //recFunc[icmd]();*/
;
;    data = getchar();;
;    if(data=='<')
;    {
;        comStart = 1;
;        i=0;
;        xmitString("command start");
;    }
;    else if(data =='>')
;       {
;           comStart = 0;
;           i=0;xmitString("command end");comDecode(rdataA);
;       }
;    if (comStart == 1)
;        {
;            *(rdataA+i)=data;  // Read data
;            i++;if(i==5){i=0;}
;        }
;}
;
;
;void comDecode(char * rec)
;{
;
;    char cmd[3]={'0','0','0'};
;    int icmd = 0;
;    int i;
;
;    for(i = 0;i<5;i++)
;	*rec -> Y+7
;	cmd -> Y+4
;	icmd -> R16,R17
;	i -> R18,R19
;    {
;        putchar(*(rec+i));
;    }
;
;
;    for(i=1;i<4;i++)
;    {
;       cmd[i-1] = rec[i];
;    }
;
;    icmd = cmd[2]-'0'+((cmd[1]-'0')*10)+((cmd[0]-'0')*100);
;    putchar(icmd);
;    //func[icmd]();
;}
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 000D #endasm
;
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;// External Interrupt 4 service routine
;interrupt [EXT_INT4] void ext_int4_isr(void)
; 0000 0019 {
_ext_int4_isr:
; .FSTART _ext_int4_isr
; 0000 001A 
; 0000 001B 
; 0000 001C }
	RETI
; .FEND
;
;// External Interrupt 5 service routine
;interrupt [EXT_INT5] void ext_int5_isr(void)
; 0000 0020 {
_ext_int5_isr:
; .FSTART _ext_int5_isr
; 0000 0021 // Place your code here
; 0000 0022 
; 0000 0023 }
	RETI
; .FEND
;
;// External Interrupt 6 service routine
;interrupt [EXT_INT6] void ext_int6_isr(void)
; 0000 0027 {
_ext_int6_isr:
; .FSTART _ext_int6_isr
; 0000 0028 // Place your code here
; 0000 0029 
; 0000 002A }
	RETI
; .FEND
;
;// External Interrupt 7 service routine
;interrupt [EXT_INT7] void ext_int7_isr(void)
; 0000 002E {
_ext_int7_isr:
; .FSTART _ext_int7_isr
; 0000 002F // Place your code here
; 0000 0030 
; 0000 0031 }
	RETI
; .FEND
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
;// Standard Input/Output functions
;#include <stdio.h>
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 64
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
;int on_pressed = 0;
;int off_pressed = 0;
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0074 {
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0075 char status,data;
; 0000 0076 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0077 data=UDR0;
	IN   R16,12
; 0000 0078 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x1B
; 0000 0079    {
; 0000 007A    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 007B #if RX_BUFFER_SIZE0 == 256
; 0000 007C    // special case for receiver buffer size=256
; 0000 007D    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 007E #else
; 0000 007F    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R12
	BRNE _0x1C
	CLR  R12
; 0000 0080    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x1C:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x1D
; 0000 0081       {
; 0000 0082       rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 0083       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0084       }
; 0000 0085 #endif
; 0000 0086    }//recOp();
_0x1D:
; 0000 0087 }
_0x1B:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xB8
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
; 0000 0091 {
; 0000 0092 char data;
; 0000 0093 while (rx_counter0==0);
;	data -> R17
; 0000 0094 data=rx_buffer0[rx_rd_index0++];
; 0000 0095 #if RX_BUFFER_SIZE0 != 256
; 0000 0096 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 0097 #endif
; 0000 0098 #asm("cli")
; 0000 0099 --rx_counter0;
; 0000 009A #asm("sei")
; 0000 009B return data;
; 0000 009C }
;#pragma used-
;#endif
;
;
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
;
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 00B6 {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B7 if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x22
; 0000 00B8    {
; 0000 00B9    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 00BA    UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00BB #if TX_BUFFER_SIZE0 != 256
; 0000 00BC    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0x23
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 00BD #endif
; 0000 00BE    }
_0x23:
; 0000 00BF }
_0x22:
_0xB8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;
;
;
;
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00CA {
_putchar:
; .FSTART _putchar
; 0000 00CB while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x24:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x24
; 0000 00CC #asm("cli")
	cli
; 0000 00CD if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x28
	SBIC 0xB,5
	RJMP _0x27
_0x28:
; 0000 00CE    {
; 0000 00CF    tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00D0 #if TX_BUFFER_SIZE0 != 256
; 0000 00D1    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x2A
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00D2 #endif
; 0000 00D3    ++tx_counter0;
_0x2A:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00D4    }
; 0000 00D5 else
	RJMP _0x2B
_0x27:
; 0000 00D6    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00D7 #asm("sei")
_0x2B:
	sei
; 0000 00D8 }
	JMP  _0x2120002
; .FEND
;#pragma used-
;#endif
;
;
;
;short int on_button_state = 0x0000;
;short int off_button_state = 0x0000;
;
;
;// Timer3 overflow interrupt service routine
;interrupt[TIM3_OVF] void timer3_ovf_isr(void) {
; 0000 00E3 interrupt[30] void timer3_ovf_isr(void) {
_timer3_ovf_isr:
; .FSTART _timer3_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00E4 
; 0000 00E5     // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF
; 0000 00E6 
; 0000 00E7     // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-softwar ...
; 0000 00E8     // 16 bit shifts = approx 130msec debounce delay
; 0000 00E9 on_button_state = (0x8000 | !PINE.4) | (on_button_state << 1);
	LDI  R30,0
	SBIS 0x1,4
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	LDS  R30,_on_button_state
	LDS  R31,_on_button_state+1
	LSL  R30
	ROL  R31
	OR   R30,R26
	OR   R31,R27
	STS  _on_button_state,R30
	STS  _on_button_state+1,R31
; 0000 00EA     if(on_button_state == 0xC000) {
	LDS  R26,_on_button_state
	LDS  R27,_on_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x2C
; 0000 00EB        PORTC.3 = 0;
	CBI  0x15,3
; 0000 00EC        on_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R31
; 0000 00ED 
; 0000 00EE     }
; 0000 00EF 
; 0000 00F0     off_button_state = (0x8000 | !PINE.5) | (off_button_state << 1);
_0x2C:
	LDI  R30,0
	SBIS 0x1,5
	LDI  R30,1
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	LDS  R30,_off_button_state
	LDS  R31,_off_button_state+1
	LSL  R30
	ROL  R31
	OR   R30,R26
	OR   R31,R27
	STS  _off_button_state,R30
	STS  _off_button_state+1,R31
; 0000 00F1     if(off_button_state == 0xC000 ) {
	LDS  R26,_off_button_state
	LDS  R27,_off_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x2F
; 0000 00F2         PORTC.3 = 1;
	SBI  0x15,3
; 0000 00F3        off_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _off_pressed,R30
	STS  _off_pressed+1,R31
; 0000 00F4     }
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 }
_0x2F:
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
;#define ADC_VREF_TYPE 0x00
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00FD {
; 0000 00FE ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 00FF // Delay needed for the stabilization of the ADC input voltage
; 0000 0100 delay_us(10);
; 0000 0101 // Start the AD conversion
; 0000 0102 ADCSRA|=0x40;
; 0000 0103 // Wait for the AD conversion to complete
; 0000 0104 while ((ADCSRA & 0x10)==0);
; 0000 0105 ADCSRA|=0x10;
; 0000 0106 return ADCW;
; 0000 0107 }
;
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

	.DSEG
;//-------------Display Functions---------
;#include "Display_functions.c"
;//#include <variables.h>
;
;void pointer_display_horiz()                          //checks the cursor position.
; 0000 0112 {

	.CSEG
;    lcd_gotoxy(0,2);
;    lcd_putsf(" ");
;    lcd_gotoxy(1,2);
;    lcd_putsf(" ");
;    lcd_gotoxy(2,2);
;    lcd_putsf(" ");
;    lcd_gotoxy(3,2);
;    lcd_putsf(" ");
;    lcd_gotoxy(Pointer_horiz,2);                      //Pointer displays arrow at that position
;    lcd_putsf("^");
;}
;
;void pointer_display_vert()                          //checks the cursor position.
;{
;    lcd_gotoxy(0,0);
;    lcd_putsf(" ");
;    lcd_gotoxy(0,1);
;    lcd_putsf(" ");
;    lcd_gotoxy(0,2);
;    lcd_putsf(" ");
;    lcd_gotoxy(0,3);
;    lcd_putsf(" ");
;    lcd_gotoxy(0,Pointer_vert);                      //Pointer displays arrow at that position
;    lcd_putsf(">");
;}
;
;
;
;void show_volt()
;{
;    sprintf(disp_volt,"%03d",voltage);
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_volt);
;}
;void show_current()
;{
;    sprintf(disp_current,"%03d",current);
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_current);
;}
;//----Input and val change functions-----
;#include "Change.c"
;#include "Inputs.c"
;//#include <variables.h>
;
;
;
;void input(int next)                         //next recieves value no of options we will have in the next menu
; 0000 0115 {   //int next = 4;
;    //int flag = 0;
;    Pt = Pointer_vert;
;	next -> Y+0
;    pointer_display_vert();
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP
;       {
;        while(PINE.2 == 0);
;        Pt--;
;        Pointer_vert = ((Pt < 0) ? (next+Pt): Pt) % next;
;        pointer_display_vert();
;       }
;
;    if (PINE.3 == 0)                                            //DOWN
;       {
;        while(PINE.3 == 0);
;        Pointer_vert++;
;        Pointer_vert = Pointer_vert % next;
;        pointer_display_vert();
;       }
;
;    if (PINE.0 == 0)                                            //ENTER
;       {
;        while(PINE.0 == 0);
;        if(Screen < 10)
;        {
;            Screen = ((Screen+1)*10) + Pointer_vert;
;        }
;        else
;        {
;            Screen = ((Screen)*10) + Pointer_vert;
;        }
;
;        //flag = 1;
;       }
;
;    if (PINE.1 == 0)                                            //ESCAPE
;       {
;        while(PINE.1 == 0);
;        if(Screen > 100)
;        {Screen = Screen/10;}
;        else
;        {
;        Screen = (Screen/10)-1;
;        }
;        //flag = 1;
;       }
;
;    //return (flag);
;}
;
;
;void input_volt(int next)
;{
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP     1
;       {
;        while(PINE.2 == 0);
;        if(change == 1)
;        {voltage = voltage + (change);}
;        else
;        {voltage = voltage + 1 + (change);}
;        voltage = voltage % 1000;
;        show_volt();
;        pointer_display_horiz();
;       }
;
;    if (PINE.3 == 0)                                            //Next   2
;       {
;        while(PINE.3 == 0);
;        Pointer_horiz++;
;
;        Pointer_horiz = Pointer_horiz % next;
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                             //ENTER 3
;        {
;         while(PINE.0 == 0);
;         if(110 <= voltage && voltage <= 135)
;         {
;            lcd_clear();
;            lcd_gotoxy(0,0);
;            lcd_puts("Voltage set to:");
;            show_volt();
;            //Voltage = temp_volt;
;            flag = 11;
;            Screen = 30;
;            delay_ms(2000);
;         }
;         else
;         {
;            lcd_clear();
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
;            lcd_gotoxy(0,1);
;            lcd_putsf("be between 110-");
;            lcd_gotoxy(0,2);
;            lcd_putsf("135 volts");
;            voltage = 000;
;            Screen = 300;
;            flag = 11;
;            delay_ms(2000);
;         }
;        }
;
;    if (PINE.1 == 0)                                            //ESCAPE 4
;       {
;        while(PINE.1 == 0);
;        flag = 11;
;        if(Screen > 100)
;        {Screen = Screen/10;}
;        else
;        {Screen = (Screen/10)-1;}
;        //flag = 1;
;       }
;}

	.DSEG
_0x5E:
	.BYTE 0x10
;
;void input_current(int next)
;{

	.CSEG
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP     1
;       {
;        while(PINE.2 == 0);
;        if(change == 1)
;        {current = current + (change);}
;        else
;        {current = current + 1 + (change);}
;        current = current % 1000;
;        show_current();
;        pointer_display_horiz();
;       }
;
;    if (PINE.3 == 0)                                            //Next   2
;       {
;        while(PINE.3 == 0);
;        Pointer_horiz++;
;
;        Pointer_horiz = Pointer_horiz % next;
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                             //ENTER 3
;        {
;         while(PINE.0 == 0);
;         if(10 <= current && current <= 20)
;         {
;            lcd_clear();
;            lcd_gotoxy(0,0);
;            lcd_puts("Current set to:");
;            show_current();
;            flag = 11;
;            Screen = 30;
;            delay_ms(2000);
;         }
;         else
;         {
;            lcd_clear();
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
;            lcd_gotoxy(0,1);
;            lcd_putsf("be between 10-");
;            lcd_gotoxy(0,2);
;            lcd_putsf("20 amps");
;            current = 000;
;            Screen = 301;
;            flag = 11;
;            delay_ms(2000);
;         }
;        }
;
;    if (PINE.1 == 0)                                            //ESCAPE 4
;       {
;        while(PINE.1 == 0);
;        flag = 11;
;        if(Screen > 100)
;        {Screen = Screen/10;}
;        else
;        {Screen = (Screen/10)-1;}
;        //flag = 1;
;       }
;
;
;}

	.DSEG
_0x77:
	.BYTE 0x10
;
;
;
;
;void Screen1()
; 0000 011B {

	.CSEG
; 0000 011C     Screen = 1;
; 0000 011D     Pointer_horiz = 0;
; 0000 011E     Pointer_vert = 0;
; 0000 011F     lcd_clear();
; 0000 0120     lcd_gotoxy(0,0);
; 0000 0121     lcd_puts("Welcome to HMI");
; 0000 0122 
; 0000 0123     delay_ms(1000);
; 0000 0124 
; 0000 0125     Screen = 2;
; 0000 0126 }

	.DSEG
_0x7F:
	.BYTE 0xF
;
;void Screen2()
; 0000 0129 {

	.CSEG
; 0000 012A     lcd_clear();
; 0000 012B 
; 0000 012C     Screen = 2;
; 0000 012D     Pointer_vert = 0;
; 0000 012E     Pointer_horiz= 0;
; 0000 012F     while(Screen == 2)
; 0000 0130     {
; 0000 0131 
; 0000 0132 
; 0000 0133         lcd_gotoxy(1,0);
; 0000 0134         lcd_putsf("Set Parameters");
; 0000 0135         lcd_gotoxy(1,1) ;
; 0000 0136         lcd_putsf("Sensor Values");
; 0000 0137 
; 0000 0138         input(2);
; 0000 0139     }
; 0000 013A 
; 0000 013B }
;
;
;
;void Screen30()
; 0000 0140 {
; 0000 0141     lcd_clear();
; 0000 0142 
; 0000 0143     lcd_gotoxy(3,3);
; 0000 0144     lcd_putsf("PARAMETERS");
; 0000 0145     lcd_gotoxy(1,0);
; 0000 0146     lcd_putsf("Voltage (VOLTS)");
; 0000 0147     lcd_gotoxy(1,1);
; 0000 0148     lcd_putsf("Current (AMPS)");
; 0000 0149 
; 0000 014A     while(Screen == 30)
; 0000 014B     {
; 0000 014C         input(2);
; 0000 014D 
; 0000 014E     if (PINE.1 == 0)                                            //ESCAPE Pressed 4
; 0000 014F        {
; 0000 0150         while(PINE.1 == 0);
; 0000 0151         Screen = 2;
; 0000 0152        }
; 0000 0153     }
; 0000 0154 
; 0000 0155 
; 0000 0156 }
;
;void Screen300()      //SET VOLTAGE
; 0000 0159 {
; 0000 015A     while(Screen == 300)
; 0000 015B     {
; 0000 015C     lcd_clear();
; 0000 015D     lcd_gotoxy(0,0);
; 0000 015E     lcd_putsf("Set voltage:");
; 0000 015F     show_volt();
; 0000 0160     while(flag != 11)
; 0000 0161     {
; 0000 0162         input_volt(3);
; 0000 0163     }
; 0000 0164     flag = 0;
; 0000 0165     }
; 0000 0166 }
;void Screen301()     //SET CURRENT
; 0000 0168 {
; 0000 0169     while (Screen == 301)
; 0000 016A     {
; 0000 016B     lcd_clear();
; 0000 016C     lcd_gotoxy(0,0);
; 0000 016D     lcd_putsf("Set current:");
; 0000 016E     show_current();
; 0000 016F     while(flag != 11)
; 0000 0170     {
; 0000 0171         input_current(3);
; 0000 0172     }
; 0000 0173     flag = 0;
; 0000 0174     }
; 0000 0175 }
;
;
;void Screen31()
; 0000 0179 {
; 0000 017A     lcd_clear();
; 0000 017B     Pointer_vert = 0;
; 0000 017C     lcd_gotoxy(4,3);
; 0000 017D     lcd_putsf("SENSORS");
; 0000 017E     lcd_gotoxy(1,0);
; 0000 017F     lcd_putsf("Analog");
; 0000 0180     lcd_gotoxy(1,1);
; 0000 0181     lcd_putsf("Digital");
; 0000 0182     lcd_gotoxy(1,2);
; 0000 0183     lcd_putsf("Thermocouple");
; 0000 0184 
; 0000 0185     while(Screen == 31)
; 0000 0186     {
; 0000 0187         input(3);
; 0000 0188     }
; 0000 0189 }
;
;void Screen310()  // Analog Values
; 0000 018C {
; 0000 018D     lcd_gotoxy(0,0);
; 0000 018E     lcd_putsf("No functions          added yet");
; 0000 018F     delay_ms(1000);
; 0000 0190     Screen = 31;
; 0000 0191 }
;
;void Screen311()        // Digital Values
; 0000 0194 {
; 0000 0195     int x = 0;
; 0000 0196     char disp_ch[3];
; 0000 0197     lcd_clear();
;	x -> R16,R17
;	disp_ch -> Y+2
; 0000 0198     lcd_gotoxy(0,0);
; 0000 0199     lcd_putsf("Ch0:");
; 0000 019A     lcd_gotoxy(0,1);
; 0000 019B     lcd_putsf("Ch1:");
; 0000 019C     lcd_gotoxy(0,2);
; 0000 019D     lcd_putsf("Ch2:");
; 0000 019E     lcd_gotoxy(0,3);
; 0000 019F     lcd_putsf("Ch3:");
; 0000 01A0     lcd_gotoxy(9,0);
; 0000 01A1     lcd_putsf("Ch4:");
; 0000 01A2     lcd_gotoxy(9,1);
; 0000 01A3     lcd_putsf("Ch5:");
; 0000 01A4     lcd_gotoxy(9,2);
; 0000 01A5     lcd_putsf("Ch6:");
; 0000 01A6     lcd_gotoxy(9,3);
; 0000 01A7     lcd_putsf("Ch7:");
; 0000 01A8 
; 0000 01A9     while (PINE.1 != 0)
; 0000 01AA     {
; 0000 01AB         x = read_adc(0x00)/4;
; 0000 01AC         sprintf(disp_ch,"%03d",x);
; 0000 01AD         lcd_gotoxy(4,0);
; 0000 01AE         lcd_puts(disp_ch);
; 0000 01AF         x = read_adc(0x01)/4;
; 0000 01B0         sprintf(disp_ch,"%03d",x);
; 0000 01B1         lcd_gotoxy(4,1);
; 0000 01B2         lcd_puts(disp_ch);
; 0000 01B3         x = read_adc(0x02)/4;
; 0000 01B4         sprintf(disp_ch,"%03d",x);
; 0000 01B5         lcd_gotoxy(4,2);
; 0000 01B6         lcd_puts(disp_ch);
; 0000 01B7         x = read_adc(0x03)/4;
; 0000 01B8         sprintf(disp_ch,"%03d",x);
; 0000 01B9         lcd_gotoxy(4,3);
; 0000 01BA         lcd_puts(disp_ch);
; 0000 01BB         x = read_adc(0x04)/4;
; 0000 01BC         sprintf(disp_ch,"%03d",x);
; 0000 01BD         lcd_gotoxy(13,0);
; 0000 01BE         lcd_puts(disp_ch);
; 0000 01BF         x = read_adc(0x05)/4;
; 0000 01C0         sprintf(disp_ch,"%03d",x);
; 0000 01C1         lcd_gotoxy(13,1);
; 0000 01C2         lcd_puts(disp_ch);
; 0000 01C3         x = read_adc(0x06)/4;
; 0000 01C4         sprintf(disp_ch,"%03d",x);
; 0000 01C5         lcd_gotoxy(13,2);
; 0000 01C6         lcd_puts(disp_ch);
; 0000 01C7         x = read_adc(0x07)/4;
; 0000 01C8         sprintf(disp_ch,"%03d",x);
; 0000 01C9         lcd_gotoxy(13,3);
; 0000 01CA         lcd_puts(disp_ch);
; 0000 01CB         delay_ms(1000);
; 0000 01CC     }
; 0000 01CD     Screen = 31;
; 0000 01CE }
;
;
;void Screen_sel()
; 0000 01D2 {
; 0000 01D3     switch(Screen)
; 0000 01D4     {
; 0000 01D5         case 1:
; 0000 01D6             Screen1();
; 0000 01D7         break;
; 0000 01D8         case 2:
; 0000 01D9             Screen2();
; 0000 01DA         break;
; 0000 01DB 
; 0000 01DC         case 30:                           //Ports
; 0000 01DD             Screen30();
; 0000 01DE         break;
; 0000 01DF 
; 0000 01E0         case 300:
; 0000 01E1             Screen300();                   //Set Voltage
; 0000 01E2         break;
; 0000 01E3         case 301:
; 0000 01E4             Screen301();
; 0000 01E5         break;
; 0000 01E6 
; 0000 01E7         case 31:
; 0000 01E8             Screen31();
; 0000 01E9         break;
; 0000 01EA         case 310:                           //Analog
; 0000 01EB             Screen310();
; 0000 01EC         break;
; 0000 01ED         case 311:                           //Digital
; 0000 01EE             Screen311();
; 0000 01EF         break;
; 0000 01F0 
; 0000 01F1         default:
; 0000 01F2             lcd_clear();
; 0000 01F3             lcd_gotoxy(0,0);
; 0000 01F4             lcd_puts("Error.");
; 0000 01F5             lcd_gotoxy(0,1);
; 0000 01F6             lcd_puts("Restarting in 5 seconds.");
; 0000 01F7             delay_ms(2000);
; 0000 01F8             Screen = 1;
; 0000 01F9         break;
; 0000 01FA     }
; 0000 01FB }

	.DSEG
_0xA8:
	.BYTE 0x20
;
;void main(void)
; 0000 01FE {

	.CSEG
_main:
; .FSTART _main
; 0000 01FF 
; 0000 0200 
; 0000 0201 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0202 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0203 
; 0000 0204 
; 0000 0205 PORTB=0x00;
	OUT  0x18,R30
; 0000 0206 DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0207 
; 0000 0208 
; 0000 0209 PORTC=0x08;
	LDI  R30,LOW(8)
	OUT  0x15,R30
; 0000 020A DDRC=0x08;
	OUT  0x14,R30
; 0000 020B 
; 0000 020C 
; 0000 020D PORTD=0xC0;
	LDI  R30,LOW(192)
	OUT  0x12,R30
; 0000 020E DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 020F 
; 0000 0210 
; 0000 0211 
; 0000 0212 PORTE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x3,R30
; 0000 0213 DDRE=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0214 
; 0000 0215 
; 0000 0216 
; 0000 0217 PORTF=0x00;
	STS  98,R30
; 0000 0218 DDRF=0x00;
	STS  97,R30
; 0000 0219 
; 0000 021A 
; 0000 021B PORTG=0x00;
	STS  101,R30
; 0000 021C DDRG=0x00;
	STS  100,R30
; 0000 021D 
; 0000 021E TCCR3A=0x00;
	STS  139,R30
; 0000 021F TCCR3B=0x09;
	LDI  R30,LOW(9)
	STS  138,R30
; 0000 0220 TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0221 TCNT3L=0x00;
	STS  136,R30
; 0000 0222 ICR3H=0x00;
	STS  129,R30
; 0000 0223 ICR3L=0x00;
	STS  128,R30
; 0000 0224 OCR3AH=0xFF;
	LDI  R30,LOW(255)
	STS  135,R30
; 0000 0225 OCR3AL=0xFF;
	STS  134,R30
; 0000 0226 OCR3BH=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0227 OCR3BL=0x00;
	STS  132,R30
; 0000 0228 OCR3CH=0x00;
	STS  131,R30
; 0000 0229 OCR3CL=0x00;
	STS  130,R30
; 0000 022A 
; 0000 022B // External Interrupt(s) initialization
; 0000 022C EICRA=0x00;
	STS  106,R30
; 0000 022D EICRB=0xAA;
	LDI  R30,LOW(170)
	OUT  0x3A,R30
; 0000 022E EIMSK=0xF0;
	LDI  R30,LOW(240)
	OUT  0x39,R30
; 0000 022F EIFR=0xF0;
	OUT  0x38,R30
; 0000 0230 
; 0000 0231 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0232 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 0233 ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 0234 
; 0000 0235 // USART0 initialization
; 0000 0236 /*
; 0000 0237 UCSR0A=0x00;
; 0000 0238 UCSR0B=0x18;
; 0000 0239 UCSR0C=0x06;
; 0000 023A UBRR0H=0x00;
; 0000 023B UBRR0L=0x67;
; 0000 023C */
; 0000 023D // USART0 initialization
; 0000 023E // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 023F // USART0 Receiver: On
; 0000 0240 // USART0 Transmitter: On
; 0000 0241 // USART0 Mode: Asynchronous
; 0000 0242 // USART0 Baud Rate: 9600
; 0000 0243 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0244 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0245 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0246 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0247 UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0248 
; 0000 0249 // USART1 initialization
; 0000 024A UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 024B UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 024C UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 024D UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 024E UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 024F 
; 0000 0250 // Analog Comparator initialization
; 0000 0251 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0252 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0253 
; 0000 0254 // ADC initialization
; 0000 0255 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 0256 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0257 
; 0000 0258 // SPI initialization
; 0000 0259 SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 025A SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 025B 
; 0000 025C // TWI initializatioN
; 0000 025D TWCR=0x00;
	STS  116,R30
; 0000 025E 
; 0000 025F // I2C Bus initialization
; 0000 0260 i2c_init();
	CALL _i2c_init
; 0000 0261 
; 0000 0262 // DS1307 Real Time Clock initialization
; 0000 0263 rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _rtc_init
; 0000 0264 
; 0000 0265 
; 0000 0266 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0267 
; 0000 0268 // Global enable interrupts
; 0000 0269 #asm("sei")
	sei
; 0000 026A 
; 0000 026B 
; 0000 026C while(1)
_0xA9:
; 0000 026D {
; 0000 026E        if(on_pressed == 1)
	LDS  R26,_on_pressed
	LDS  R27,_on_pressed+1
	SBIW R26,1
	BRNE _0xAC
; 0000 026F         {
; 0000 0270             mainOn();
	RCALL _mainOn
; 0000 0271             on_pressed = 0;
	LDI  R30,LOW(0)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R30
; 0000 0272         }
; 0000 0273         else if(off_pressed == 1)
	RJMP _0xAD
_0xAC:
	LDS  R26,_off_pressed
	LDS  R27,_off_pressed+1
	SBIW R26,1
	BRNE _0xAE
; 0000 0274         {
; 0000 0275             mainOff();
	RCALL _mainOff
; 0000 0276             off_pressed = 0;
	LDI  R30,LOW(0)
	STS  _off_pressed,R30
	STS  _off_pressed+1,R30
; 0000 0277 
; 0000 0278         }
; 0000 0279     //Screen_sel();
; 0000 027A 
; 0000 027B }
_0xAE:
_0xAD:
	RJMP _0xA9
; 0000 027C 
; 0000 027D }
_0xAF:
	RJMP _0xAF
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG

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

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2120002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x2120002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
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
	CALL SUBOPT_0x2
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x2
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
	BREQ _0x2060005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
_0x2060005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060007
	RJMP _0x2120002
_0x2060007:
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2120002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x206000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x206000B
_0x206000D:
	LDD  R17,Y+0
	RJMP _0x2120001
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
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2120002:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2080003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2080003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2080004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2080004:
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _i2c_write
	CALL _i2c_stop
_0x2120001:
	ADIW R28,3
	RET
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

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rdataA:
	.BYTE 0x4
_comStart:
	.BYTE 0x2
_i:
	.BYTE 0x2
_rx_buffer0:
	.BYTE 0x40
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x1
_on_pressed:
	.BYTE 0x2
_off_pressed:
	.BYTE 0x2
_tx_buffer0:
	.BYTE 0x40
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
_on_button_state:
	.BYTE 0x2
_off_button_state:
	.BYTE 0x2
_Screen:
	.BYTE 0x2
_Pointer_horiz:
	.BYTE 0x2
_Pointer_vert:
	.BYTE 0x2
_Pt:
	.BYTE 0x2
_voltage:
	.BYTE 0x4
_current:
	.BYTE 0x4
_flag:
	.BYTE 0x2
_disp_volt:
	.BYTE 0x3
_disp_current:
	.BYTE 0x3
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOVW R30,R16
	ADD  R30,R8
	ADC  R31,R9
	SBIW R30,1
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOVW R30,R16
	ADD  R30,R8
	ADC  R31,R9
	MOVW R18,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G103
	__DELAY_USW 200
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
