
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _hr1=R5
	.DEF _hr2=R4
	.DEF _min1=R7
	.DEF _min2=R6
	.DEF _sec1=R9
	.DEF _sec2=R8
	.DEF _dd1=R11
	.DEF _dd2=R10
	.DEF _mm1=R13
	.DEF _mm2=R12

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
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  _timer0_ovf_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x18:
	.DB  0x13
_0x19:
	.DB  0x13
_0x1A:
	.DB  0x1
_0x1B:
	.DB  0x3
_0xE8:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x1
_0x0:
	.DB  0x20,0x0,0x5E,0x0,0x3E,0x0,0x25,0x30
	.DB  0x32,0x64,0x3A,0x25,0x30,0x32,0x64,0x3A
	.DB  0x25,0x30,0x32,0x64,0x0,0x25,0x30,0x32
	.DB  0x64,0x2F,0x25,0x30,0x32,0x64,0x2F,0x25
	.DB  0x34,0x64,0x0,0x25,0x30,0x34,0x64,0x0
	.DB  0x25,0x30,0x33,0x64,0x0,0x56,0x6F,0x6C
	.DB  0x74,0x61,0x67,0x65,0x20,0x73,0x65,0x74
	.DB  0x20,0x74,0x6F,0x3A,0x0,0x53,0x65,0x74
	.DB  0x20,0x76,0x61,0x6C,0x75,0x65,0x20,0x73
	.DB  0x68,0x6F,0x75,0x6C,0x64,0x0,0x62,0x65
	.DB  0x20,0x62,0x65,0x74,0x77,0x65,0x65,0x6E
	.DB  0x20,0x31,0x31,0x30,0x2D,0x0,0x31,0x33
	.DB  0x35,0x20,0x76,0x6F,0x6C,0x74,0x73,0x0
	.DB  0x43,0x75,0x72,0x72,0x65,0x6E,0x74,0x20
	.DB  0x73,0x65,0x74,0x20,0x74,0x6F,0x3A,0x0
	.DB  0x62,0x65,0x20,0x62,0x65,0x74,0x77,0x65
	.DB  0x65,0x6E,0x20,0x31,0x30,0x2D,0x0,0x32
	.DB  0x30,0x20,0x61,0x6D,0x70,0x73,0x0,0x57
	.DB  0x65,0x6C,0x63,0x6F,0x6D,0x65,0x20,0x74
	.DB  0x6F,0x20,0x48,0x4D,0x49,0x0,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x20,0x52
	.DB  0x73,0x74,0x0,0x54,0x69,0x6D,0x65,0x72
	.DB  0x0,0x53,0x65,0x6E,0x73,0x6F,0x72,0x20
	.DB  0x56,0x61,0x6C,0x75,0x65,0x73,0x0,0x53
	.DB  0x65,0x74,0x20,0x50,0x61,0x72,0x61,0x6D
	.DB  0x65,0x74,0x65,0x72,0x73,0x0,0x54,0x49
	.DB  0x4D,0x45,0x0,0x53,0x65,0x74,0x20,0x44
	.DB  0x61,0x74,0x65,0x20,0x2F,0x20,0x54,0x69
	.DB  0x6D,0x65,0x0,0x41,0x6C,0x61,0x72,0x6D
	.DB  0x20,0x4D,0x6F,0x64,0x65,0x0,0x43,0x6F
	.DB  0x75,0x6E,0x74,0x64,0x6F,0x77,0x6E,0x20
	.DB  0x54,0x69,0x6D,0x65,0x72,0x0,0x44,0x61
	.DB  0x74,0x65,0x3A,0x20,0x0,0x54,0x69,0x6D
	.DB  0x65,0x3A,0x20,0x0,0x4E,0x65,0x77,0x20
	.DB  0x54,0x3A,0x0,0x4E,0x65,0x77,0x20,0x44
	.DB  0x3A,0x0,0x63,0x6F,0x75,0x6E,0x74,0x64
	.DB  0x6F,0x77,0x6E,0x74,0x69,0x6D,0x65,0x72
	.DB  0x0,0x53,0x45,0x4E,0x53,0x4F,0x52,0x53
	.DB  0x0,0x41,0x6E,0x61,0x6C,0x6F,0x67,0x0
	.DB  0x44,0x69,0x67,0x69,0x74,0x61,0x6C,0x0
	.DB  0x54,0x68,0x65,0x72,0x6D,0x6F,0x63,0x6F
	.DB  0x75,0x70,0x6C,0x65,0x0,0x4E,0x6F,0x20
	.DB  0x66,0x75,0x6E,0x63,0x74,0x69,0x6F,0x6E
	.DB  0x73,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x61,0x64,0x64,0x65,0x64
	.DB  0x20,0x79,0x65,0x74,0x0,0x43,0x68,0x30
	.DB  0x3A,0x0,0x43,0x68,0x31,0x3A,0x0,0x43
	.DB  0x68,0x32,0x3A,0x0,0x43,0x68,0x33,0x3A
	.DB  0x0,0x43,0x68,0x34,0x3A,0x0,0x43,0x68
	.DB  0x35,0x3A,0x0,0x43,0x68,0x36,0x3A,0x0
	.DB  0x43,0x68,0x37,0x3A,0x0,0x54,0x65,0x6D
	.DB  0x70,0x3A,0x25,0x30,0x34,0x64,0x0,0x50
	.DB  0x41,0x52,0x41,0x4D,0x45,0x54,0x45,0x52
	.DB  0x53,0x0,0x56,0x6F,0x6C,0x74,0x61,0x67
	.DB  0x65,0x20,0x28,0x56,0x4F,0x4C,0x54,0x53
	.DB  0x29,0x0,0x43,0x75,0x72,0x72,0x65,0x6E
	.DB  0x74,0x20,0x28,0x41,0x4D,0x50,0x53,0x29
	.DB  0x0,0x53,0x65,0x74,0x20,0x76,0x6F,0x6C
	.DB  0x74,0x61,0x67,0x65,0x3A,0x0,0x53,0x65
	.DB  0x74,0x20,0x63,0x75,0x72,0x72,0x65,0x6E
	.DB  0x74,0x3A,0x0,0x45,0x72,0x72,0x6F,0x72
	.DB  0x2E,0x0,0x52,0x65,0x73,0x74,0x61,0x72
	.DB  0x74,0x69,0x6E,0x67,0x20,0x69,0x6E,0x20
	.DB  0x35,0x20,0x73,0x65,0x63,0x6F,0x6E,0x64
	.DB  0x73,0x2E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2080003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _yy1
	.DW  _0x18*2

	.DW  0x01
	.DW  _yy2
	.DW  _0x19*2

	.DW  0x01
	.DW  _Screen
	.DW  _0x1A*2

	.DW  0x01
	.DW  _rtc_setter
	.DW  _0x1B*2

	.DW  0x02
	.DW  _0x1C
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x1C+2
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x1C+4
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x1C+6
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x1C+8
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x1C+10
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x1C+12
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x1C+14
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x1C+16
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x1C+18
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x1C+20
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x1C+22
	.DW  _0x0*2+2

	.DW  0x10
	.DW  _0x75
	.DW  _0x0*2+45

	.DW  0x10
	.DW  _0x8E
	.DW  _0x0*2+104

	.DW  0x0F
	.DW  _0x96
	.DW  _0x0*2+143

	.DW  0x07
	.DW  _0xD8
	.DW  _0x0*2+483

	.DW  0x19
	.DW  _0xD8+7
	.DW  _0x0*2+490

	.DW  0x0A
	.DW  0x04
	.DW  _0xE8*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G104
	.DW  _0x2080003*2

_0xFFFFFFFF:
	.DW  0

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
;/*****************************************************
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
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
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0015 #endasm
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
; 0000 0021 {

	.CSEG
_ext_int4_isr:
; 0000 0022 // Place your code here
; 0000 0023 
; 0000 0024 }
	RETI
;
;// External Interrupt 5 service routine
;interrupt [EXT_INT5] void ext_int5_isr(void)
; 0000 0028 {
_ext_int5_isr:
; 0000 0029 // Place your code here
; 0000 002A 
; 0000 002B }
	RETI
;
;// External Interrupt 6 service routine
;interrupt [EXT_INT6] void ext_int6_isr(void)
; 0000 002F {
_ext_int6_isr:
; 0000 0030 // Place your code here
; 0000 0031 
; 0000 0032 }
	RETI
;
;// External Interrupt 7 service routine
;interrupt [EXT_INT7] void ext_int7_isr(void)
; 0000 0036 {
_ext_int7_isr:
; 0000 0037 // Place your code here
; 0000 0038 
; 0000 0039 }
	RETI
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
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 0060 {
; 0000 0061 char status,data;
; 0000 0062 while (1)
;	status -> R17
;	data -> R16
; 0000 0063       {
; 0000 0064       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 0065       data=UDR1;
; 0000 0066       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 0067          return data;
; 0000 0068       }
; 0000 0069 }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 006F {
; 0000 0070 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 0071 UDR1=c;
; 0000 0072 }
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 007A {
_timer0_ovf_isr:
; 0000 007B // Place your code here
; 0000 007C 
; 0000 007D }
	RETI
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0081 {
_timer1_ovf_isr:
; 0000 0082 // Place your code here
; 0000 0083 
; 0000 0084 }
	RETI
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 008A {
_read_adc:
; 0000 008B ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 008C // Delay needed for the stabilization of the ADC input voltage
; 0000 008D delay_us(10);
	__DELAY_USB 53
; 0000 008E // Start the AD conversion
; 0000 008F ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0090 // Wait for the AD conversion to complete
; 0000 0091 while ((ADCSRA & 0x10)==0);
_0xD:
	SBIS 0x6,4
	RJMP _0xD
; 0000 0092 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0093 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0094 }
;
;// SPI functions
;#include <spi.h>
;
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
;signed int  ThermoReadRaw (void)
; 0000 009A {
_ThermoReadRaw:
;    signed int                   d;
;    unsigned char                n;
;
;    PORT_THERMO_CS &= ~MASK_THERMO_CS;    // pull thermo CS low
	CALL __SAVELOCR4
;	d -> R16,R17
;	n -> R19
	CBI  0x3,3
;    d = 0;                                // start with nothing
	__GETWRN 16,17,0
;    for (n=3; n!=0xff; n--)
	LDI  R19,LOW(3)
_0x11:
	CPI  R19,255
	BREQ _0x12
;    {
;        SPDR = 0;                         // send a null byte
	LDI  R30,LOW(0)
	OUT  0xF,R30
;        while ((SPSR & (1<<SPIF)) == 0)  ;    // wait until transfer ends
_0x13:
	SBIS 0xE,7
	RJMP _0x13
;        d = (d<<8) + SPDR;                // add next byte, starting with MSB
	MOV  R27,R16
	LDI  R26,LOW(0)
	IN   R30,0xF
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
;    }
	SUBI R19,1
	RJMP _0x11
_0x12:
;    PORT_THERMO_CS |= MASK_THERMO_CS;     // done, pull CS high
	SBI  0x3,3
;    return  d;
	MOVW R30,R16
	CALL __LOADLOCR4
	RJMP _0x212000D
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
;int  ThermoReadC(void)
;{
_ThermoReadC:
;    signed int d;
;    int neg;
;
;
;    neg = 0;                    // assume a positive raw value
	CALL __SAVELOCR4
;	d -> R16,R17
;	neg -> R18,R19
	__GETWRN 18,19,0
;    d = ThermoReadRaw();        // get a raw value
	RCALL _ThermoReadRaw
	MOVW R16,R30
;    d = ((d >> 10) & 0x3fff);   // leave only thermocouple value in d
	MOVW R26,R16
	LDI  R30,LOW(10)
	CALL __ASRW12
	ANDI R31,HIGH(0x3FFF)
	MOVW R16,R30
;    if (d & 0x2000)             // if thermocouple reading is negative...
	SBRS R17,5
	RJMP _0x16
;    {
;        d = -d & 0x3fff;        // always work with positive values
	MOVW R30,R16
	CALL __ANEGW1
	ANDI R31,HIGH(0x3FFF)
	MOVW R16,R30
;        neg = 1;                // but note original value was negative
	__GETWRN 18,19,1
;    }
;    d = d + 2;                  // round up by 0.5 degC (2 LSBs)
_0x16:
	__ADDWRN 16,17,2
;    d = d >> 2;                 // now convert from 0.25 degC units to degC
	ASR  R17
	ROR  R16
	ASR  R17
	ROR  R16
;    if (neg)  d = -d;           // convert to negative if needed
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x17
	MOVW R30,R16
	CALL __ANEGW1
	MOVW R16,R30
;    return  d;                  // return as integer
_0x17:
	MOVW R30,R16
	CALL __LOADLOCR4
	RJMP _0x212000D
;}
;
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
;//---------------Variables---------------
;#include <variables.h>

	.DSEG
;//-------------Display Functions---------
;#include "Display_functions.c"
;//#include <variables.h>
;
;void pointer_display_horiz()                          //checks the cursor position.
; 0000 009E {

	.CSEG
_pointer_display_horiz:
;    lcd_gotoxy(0,2);
	CALL SUBOPT_0x0
;    lcd_putsf(" ");
;    lcd_gotoxy(1,2);
	CALL SUBOPT_0x1
;    lcd_putsf(" ");
	CALL SUBOPT_0x2
;    lcd_gotoxy(2,2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x3
;    lcd_putsf(" ");
;    lcd_gotoxy(3,2);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
;    lcd_putsf(" ");
;    lcd_gotoxy(Pointer_horiz,2);                      //Pointer displays arrow at that position
	LDS  R30,_Pointer_horiz
	CALL SUBOPT_0x4
;    lcd_putsf("^");
	__POINTW1FN _0x0,2
	RJMP _0x212000F
;}
;
;void pointer_display_vert()                          //checks the cursor position.
;{
_pointer_display_vert:
;    lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
;    lcd_putsf(" ");
	CALL SUBOPT_0x2
;    lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
;    lcd_putsf(" ");
	CALL SUBOPT_0x2
;    lcd_gotoxy(0,2);
	CALL SUBOPT_0x0
;    lcd_putsf(" ");
;    lcd_gotoxy(0,3);
	CALL SUBOPT_0x7
;    lcd_putsf(" ");
	CALL SUBOPT_0x2
;    lcd_gotoxy(0,Pointer_vert);                      //Pointer displays arrow at that position
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,_Pointer_vert
	ST   -Y,R30
	CALL _lcd_gotoxy
;    lcd_putsf(">");
	__POINTW1FN _0x0,4
_0x212000F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
;}
	RET
;
;void RTC_pointer()
;{
_RTC_pointer:
;    lcd_gotoxy(6,2);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4
;    sprintf(disptime1, "%02d:%02d:%02d", hr1, min1, sec1);
	LDI  R30,LOW(_disptime1)
	LDI  R31,HIGH(_disptime1)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,6
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL SUBOPT_0x8
	MOV  R30,R7
	CALL SUBOPT_0x8
	MOV  R30,R9
	CALL SUBOPT_0x8
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
;    lcd_puts(disptime1);
	LDI  R30,LOW(_disptime1)
	LDI  R31,HIGH(_disptime1)
	CALL SUBOPT_0x9
;
;    lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0xA
;    sprintf(dispdate1, "%02d/%02d/%4d", dd1, mm1, 2000+yy1);
	LDI  R30,LOW(_dispdate1)
	LDI  R31,HIGH(_dispdate1)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,21
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	CALL SUBOPT_0x8
	MOV  R30,R13
	CALL SUBOPT_0x8
	LDS  R30,_yy1
	LDI  R31,0
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	CALL SUBOPT_0xB
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
;    lcd_puts(dispdate1);
	LDI  R30,LOW(_dispdate1)
	LDI  R31,HIGH(_dispdate1)
	CALL SUBOPT_0x9
;
;    lcd_gotoxy(15,1);
	CALL SUBOPT_0xC
;    lcd_puts(" ");
	__POINTW1MN _0x1C,0
	CALL SUBOPT_0x9
;    lcd_gotoxy(10,1);
	CALL SUBOPT_0xD
;    lcd_puts(" ");
	__POINTW1MN _0x1C,2
	CALL SUBOPT_0x9
;    lcd_gotoxy(7,1);
	CALL SUBOPT_0xE
;    lcd_puts(" ");
	__POINTW1MN _0x1C,4
	CALL SUBOPT_0x9
;    lcd_gotoxy(13,3);
	CALL SUBOPT_0xF
;    lcd_puts(" ");
	__POINTW1MN _0x1C,6
	CALL SUBOPT_0x9
;    lcd_gotoxy(10,3);
	CALL SUBOPT_0x10
;    lcd_puts(" ");
	__POINTW1MN _0x1C,8
	CALL SUBOPT_0x9
;    lcd_gotoxy(7,3);
	CALL SUBOPT_0x11
;    lcd_puts(" ");
	__POINTW1MN _0x1C,10
	CALL SUBOPT_0x9
;
;    switch(rtc_setter)
	LDS  R30,_rtc_setter
	LDS  R31,_rtc_setter+1
;    {
;        case 3:                         //Years
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20
;            lcd_gotoxy(15,1);
	CALL SUBOPT_0xC
;            lcd_puts("^");
	__POINTW1MN _0x1C,12
	RJMP _0xDD
;        break;
;        case 4:                         //Months
_0x20:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x21
;            lcd_gotoxy(10,1);
	CALL SUBOPT_0xD
;            lcd_puts("^");
	__POINTW1MN _0x1C,14
	RJMP _0xDD
;        break;
;        case 5:                         //Days
_0x21:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x22
;            lcd_gotoxy(7,1);
	CALL SUBOPT_0xE
;            lcd_puts("^");
	__POINTW1MN _0x1C,16
	RJMP _0xDD
;        break;
;        case 0:                         //Seconds
_0x22:
	SBIW R30,0
	BRNE _0x23
;            lcd_gotoxy(13,3);
	CALL SUBOPT_0xF
;            lcd_puts("^");
	__POINTW1MN _0x1C,18
	RJMP _0xDD
;        break;
;        case 1:                         //Minutes
_0x23:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x24
;            lcd_gotoxy(10,3);
	CALL SUBOPT_0x10
;            lcd_puts("^");
	__POINTW1MN _0x1C,20
	RJMP _0xDD
;        break;
;        case 2:                         //Hours
_0x24:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
;            lcd_gotoxy(7,3);
	CALL SUBOPT_0x11
;            lcd_puts("^");
	__POINTW1MN _0x1C,22
_0xDD:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;        break;
;    }
_0x1F:
;}
	RET

	.DSEG
_0x1C:
	.BYTE 0x18
;
;void show_pass()
;{

	.CSEG
;    sprintf(disp_pass,"%04d",temp_pass);
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_pass);
;}
;
;void show_volt()
;{
_show_volt:
;    sprintf(disp_volt,"%03d",voltage);
	LDI  R30,LOW(_disp_volt)
	LDI  R31,HIGH(_disp_volt)
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_volt);
	LDI  R30,LOW(_disp_volt)
	LDI  R31,HIGH(_disp_volt)
	RJMP _0x212000E
;}
;void show_current()
;{
_show_current:
;    sprintf(disp_current,"%03d",current);
	LDI  R30,LOW(_disp_current)
	LDI  R31,HIGH(_disp_current)
	CALL SUBOPT_0x12
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_current);
	LDI  R30,LOW(_disp_current)
	LDI  R31,HIGH(_disp_current)
_0x212000E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;}
	RET
;//----Input and val change functions-----
;#include "Change.c"
;#include "Inputs.c"
;//#include <variables.h>
;
;void input_RTC()
; 0000 00A1 {
_input_RTC:
;    RTC_pointer();
	RCALL _RTC_pointer
;    if (PINE.2 == 0)                                            //UP/increase     1
	SBIC 0x1,2
	RJMP _0x26
;       {
;        while(PINE.2 == 0);
_0x27:
	SBIS 0x1,2
	RJMP _0x27
;
;        RTC_pointer();
	RCALL _RTC_pointer
;       }
;
;    if (PINE.3 == 0)                                            //DOWN/decrease   2
_0x26:
	SBIC 0x1,3
	RJMP _0x2A
;       {
;        while(PINE.3 == 0);
_0x2B:
	SBIS 0x1,3
	RJMP _0x2B
;
;        RTC_pointer();
	RCALL _RTC_pointer
;       }
;
;    if (PINE.0 == 0)                                            //NEXT   3
_0x2A:
	SBIC 0x1,0
	RJMP _0x2E
;       {
;        while(PINE.0 == 0);
_0x2F:
	SBIS 0x1,0
	RJMP _0x2F
;        rtc_setter++;
	LDI  R26,LOW(_rtc_setter)
	LDI  R27,HIGH(_rtc_setter)
	CALL SUBOPT_0x16
;        rtc_setter = rtc_setter % 6;
	LDS  R26,_rtc_setter
	LDS  R27,_rtc_setter+1
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __MODW21
	STS  _rtc_setter,R30
	STS  _rtc_setter+1,R31
;        RTC_pointer();
	RCALL _RTC_pointer
;       }
;    if (PINE.1 == 0)                                            //SET   4
_0x2E:
	SBIC 0x1,1
	RJMP _0x32
;       {
;        while(PINE.1 == 0);
_0x33:
	SBIS 0x1,1
	RJMP _0x33
;            if (Screen == 310)
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BREQ _0xDE
;            {
;                rtc_set_date(dd1,mm1,yy1);
;                rtc_set_time(hr1,min1,sec1);
;                Screen = 31;
;            }
;            else if (Screen == 311)
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	BRNE _0x38
;            {
;                rtc_set_date(dd1,mm1,yy1);
_0xDE:
	ST   -Y,R11
	ST   -Y,R13
	LDS  R30,_yy1
	ST   -Y,R30
	CALL _rtc_set_date
;                rtc_set_time(hr1,min1,sec1);
	ST   -Y,R5
	ST   -Y,R7
	ST   -Y,R9
	CALL _rtc_set_time
;                Screen = 31;
	CALL SUBOPT_0x18
;            }
;
;       }
_0x38:
;}
_0x32:
	RET
;
;
;void input_pass(int next)
;{
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
;	next -> Y+2
;	change -> R16,R17
;    if (PINE.2 == 0)                                            //UP     1
;       {
;        while(PINE.2 == 0);
;        if(change == 1)
;        {temp_pass = temp_pass + (change);}
;        else
;        {temp_pass = temp_pass + 1 + (change);}
;        temp_pass = temp_pass % 10000;
;        show_pass();
;        pointer_display_horiz();
;       }
;
;    if (PINE.3 == 0)                                            //DOWN   2
;       {
;        while(PINE.3 == 0);
;        temp_pass = temp_pass - (change);
;        temp_pass = temp_pass % 10000;
;        temp_pass = ((temp_pass < 0) ? (9999 + temp_pass): temp_pass);
;        show_pass();
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                            //NEXT  3
;       {
;        while(PINE.0 == 0);
;
;        Pointer_horiz++;
;
;        if((Pointer_horiz ==0) && (temp_pass == password))
;        {flag = 1;}
;
;        Pointer_horiz = Pointer_horiz % next;
;        pointer_display_horiz();
;       }
;
;    /*
;    if (PINE.1 == 0)                                            //ESCAPE 4
;       {
;        while(PINE.1 == 0);
;        if(Screen > 100)
;        {Screen = Screen/10;}
;        else
;        Screen = (Screen/10)-1;
;        //flag = 1;
;       }
;    */
;}
;
;
;void input(int next)                         //next recieves value no of options we will have in the next menu
;{   //int next = 4;
_input:
;    //int flag = 0;
;    Pt = Pointer_vert;
;	next -> Y+0
	LDS  R30,_Pointer_vert
	LDS  R31,_Pointer_vert+1
	STS  _Pt,R30
	STS  _Pt+1,R31
;    pointer_display_vert();
	RCALL _pointer_display_vert
;    delay_ms(100);
	CALL SUBOPT_0x19
;    if (PINE.2 == 0)                                            //UP
	SBIC 0x1,2
	RJMP _0x4D
;       {
;        while(PINE.2 == 0);
_0x4E:
	SBIS 0x1,2
	RJMP _0x4E
;        Pt--;
	LDI  R26,LOW(_Pt)
	LDI  R27,HIGH(_Pt)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
;        Pointer_vert = ((Pt < 0) ? (next+Pt): Pt) % next;
	LDS  R26,_Pt+1
	TST  R26
	BRPL _0x51
	LDS  R30,_Pt
	LDS  R31,_Pt+1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x52
_0x51:
	LDS  R30,_Pt
	LDS  R31,_Pt+1
_0x52:
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x1A
;        pointer_display_vert();
;       }
;
;    if (PINE.3 == 0)                                            //DOWN
_0x4D:
	SBIC 0x1,3
	RJMP _0x54
;       {
;        while(PINE.3 == 0);
_0x55:
	SBIS 0x1,3
	RJMP _0x55
;        Pointer_vert++;
	LDI  R26,LOW(_Pointer_vert)
	LDI  R27,HIGH(_Pointer_vert)
	CALL SUBOPT_0x16
;        Pointer_vert = Pointer_vert % next;
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_Pointer_vert
	LDS  R27,_Pointer_vert+1
	CALL SUBOPT_0x1A
;        pointer_display_vert();
;       }
;
;    if (PINE.0 == 0)                                            //ENTER
_0x54:
	SBIC 0x1,0
	RJMP _0x58
;       {
;        while(PINE.0 == 0);
_0x59:
	SBIS 0x1,0
	RJMP _0x59
;        if(Screen < 10)
	CALL SUBOPT_0x17
	SBIW R26,10
	BRGE _0x5C
;        {
;            Screen = ((Screen+1)*10) + Pointer_vert;
	CALL SUBOPT_0x1B
	ADIW R30,1
	RJMP _0xE0
;        }
;        else
_0x5C:
;        {
;            Screen = ((Screen)*10) + Pointer_vert;
	CALL SUBOPT_0x1B
_0xE0:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	LDS  R26,_Pointer_vert
	LDS  R27,_Pointer_vert+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x1C
;        }
;
;        //flag = 1;
;       }
;
;    if (PINE.1 == 0)                                            //ESCAPE
_0x58:
	SBIC 0x1,1
	RJMP _0x5E
;       {
;        while(PINE.1 == 0);
_0x5F:
	SBIS 0x1,1
	RJMP _0x5F
;        if(Screen > 100)
	CALL SUBOPT_0x1D
	BRLT _0x62
;        {Screen = Screen/10;}
	CALL SUBOPT_0x1E
	RJMP _0xE1
;        else
_0x62:
;        Screen = (Screen/10)-1;
	CALL SUBOPT_0x1E
	SBIW R30,1
_0xE1:
	STS  _Screen,R30
	STS  _Screen+1,R31
;        //flag = 1;
;       }
;
;    //return (flag);
;}
_0x5E:
	ADIW R28,2
	RET
;
;
;void input_volt(int next)
;{
_input_volt:
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
	CALL SUBOPT_0x1F
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP     1
	SBIC 0x1,2
	RJMP _0x64
;       {
;        while(PINE.2 == 0);
_0x65:
	SBIS 0x1,2
	RJMP _0x65
;        if(change == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x68
;        {voltage = voltage + (change);}
	MOVW R30,R16
	CALL SUBOPT_0x20
	RJMP _0xE2
;        else
_0x68:
;        {voltage = voltage + 1 + (change);}
	CALL SUBOPT_0x13
	CALL SUBOPT_0x21
_0xE2:
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x22
;        voltage = voltage % 1000;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
;        show_volt();
	RCALL _show_volt
;        pointer_display_horiz();
	RCALL _pointer_display_horiz
;       }
;
;    if (PINE.3 == 0)                                            //Next   2
_0x64:
	SBIC 0x1,3
	RJMP _0x6A
;       {
;        while(PINE.3 == 0);
_0x6B:
	SBIS 0x1,3
	RJMP _0x6B
;        Pointer_horiz++;
	LDI  R26,LOW(_Pointer_horiz)
	LDI  R27,HIGH(_Pointer_horiz)
	CALL SUBOPT_0x16
;
;        Pointer_horiz = Pointer_horiz % next;
	CALL SUBOPT_0x24
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                             //ENTER 3
_0x6A:
	SBIC 0x1,0
	RJMP _0x6E
;        {
;         while(PINE.0 == 0);
_0x6F:
	SBIS 0x1,0
	RJMP _0x6F
;         if(110 <= voltage && voltage <= 135)
	CALL SUBOPT_0x13
	__CPD1N 0x6E
	BRLT _0x73
	CALL SUBOPT_0x20
	__CPD2N 0x88
	BRLT _0x74
_0x73:
	RJMP _0x72
_0x74:
;         {
;            lcd_clear();
	CALL SUBOPT_0x25
;            lcd_gotoxy(0,0);
;            lcd_puts("Voltage set to:");
	__POINTW1MN _0x75,0
	CALL SUBOPT_0x9
;            show_volt();
	RCALL _show_volt
;            //Voltage = temp_volt;
;            flag = 11;
	CALL SUBOPT_0x26
;            Screen = 33;
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	CALL SUBOPT_0x1C
;            delay_ms(2000);
	RJMP _0xE3
;         }
;         else
_0x72:
;         {
;            lcd_clear();
	CALL SUBOPT_0x25
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
	CALL SUBOPT_0x27
;            lcd_gotoxy(0,1);
;            lcd_putsf("be between 110-");
	__POINTW1FN _0x0,78
	CALL SUBOPT_0x28
;            lcd_gotoxy(0,2);
	CALL SUBOPT_0x4
;            lcd_putsf("135 volts");
	__POINTW1FN _0x0,94
	CALL SUBOPT_0x28
;            voltage = 000;
	CALL SUBOPT_0x29
;            Screen = 330;
	LDI  R30,LOW(330)
	LDI  R31,HIGH(330)
	CALL SUBOPT_0x1C
;            flag = 11;
	CALL SUBOPT_0x26
;            delay_ms(2000);
_0xE3:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2A
;         }
;        }
;
;    if (PINE.1 == 0)                                            //ESCAPE 4
_0x6E:
	SBIC 0x1,1
	RJMP _0x77
;       {
;        while(PINE.1 == 0);
_0x78:
	SBIS 0x1,1
	RJMP _0x78
;        flag = 11;
	CALL SUBOPT_0x26
;        if(Screen > 100)
	CALL SUBOPT_0x1D
	BRLT _0x7B
;        {Screen = Screen/10;}
	CALL SUBOPT_0x1E
	RJMP _0xE4
;        else
_0x7B:
;        {Screen = (Screen/10)-1;}
	CALL SUBOPT_0x1E
	SBIW R30,1
_0xE4:
	STS  _Screen,R30
	STS  _Screen+1,R31
;        //flag = 1;
;       }
;}
_0x77:
	RJMP _0x212000C

	.DSEG
_0x75:
	.BYTE 0x10
;
;void input_current(int next)
;{

	.CSEG
_input_current:
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
	CALL SUBOPT_0x1F
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP     1
	SBIC 0x1,2
	RJMP _0x7D
;       {
;        while(PINE.2 == 0);
_0x7E:
	SBIS 0x1,2
	RJMP _0x7E
;        if(change == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x81
;        {current = current + (change);}
	MOVW R30,R16
	CALL SUBOPT_0x2B
	RJMP _0xE5
;        else
_0x81:
;        {current = current + 1 + (change);}
	CALL SUBOPT_0x15
	CALL SUBOPT_0x21
_0xE5:
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x2C
;        current = current % 1000;
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x23
	CALL SUBOPT_0x2C
;        show_current();
	RCALL _show_current
;        pointer_display_horiz();
	RCALL _pointer_display_horiz
;       }
;
;    if (PINE.3 == 0)                                            //Next   2
_0x7D:
	SBIC 0x1,3
	RJMP _0x83
;       {
;        while(PINE.3 == 0);
_0x84:
	SBIS 0x1,3
	RJMP _0x84
;        Pointer_horiz++;
	LDI  R26,LOW(_Pointer_horiz)
	LDI  R27,HIGH(_Pointer_horiz)
	CALL SUBOPT_0x16
;
;        Pointer_horiz = Pointer_horiz % next;
	CALL SUBOPT_0x24
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                             //ENTER 3
_0x83:
	SBIC 0x1,0
	RJMP _0x87
;        {
;         while(PINE.0 == 0);
_0x88:
	SBIS 0x1,0
	RJMP _0x88
;         if(10 <= current && current <= 20)
	CALL SUBOPT_0x15
	__CPD1N 0xA
	BRLT _0x8C
	CALL SUBOPT_0x2B
	__CPD2N 0x15
	BRLT _0x8D
_0x8C:
	RJMP _0x8B
_0x8D:
;         {
;            lcd_clear();
	CALL SUBOPT_0x25
;            lcd_gotoxy(0,0);
;            lcd_puts("Current set to:");
	__POINTW1MN _0x8E,0
	CALL SUBOPT_0x9
;            show_current();
	RCALL _show_current
;            flag = 11;
	CALL SUBOPT_0x26
;            Screen = 33;
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	CALL SUBOPT_0x1C
;            delay_ms(2000);
	RJMP _0xE6
;         }
;         else
_0x8B:
;         {
;            lcd_clear();
	CALL SUBOPT_0x25
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
	CALL SUBOPT_0x27
;            lcd_gotoxy(0,1);
;            lcd_putsf("be between 10-");
	__POINTW1FN _0x0,120
	CALL SUBOPT_0x28
;            lcd_gotoxy(0,2);
	CALL SUBOPT_0x4
;            lcd_putsf("20 amps");
	__POINTW1FN _0x0,135
	CALL SUBOPT_0x28
;            voltage = 000;
	CALL SUBOPT_0x29
;            Screen = 331;
	LDI  R30,LOW(331)
	LDI  R31,HIGH(331)
	CALL SUBOPT_0x1C
;            flag = 11;
	CALL SUBOPT_0x26
;            delay_ms(2000);
_0xE6:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2A
;         }
;        }
;
;    if (PINE.1 == 0)                                            //ESCAPE 4
_0x87:
	SBIC 0x1,1
	RJMP _0x90
;       {
;        while(PINE.1 == 0);
_0x91:
	SBIS 0x1,1
	RJMP _0x91
;        flag = 11;
	CALL SUBOPT_0x26
;        if(Screen > 100)
	CALL SUBOPT_0x1D
	BRLT _0x94
;        {Screen = Screen/10;}
	CALL SUBOPT_0x1E
	RJMP _0xE7
;        else
_0x94:
;        {Screen = (Screen/10)-1;}
	CALL SUBOPT_0x1E
	SBIW R30,1
_0xE7:
	STS  _Screen,R30
	STS  _Screen+1,R31
;        //flag = 1;
;       }
;
;
;}
_0x90:
_0x212000C:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x212000D:
	ADIW R28,4
	RET

	.DSEG
_0x8E:
	.BYTE 0x10
;
;
;
;/*
;void PASSWORD_CHK()
;{
;    lcd_gotoxy(0,0);
;    lcd_puts("ENTER PASSWORD:");
;    lcd_gotoxy(0,1);
;    lcd_puts("0000");
;    while ((temp_pass != password) && (flag == 0))
;    {
;        input_pass(4);
;    }
;}
; */
;
;
;void Screen1()
; 0000 00B5 {

	.CSEG
_Screen1:
; 0000 00B6     Screen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x1C
; 0000 00B7     Pointer_horiz = 0;
	LDI  R30,LOW(0)
	STS  _Pointer_horiz,R30
	STS  _Pointer_horiz+1,R30
; 0000 00B8     Pointer_vert = 0;
	CALL SUBOPT_0x2D
; 0000 00B9     lcd_clear();
	CALL SUBOPT_0x25
; 0000 00BA     lcd_gotoxy(0,0);
; 0000 00BB     lcd_puts("Welcome to HMI");
	__POINTW1MN _0x96,0
	CALL SUBOPT_0x9
; 0000 00BC     /*lcd_gotoxy(0,1);
; 0000 00BD     lcd_puts("Welcome to HMI");
; 0000 00BE     lcd_gotoxy(0,2);
; 0000 00BF     lcd_puts("Welcome to HMI");
; 0000 00C0     lcd_gotoxy(0,3);
; 0000 00C1     lcd_puts("Welcome to HMI");  */
; 0000 00C2     delay_ms(1000);
	CALL SUBOPT_0x2E
; 0000 00C3 
; 0000 00C4  /*  lcd_clear();
; 0000 00C5    PASSWORD_CHK();
; 0000 00C6 
; 0000 00C7     lcd_clear();
; 0000 00C8     lcd_gotoxy(0,0);
; 0000 00C9     lcd_puts("PASSWORD CORRECT");
; 0000 00CA     delay_ms(3000);
; 0000 00CB  */
; 0000 00CC     Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x212000B
; 0000 00CD }

	.DSEG
_0x96:
	.BYTE 0xF
;
;void Screen2()
; 0000 00D0 {

	.CSEG
_Screen2:
; 0000 00D1     //int flag1 = 0;
; 0000 00D2     lcd_clear();
	CALL _lcd_clear
; 0000 00D3     Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x1C
; 0000 00D4     Pointer_vert = 0;
	CALL SUBOPT_0x2D
; 0000 00D5     Pointer_horiz= 0;
	LDI  R30,LOW(0)
	STS  _Pointer_horiz,R30
	STS  _Pointer_horiz+1,R30
; 0000 00D6     lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
; 0000 00D7     lcd_putsf("Password Rst");
	__POINTW1FN _0x0,158
	CALL SUBOPT_0x2F
; 0000 00D8     lcd_gotoxy(1,1);
	CALL SUBOPT_0x30
; 0000 00D9     lcd_putsf("Timer");
	__POINTW1FN _0x0,171
	CALL SUBOPT_0x2F
; 0000 00DA     lcd_gotoxy(1,2);
	CALL SUBOPT_0x1
; 0000 00DB     lcd_putsf("Sensor Values");
	__POINTW1FN _0x0,177
	CALL SUBOPT_0x2F
; 0000 00DC     lcd_gotoxy(1,3);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x31
; 0000 00DD     lcd_putsf("Set Parameters");
	__POINTW1FN _0x0,191
	CALL SUBOPT_0x2F
; 0000 00DE     while(Screen == 2)
_0x97:
	CALL SUBOPT_0x17
	SBIW R26,2
	BRNE _0x99
; 0000 00DF     {
; 0000 00E0         input(4);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x32
; 0000 00E1     }
	RJMP _0x97
_0x99:
; 0000 00E2     //return(Screen);
; 0000 00E3     //delay_ms(3000);
; 0000 00E4 }
	RET
;
;/*
;void Screen30()
;{
;    lcd_clear();
;    Pointer_vert = 0;
;    lcd_gotoxy(3,3);
;    lcd_putsf("MOTOR MODE");
;    lcd_gotoxy(1,0);
;    lcd_putsf("BLDC");
;    lcd_gotoxy(1,1);
;    lcd_putsf("PMSM");
;    lcd_gotoxy(1,2);
;    lcd_putsf("IM");
;    while(Screen == 30)
;    {
;        input(3);
;    }
;}
;*/
;
;void Screen31()
; 0000 00FB {
_Screen31:
; 0000 00FC     //TIMER
; 0000 00FD     lcd_clear();
	CALL SUBOPT_0x33
; 0000 00FE     Pointer_vert = 0;
; 0000 00FF     lcd_gotoxy(6,3);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x31
; 0000 0100     lcd_putsf("TIME");
	__POINTW1FN _0x0,206
	CALL SUBOPT_0x2F
; 0000 0101     /*
; 0000 0102        rtc_get_time(&hr1,&min1,&sec1);
; 0000 0103        rtc_get_date(&dd1,&mm1,&yy1);
; 0000 0104 
; 0000 0105        lcd_gotoxy(0,0);
; 0000 0106 
; 0000 0107        sprintf(disptime1,"TIME:%02d:%02d:%02d",hr1,min1,sec1);
; 0000 0108        lcd_puts(disptime1);
; 0000 0109 
; 0000 010A        lcd_gotoxy(0,1);
; 0000 010B        sprintf(dispdate1,"DATE:%02d/%02d/%04d",dd1,mm1,2000+yy1);
; 0000 010C        lcd_puts(dispdate1);
; 0000 010D     */
; 0000 010E     lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
; 0000 010F     lcd_putsf("Set Date / Time");
	__POINTW1FN _0x0,211
	CALL SUBOPT_0x2F
; 0000 0110     lcd_gotoxy(1,1);
	CALL SUBOPT_0x30
; 0000 0111     lcd_putsf("Alarm Mode");
	__POINTW1FN _0x0,227
	CALL SUBOPT_0x2F
; 0000 0112     lcd_gotoxy(1,2);
	CALL SUBOPT_0x1
; 0000 0113     lcd_putsf("Countdown Timer");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x2F
; 0000 0114     while(Screen == 31)
_0x9A:
	CALL SUBOPT_0x17
	SBIW R26,31
	BRNE _0x9C
; 0000 0115     {
; 0000 0116         input(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x32
; 0000 0117     }
	RJMP _0x9A
_0x9C:
; 0000 0118 }
	RET
;
;void Screen310()
; 0000 011B {
_Screen310:
; 0000 011C     //Set Date and time.
; 0000 011D     lcd_clear();
	CALL _lcd_clear
; 0000 011E     rtc_get_time(&hr1,&min1,&sec1);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
; 0000 011F     rtc_get_date(&dd1,&mm1,&yy1);
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_yy1)
	LDI  R31,HIGH(_yy1)
	CALL SUBOPT_0x34
; 0000 0120 
; 0000 0121     lcd_gotoxy(0,0);
; 0000 0122     lcd_putsf("Date: ");
	__POINTW1FN _0x0,254
	CALL SUBOPT_0x28
; 0000 0123     lcd_gotoxy(0,2);
	CALL SUBOPT_0x4
; 0000 0124     lcd_putsf("Time: ");
	__POINTW1FN _0x0,261
	CALL SUBOPT_0x2F
; 0000 0125     while(Screen == 310)
_0x9D:
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x136)
	LDI  R30,HIGH(0x136)
	CPC  R27,R30
	BRNE _0x9F
; 0000 0126     {input_RTC();}
	RCALL _input_RTC
	RJMP _0x9D
_0x9F:
; 0000 0127 }
	RET
;
;void Screen311()
; 0000 012A {
_Screen311:
; 0000 012B     //Alarm Mode
; 0000 012C     lcd_clear();
	CALL _lcd_clear
; 0000 012D     rtc_get_time(&hr2,&min2,&sec2);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_time
; 0000 012E     rtc_get_date(&dd2,&mm2,&yy2);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_yy2)
	LDI  R31,HIGH(_yy2)
	CALL SUBOPT_0x34
; 0000 012F     lcd_gotoxy(0,0);
; 0000 0130     lcd_putsf("New T:");
	__POINTW1FN _0x0,268
	CALL SUBOPT_0x28
; 0000 0131     lcd_gotoxy(0,2);
	CALL SUBOPT_0x4
; 0000 0132     lcd_putsf("New D:");
	__POINTW1FN _0x0,275
	CALL SUBOPT_0x2F
; 0000 0133     while(Screen == 311)
_0xA0:
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x137)
	LDI  R30,HIGH(0x137)
	CPC  R27,R30
	BRNE _0xA2
; 0000 0134     {input_RTC();
	RCALL _input_RTC
; 0000 0135 
; 0000 0136     }
	RJMP _0xA0
_0xA2:
; 0000 0137 
; 0000 0138 }
	RET
;
;void Screen312()
; 0000 013B {
_Screen312:
; 0000 013C     //Countdown timer. using input time.
; 0000 013D     lcd_clear();
	CALL SUBOPT_0x25
; 0000 013E     lcd_gotoxy(0,0);
; 0000 013F     lcd_putsf("countdowntimer");
	__POINTW1FN _0x0,282
	CALL SUBOPT_0x2F
; 0000 0140     delay_ms(1000);
	CALL SUBOPT_0x2E
; 0000 0141     if(PINE.1 == 0)                  //ESCAPE -- 4
	SBIC 0x1,1
	RJMP _0xA3
; 0000 0142     {
; 0000 0143         while(PINE.1 == 0)
_0xA4:
	SBIC 0x1,1
	RJMP _0xA6
; 0000 0144         {
; 0000 0145             Screen = 31;
	CALL SUBOPT_0x18
; 0000 0146         }
	RJMP _0xA4
_0xA6:
; 0000 0147     }
; 0000 0148 
; 0000 0149 }
_0xA3:
	RET
;
;
;void Screen32()
; 0000 014D {
_Screen32:
; 0000 014E     lcd_clear();
	CALL SUBOPT_0x33
; 0000 014F     Pointer_vert = 0;
; 0000 0150     lcd_gotoxy(4,3);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x31
; 0000 0151     lcd_putsf("SENSORS");
	__POINTW1FN _0x0,297
	CALL SUBOPT_0x2F
; 0000 0152     lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
; 0000 0153     lcd_putsf("Analog");
	__POINTW1FN _0x0,305
	CALL SUBOPT_0x2F
; 0000 0154     lcd_gotoxy(1,1);
	CALL SUBOPT_0x30
; 0000 0155     lcd_putsf("Digital");
	__POINTW1FN _0x0,312
	CALL SUBOPT_0x2F
; 0000 0156     lcd_gotoxy(1,2);
	CALL SUBOPT_0x1
; 0000 0157     lcd_putsf("Thermocouple");
	__POINTW1FN _0x0,320
	CALL SUBOPT_0x2F
; 0000 0158 
; 0000 0159     while(Screen == 32)
_0xA7:
	CALL SUBOPT_0x17
	SBIW R26,32
	BRNE _0xA9
; 0000 015A     {
; 0000 015B         input(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x32
; 0000 015C     }
	RJMP _0xA7
_0xA9:
; 0000 015D }
	RET
;
;void Screen320()  // Analog Values
; 0000 0160 {
_Screen320:
; 0000 0161     lcd_gotoxy(0,0);
	CALL SUBOPT_0x5
; 0000 0162     lcd_putsf("No functions          added yet");
	__POINTW1FN _0x0,333
	CALL SUBOPT_0x2F
; 0000 0163     delay_ms(1000);
	CALL SUBOPT_0x2E
; 0000 0164     Screen = 32;
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
_0x212000B:
	STS  _Screen,R30
	STS  _Screen+1,R31
; 0000 0165 }
	RET
;
;void Screen321()        // Digital Values
; 0000 0168 {
_Screen321:
; 0000 0169     int x = 0;
; 0000 016A     char disp_ch[3];
; 0000 016B     lcd_clear();
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
;	x -> R16,R17
;	disp_ch -> Y+2
	__GETWRN 16,17,0
	CALL SUBOPT_0x25
; 0000 016C     lcd_gotoxy(0,0);
; 0000 016D     lcd_putsf("Ch0:");
	__POINTW1FN _0x0,365
	CALL SUBOPT_0x2F
; 0000 016E     lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 016F     lcd_putsf("Ch1:");
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x28
; 0000 0170     lcd_gotoxy(0,2);
	CALL SUBOPT_0x4
; 0000 0171     lcd_putsf("Ch2:");
	__POINTW1FN _0x0,375
	CALL SUBOPT_0x2F
; 0000 0172     lcd_gotoxy(0,3);
	CALL SUBOPT_0x7
; 0000 0173     lcd_putsf("Ch3:");
	__POINTW1FN _0x0,380
	CALL SUBOPT_0x2F
; 0000 0174     lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	CALL SUBOPT_0xA
; 0000 0175     lcd_putsf("Ch4:");
	__POINTW1FN _0x0,385
	CALL SUBOPT_0x2F
; 0000 0176     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x35
; 0000 0177     lcd_putsf("Ch5:");
	__POINTW1FN _0x0,390
	CALL SUBOPT_0x2F
; 0000 0178     lcd_gotoxy(9,2);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x4
; 0000 0179     lcd_putsf("Ch6:");
	__POINTW1FN _0x0,395
	CALL SUBOPT_0x2F
; 0000 017A     lcd_gotoxy(9,3);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x31
; 0000 017B     lcd_putsf("Ch7:");
	__POINTW1FN _0x0,400
	CALL SUBOPT_0x2F
; 0000 017C 
; 0000 017D     while (PINE.1 != 0)
_0xAA:
	SBIS 0x1,1
	RJMP _0xAC
; 0000 017E     {
; 0000 017F         x = read_adc(0x00)/4;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x36
; 0000 0180         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x37
; 0000 0181         lcd_gotoxy(4,0);
	CALL SUBOPT_0xA
; 0000 0182         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 0183         x = read_adc(0x01)/4;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x36
; 0000 0184         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x37
; 0000 0185         lcd_gotoxy(4,1);
	CALL SUBOPT_0x35
; 0000 0186         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 0187         x = read_adc(0x02)/4;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x36
; 0000 0188         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x37
; 0000 0189         lcd_gotoxy(4,2);
	CALL SUBOPT_0x4
; 0000 018A         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 018B         x = read_adc(0x03)/4;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x36
; 0000 018C         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x37
; 0000 018D         lcd_gotoxy(4,3);
	CALL SUBOPT_0x31
; 0000 018E         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 018F         x = read_adc(0x04)/4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x36
; 0000 0190         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x39
; 0000 0191         lcd_gotoxy(13,0);
	CALL SUBOPT_0xA
; 0000 0192         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 0193         x = read_adc(0x05)/4;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x36
; 0000 0194         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x39
; 0000 0195         lcd_gotoxy(13,1);
	CALL SUBOPT_0x35
; 0000 0196         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 0197         x = read_adc(0x06)/4;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x36
; 0000 0198         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	CALL SUBOPT_0x39
; 0000 0199         lcd_gotoxy(13,2);
	CALL SUBOPT_0x4
; 0000 019A         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 019B         x = read_adc(0x07)/4;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x36
; 0000 019C         sprintf(disp_ch,"%03d",x);
	MOVW R30,R16
	CALL SUBOPT_0xB
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 019D         lcd_gotoxy(13,3);
	CALL SUBOPT_0xF
; 0000 019E         lcd_puts(disp_ch);
	CALL SUBOPT_0x38
; 0000 019F         delay_ms(1000);
	CALL SUBOPT_0x2E
; 0000 01A0     }
	RJMP _0xAA
_0xAC:
; 0000 01A1     Screen = 32;
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x1C
; 0000 01A2 }
	RJMP _0x212000A
;
;void Screen322()                            //Thermocouple Reading function
; 0000 01A5 {
_Screen322:
; 0000 01A6     char ThermVal[16];
; 0000 01A7     int x = ThermoReadC();
; 0000 01A8     while(Screen == 322)
	SBIW R28,16
	ST   -Y,R17
	ST   -Y,R16
;	ThermVal -> Y+2
;	x -> R16,R17
	RCALL _ThermoReadC
	MOVW R16,R30
_0xAD:
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x142)
	LDI  R30,HIGH(0x142)
	CPC  R27,R30
	BRNE _0xAF
; 0000 01A9     {
; 0000 01AA         lcd_clear();
	CALL SUBOPT_0x25
; 0000 01AB         lcd_gotoxy(0,0);
; 0000 01AC         sprintf(ThermVal,"Temp:%04d",x);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,405
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0xB
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 01AD         lcd_puts(ThermVal);
	CALL SUBOPT_0x38
; 0000 01AE        // delay_ms(1500);
; 0000 01AF        if (PINE.1 == 0)                                            //ESCAPE Pressed 4
	SBIC 0x1,1
	RJMP _0xB0
; 0000 01B0        {
; 0000 01B1         while(PINE.1 == 0);
_0xB1:
	SBIS 0x1,1
	RJMP _0xB1
; 0000 01B2         Screen = 32;
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x1C
; 0000 01B3         //flag = 1;
; 0000 01B4        }
; 0000 01B5     }
_0xB0:
	RJMP _0xAD
_0xAF:
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 
; 0000 01B9 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
;
;void Screen33()
; 0000 01BC {
_Screen33:
; 0000 01BD     lcd_clear();
	CALL SUBOPT_0x33
; 0000 01BE     Pointer_vert = 0;
; 0000 01BF     lcd_gotoxy(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x31
; 0000 01C0     lcd_putsf("PARAMETERS");
	__POINTW1FN _0x0,415
	CALL SUBOPT_0x2F
; 0000 01C1     lcd_gotoxy(1,0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
; 0000 01C2     lcd_putsf("Voltage (VOLTS)");
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x2F
; 0000 01C3     lcd_gotoxy(1,1);
	CALL SUBOPT_0x30
; 0000 01C4     lcd_putsf("Current (AMPS)");
	__POINTW1FN _0x0,442
	CALL SUBOPT_0x2F
; 0000 01C5 
; 0000 01C6     while(Screen == 33)
_0xB4:
	CALL SUBOPT_0x17
	SBIW R26,33
	BRNE _0xB6
; 0000 01C7     {
; 0000 01C8         input(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x32
; 0000 01C9 
; 0000 01CA     if (PINE.1 == 0)                                            //ESCAPE Pressed 4
	SBIC 0x1,1
	RJMP _0xB7
; 0000 01CB        {
; 0000 01CC         while(PINE.1 == 0);
_0xB8:
	SBIS 0x1,1
	RJMP _0xB8
; 0000 01CD         Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x1C
; 0000 01CE        }
; 0000 01CF     }
_0xB7:
	RJMP _0xB4
_0xB6:
; 0000 01D0    // Screen = 33;
; 0000 01D1 
; 0000 01D2 }
	RET
;
;void Screen330()      //SET VOLTAGE
; 0000 01D5 {
_Screen330:
; 0000 01D6     while(Screen == 330)
_0xBB:
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x14A)
	LDI  R30,HIGH(0x14A)
	CPC  R27,R30
	BRNE _0xBD
; 0000 01D7     {
; 0000 01D8     lcd_clear();
	CALL SUBOPT_0x25
; 0000 01D9     lcd_gotoxy(0,0);
; 0000 01DA     lcd_putsf("Set voltage:");
	__POINTW1FN _0x0,457
	CALL SUBOPT_0x2F
; 0000 01DB     show_volt();
	RCALL _show_volt
; 0000 01DC     while(flag != 11)
_0xBE:
	LDS  R26,_flag
	LDS  R27,_flag+1
	SBIW R26,11
	BREQ _0xC0
; 0000 01DD     {
; 0000 01DE         input_volt(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _input_volt
; 0000 01DF     }
	RJMP _0xBE
_0xC0:
; 0000 01E0     flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 01E1     }
	RJMP _0xBB
_0xBD:
; 0000 01E2 }
	RET
;void Screen331()     //SET CURRENT
; 0000 01E4 {
_Screen331:
; 0000 01E5     while (Screen == 331)
_0xC1:
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x14B)
	LDI  R30,HIGH(0x14B)
	CPC  R27,R30
	BRNE _0xC3
; 0000 01E6     {
; 0000 01E7     lcd_clear();
	CALL SUBOPT_0x25
; 0000 01E8     lcd_gotoxy(0,0);
; 0000 01E9     lcd_putsf("Set current:");
	__POINTW1FN _0x0,470
	CALL SUBOPT_0x2F
; 0000 01EA     show_current();
	RCALL _show_current
; 0000 01EB     while(flag != 11)
_0xC4:
	LDS  R26,_flag
	LDS  R27,_flag+1
	SBIW R26,11
	BREQ _0xC6
; 0000 01EC     {
; 0000 01ED         input_current(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _input_current
; 0000 01EE     }
	RJMP _0xC4
_0xC6:
; 0000 01EF     flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 01F0     }
	RJMP _0xC1
_0xC3:
; 0000 01F1 }
	RET
;
;void Screen_sel()
; 0000 01F4 {
_Screen_sel:
; 0000 01F5     switch(Screen)
	CALL SUBOPT_0x1B
; 0000 01F6     {
; 0000 01F7         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xCA
; 0000 01F8             Screen1();
	RCALL _Screen1
; 0000 01F9         break;
	RJMP _0xC9
; 0000 01FA         case 2:
_0xCA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCB
; 0000 01FB             Screen2();
	RCALL _Screen2
; 0000 01FC         break;
	RJMP _0xC9
; 0000 01FD         //case 30:
; 0000 01FE             //Screen30();
; 0000 01FF 
; 0000 0200 
; 0000 0201 
; 0000 0202         case 31:                            //Timer
_0xCB:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0203             Screen31();
	RCALL _Screen31
; 0000 0204         break;
	RJMP _0xC9
; 0000 0205         case 310:                           //Set date time.
_0xCC:
	CPI  R30,LOW(0x136)
	LDI  R26,HIGH(0x136)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0206             Screen310();
	RCALL _Screen310
; 0000 0207         break;
	RJMP _0xC9
; 0000 0208         case 311:                           //Alarm Mode
_0xCD:
	CPI  R30,LOW(0x137)
	LDI  R26,HIGH(0x137)
	CPC  R31,R26
	BRNE _0xCE
; 0000 0209             Screen311();
	RCALL _Screen311
; 0000 020A         break;
	RJMP _0xC9
; 0000 020B         case 312:                           //Countdown timer
_0xCE:
	CPI  R30,LOW(0x138)
	LDI  R26,HIGH(0x138)
	CPC  R31,R26
	BRNE _0xCF
; 0000 020C             Screen312();
	RCALL _Screen312
; 0000 020D         break;
	RJMP _0xC9
; 0000 020E 
; 0000 020F         case 32:
_0xCF:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xD0
; 0000 0210             Screen32();
	RCALL _Screen32
; 0000 0211         break;
	RJMP _0xC9
; 0000 0212         case 320:                           //Analog
_0xD0:
	CPI  R30,LOW(0x140)
	LDI  R26,HIGH(0x140)
	CPC  R31,R26
	BRNE _0xD1
; 0000 0213             Screen320();
	RCALL _Screen320
; 0000 0214         break;
	RJMP _0xC9
; 0000 0215         case 321:                           //Digital
_0xD1:
	CPI  R30,LOW(0x141)
	LDI  R26,HIGH(0x141)
	CPC  R31,R26
	BRNE _0xD2
; 0000 0216             Screen321();
	RCALL _Screen321
; 0000 0217         break;
	RJMP _0xC9
; 0000 0218         case 322:                           //Thermocouple
_0xD2:
	CPI  R30,LOW(0x142)
	LDI  R26,HIGH(0x142)
	CPC  R31,R26
	BRNE _0xD3
; 0000 0219             Screen322();
	RCALL _Screen322
; 0000 021A         break;
	RJMP _0xC9
; 0000 021B 
; 0000 021C         case 33:                           //Ports
_0xD3:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xD4
; 0000 021D             Screen33();
	RCALL _Screen33
; 0000 021E         break;
	RJMP _0xC9
; 0000 021F 
; 0000 0220         case 330:
_0xD4:
	CPI  R30,LOW(0x14A)
	LDI  R26,HIGH(0x14A)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0221             Screen330();                   //Set Voltage
	RCALL _Screen330
; 0000 0222         break;
	RJMP _0xC9
; 0000 0223         case 331:
_0xD5:
	CPI  R30,LOW(0x14B)
	LDI  R26,HIGH(0x14B)
	CPC  R31,R26
	BRNE _0xD7
; 0000 0224             Screen331();
	RCALL _Screen331
; 0000 0225         break;
	RJMP _0xC9
; 0000 0226         default:
_0xD7:
; 0000 0227             lcd_clear();
	CALL SUBOPT_0x25
; 0000 0228             lcd_gotoxy(0,0);
; 0000 0229             lcd_puts("Error.");
	__POINTW1MN _0xD8,0
	CALL SUBOPT_0x9
; 0000 022A             lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 022B             lcd_puts("Restarting in 5 seconds.");
	__POINTW1MN _0xD8,7
	CALL SUBOPT_0x9
; 0000 022C             delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x2A
; 0000 022D             Screen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x1C
; 0000 022E         break;
; 0000 022F     }
_0xC9:
; 0000 0230 }
	RET

	.DSEG
_0xD8:
	.BYTE 0x20
;
;void main(void)
; 0000 0233 {

	.CSEG
_main:
; 0000 0234 // Declare your local variables here
; 0000 0235 
; 0000 0236 // Input/Output Ports initialization
; 0000 0237 // Port A initialization
; 0000 0238 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0239 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 023A PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 023B DDRA=0x00;
	OUT  0x1A,R30
; 0000 023C 
; 0000 023D // Port B initialization
; 0000 023E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 023F // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
; 0000 0240 PORTB=0x00;
	OUT  0x18,R30
; 0000 0241 DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0242 
; 0000 0243 // Port C initialization
; 0000 0244 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0245 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0246 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0247 DDRC=0x00;
	OUT  0x14,R30
; 0000 0248 
; 0000 0249 // Port D initialization
; 0000 024A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 024B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 024C PORTD=0x00;
	OUT  0x12,R30
; 0000 024D DDRD=0x00;
	OUT  0x11,R30
; 0000 024E 
; 0000 024F // Port E initialization
; 0000 0250 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0251 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0252 PORTE=0x00;
	OUT  0x3,R30
; 0000 0253 DDRE=0x00;
	OUT  0x2,R30
; 0000 0254 
; 0000 0255 // Port F initialization
; 0000 0256 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0257 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0258 PORTF=0x00;
	STS  98,R30
; 0000 0259 DDRF=0x00;
	STS  97,R30
; 0000 025A 
; 0000 025B // Port G initialization
; 0000 025C // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 025D // State4=T State3=T State2=T State1=T State0=T
; 0000 025E PORTG=0x00;
	STS  101,R30
; 0000 025F DDRG=0x00;
	STS  100,R30
; 0000 0260 
; 0000 0261 // Timer/Counter 0 initialization
; 0000 0262 // Clock source: System Clock
; 0000 0263 // Clock value: Timer 0 Stopped
; 0000 0264 // Mode: Normal top=0xFF
; 0000 0265 // OC0 output: Disconnected
; 0000 0266 ASSR=0x00;
	OUT  0x30,R30
; 0000 0267 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0268 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0269 OCR0=0x00;
	OUT  0x31,R30
; 0000 026A 
; 0000 026B // Timer/Counter 1 initialization
; 0000 026C // Clock source: System Clock
; 0000 026D // Clock value: Timer1 Stopped
; 0000 026E // Mode: Normal top=0xFFFF
; 0000 026F // OC1A output: Discon.
; 0000 0270 // OC1B output: Discon.
; 0000 0271 // OC1C output: Discon.
; 0000 0272 // Noise Canceler: Off
; 0000 0273 // Input Capture on Falling Edge
; 0000 0274 // Timer1 Overflow Interrupt: On
; 0000 0275 // Input Capture Interrupt: Off
; 0000 0276 // Compare A Match Interrupt: Off
; 0000 0277 // Compare B Match Interrupt: Off
; 0000 0278 // Compare C Match Interrupt: Off
; 0000 0279 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 027A TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 027B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 027C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 027D ICR1H=0x00;
	OUT  0x27,R30
; 0000 027E ICR1L=0x00;
	OUT  0x26,R30
; 0000 027F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0280 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0281 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0282 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0283 OCR1CH=0x00;
	STS  121,R30
; 0000 0284 OCR1CL=0x00;
	STS  120,R30
; 0000 0285 
; 0000 0286 // Timer/Counter 2 initialization
; 0000 0287 // Clock source: System Clock
; 0000 0288 // Clock value: Timer2 Stopped
; 0000 0289 // Mode: Normal top=0xFF
; 0000 028A // OC2 output: Disconnected
; 0000 028B TCCR2=0x00;
	OUT  0x25,R30
; 0000 028C TCNT2=0x00;
	OUT  0x24,R30
; 0000 028D OCR2=0x00;
	OUT  0x23,R30
; 0000 028E 
; 0000 028F // Timer/Counter 3 initialization
; 0000 0290 // Clock source: System Clock
; 0000 0291 // Clock value: Timer3 Stopped
; 0000 0292 // Mode: Normal top=0xFFFF
; 0000 0293 // OC3A output: Discon.
; 0000 0294 // OC3B output: Discon.
; 0000 0295 // OC3C output: Discon.
; 0000 0296 // Noise Canceler: Off
; 0000 0297 // Input Capture on Falling Edge
; 0000 0298 // Timer3 Overflow Interrupt: Off
; 0000 0299 // Input Capture Interrupt: Off
; 0000 029A // Compare A Match Interrupt: Off
; 0000 029B // Compare B Match Interrupt: Off
; 0000 029C // Compare C Match Interrupt: Off
; 0000 029D TCCR3A=0x00;
	STS  139,R30
; 0000 029E TCCR3B=0x00;
	STS  138,R30
; 0000 029F TCNT3H=0x00;
	STS  137,R30
; 0000 02A0 TCNT3L=0x00;
	STS  136,R30
; 0000 02A1 ICR3H=0x00;
	STS  129,R30
; 0000 02A2 ICR3L=0x00;
	STS  128,R30
; 0000 02A3 OCR3AH=0x00;
	STS  135,R30
; 0000 02A4 OCR3AL=0x00;
	STS  134,R30
; 0000 02A5 OCR3BH=0x00;
	STS  133,R30
; 0000 02A6 OCR3BL=0x00;
	STS  132,R30
; 0000 02A7 OCR3CH=0x00;
	STS  131,R30
; 0000 02A8 OCR3CL=0x00;
	STS  130,R30
; 0000 02A9 
; 0000 02AA // External Interrupt(s) initialization
; 0000 02AB // INT0: Off
; 0000 02AC // INT1: Off
; 0000 02AD // INT2: Off
; 0000 02AE // INT3: Off
; 0000 02AF // INT4: On
; 0000 02B0 // INT4 Mode: Falling Edge
; 0000 02B1 // INT5: On
; 0000 02B2 // INT5 Mode: Falling Edge
; 0000 02B3 // INT6: On
; 0000 02B4 // INT6 Mode: Falling Edge
; 0000 02B5 // INT7: On
; 0000 02B6 // INT7 Mode: Falling Edge
; 0000 02B7 EICRA=0x00;
	STS  106,R30
; 0000 02B8 EICRB=0xAA;
	LDI  R30,LOW(170)
	OUT  0x3A,R30
; 0000 02B9 EIMSK=0xF0;
	LDI  R30,LOW(240)
	OUT  0x39,R30
; 0000 02BA EIFR=0xF0;
	OUT  0x38,R30
; 0000 02BB 
; 0000 02BC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02BD TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x37,R30
; 0000 02BE 
; 0000 02BF ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 02C0 
; 0000 02C1 // USART0 initialization
; 0000 02C2 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02C3 // USART0 Receiver: On
; 0000 02C4 // USART0 Transmitter: On
; 0000 02C5 // USART0 Mode: Asynchronous
; 0000 02C6 // USART0 Baud Rate: 9600
; 0000 02C7 UCSR0A=0x00;
	OUT  0xB,R30
; 0000 02C8 UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 02C9 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 02CA UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 02CB UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 02CC 
; 0000 02CD // USART1 initialization
; 0000 02CE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02CF // USART1 Receiver: On
; 0000 02D0 // USART1 Transmitter: On
; 0000 02D1 // USART1 Mode: Asynchronous
; 0000 02D2 // USART1 Baud Rate: 9600
; 0000 02D3 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 02D4 UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 02D5 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 02D6 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 02D7 UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 02D8 
; 0000 02D9 // Analog Comparator initialization
; 0000 02DA // Analog Comparator: Off
; 0000 02DB // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02DC ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02DD SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02DE 
; 0000 02DF // ADC initialization
; 0000 02E0 // ADC Clock frequency: 1000.000 kHz
; 0000 02E1 // ADC Voltage Reference: AREF pin
; 0000 02E2 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 02E3 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 02E4 
; 0000 02E5 // SPI initialization
; 0000 02E6 // SPI Type: Master
; 0000 02E7 // SPI Clock Rate: 4000.000 kHz
; 0000 02E8 // SPI Clock Phase: Cycle Start
; 0000 02E9 // SPI Clock Polarity: Low
; 0000 02EA // SPI Data Order: MSB First
; 0000 02EB SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 02EC SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 02ED 
; 0000 02EE // TWI initialization
; 0000 02EF // TWI disabled
; 0000 02F0 TWCR=0x00;
	STS  116,R30
; 0000 02F1 
; 0000 02F2 // I2C Bus initialization
; 0000 02F3 i2c_init();
	CALL _i2c_init
; 0000 02F4 
; 0000 02F5 // DS1307 Real Time Clock initialization
; 0000 02F6 // Square wave output on pin SQW/OUT: Off
; 0000 02F7 // SQW/OUT pin state: 0
; 0000 02F8 rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _rtc_init
; 0000 02F9 
; 0000 02FA 
; 0000 02FB // Alphanumeric LCD initialization
; 0000 02FC // Connections specified in the
; 0000 02FD // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 02FE // RS - PORTC Bit 0
; 0000 02FF // RD - PORTC Bit 1
; 0000 0300 // EN - PORTC Bit 2
; 0000 0301 // D4 - PORTC Bit 4
; 0000 0302 // D5 - PORTC Bit 5
; 0000 0303 // D6 - PORTC Bit 6
; 0000 0304 // D7 - PORTC Bit 7
; 0000 0305 // Characters/line: 16
; 0000 0306 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0307 
; 0000 0308 // Global enable interrupts
; 0000 0309 #asm("sei")
	sei
; 0000 030A 
; 0000 030B PORTE=0x0F;
	LDI  R30,LOW(15)
	OUT  0x3,R30
; 0000 030C DDRE=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 030D 
; 0000 030E password = 1234;
	LDI  R26,LOW(_password)
	LDI  R27,HIGH(_password)
	LDI  R30,LOW(1234)
	LDI  R31,HIGH(1234)
	CALL __EEPROMWRW
; 0000 030F 
; 0000 0310 
; 0000 0311 while(1)
_0xD9:
; 0000 0312 {
; 0000 0313     Screen_sel();
	RCALL _Screen_sel
; 0000 0314 }
	RJMP _0xD9
; 0000 0315 }
_0xDC:
	RJMP _0xDC
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
	CALL SUBOPT_0x16
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x16
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
_0x212000A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G100:
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
	BRNE PC+3
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x3A
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x3A
	RJMP _0x20000C9
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
	BREQ PC+3
	JMP _0x200001B
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
	CALL SUBOPT_0x3B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3C
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3D
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3D
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
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
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
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3E
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
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3A
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
	RJMP _0x20000CA
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
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x3C
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3C
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
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
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x3F
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120009
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x3F
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
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120009:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_ftrunc:
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
_floor:
	CALL SUBOPT_0x40
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x40
	RJMP _0x2120008
__floor1:
    brtc __floor0
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
_0x2120008:
	ADIW R28,4
	RET
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x42
	CALL __CPD02
	BRLT _0x204000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2120007
_0x204000C:
	CALL SUBOPT_0x43
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x44
	CALL SUBOPT_0x42
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x204000D
	CALL SUBOPT_0x45
	CALL __ADDF12
	CALL SUBOPT_0x44
	__SUBWRN 16,17,1
_0x204000D:
	CALL SUBOPT_0x43
	CALL SUBOPT_0x41
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x43
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x47
	CALL SUBOPT_0x42
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x48
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
_0x2120007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_exp:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x49
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x204000F
	CALL SUBOPT_0x4A
	RJMP _0x2120006
_0x204000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2040010
	__GETD1N 0x3F800000
	RJMP _0x2120006
_0x2040010:
	CALL SUBOPT_0x49
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040011
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120006
_0x2040011:
	CALL SUBOPT_0x49
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL __PUTPARD1
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x49
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x47
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x47
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x42
	CALL __MULF12
	CALL SUBOPT_0x44
	CALL SUBOPT_0x48
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x43
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x42
	CALL SUBOPT_0x48
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	ST   -Y,R17
	ST   -Y,R16
	CALL _ldexp
_0x2120006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	SBIW R28,4
	CALL SUBOPT_0x4B
	CALL __CPD10
	BRNE _0x2040012
	CALL SUBOPT_0x4A
	RJMP _0x2120005
_0x2040012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2040013
	CALL SUBOPT_0x4C
	CALL __CPD10
	BRNE _0x2040014
	__GETD1N 0x3F800000
	RJMP _0x2120005
_0x2040014:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4D
	RJMP _0x2120005
_0x2040013:
	CALL SUBOPT_0x4C
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x40
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x4C
	CALL __CPD12
	BREQ _0x2040015
	CALL SUBOPT_0x4A
	RJMP _0x2120005
_0x2040015:
	CALL SUBOPT_0x4B
	CALL __ANEGF1
	CALL SUBOPT_0x4D
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2040016
	CALL SUBOPT_0x4B
	RJMP _0x2120005
_0x2040016:
	CALL SUBOPT_0x4B
	CALL __ANEGF1
_0x2120005:
	ADIW R28,12
	RET

	.CSEG
_rtc_init:
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2060003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2060003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2060004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2060004:
	CALL SUBOPT_0x4E
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x50
	RJMP _0x2120003
_rtc_get_time:
	CALL SUBOPT_0x4E
	LDI  R30,LOW(0)
	CALL SUBOPT_0x51
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x52
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP _0x2120004
_rtc_set_time:
	CALL SUBOPT_0x4E
	LDI  R30,LOW(0)
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	CALL SUBOPT_0x4F
	CALL _bin2bcd
	ST   -Y,R30
	CALL SUBOPT_0x50
	RJMP _0x2120003
_rtc_get_date:
	CALL SUBOPT_0x4E
	LDI  R30,LOW(4)
	CALL SUBOPT_0x51
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x52
	LD   R26,Y
	LDD  R27,Y+1
_0x2120004:
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
_rtc_set_date:
	CALL SUBOPT_0x4E
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4F
	CALL _bin2bcd
	ST   -Y,R30
	CALL SUBOPT_0x54
	CALL SUBOPT_0x53
	CALL SUBOPT_0x50
	RJMP _0x2120003
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
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2080004
	SBI  0x15,4
	RJMP _0x2080005
_0x2080004:
	CBI  0x15,4
_0x2080005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2080006
	SBI  0x15,5
	RJMP _0x2080007
_0x2080006:
	CBI  0x15,5
_0x2080007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2080008
	SBI  0x15,6
	RJMP _0x2080009
_0x2080008:
	CBI  0x15,6
_0x2080009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x208000A
	SBI  0x15,7
	RJMP _0x208000B
_0x208000A:
	CBI  0x15,7
_0x208000B:
	__DELAY_USB 11
	SBI  0x15,2
	__DELAY_USB 27
	CBI  0x15,2
	__DELAY_USB 27
	RJMP _0x2120001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G104
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G104
	__DELAY_USW 200
	RJMP _0x2120001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G104)
	SBCI R31,HIGH(-__base_y_G104)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x55
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x55
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2080010
_0x2080011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2080013
	RJMP _0x2120001
_0x2080013:
_0x2080010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2120001
_lcd_puts:
	ST   -Y,R17
_0x2080014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2080016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2080014
_0x2080016:
	RJMP _0x2120002
_lcd_putsf:
	ST   -Y,R17
_0x2080017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2080019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2080017
_0x2080019:
_0x2120002:
	LDD  R17,Y+0
_0x2120003:
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
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
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x56
	CALL SUBOPT_0x56
	CALL SUBOPT_0x56
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G104
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2120001:
	ADIW R28,1
	RET
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
_strlen:
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
_strlenf:
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

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
_bin2bcd:
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret

	.ESEG
_password:
	.DW  0x51B

	.DSEG
_yy1:
	.BYTE 0x1
_yy2:
	.BYTE 0x1
_disptime1:
	.BYTE 0x10
_dispdate1:
	.BYTE 0x10
_Screen:
	.BYTE 0x2
_Pointer_horiz:
	.BYTE 0x2
_Pointer_vert:
	.BYTE 0x2
_Pt:
	.BYTE 0x2
_temp_pass:
	.BYTE 0x4
_voltage:
	.BYTE 0x4
_current:
	.BYTE 0x4
_flag:
	.BYTE 0x2
_disp_pass:
	.BYTE 0x4
_disp_volt:
	.BYTE 0x3
_disp_current:
	.BYTE 0x3
_rtc_setter:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,40
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDS  R30,_voltage
	LDS  R31,_voltage+1
	LDS  R22,_voltage+2
	LDS  R23,_voltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDS  R30,_current
	LDS  R31,_current+1
	LDS  R22,_current+2
	LDS  R23,_current+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x17:
	LDS  R26,_Screen
	LDS  R27,_Screen+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	STS  _Screen,R30
	STS  _Screen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	CALL __MODW21
	STS  _Pointer_vert,R30
	STS  _Pointer_vert+1,R31
	JMP  _pointer_display_vert

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDS  R30,_Screen
	LDS  R31,_Screen+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1C:
	STS  _Screen,R30
	STS  _Screen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x17
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1F:
	ST   -Y,R17
	ST   -Y,R16
	__GETD1N 0x41200000
	CALL __PUTPARD1
	LDS  R26,_Pointer_horiz
	LDS  R27,_Pointer_horiz+1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	SBIW R30,1
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	CALL _pow
	CALL __CFD1U
	MOVW R16,R30
	CALL _pointer_display_horiz
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDS  R26,_voltage
	LDS  R27,_voltage+1
	LDS  R24,_voltage+2
	LDS  R25,_voltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	__ADDD1N 1
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	STS  _voltage,R30
	STS  _voltage+1,R31
	STS  _voltage+2,R22
	STS  _voltage+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__GETD1N 0x3E8
	CALL __MODD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_Pointer_horiz
	LDS  R27,_Pointer_horiz+1
	CALL __MODW21
	STS  _Pointer_horiz,R30
	STS  _Pointer_horiz+1,R31
	JMP  _pointer_display_horiz

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x25:
	CALL _lcd_clear
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _flag,R30
	STS  _flag+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	__POINTW1FN _0x0,61
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x28:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	STS  _voltage,R30
	STS  _voltage+1,R30
	STS  _voltage+2,R30
	STS  _voltage+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDS  R26,_current
	LDS  R27,_current+1
	LDS  R24,_current+2
	LDS  R25,_current+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	STS  _current,R30
	STS  _current+1,R31
	STS  _current+2,R22
	STS  _current+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(0)
	STS  _Pointer_vert,R30
	STS  _Pointer_vert+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x2F:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x31:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _input

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	CALL _lcd_clear
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	CALL _rtc_get_date
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x36:
	ST   -Y,R30
	CALL _read_adc
	CALL __LSRW2
	MOVW R16,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x38:
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(13)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3A:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x42:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x43
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4D:
	CALL __PUTPARD1
	CALL _log
	__GETD2S 4
	CALL __MULF12
	CALL __PUTPARD1
	JMP  _exp

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	CALL _i2c_start
	LDI  R30,LOW(208)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x51:
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_start
	LDI  R30,LOW(209)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x52:
	ST   X,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	CALL _bcd2bin
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	ST   -Y,R30
	CALL _i2c_write
	LD   R30,Y
	ST   -Y,R30
	RCALL _bin2bcd
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	CALL _i2c_write
	LDD  R30,Y+1
	ST   -Y,R30
	RJMP _bin2bcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x55:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G104
	__DELAY_USW 400
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
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
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
	ld   r23,y+
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
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
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
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R26,Y+
	LD   R27,Y+
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
	LD   R26,Y+
	LD   R27,Y+
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

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
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

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
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
