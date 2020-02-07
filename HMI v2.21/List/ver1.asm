
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 8.000000 MHz
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
	.DEF _msg=R4
	.DEF _xmitMsg=R6
	.DEF _rec=R8
	.DEF _rdata=R10
	.DEF _comStart=R12

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

_0x0:
	.DB  0x3C,0x30,0x30,0x31,0x3E,0x0,0x3C,0x30
	.DB  0x30,0x32,0x3E,0x0,0x3C,0x30,0x30,0x33
	.DB  0x3E,0x0,0x3C,0x30,0x30,0x34,0x3E,0x0
	.DB  0x3C,0x30,0x30,0x35,0x3E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
;//#include <alcd.h>
;#include <ver1.h>
;
;flash char *msg;
;flash char *xmitMsg;
;flash char *rec;
;flash char *rdata;
;
;//char sdataA[20];    // Send data for SCI-A
;char rdataA[20]; // Received data for SCI-A
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
;    //    004-  faultDetect
;    //    005-
;    //    006-
;    //    007-
;    //    008-
;    //    009-
;    //    010-
;    //    011-  readVolt
;    //    012-  readAmp
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
;    int i =0;
;    for(i = 0;*(xmitMsg+i)!= '\0';i++)
	ST   -Y,R17
	ST   -Y,R16
;	*xmitMsg -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x4:
	CALL SUBOPT_0x0
	CPI  R30,0
	BREQ _0x5
;    {
;         putchar(xmitMsg[i]);
	CALL SUBOPT_0x0
	ST   -Y,R30
	RCALL _putchar
;
;    }
	__ADDWRN 16,17,1
	RJMP _0x4
_0x5:
;
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;void noOp()
;{
;
;}
;
;void mainOn()
;{
_mainOn:
;    //lcd_clear();
;    //lcd_putsf("Entering Soft-Start");
;    xmitMsg ="<001>";
	__POINTW1FN _0x0,0
	RJMP _0x20A0002
;    xmitString(xmitMsg);
;    //delay_ms(500);
;
;   // lcd_clear();
;
;
;}
;
;void mainOff()
;{
_mainOff:
;   // lcd_clear();
;    //lcd_putsf("Entering Soft-Stop");
;    xmitMsg = "<002>";
	__POINTW1FN _0x0,6
	RJMP _0x20A0002
;    xmitString(xmitMsg);
;    //delay_ms(500);
;   // lcd_clear();
;}
;
;void resetFault()
;{
_resetFault:
;    //lcd_putsf("Resetting Faults");
;    xmitMsg = "<003>";
	__POINTW1FN _0x0,12
_0x20A0002:
	MOVW R6,R30
;    xmitString(xmitMsg);
	ST   -Y,R7
	ST   -Y,R6
	RCALL _xmitString
;
;}
	RET
;
;void readVolt()
;{
;    xmitMsg = "<004>";
;    xmitString(xmitMsg);
;    //voltVal = recVolt();
;    //msg = sprintf("\nVoltage is: %d",voltVal);
;    //lcd_putsf(msg);
;
;}
;
;void readAmp()
;{
;    xmitMsg = "<005>";
;    xmitString(xmitMsg);
;    //ampVal = recAmp();
;    //msg = sprintf("\nCurrent is: %d",ampVal);
;    //lcd_putsf(msg);
;}
;
;
;//On receiving response from the TMS, further actions are taken by recFunc array
;void rxnoOp()
;{
;
;}
;
;
;void rxmainOn()
;{
_rxmainOn:
;    PORTC.3 = 0;
	CBI  0x15,3
;    //flash char*msg ="The System has turned on";
;     //PORTF &= ~0x40;
;    //putchar('r');
;    //xmitMsg = "on button pressed acknowledged by the dsp";
;    //xmitString(xmitMsg);
;   // lcd_putsf(msg);                            //function to display message on the lcd
;
;}
	RET
;
;void rxmainOff()
;{
_rxmainOff:
;
;    PORTC.3 = 1;
	SBI  0x15,3
;//    putchar('s');
;//    xmitMsg = "off button pressed acknowledged by the dsp";
;//    xmitString(xmitMsg);
;//    msg = "The System has turned off";
;    //lcd_putsf(msg);
;
;}
	RET
;
;void rxresetFault()
;{
;    //msg = "Faults have been reset";
;   // lcd_putsf(msg);
;
;}
;
;void rxfaultDetect(char *data)
;{
;    int i = 0,j,k=0;
;    int fault = 0, cpyFault;
;    int fltBit[8], tmpBit[8];
;    fault = data[2]-'0'+((data[1]-'0')*10)+((data[0]-'0')*100);
;	*data -> Y+42
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	fault -> Y+40
;	cpyFault -> Y+38
;	fltBit -> Y+22
;	tmpBit -> Y+6
;    cpyFault = fault;
;
;
;    // counter for binary array
;    while (cpyFault > 0) {
;
;        tmpBit[i] = cpyFault % 2;
;        cpyFault = cpyFault / 2;
;        i++;
;    }
;
;    for (j = i - 1; j >= 0; j--,k++){
;        fltBit[k] = tmpBit[j];
;    }
;    for (j=k;j<8;j++)
;    {
;        fltBit[j] = 0;
;    }
;
;    if(fltBit[0] == 1)PORTF != ~0x40;
;    if(fltBit[1] == 1);
;    if(fltBit[2] == 1)PORTF != ~0x80;
;    if(fltBit[3] == 1)  ;
;    if(fltBit[4] == 1)   ;
;    if(fltBit[5] == 1)    ;
;    if(fltBit[6] == 1)     ;
;    if(fltBit[7] == 1)      ;
;
;
;
;
;
;
;
;
;    if(fault!=0)
;    {
;        PORTD.3=0;
;    }
;
;
;}
;
;void rxreadVolt()
;{
;    int i = 0;
;    for(i = 0;i<4;i++)
;	i -> R16,R17
;    {
;
;    }
;
;    msg = rdata;
;    //lcd_putsf(msg);
;
;}
;
;void rxreadAmp()
;{
;    int i;flash char *tempRdata;
;    for(i=5;*(rec+i-1)!='\0';i++)
;	i -> R16,R17
;	*tempRdata -> R18,R19
;    {
;        tempRdata= (rec+i);
;        if(i==5)  rdata = tempRdata;
;        tempRdata++;
;    }
;    msg = rdata;
;    //lcd_putsf(msg);
;
;}
;
;
;void recOp() {
_recOp:
;
;
;    char data = getchar();
;
;    PORTF |= 0x80;
	ST   -Y,R17
;	data -> R17
	RCALL _getchar
	MOV  R17,R30
	LDS  R30,98
	ORI  R30,0x80
	STS  98,R30
;
;    if(data == '<') {
	CPI  R17,60
	BRNE _0x25
;        comStart = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
;        i = 0;
	CALL SUBOPT_0x1
;
;    }
;    else if(data == '>') {
	RJMP _0x26
_0x25:
	CPI  R17,62
	BRNE _0x27
;            *(rdataA+i) = data;
	CALL SUBOPT_0x2
;            comStart = 0;
	CLR  R12
	CLR  R13
;            i = 0;
	CALL SUBOPT_0x1
;            comDecode(rdataA);
	LDI  R30,LOW(_rdataA)
	LDI  R31,HIGH(_rdataA)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _comDecode
;    }
;    if (comStart == 1) {
_0x27:
_0x26:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x28
;            *(rdataA+i) = data;  // Read data
	CALL SUBOPT_0x2
;            i++;
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
;            if(i==9){i=0;}
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,9
	BRNE _0x29
	CALL SUBOPT_0x1
;    }
_0x29:
;}
_0x28:
	RJMP _0x20A0001
;
;
;void comDecode(char * rec)
;{
_comDecode:
;
;    char cmd[3] = {'0','0','0'};
;    char data[4] = {'0','0','0','0'};
;    int icmd = 0;
;    int idata = 0;
;    int i;
;
;    for(i = 1; i < 4; i++)
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
_0x2B:
	__CPWRN 20,21,4
	BRGE _0x2C
;    {
;       cmd[i-1] = rec[i];
	MOVW R30,R20
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x3
;    }
	__ADDWRN 20,21,1
	RJMP _0x2B
_0x2C:
;
;    for(i = 5; i < 9; i++)
	__GETWRN 20,21,5
_0x2E:
	__CPWRN 20,21,9
	BRGE _0x2F
;    {
;       data[i-5] = rec[i];
	MOVW R30,R20
	SBIW R30,5
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x3
;    }
	__ADDWRN 20,21,1
	RJMP _0x2E
_0x2F:
;
;
;    icmd = (cmd[2]-'0') + ((cmd[1] - '0')*10) + ((cmd[0]-'0')*100);
	LDD  R30,Y+12
	CALL SUBOPT_0x4
	MOVW R22,R30
	LDD  R30,Y+11
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	LDD  R30,Y+10
	CALL SUBOPT_0x4
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R16,R30
;    idata = (data[3]-'0') + ((data[2] - '0')*10) + ((data[1]-'0')*100) + ((data[0]-'0')*1000);
	LDD  R30,Y+9
	CALL SUBOPT_0x4
	MOVW R22,R30
	LDD  R30,Y+8
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	LDD  R30,Y+7
	CALL SUBOPT_0x4
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	LDD  R30,Y+6
	CALL SUBOPT_0x4
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R18,R30
;
;    if (icmd == 1) {  // <001>
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x30
;        rxmainOn();
	RCALL _rxmainOn
;    }
;    else if (icmd == 2) {
	RJMP _0x31
_0x30:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x32
;        rxmainOff();
	RCALL _rxmainOff
;    }
;    else if (icmd == 4 ) {
	RJMP _0x33
_0x32:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x34
;        if (idata != 0) {
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x35
;           PORTD.3 = 0;
	CBI  0x12,3
;           PORTC.3 = 1;
	SBI  0x15,3
;        }
;        else {
	RJMP _0x3A
_0x35:
;           PORTD.3 = 1;
	SBI  0x12,3
;        }
_0x3A:
;
;
;    }
;
;
;}
_0x34:
_0x33:
_0x31:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
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
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 64
;    char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;    unsigned char rx_wr_index0 = 0, rx_rd_index0 = 0;
;#else
;    unsigned int rx_wr_index0=0, rx_rd_index0 = 0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;    unsigned char rx_counter0 = 0;
;#else
;    unsigned int rx_counter0 = 0;
;#endif
;
;
;int on_pressed = 0;
;int off_pressed = 0;
;int data_received = 0;
;int reset_pressed = 0;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0048 {
_usart0_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0049     char status, data;
; 0000 004A     status = UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 004B     data = UDR0;
	IN   R16,12
; 0000 004C 
; 0000 004D     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))== 0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3D
; 0000 004E        rx_buffer0[rx_wr_index0++] = data;
	LDS  R30,_rx_wr_index0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index0,R30
	CALL SUBOPT_0x6
	ST   Z,R16
; 0000 004F     #if RX_BUFFER_SIZE0 == 256
; 0000 0050        // special case for receiver buffer size=256
; 0000 0051        if (++rx_counter0 == 0)
; 0000 0052             rx_buffer_overflow0 = 1;
; 0000 0053     #else
; 0000 0054        if (rx_wr_index0 == RX_BUFFER_SIZE0)
	LDS  R26,_rx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x3E
; 0000 0055             rx_wr_index0=0;
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 0056 
; 0000 0057        if (++rx_counter0 == RX_BUFFER_SIZE0){
_0x3E:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x40)
	BRNE _0x3F
; 0000 0058             rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 0059             rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 005A        }
; 0000 005B     #endif
; 0000 005C 
; 0000 005D     }
_0x3F:
; 0000 005E 
; 0000 005F     data_received = 1;
_0x3D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _data_received,R30
	STS  _data_received+1,R31
; 0000 0060 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x5C
;
;#ifndef _DEBUG_TERMINAL_IO_
;
;
;
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006A {
_getchar:
; 0000 006B     char data;
; 0000 006C 
; 0000 006D     while (rx_counter0 == 0);
	ST   -Y,R17
;	data -> R17
_0x40:
	LDS  R30,_rx_counter0
	CPI  R30,0
	BREQ _0x40
; 0000 006E 
; 0000 006F     data = rx_buffer0[rx_rd_index0++];
	LDS  R30,_rx_rd_index0
	SUBI R30,-LOW(1)
	STS  _rx_rd_index0,R30
	CALL SUBOPT_0x6
	LD   R17,Z
; 0000 0070 
; 0000 0071     #if RX_BUFFER_SIZE0 != 256
; 0000 0072         if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDS  R26,_rx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0x43
	LDI  R30,LOW(0)
	STS  _rx_rd_index0,R30
; 0000 0073     #endif
; 0000 0074     #asm("cli")
_0x43:
	cli
; 0000 0075         --rx_counter0;
	LDS  R30,_rx_counter0
	SUBI R30,LOW(1)
	STS  _rx_counter0,R30
; 0000 0076     #asm("sei")
	sei
; 0000 0077 
; 0000 0078     return data;
	MOV  R30,R17
_0x20A0001:
	LD   R17,Y+
	RET
; 0000 0079 }
;#pragma used-
;#endif
;
;
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 64
;    char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;    unsigned char tx_wr_index0 = 0, tx_rd_index0=0;
;#else
;    unsigned int tx_wr_index0 = 0, tx_rd_index0=0;
;#endif
;
;#if TX_BUFFER_SIZE0 < 256
;    unsigned char tx_counter0 = 0;
;#else
;    unsigned int tx_counter0 = 0;
;#endif
;
;
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0093 {
_usart0_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0094     if (tx_counter0) {
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x44
; 0000 0095        --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 0096        UDR0 = tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	CALL SUBOPT_0x7
	LD   R30,Z
	OUT  0xC,R30
; 0000 0097 
; 0000 0098     #if TX_BUFFER_SIZE0 != 256
; 0000 0099        if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0x45
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 009A     #endif
; 0000 009B 
; 0000 009C     }
_0x45:
; 0000 009D }
_0x44:
_0x5C:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
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
; 0000 00A8 {
_putchar:
; 0000 00A9     while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x46:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x46
; 0000 00AA     #asm("cli")
	cli
; 0000 00AB     if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x4A
	SBIC 0xB,5
	RJMP _0x49
_0x4A:
; 0000 00AC        {
; 0000 00AD        tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	CALL SUBOPT_0x7
	LD   R26,Y
	STD  Z+0,R26
; 0000 00AE     #if TX_BUFFER_SIZE0 != 256
; 0000 00AF        if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x4C
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00B0     #endif
; 0000 00B1        ++tx_counter0;
_0x4C:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00B2        }
; 0000 00B3     else
	RJMP _0x4D
_0x49:
; 0000 00B4        UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00B5     #asm("sei")
_0x4D:
	sei
; 0000 00B6 }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;
;
;short int on_button_state = 0x0000;
;short int off_button_state = 0x0000;
;short int reset_button_state = 0x0000;
;
;// Timer3 overflow interrupt service routine
;interrupt[TIM3_OVF] void timer3_ovf_isr(void) {
; 0000 00C1 interrupt[30] void timer3_ovf_isr(void) {
_timer3_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C2 
; 0000 00C3     // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF
; 0000 00C4 
; 0000 00C5     // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-software-debouncers
; 0000 00C6     // 16 bit shifts = approx 130msec debounce delay
; 0000 00C7     on_button_state = (0x8000 | !PINE.4) | (on_button_state << 1);
	LDI  R30,0
	SBIS 0x1,4
	LDI  R30,1
	CALL SUBOPT_0x8
	LDS  R30,_on_button_state
	LDS  R31,_on_button_state+1
	CALL SUBOPT_0x9
	STS  _on_button_state,R30
	STS  _on_button_state+1,R31
; 0000 00C8     if(on_button_state == 0xC000) {
	LDS  R26,_on_button_state
	LDS  R27,_on_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x4E
; 0000 00C9        //PORTC.3 = 0;
; 0000 00CA        //PORTF &= ~0x40;
; 0000 00CB        on_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R31
; 0000 00CC 
; 0000 00CD     }
; 0000 00CE 
; 0000 00CF     off_button_state = (0x8000 | !PINE.5) | (off_button_state << 1);
_0x4E:
	LDI  R30,0
	SBIS 0x1,5
	LDI  R30,1
	CALL SUBOPT_0x8
	LDS  R30,_off_button_state
	LDS  R31,_off_button_state+1
	CALL SUBOPT_0x9
	STS  _off_button_state,R30
	STS  _off_button_state+1,R31
; 0000 00D0     if(off_button_state == 0xC000 ) {
	LDS  R26,_off_button_state
	LDS  R27,_off_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x4F
; 0000 00D1       //PORTC.3 = 1;
; 0000 00D2        off_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _off_pressed,R30
	STS  _off_pressed+1,R31
; 0000 00D3 
; 0000 00D4     }
; 0000 00D5 
; 0000 00D6     reset_button_state = (0x8000 | !PINE.6) | (reset_button_state << 1);
_0x4F:
	LDI  R30,0
	SBIS 0x1,6
	LDI  R30,1
	CALL SUBOPT_0x8
	LDS  R30,_reset_button_state
	LDS  R31,_reset_button_state+1
	CALL SUBOPT_0x9
	STS  _reset_button_state,R30
	STS  _reset_button_state+1,R31
; 0000 00D7     if(reset_button_state == 0xC000) {
	LDS  R26,_reset_button_state
	LDS  R27,_reset_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x50
; 0000 00D8 
; 0000 00D9 
; 0000 00DA        PORTD.3 = 1;
	SBI  0x12,3
; 0000 00DB        reset_pressed = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _reset_pressed,R30
	STS  _reset_pressed+1,R31
; 0000 00DC 
; 0000 00DD     }
; 0000 00DE 
; 0000 00DF 
; 0000 00E0 }
_0x50:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;
;void main(void)
; 0000 00E4 {
_main:
; 0000 00E5 
; 0000 00E6 
; 0000 00E7     PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00E8     DDRA=0x00;
	OUT  0x1A,R30
; 0000 00E9 
; 0000 00EA 
; 0000 00EB     PORTB=0x00;
	OUT  0x18,R30
; 0000 00EC     DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 00ED 
; 0000 00EE 
; 0000 00EF     PORTC=0x08;
	LDI  R30,LOW(8)
	OUT  0x15,R30
; 0000 00F0     DDRC=0x08;
	OUT  0x14,R30
; 0000 00F1 
; 0000 00F2 
; 0000 00F3     PORTD=0xC8;
	LDI  R30,LOW(200)
	OUT  0x12,R30
; 0000 00F4     DDRD=0x08;
	LDI  R30,LOW(8)
	OUT  0x11,R30
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 
; 0000 00F8     PORTE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x3,R30
; 0000 00F9     DDRE=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00FA 
; 0000 00FB 
; 0000 00FC 
; 0000 00FD     PORTF=0xFF;
	LDI  R30,LOW(255)
	STS  98,R30
; 0000 00FE     DDRF=0xFF;
	STS  97,R30
; 0000 00FF 
; 0000 0100 
; 0000 0101     PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0102     DDRG=0x00;
	STS  100,R30
; 0000 0103 
; 0000 0104     TCCR3A=0x00;
	STS  139,R30
; 0000 0105     TCCR3B=0x09;
	LDI  R30,LOW(9)
	STS  138,R30
; 0000 0106     TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0107     TCNT3L=0x00;
	STS  136,R30
; 0000 0108     ICR3H=0x00;
	STS  129,R30
; 0000 0109     ICR3L=0x00;
	STS  128,R30
; 0000 010A     OCR3AH=0xFF;
	LDI  R30,LOW(255)
	STS  135,R30
; 0000 010B     OCR3AL=0xFF;
	STS  134,R30
; 0000 010C     OCR3BH=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 010D     OCR3BL=0x00;
	STS  132,R30
; 0000 010E     OCR3CH=0x00;
	STS  131,R30
; 0000 010F     OCR3CL=0x00;
	STS  130,R30
; 0000 0110 
; 0000 0111     //// External Interrupt(s) initialization
; 0000 0112     //EICRA=0x00;
; 0000 0113     //EICRB=0xAA;
; 0000 0114     //EIMSK=0xF0;
; 0000 0115     //EIFR=0xF0;
; 0000 0116 
; 0000 0117     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0118     TIMSK=0x00;
	OUT  0x37,R30
; 0000 0119     ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 011A 
; 0000 011B     // USART0 initialization
; 0000 011C //
; 0000 011D //    UCSR0A=0x00;
; 0000 011E //    UCSR0B=0x18;
; 0000 011F //    UCSR0C=0x06;
; 0000 0120 //    UBRR0H=0x00;
; 0000 0121 //    UBRR0L=0x67;
; 0000 0122 
; 0000 0123     // USART0 initialization
; 0000 0124     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0125     // USART0 Receiver: On
; 0000 0126     // USART0 Transmitter: On
; 0000 0127     // USART0 Mode: Asynchronous
; 0000 0128     // USART0 Baud Rate: 9600
; 0000 0129     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 012A     UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 012B     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 012C     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 012D     UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 012E 
; 0000 012F     PORTF &= ~0x80;
	LDS  R30,98
	ANDI R30,0x7F
	STS  98,R30
; 0000 0130     // Global enable interrupts
; 0000 0131     #asm("sei")
	sei
; 0000 0132 
; 0000 0133     while(1)
_0x53:
; 0000 0134     {
; 0000 0135            if(on_pressed == 1)
	LDS  R26,_on_pressed
	LDS  R27,_on_pressed+1
	SBIW R26,1
	BRNE _0x56
; 0000 0136             {
; 0000 0137 
; 0000 0138                 mainOn();
	RCALL _mainOn
; 0000 0139                 on_pressed = 0;
	LDI  R30,LOW(0)
	STS  _on_pressed,R30
	STS  _on_pressed+1,R30
; 0000 013A             }
; 0000 013B             else if(off_pressed == 1)
	RJMP _0x57
_0x56:
	LDS  R26,_off_pressed
	LDS  R27,_off_pressed+1
	SBIW R26,1
	BRNE _0x58
; 0000 013C             {
; 0000 013D                 mainOff();
	RCALL _mainOff
; 0000 013E                 off_pressed = 0;
	LDI  R30,LOW(0)
	STS  _off_pressed,R30
	STS  _off_pressed+1,R30
; 0000 013F 
; 0000 0140             }
; 0000 0141             if(data_received == 1)
_0x58:
_0x57:
	LDS  R26,_data_received
	LDS  R27,_data_received+1
	SBIW R26,1
	BRNE _0x59
; 0000 0142             {
; 0000 0143                 recOp();
	RCALL _recOp
; 0000 0144                 data_received = 0;
	LDI  R30,LOW(0)
	STS  _data_received,R30
	STS  _data_received+1,R30
; 0000 0145             }
; 0000 0146             if(reset_pressed == 1)
_0x59:
	LDS  R26,_reset_pressed
	LDS  R27,_reset_pressed+1
	SBIW R26,1
	BRNE _0x5A
; 0000 0147             {
; 0000 0148                 resetFault();
	RCALL _resetFault
; 0000 0149                 reset_pressed = 0;
	LDI  R30,LOW(0)
	STS  _reset_pressed,R30
	STS  _reset_pressed+1,R30
; 0000 014A             }
; 0000 014B         //Screen_sel();
; 0000 014C 
; 0000 014D     }
_0x5A:
	RJMP _0x53
; 0000 014E 
; 0000 014F }
_0x5B:
	RJMP _0x5B
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

	.CSEG

	.CSEG

	.DSEG
_rdataA:
	.BYTE 0x14
_i:
	.BYTE 0x2
_rx_buffer0:
	.BYTE 0x40
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_rx_counter0:
	.BYTE 0x1
_on_pressed:
	.BYTE 0x2
_off_pressed:
	.BYTE 0x2
_data_received:
	.BYTE 0x2
_reset_pressed:
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
_reset_button_state:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDS  R30,_i
	LDS  R31,_i+1
	SUBI R30,LOW(-_rdataA)
	SBCI R31,HIGH(-_rdataA)
	ST   Z,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R31,0
	SBIW R30,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R31,0
	ORI  R31,HIGH(0x8000)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LSL  R30
	ROL  R31
	OR   R30,R26
	OR   R31,R27
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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
