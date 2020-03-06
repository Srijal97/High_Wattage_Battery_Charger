
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
	.DEF _tx_wr_index0=R13
	.DEF _tx_rd_index0=R12

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
	JMP  0x00
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

_0x6:
	.DB  LOW(_noOp),HIGH(_noOp),LOW(_mainOn),HIGH(_mainOn),LOW(_mainOff),HIGH(_mainOff),LOW(_resetFault),HIGH(_resetFault)
	.DB  LOW(_readVolt),HIGH(_readVolt),LOW(_readAmp),HIGH(_readAmp)
_0xF:
	.DB  LOW(_rnoOp),HIGH(_rnoOp),LOW(_rmainOn),HIGH(_rmainOn),LOW(_rmainOff),HIGH(_rmainOff),LOW(_rresetFault),HIGH(_rresetFault)
	.DB  LOW(_rreadVolt),HIGH(_rreadVolt),LOW(_rreadAmp),HIGH(_rreadAmp)
_0x29:
	.DB  0x1
_0x2A:
	.DB  0x4D,0x61,0x63,0x68,0x69,0x6E,0x65,0x20
	.DB  0x3A,0x20,0x4F,0x46,0x46
_0xA8:
	.DB  0x0,0x0
_0x0:
	.DB  0x54,0x68,0x65,0x20,0x53,0x79,0x73,0x74
	.DB  0x65,0x6D,0x20,0x69,0x73,0x20,0x74,0x75
	.DB  0x72,0x6E,0x69,0x6E,0x67,0x20,0x6F,0x6E
	.DB  0x0,0x3C,0x30,0x30,0x31,0x3E,0x0,0x54
	.DB  0x68,0x65,0x20,0x53,0x79,0x73,0x74,0x65
	.DB  0x6D,0x20,0x69,0x73,0x20,0x74,0x75,0x72
	.DB  0x6E,0x69,0x6E,0x67,0x20,0x6F,0x66,0x66
	.DB  0x0,0x3C,0x30,0x30,0x32,0x3E,0x0,0x52
	.DB  0x65,0x73,0x65,0x74,0x74,0x69,0x6E,0x67
	.DB  0x20,0x46,0x61,0x75,0x6C,0x74,0x73,0x0
	.DB  0x3C,0x30,0x30,0x33,0x3E,0x0,0x3C,0x30
	.DB  0x30,0x34,0x3E,0x0,0x3C,0x30,0x30,0x35
	.DB  0x3E,0x0,0x54,0x68,0x65,0x20,0x53,0x79
	.DB  0x73,0x74,0x65,0x6D,0x20,0x68,0x61,0x73
	.DB  0x20,0x74,0x75,0x72,0x6E,0x65,0x64,0x20
	.DB  0x6F,0x6E,0x0,0x54,0x68,0x65,0x20,0x53
	.DB  0x79,0x73,0x74,0x65,0x6D,0x20,0x68,0x61
	.DB  0x73,0x20,0x74,0x75,0x72,0x6E,0x65,0x64
	.DB  0x20,0x6F,0x66,0x66,0x0,0x46,0x61,0x75
	.DB  0x6C,0x74,0x73,0x20,0x68,0x61,0x76,0x65
	.DB  0x20,0x62,0x65,0x65,0x6E,0x20,0x72,0x65
	.DB  0x73,0x65,0x74,0x0,0x20,0x0,0x5E,0x0
	.DB  0x25,0x30,0x33,0x64,0x0,0x25,0x30,0x32
	.DB  0x64,0x0,0x4D,0x61,0x69,0x6E,0x20,0x53
	.DB  0x63,0x72,0x65,0x65,0x6E,0x0,0x56,0x6F
	.DB  0x6C,0x74,0x61,0x67,0x65,0x20,0x73,0x65
	.DB  0x74,0x20,0x74,0x6F,0x3A,0x0,0x56,0x0
	.DB  0x53,0x65,0x74,0x20,0x76,0x61,0x6C,0x75
	.DB  0x65,0x20,0x73,0x68,0x6F,0x75,0x6C,0x64
	.DB  0x0,0x62,0x65,0x20,0x62,0x65,0x74,0x77
	.DB  0x65,0x65,0x6E,0x20,0x31,0x31,0x30,0x2D
	.DB  0x0,0x31,0x33,0x35,0x20,0x76,0x6F,0x6C
	.DB  0x74,0x73,0x0,0x43,0x75,0x72,0x72,0x65
	.DB  0x6E,0x74,0x20,0x73,0x65,0x74,0x20,0x74
	.DB  0x6F,0x3A,0x0,0x41,0x0,0x62,0x65,0x20
	.DB  0x62,0x65,0x74,0x77,0x65,0x65,0x6E,0x20
	.DB  0x31,0x30,0x2D,0x0,0x32,0x30,0x20,0x61
	.DB  0x6D,0x70,0x73,0x0,0x57,0x65,0x6C,0x63
	.DB  0x6F,0x6D,0x65,0x20,0x74,0x6F,0x20,0x48
	.DB  0x4D,0x49,0x0,0x53,0x65,0x74,0x20,0x50
	.DB  0x61,0x72,0x61,0x6D,0x65,0x74,0x65,0x72
	.DB  0x73,0x0,0x53,0x65,0x6E,0x73,0x6F,0x72
	.DB  0x20,0x56,0x61,0x6C,0x75,0x65,0x73,0x0
	.DB  0x50,0x41,0x52,0x41,0x4D,0x45,0x54,0x45
	.DB  0x52,0x53,0x0,0x56,0x6F,0x6C,0x74,0x61
	.DB  0x67,0x65,0x20,0x28,0x56,0x4F,0x4C,0x54
	.DB  0x53,0x29,0x0,0x43,0x75,0x72,0x72,0x65
	.DB  0x6E,0x74,0x20,0x28,0x41,0x4D,0x50,0x53
	.DB  0x29,0x0,0x53,0x65,0x74,0x20,0x76,0x6F
	.DB  0x6C,0x74,0x61,0x67,0x65,0x3A,0x0,0x53
	.DB  0x65,0x74,0x20,0x63,0x75,0x72,0x72,0x65
	.DB  0x6E,0x74,0x3A,0x0,0x53,0x45,0x4E,0x53
	.DB  0x4F,0x52,0x53,0x0,0x41,0x6E,0x61,0x6C
	.DB  0x6F,0x67,0x0,0x44,0x69,0x67,0x69,0x74
	.DB  0x61,0x6C,0x0,0x54,0x68,0x65,0x72,0x6D
	.DB  0x6F,0x63,0x6F,0x75,0x70,0x6C,0x65,0x0
	.DB  0x4E,0x6F,0x20,0x66,0x75,0x6E,0x63,0x74
	.DB  0x69,0x6F,0x6E,0x73,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x61,0x64
	.DB  0x64,0x65,0x64,0x20,0x79,0x65,0x74,0x0
	.DB  0x43,0x68,0x30,0x3A,0x0,0x43,0x68,0x31
	.DB  0x3A,0x0,0x43,0x68,0x32,0x3A,0x0,0x43
	.DB  0x68,0x33,0x3A,0x0,0x43,0x68,0x34,0x3A
	.DB  0x0,0x43,0x68,0x35,0x3A,0x0,0x43,0x68
	.DB  0x36,0x3A,0x0,0x43,0x68,0x37,0x3A,0x0
	.DB  0x45,0x72,0x72,0x6F,0x72,0x2E,0x0,0x52
	.DB  0x65,0x73,0x74,0x61,0x72,0x74,0x69,0x6E
	.DB  0x67,0x20,0x69,0x6E,0x20,0x35,0x20,0x73
	.DB  0x65,0x63,0x6F,0x6E,0x64,0x73,0x2E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  _recFunc_G000
	.DW  _0xF*2

	.DW  0x01
	.DW  _Screen
	.DW  _0x29*2

	.DW  0x10
	.DW  _0x55
	.DW  _0x0*2+198

	.DW  0x10
	.DW  _0x6E
	.DW  _0x0*2+259

	.DW  0x0F
	.DW  _0x76
	.DW  _0x0*2+300

	.DW  0x07
	.DW  _0x9B
	.DW  _0x0*2+520

	.DW  0x19
	.DW  _0x9B+7
	.DW  _0x0*2+527

	.DW  0x02
	.DW  0x0C
	.DW  _0xA8*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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
;#include <alcd.h>
;#include <ver1.h>
;flash char *msg;
;flash char *xmitMsg;
;flash char *rec;
;flash char *rdata;
;
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
;
;
;}
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x212000F
;
;void noOp()
;{
_noOp:
;
;}
	RET
;
;void mainOn()
;{
_mainOn:
;    lcd_clear();
	CALL _lcd_clear
;    lcd_putsf("The System is turning on");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
;    xmitMsg ="<001>";
	__POINTW1FN _0x0,25
	RJMP _0x2120011
;    xmitString(xmitMsg);
;    delay_ms(500);
;
;     lcd_clear();
;
;
;}
;
;void mainOff()
;{
_mainOff:
;    lcd_clear();
	CALL _lcd_clear
;    lcd_putsf("The System is turning off");
	__POINTW1FN _0x0,31
	CALL SUBOPT_0x1
;    xmitMsg = "<002>";
	__POINTW1FN _0x0,57
_0x2120011:
	MOVW R6,R30
;    xmitString(xmitMsg);
	ST   -Y,R7
	ST   -Y,R6
	RCALL _xmitString
;    delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x2
;    lcd_clear();
	CALL _lcd_clear
;}
	RET
;
;void resetFault()
;{
_resetFault:
;    lcd_putsf("Resetting Faults");
	__POINTW1FN _0x0,63
	CALL SUBOPT_0x1
;    xmitMsg = "<003>";
	__POINTW1FN _0x0,80
	RJMP _0x2120010
;    xmitString(xmitMsg);
;
;}
;
;void readVolt()
;{
_readVolt:
;    xmitMsg = "<004>";
	__POINTW1FN _0x0,86
	RJMP _0x2120010
;    xmitString(xmitMsg);
;    //voltVal = recVolt();
;    //msg = sprintf("\nVoltage is: %d",voltVal);
;    //lcd_putsf(msg);
;
;}
;
;void readAmp()
;{
_readAmp:
;    xmitMsg = "<005>";
	__POINTW1FN _0x0,92
_0x2120010:
	MOVW R6,R30
;    xmitString(xmitMsg);
	ST   -Y,R7
	ST   -Y,R6
	RCALL _xmitString
;    //ampVal = recAmp();
;    //msg = sprintf("\nCurrent is: %d",ampVal);
;    //lcd_putsf(msg);
;}
	RET
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
;
;}
	RET
;
;
;void rmainOn()
;{
_rmainOn:
;    flash char*msg ="The System has turned on";
;    lcd_putsf(msg);                            //function to display message on the lcd
	ST   -Y,R17
	ST   -Y,R16
;	*msg -> R16,R17
	ST   -Y,R17
	ST   -Y,R16
	CALL _lcd_putsf
;
;}
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void rmainOff()
;{
_rmainOff:
;    msg = "The System has turned off";
	__POINTW1FN _0x0,123
	MOVW R4,R30
;    lcd_putsf(msg);
	ST   -Y,R5
	ST   -Y,R4
	RJMP _0x212000C
;
;}
;
;void rresetFault()
;{
_rresetFault:
;    msg = "Faults have been reset";
	__POINTW1FN _0x0,149
	MOVW R4,R30
;    lcd_putsf(msg);
	ST   -Y,R5
	ST   -Y,R4
	RJMP _0x212000C
;
;}
;
;void rreadVolt()
;{
_rreadVolt:
;    int i;flash char *tempRdata;
;    for(i=5;*(rec+i-1)!='\0';i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	*tempRdata -> R18,R19
	__GETWRN 16,17,5
_0x8:
	CALL SUBOPT_0x3
	BREQ _0x9
;    {
;        tempRdata= (rec+i);
	CALL SUBOPT_0x4
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
	RJMP _0x212000E
;    lcd_putsf(msg);
;
;}
;
;void rreadAmp()
;{
_rreadAmp:
;    int i;flash char *tempRdata;
;    for(i=5;*(rec+i-1)!='\0';i++)
	CALL __SAVELOCR4
;	i -> R16,R17
;	*tempRdata -> R18,R19
	__GETWRN 16,17,5
_0xC:
	CALL SUBOPT_0x3
	BREQ _0xD
;    {
;        tempRdata= (rec+i);
	CALL SUBOPT_0x4
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
_0x212000E:
	MOVW R4,R10
;    lcd_putsf(msg);
	ST   -Y,R5
	ST   -Y,R4
	CALL _lcd_putsf
;
;}
	CALL __LOADLOCR4
_0x212000F:
	ADIW R28,4
	RET
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
;    char recArray[100];
;    char cmd[3]={'','',''};
;    int icmd = 0;
;    int i = 0;
;    //char tempRec[100];
;    do
;	recArray -> Y+7
;	cmd -> Y+4
;	icmd -> R16,R17
;	i -> R18,R19
;    {
;        recArray[i++] = getchar();
;
;    }while(recArray[i]!='\0');
;//    char *rec = "<001-anyData>";
;    for(i=1;i<4;i++)
;    {
;       cmd[i-1] = *(recArray+i);
;    }
;
;    icmd = cmd[2]-'0'+((cmd[1]-'0')*10)+((cmd[0]-'0')*100);
;    recFunc[icmd]();
;}
;
;
;
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
; 0000 001A 
; 0000 001B 
; 0000 001C }
	RETI
;
;// External Interrupt 5 service routine
;interrupt [EXT_INT5] void ext_int5_isr(void)
; 0000 0020 {
_ext_int5_isr:
; 0000 0021 // Place your code here
; 0000 0022 
; 0000 0023 }
	RETI
;
;// External Interrupt 6 service routine
;interrupt [EXT_INT6] void ext_int6_isr(void)
; 0000 0027 {
_ext_int6_isr:
; 0000 0028 // Place your code here
; 0000 0029 
; 0000 002A }
	RETI
;
;// External Interrupt 7 service routine
;interrupt [EXT_INT7] void ext_int7_isr(void)
; 0000 002E {
_ext_int7_isr:
; 0000 002F // Place your code here
; 0000 0030 
; 0000 0031 }
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
;/*
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar(void)
;{
;char status,data;
;while (1)
;      {
;      while (((status=UCSR0A) & RX_COMPLETE)==0);
;      data=UDR0;
;      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;         return data;
;      }
;}
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar(char c)
;{
;while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
;UDR0=c;
;}
;#pragma used-
;                 */
;// Standard Input/Output functions
;#include <stdio.h>
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
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
; 0000 008A {
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008B if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x16
; 0000 008C    {
; 0000 008D    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 008E    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 008F #if TX_BUFFER_SIZE0 != 256
; 0000 0090    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R12
	BRNE _0x17
	CLR  R12
; 0000 0091 #endif
; 0000 0092    }
_0x17:
; 0000 0093 }
_0x16:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 009C {
_putchar:
; 0000 009D while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x18:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x18
; 0000 009E #asm("cli")
	cli
; 0000 009F if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x1C
	SBIC 0xB,5
	RJMP _0x1B
_0x1C:
; 0000 00A0    {
; 0000 00A1    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00A2 #if TX_BUFFER_SIZE0 != 256
; 0000 00A3    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R13
	BRNE _0x1E
	CLR  R13
; 0000 00A4 #endif
; 0000 00A5    ++tx_counter0;
_0x1E:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00A6    }
; 0000 00A7 else
	RJMP _0x1F
_0x1B:
; 0000 00A8    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A9 #asm("sei")
_0x1F:
	sei
; 0000 00AA }
	RJMP _0x212000D
;#pragma used-
;#endif
;
;
;/*#define DATA_REGISTER_EMPTY (1<<UDRE0) //buffer change
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
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
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
;{
;char status,data;
;status=UCSR0A;
;data=UDR0;
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;   {
;   rx_buffer0[rx_wr_index0++]=data;
;#if RX_BUFFER_SIZE0 == 256
;   // special case for receiver buffer size=256
;   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
;#else
;   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
;   if (++rx_counter0 == RX_BUFFER_SIZE0)
;      {
;      rx_counter0=0;
;      rx_buffer_overflow0=1;
;      }
;#endif
; recOp();}
;}
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;char data;
;while (rx_counter0==0);
;data=rx_buffer0[rx_rd_index0++];
;#if RX_BUFFER_SIZE0 != 256
;if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
;#endif
;#asm("cli")
;--rx_counter0;
;#asm("sei")
;return data;
;}
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
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
;{
;if (tx_counter0)
;   {
;   --tx_counter0;
;   UDR0=tx_buffer0[tx_rd_index0++];
;#if TX_BUFFER_SIZE0 != 256
;   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
;#endif
;   }
;}
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
;{
;while (tx_counter0 == TX_BUFFER_SIZE0);
;#asm("cli")
;if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
;   {
;   tx_buffer0[tx_wr_index0++]=c;
;#if TX_BUFFER_SIZE0 != 256
;   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
;#endif
;   ++tx_counter0;
;   }
;else
;   UDR0=c;
;#asm("sei")
;}
;#pragma used-
;#endif
;
;*/
;short int on_button_state = 0x0000;
;short int off_button_state = 0x0000;
;
;
;// Timer3 overflow interrupt service routine
;interrupt[TIM3_OVF] void timer3_ovf_isr(void) {
; 0000 012D interrupt[30] void timer3_ovf_isr(void) {
_timer3_ovf_isr:
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
; 0000 012E 
; 0000 012F     // ISR called every 8.595 msec when TCCRB = 0x09, and OCR3A = 0xFFFF
; 0000 0130 
; 0000 0131     // switch debounce logic. refer: https://www.embedded.com/electronics-blogs/break-points/4024981/My-favorite-software-debouncers
; 0000 0132     // 16 bit shifts = approx 130msec debounce delay
; 0000 0133 on_button_state = (0x8000 | !PIND.7) | (on_button_state << 1);
	LDI  R30,0
	SBIS 0x10,7
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
; 0000 0134     if(on_button_state == 0xC000) {
	LDS  R26,_on_button_state
	LDS  R27,_on_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x20
; 0000 0135        PORTC.3 = 0;
	CBI  0x15,3
; 0000 0136        mainOn();
	RCALL _mainOn
; 0000 0137 
; 0000 0138     }
; 0000 0139 
; 0000 013A     off_button_state = (0x8000 | !PIND.6) | (off_button_state << 1);
_0x20:
	LDI  R30,0
	SBIS 0x10,6
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
; 0000 013B     if(off_button_state == 0xC000 ) {
	LDS  R26,_off_button_state
	LDS  R27,_off_button_state+1
	CPI  R26,LOW(0xC000)
	LDI  R30,HIGH(0xC000)
	CPC  R27,R30
	BRNE _0x23
; 0000 013C         PORTC.3 = 1;
	SBI  0x15,3
; 0000 013D         mainOff();
	RCALL _mainOff
; 0000 013E     }
; 0000 013F 
; 0000 0140 
; 0000 0141 }
_0x23:
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
;
;
;#define ADC_VREF_TYPE 0x00
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0147 {
_read_adc:
; 0000 0148 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0149 // Delay needed for the stabilization of the ADC input voltage
; 0000 014A delay_us(10);
	__DELAY_USB 27
; 0000 014B // Start the AD conversion
; 0000 014C ADCSRA|=0x40;
	SBI  0x6,6
; 0000 014D // Wait for the AD conversion to complete
; 0000 014E while ((ADCSRA & 0x10)==0);
_0x26:
	SBIS 0x6,4
	RJMP _0x26
; 0000 014F ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0150 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x212000D:
	ADIW R28,1
	RET
; 0000 0151 }
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
; 0000 015C {

	.CSEG
_pointer_display_horiz:
;    lcd_gotoxy(0,2);
	CALL SUBOPT_0x5
;    lcd_putsf(" ");
;    lcd_gotoxy(1,2);
	CALL SUBOPT_0x6
;    lcd_putsf(" ");
	CALL SUBOPT_0x7
;    lcd_gotoxy(2,2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x8
;    lcd_putsf(" ");
;    lcd_gotoxy(3,2);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x8
;    lcd_putsf(" ");
;    lcd_gotoxy(Pointer_horiz,2);                      //Pointer displays arrow at that position
	LDS  R30,_Pointer_horiz
	CALL SUBOPT_0x9
;    lcd_putsf("^");
	__POINTW1FN _0x0,174
	RJMP _0x212000B
;}
;
;void pointer_display_vert()                          //checks the cursor position.
;{
_pointer_display_vert:
;    lcd_gotoxy(0,0);
	CALL SUBOPT_0xA
;    lcd_putsf(" ");
	CALL SUBOPT_0x7
;    lcd_gotoxy(0,1);
	CALL SUBOPT_0xB
;    lcd_putsf(" ");
	CALL SUBOPT_0x7
;    lcd_gotoxy(0,2);
	CALL SUBOPT_0x5
;    lcd_putsf(" ");
;    lcd_gotoxy(0,3);
	CALL SUBOPT_0xC
;    lcd_putsf(" ");
	CALL SUBOPT_0x7
;    lcd_gotoxy(0,Pointer_vert);                      //Pointer displays arrow at that position
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,_Pointer_vert
	ST   -Y,R30
	CALL _lcd_gotoxy
;    lcd_putsf(">");
	__POINTW1FN _0x0,29
_0x212000B:
	ST   -Y,R31
	ST   -Y,R30
_0x212000C:
	CALL _lcd_putsf
;}
	RET
;
;
;
;void show_volt()
;{
_show_volt:
;    sprintf(disp_volt,"%03d",voltage);
	LDI  R30,LOW(_disp_volt)
	LDI  R31,HIGH(_disp_volt)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_volt);
	LDI  R30,LOW(_disp_volt)
	LDI  R31,HIGH(_disp_volt)
	RJMP _0x212000A
;}
;void show_current()
;{
_show_current:
;    sprintf(disp_current,"%02d",current);
	LDI  R30,LOW(_disp_current)
	LDI  R31,HIGH(_disp_current)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,181
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
;    lcd_gotoxy(0,1);
;    lcd_puts(disp_current);
	LDI  R30,LOW(_disp_current)
	LDI  R31,HIGH(_disp_current)
_0x212000A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;}
	RET
;
;//----Input and val change functions-----
;#include "Change.c"
;#include "Inputs.c"
;//#include <variables.h>
;
;
;
;void input(int next)                         //next recieves value no of options we will have in the next menu
; 0000 015F {
_input:
;    Pt = Pointer_vert;
;	next -> Y+0
	LDS  R30,_Pointer_vert
	LDS  R31,_Pointer_vert+1
	STS  _Pt,R30
	STS  _Pt+1,R31
;    pointer_display_vert();
	RCALL _pointer_display_vert
;    delay_ms(100);
	CALL SUBOPT_0x11
;    if (PINE.2 == 0)                                            //UP
	SBIC 0x1,2
	RJMP _0x2B
;       {
;        while(PINE.2 == 0);
_0x2C:
	SBIS 0x1,2
	RJMP _0x2C
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
	BRPL _0x2F
	LDS  R30,_Pt
	LDS  R31,_Pt+1
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x30
_0x2F:
	LDS  R30,_Pt
	LDS  R31,_Pt+1
_0x30:
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x12
;        pointer_display_vert();
;       }
;
;    if (PINE.3 == 0)                                            //DOWN
_0x2B:
	SBIC 0x1,3
	RJMP _0x32
;       {
;        while(PINE.3 == 0);
_0x33:
	SBIS 0x1,3
	RJMP _0x33
;        Pointer_vert++;
	LDI  R26,LOW(_Pointer_vert)
	LDI  R27,HIGH(_Pointer_vert)
	CALL SUBOPT_0x13
;        Pointer_vert = Pointer_vert % next;
	LD   R30,Y
	LDD  R31,Y+1
	LDS  R26,_Pointer_vert
	LDS  R27,_Pointer_vert+1
	CALL SUBOPT_0x12
;        pointer_display_vert();
;       }
;
;    if (PINE.0 == 0)                                            //ENTER
_0x32:
	SBIC 0x1,0
	RJMP _0x36
;       {
;        while(PINE.0 == 0);
_0x37:
	SBIS 0x1,0
	RJMP _0x37
;        if(Screen < 10)
	CALL SUBOPT_0x14
	SBIW R26,10
	BRGE _0x3A
;        {
;            Screen = ((Screen+1)*10) + Pointer_vert;
	CALL SUBOPT_0x15
	ADIW R30,1
	RJMP _0xA0
;        }
;        else
_0x3A:
;        {
;            Screen = ((Screen)*10) + Pointer_vert;
	CALL SUBOPT_0x15
_0xA0:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	LDS  R26,_Pointer_vert
	LDS  R27,_Pointer_vert+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x16
;        }
;
;
;       }
;
;    if (PINE.1 == 0)                                            //ESCAPE
_0x36:
	SBIC 0x1,1
	RJMP _0x3C
;       {
;        while(PINE.1 == 0);
_0x3D:
	SBIS 0x1,1
	RJMP _0x3D
;
;            if (Screen == 2)
	CALL SUBOPT_0x14
	SBIW R26,2
	BRNE _0x40
;            {
;              lcd_clear();
	CALL SUBOPT_0x17
;              lcd_gotoxy(0,0);
;              lcd_putsf("Main Screen");
	__POINTW1FN _0x0,186
	CALL SUBOPT_0x1
;              delay_ms(1000);
	CALL SUBOPT_0x18
;              main_screen_trigger = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _main_screen_trigger,R30
	STS  _main_screen_trigger+1,R31
;              Current_Screen = 0;
	LDI  R30,LOW(0)
	STS  _Current_Screen,R30
	STS  _Current_Screen+1,R30
;              set_flag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _set_flag,R30
	STS  _set_flag+1,R31
;              //Screen = 2;
;            }
;            else if(Screen > 100)
	RJMP _0x41
_0x40:
	CALL SUBOPT_0x19
	BRLT _0x42
;            {
;                Screen = Screen/10;
	CALL SUBOPT_0x1A
	RJMP _0xA1
;            }
;            else
_0x42:
;            {
;                Screen = (Screen/10)-1;
	CALL SUBOPT_0x1A
	SBIW R30,1
_0xA1:
	STS  _Screen,R30
	STS  _Screen+1,R31
;            }
_0x41:
;
;
;       }
;
;}
_0x3C:
	ADIW R28,2
	RET
;
;
;void input_volt(int next)
;{
_input_volt:
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
	CALL SUBOPT_0x1B
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP     1
	SBIC 0x1,2
	RJMP _0x44
;       {
;        while(PINE.2 == 0);
_0x45:
	SBIS 0x1,2
	RJMP _0x45
;        if(change == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x48
;        {voltage = voltage + (change);}
	MOVW R30,R16
	CALL SUBOPT_0x1C
	RJMP _0xA2
;        else
_0x48:
;        {voltage = voltage + 1 + (change);}
	CALL SUBOPT_0xE
	CALL SUBOPT_0x1D
_0xA2:
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x1E
;        voltage = voltage % 1000;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1E
;        show_volt();
	RCALL _show_volt
;        pointer_display_horiz();
	RCALL _pointer_display_horiz
;       }
;
;    if (PINE.3 == 0)                                            //Next   2
_0x44:
	SBIC 0x1,3
	RJMP _0x4A
;       {
;        while(PINE.3 == 0);
_0x4B:
	SBIS 0x1,3
	RJMP _0x4B
;        Pointer_horiz++;
	LDI  R26,LOW(_Pointer_horiz)
	LDI  R27,HIGH(_Pointer_horiz)
	CALL SUBOPT_0x13
;
;        Pointer_horiz = Pointer_horiz % next;
	CALL SUBOPT_0x20
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                             //ENTER 3
_0x4A:
	SBIC 0x1,0
	RJMP _0x4E
;        {
;         while(PINE.0 == 0);
_0x4F:
	SBIS 0x1,0
	RJMP _0x4F
;         if(110 <= voltage && voltage <= 135)
	CALL SUBOPT_0xE
	__CPD1N 0x6E
	BRLT _0x53
	CALL SUBOPT_0x1C
	__CPD2N 0x88
	BRLT _0x54
_0x53:
	RJMP _0x52
_0x54:
;         {
;            lcd_clear();
	CALL SUBOPT_0x17
;            lcd_gotoxy(0,0);
;            lcd_puts("Voltage set to:");
	__POINTW1MN _0x55,0
	CALL SUBOPT_0x21
;            lcd_gotoxy(4,1);
	CALL SUBOPT_0x22
;            lcd_putsf("V");
	__POINTW1FN _0x0,214
	CALL SUBOPT_0x1
;            show_volt();
	RCALL _show_volt
;            //Voltage = temp_volt;
;            flag = 11;
	CALL SUBOPT_0x23
;            Screen = 30;
	CALL SUBOPT_0x24
;            delay_ms(2000);
	RJMP _0xA3
;         }
;         else
_0x52:
;         {
;            lcd_clear();
	CALL SUBOPT_0x17
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
	__POINTW1FN _0x0,216
	CALL SUBOPT_0x1
;            lcd_gotoxy(0,1);
	CALL SUBOPT_0xB
;            lcd_putsf("be between 110-");
	__POINTW1FN _0x0,233
	CALL SUBOPT_0x1
;            lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
;            lcd_putsf("135 volts");
	__POINTW1FN _0x0,249
	CALL SUBOPT_0x1
;            voltage = 000;
	LDI  R30,LOW(0)
	STS  _voltage,R30
	STS  _voltage+1,R30
	STS  _voltage+2,R30
	STS  _voltage+3,R30
;            Screen = 30;
	CALL SUBOPT_0x24
;            flag = 11;
	CALL SUBOPT_0x23
;            delay_ms(2000);
_0xA3:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
;         }
;        }
;
;    if (PINE.1 == 0)                                            //ESCAPE 4
_0x4E:
	SBIC 0x1,1
	RJMP _0x57
;       {
;        while(PINE.1 == 0);
_0x58:
	SBIS 0x1,1
	RJMP _0x58
;        flag = 11;
	CALL SUBOPT_0x23
;        if(Screen > 100)
	CALL SUBOPT_0x19
	BRLT _0x5B
;        {Screen = Screen/10;}
	CALL SUBOPT_0x1A
	RJMP _0xA4
;        else
_0x5B:
;        {Screen = (Screen/10)-1;}
	CALL SUBOPT_0x1A
	SBIW R30,1
_0xA4:
	STS  _Screen,R30
	STS  _Screen+1,R31
;        //flag = 1;
;       }
;}
_0x57:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120006

	.DSEG
_0x55:
	.BYTE 0x10
;
;void input_current(int next)
;{

	.CSEG
_input_current:
;    int change = pow(10,(next-Pointer_horiz-1));
;    pointer_display_horiz();
	CALL SUBOPT_0x1B
;	next -> Y+2
;	change -> R16,R17
;    delay_ms(100);
;    if (PINE.2 == 0)                                            //UP     1
	SBIC 0x1,2
	RJMP _0x5D
;       {
;        while(PINE.2 == 0);
_0x5E:
	SBIS 0x1,2
	RJMP _0x5E
;        if(change == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x61
;        {current = current + (change);}
	MOVW R30,R16
	CALL SUBOPT_0x25
	RJMP _0xA5
;        else
_0x61:
;        {current = current + 1 + (change);}
	CALL SUBOPT_0x10
	CALL SUBOPT_0x1D
_0xA5:
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x26
;        current = current % 1000;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x26
;        show_current();
	RCALL _show_current
;        pointer_display_horiz();
	RCALL _pointer_display_horiz
;       }
;
;    if (PINE.3 == 0)                                            //Next   2
_0x5D:
	SBIC 0x1,3
	RJMP _0x63
;       {
;        while(PINE.3 == 0);
_0x64:
	SBIS 0x1,3
	RJMP _0x64
;        Pointer_horiz++;
	LDI  R26,LOW(_Pointer_horiz)
	LDI  R27,HIGH(_Pointer_horiz)
	CALL SUBOPT_0x13
;
;        Pointer_horiz = Pointer_horiz % next;
	CALL SUBOPT_0x20
;        pointer_display_horiz();
;       }
;
;    if (PINE.0 == 0)                                             //ENTER 3
_0x63:
	SBIC 0x1,0
	RJMP _0x67
;        {
;         while(PINE.0 == 0);
_0x68:
	SBIS 0x1,0
	RJMP _0x68
;         if(10 <= current && current <= 20)
	CALL SUBOPT_0x10
	__CPD1N 0xA
	BRLT _0x6C
	CALL SUBOPT_0x25
	__CPD2N 0x15
	BRLT _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
;         {
;            lcd_clear();
	CALL SUBOPT_0x17
;            lcd_gotoxy(0,0);
;            lcd_puts("Current set to:");
	__POINTW1MN _0x6E,0
	CALL SUBOPT_0x21
;            lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x27
;            lcd_putsf("A");
	__POINTW1FN _0x0,275
	CALL SUBOPT_0x1
;            show_current();
	RCALL _show_current
;            flag = 11;
	CALL SUBOPT_0x23
;            Screen = 30;
	CALL SUBOPT_0x24
;            delay_ms(2000);
	RJMP _0xA6
;         }
;         else
_0x6B:
;         {
;            lcd_clear();
	CALL SUBOPT_0x17
;            lcd_gotoxy(0,0);
;            lcd_putsf("Set value should");
	__POINTW1FN _0x0,216
	CALL SUBOPT_0x1
;            lcd_gotoxy(0,1);
	CALL SUBOPT_0xB
;            lcd_putsf("be between 10-");
	__POINTW1FN _0x0,277
	CALL SUBOPT_0x1
;            lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
;            lcd_putsf("20 amps");
	__POINTW1FN _0x0,292
	CALL SUBOPT_0x1
;            current = 000;
	LDI  R30,LOW(0)
	STS  _current,R30
	STS  _current+1,R30
	STS  _current+2,R30
	STS  _current+3,R30
;            Screen = 30;
	CALL SUBOPT_0x24
;            flag = 11;
	CALL SUBOPT_0x23
;            delay_ms(2000);
_0xA6:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
;         }
;        }
;
;    if (PINE.1 == 0)                                            //ESCAPE 4
_0x67:
	SBIC 0x1,1
	RJMP _0x70
;       {
;        while(PINE.1 == 0);
_0x71:
	SBIS 0x1,1
	RJMP _0x71
;        flag = 11;
	CALL SUBOPT_0x23
;        if(Screen > 100)
	CALL SUBOPT_0x19
	BRLT _0x74
;        {Screen = Screen/10;}
	CALL SUBOPT_0x1A
	RJMP _0xA7
;        else
_0x74:
;        {Screen = (Screen/10)-1;}
	CALL SUBOPT_0x1A
	SBIW R30,1
_0xA7:
	STS  _Screen,R30
	STS  _Screen+1,R31
;        //flag = 1;
;       }
;
;
;}
_0x70:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120006

	.DSEG
_0x6E:
	.BYTE 0x10
;
;
;
;
;void Screen1()
; 0000 0165 {

	.CSEG
_Screen1:
; 0000 0166     Screen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x16
; 0000 0167     Pointer_horiz = 0;
	LDI  R30,LOW(0)
	STS  _Pointer_horiz,R30
	STS  _Pointer_horiz+1,R30
; 0000 0168     Pointer_vert = 0;
	CALL SUBOPT_0x28
; 0000 0169     lcd_clear();
	CALL SUBOPT_0x17
; 0000 016A     lcd_gotoxy(0,0);
; 0000 016B     lcd_puts("Welcome to HMI");
	__POINTW1MN _0x76,0
	CALL SUBOPT_0x21
; 0000 016C 
; 0000 016D     delay_ms(1000);
	CALL SUBOPT_0x18
; 0000 016E 
; 0000 016F     Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x2120009
; 0000 0170 }

	.DSEG
_0x76:
	.BYTE 0xF
;
;void Screen2()
; 0000 0173 {

	.CSEG
_Screen2:
; 0000 0174     lcd_clear();
	CALL _lcd_clear
; 0000 0175 
; 0000 0176     Screen = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x16
; 0000 0177     Pointer_vert = 0;
	CALL SUBOPT_0x28
; 0000 0178     Pointer_horiz= 0;
	LDI  R30,LOW(0)
	STS  _Pointer_horiz,R30
	STS  _Pointer_horiz+1,R30
; 0000 0179     while(Screen == 2)
_0x77:
	CALL SUBOPT_0x14
	SBIW R26,2
	BRNE _0x79
; 0000 017A     {
; 0000 017B 
; 0000 017C 
; 0000 017D         lcd_gotoxy(1,0);
	CALL SUBOPT_0x29
; 0000 017E         lcd_putsf("Set Parameters");
	__POINTW1FN _0x0,315
	CALL SUBOPT_0x1
; 0000 017F         lcd_gotoxy(1,1) ;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 0180         lcd_putsf("Sensor Values");
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x1
; 0000 0181 
; 0000 0182         input(2);
	CALL SUBOPT_0x2A
; 0000 0183     }
	RJMP _0x77
_0x79:
; 0000 0184 
; 0000 0185 }
	RET
;
;
;
;void Screen30()
; 0000 018A {
_Screen30:
; 0000 018B     lcd_clear();
	CALL _lcd_clear
; 0000 018C     while(Screen == 30)
_0x7A:
	CALL SUBOPT_0x14
	SBIW R26,30
	BRNE _0x7C
; 0000 018D     {
; 0000 018E     lcd_gotoxy(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2B
; 0000 018F     lcd_putsf("PARAMETERS");
	__POINTW1FN _0x0,344
	CALL SUBOPT_0x1
; 0000 0190     lcd_gotoxy(1,0);
	CALL SUBOPT_0x29
; 0000 0191     lcd_putsf("Voltage (VOLTS)");
	__POINTW1FN _0x0,355
	CALL SUBOPT_0x1
; 0000 0192     lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 0193     lcd_putsf("Current (AMPS)");
	__POINTW1FN _0x0,371
	CALL SUBOPT_0x1
; 0000 0194 
; 0000 0195         input(2);
	CALL SUBOPT_0x2A
; 0000 0196 
; 0000 0197     /*if (PINE.1 == 0)                                            //ESCAPE Pressed 4
; 0000 0198        {
; 0000 0199         while(PINE.1 == 0);
; 0000 019A         Screen = 2;
; 0000 019B        }*/
; 0000 019C     }
	RJMP _0x7A
_0x7C:
; 0000 019D 
; 0000 019E 
; 0000 019F }
	RET
;
;void Screen300()      //SET VOLTAGE
; 0000 01A2 {
_Screen300:
; 0000 01A3     while(Screen == 300)
_0x7D:
	CALL SUBOPT_0x14
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRNE _0x7F
; 0000 01A4     {
; 0000 01A5     lcd_clear();
	CALL SUBOPT_0x17
; 0000 01A6     lcd_gotoxy(0,0);
; 0000 01A7     lcd_putsf("Set voltage:");
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x1
; 0000 01A8     show_volt();
	RCALL _show_volt
; 0000 01A9     while(flag != 11)
_0x80:
	LDS  R26,_flag
	LDS  R27,_flag+1
	SBIW R26,11
	BREQ _0x82
; 0000 01AA     {
; 0000 01AB         input_volt(3);
	CALL SUBOPT_0x2C
	RCALL _input_volt
; 0000 01AC     }
	RJMP _0x80
_0x82:
; 0000 01AD     flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 01AE     }
	RJMP _0x7D
_0x7F:
; 0000 01AF }
	RET
;void Screen301()     //SET CURRENT
; 0000 01B1 {
_Screen301:
; 0000 01B2     while (Screen == 301)
_0x83:
	CALL SUBOPT_0x14
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRNE _0x85
; 0000 01B3     {
; 0000 01B4     lcd_clear();
	CALL SUBOPT_0x17
; 0000 01B5     lcd_gotoxy(0,0);
; 0000 01B6     lcd_putsf("Set current:");
	__POINTW1FN _0x0,399
	CALL SUBOPT_0x1
; 0000 01B7     show_current();
	RCALL _show_current
; 0000 01B8     while(flag != 11)
_0x86:
	LDS  R26,_flag
	LDS  R27,_flag+1
	SBIW R26,11
	BREQ _0x88
; 0000 01B9     {
; 0000 01BA         input_current(3);
	CALL SUBOPT_0x2C
	RCALL _input_current
; 0000 01BB     }
	RJMP _0x86
_0x88:
; 0000 01BC     flag = 0;
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0000 01BD     }
	RJMP _0x83
_0x85:
; 0000 01BE }
	RET
;
;
;void Screen31()
; 0000 01C2 {
_Screen31:
; 0000 01C3     lcd_clear();
	CALL _lcd_clear
; 0000 01C4     Pointer_vert = 0;
	CALL SUBOPT_0x28
; 0000 01C5     while(Screen == 31)
_0x89:
	CALL SUBOPT_0x14
	SBIW R26,31
	BRNE _0x8B
; 0000 01C6     {
; 0000 01C7     lcd_gotoxy(4,3);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2B
; 0000 01C8     lcd_putsf("SENSORS");
	__POINTW1FN _0x0,412
	CALL SUBOPT_0x1
; 0000 01C9     lcd_gotoxy(1,0);
	CALL SUBOPT_0x29
; 0000 01CA     lcd_putsf("Analog");
	__POINTW1FN _0x0,420
	CALL SUBOPT_0x1
; 0000 01CB     lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 01CC     lcd_putsf("Digital");
	__POINTW1FN _0x0,427
	CALL SUBOPT_0x1
; 0000 01CD     lcd_gotoxy(1,2);
	CALL SUBOPT_0x6
; 0000 01CE     lcd_putsf("Thermocouple");
	__POINTW1FN _0x0,435
	CALL SUBOPT_0x1
; 0000 01CF 
; 0000 01D0         input(3);
	CALL SUBOPT_0x2C
	RCALL _input
; 0000 01D1     }
	RJMP _0x89
_0x8B:
; 0000 01D2 }
	RET
;
;void Screen310()  // Analog Values
; 0000 01D5 {
_Screen310:
; 0000 01D6     lcd_gotoxy(0,0);
	CALL SUBOPT_0xA
; 0000 01D7     lcd_putsf("No functions          added yet");
	__POINTW1FN _0x0,448
	CALL SUBOPT_0x1
; 0000 01D8     delay_ms(1000);
	CALL SUBOPT_0x18
; 0000 01D9     Screen = 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
_0x2120009:
	STS  _Screen,R30
	STS  _Screen+1,R31
; 0000 01DA }
	RET
;
;void Screen311()        // Digital Values
; 0000 01DD {
_Screen311:
; 0000 01DE     int x = 0;
; 0000 01DF     char disp_ch[3];
; 0000 01E0     lcd_clear();
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
;	x -> R16,R17
;	disp_ch -> Y+2
	__GETWRN 16,17,0
	CALL SUBOPT_0x17
; 0000 01E1     lcd_gotoxy(0,0);
; 0000 01E2     lcd_putsf("Ch0:");
	__POINTW1FN _0x0,480
	CALL SUBOPT_0x1
; 0000 01E3     lcd_gotoxy(0,1);
	CALL SUBOPT_0xB
; 0000 01E4     lcd_putsf("Ch1:");
	__POINTW1FN _0x0,485
	CALL SUBOPT_0x1
; 0000 01E5     lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
; 0000 01E6     lcd_putsf("Ch2:");
	__POINTW1FN _0x0,490
	CALL SUBOPT_0x1
; 0000 01E7     lcd_gotoxy(0,3);
	CALL SUBOPT_0xC
; 0000 01E8     lcd_putsf("Ch3:");
	__POINTW1FN _0x0,495
	CALL SUBOPT_0x1
; 0000 01E9     lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2D
; 0000 01EA     lcd_putsf("Ch4:");
	__POINTW1FN _0x0,500
	CALL SUBOPT_0x1
; 0000 01EB     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x27
; 0000 01EC     lcd_putsf("Ch5:");
	__POINTW1FN _0x0,505
	CALL SUBOPT_0x1
; 0000 01ED     lcd_gotoxy(9,2);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x9
; 0000 01EE     lcd_putsf("Ch6:");
	__POINTW1FN _0x0,510
	CALL SUBOPT_0x1
; 0000 01EF     lcd_gotoxy(9,3);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x2B
; 0000 01F0     lcd_putsf("Ch7:");
	__POINTW1FN _0x0,515
	CALL SUBOPT_0x1
; 0000 01F1 
; 0000 01F2     while (PINE.1 != 0)
_0x8C:
	SBIS 0x1,1
	RJMP _0x8E
; 0000 01F3     {
; 0000 01F4         x = read_adc(0x00)/4;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2E
; 0000 01F5         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 01F6         lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2D
; 0000 01F7         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 01F8         x = read_adc(0x01)/4;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2E
; 0000 01F9         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 01FA         lcd_gotoxy(4,1);
	CALL SUBOPT_0x22
; 0000 01FB         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 01FC         x = read_adc(0x02)/4;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2E
; 0000 01FD         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 01FE         lcd_gotoxy(4,2);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x9
; 0000 01FF         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 0200         x = read_adc(0x03)/4;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2E
; 0000 0201         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 0202         lcd_gotoxy(4,3);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2B
; 0000 0203         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 0204         x = read_adc(0x04)/4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2E
; 0000 0205         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 0206         lcd_gotoxy(13,0);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x2D
; 0000 0207         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 0208         x = read_adc(0x05)/4;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2E
; 0000 0209         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 020A         lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x27
; 0000 020B         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 020C         x = read_adc(0x06)/4;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2E
; 0000 020D         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 020E         lcd_gotoxy(13,2);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x9
; 0000 020F         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 0210         x = read_adc(0x07)/4;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x2E
; 0000 0211         sprintf(disp_ch,"%03d",x);
	CALL SUBOPT_0x2F
; 0000 0212         lcd_gotoxy(13,3);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x2B
; 0000 0213         lcd_puts(disp_ch);
	CALL SUBOPT_0x30
; 0000 0214         delay_ms(1000);
	CALL SUBOPT_0x18
; 0000 0215     }
	RJMP _0x8C
_0x8E:
; 0000 0216     Screen = 31;
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	CALL SUBOPT_0x16
; 0000 0217 }
	RJMP _0x2120008
;
;
;void Screen_sel()
; 0000 021B {
_Screen_sel:
; 0000 021C     switch(Screen)
	CALL SUBOPT_0x15
; 0000 021D     {
; 0000 021E         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x92
; 0000 021F             Screen1();
	RCALL _Screen1
; 0000 0220         break;
	RJMP _0x91
; 0000 0221         case 2:
_0x92:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x93
; 0000 0222             Screen2();
	RCALL _Screen2
; 0000 0223         break;
	RJMP _0x91
; 0000 0224 
; 0000 0225         case 30:                           //Ports
_0x93:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0x94
; 0000 0226             Screen30();
	RCALL _Screen30
; 0000 0227         break;
	RJMP _0x91
; 0000 0228 
; 0000 0229         case 300:
_0x94:
	CPI  R30,LOW(0x12C)
	LDI  R26,HIGH(0x12C)
	CPC  R31,R26
	BRNE _0x95
; 0000 022A             Screen300();                   //Set Voltage
	RCALL _Screen300
; 0000 022B         break;
	RJMP _0x91
; 0000 022C         case 301:
_0x95:
	CPI  R30,LOW(0x12D)
	LDI  R26,HIGH(0x12D)
	CPC  R31,R26
	BRNE _0x96
; 0000 022D             Screen301();
	RCALL _Screen301
; 0000 022E         break;
	RJMP _0x91
; 0000 022F 
; 0000 0230         case 31:
_0x96:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x97
; 0000 0231             Screen31();
	RCALL _Screen31
; 0000 0232         break;
	RJMP _0x91
; 0000 0233         case 310:                           //Analog
_0x97:
	CPI  R30,LOW(0x136)
	LDI  R26,HIGH(0x136)
	CPC  R31,R26
	BRNE _0x98
; 0000 0234             Screen310();
	RCALL _Screen310
; 0000 0235         break;
	RJMP _0x91
; 0000 0236         case 311:                           //Digital
_0x98:
	CPI  R30,LOW(0x137)
	LDI  R26,HIGH(0x137)
	CPC  R31,R26
	BRNE _0x9A
; 0000 0237             Screen311();
	RCALL _Screen311
; 0000 0238         break;
	RJMP _0x91
; 0000 0239 
; 0000 023A         default:
_0x9A:
; 0000 023B             lcd_clear();
	CALL SUBOPT_0x17
; 0000 023C             lcd_gotoxy(0,0);
; 0000 023D             lcd_puts("Error.");
	__POINTW1MN _0x9B,0
	CALL SUBOPT_0x21
; 0000 023E             lcd_gotoxy(0,1);
	CALL SUBOPT_0xB
; 0000 023F             lcd_puts("Restarting in 5 seconds.");
	__POINTW1MN _0x9B,7
	CALL SUBOPT_0x21
; 0000 0240             delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
; 0000 0241             Screen = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x16
; 0000 0242         break;
; 0000 0243     }
_0x91:
; 0000 0244 }
	RET

	.DSEG
_0x9B:
	.BYTE 0x20
;
;void main(void)
; 0000 0247 {

	.CSEG
_main:
; 0000 0248 
; 0000 0249 
; 0000 024A PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 024B DDRA=0x00;
	OUT  0x1A,R30
; 0000 024C 
; 0000 024D 
; 0000 024E PORTB=0x00;
	OUT  0x18,R30
; 0000 024F DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0250 
; 0000 0251 
; 0000 0252 PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 0253 DDRC=0xFF;
	OUT  0x14,R30
; 0000 0254 
; 0000 0255 
; 0000 0256 PORTD=0xC0;
	LDI  R30,LOW(192)
	OUT  0x12,R30
; 0000 0257 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0258 
; 0000 0259 
; 0000 025A 
; 0000 025B PORTE=0x0F;
	LDI  R30,LOW(15)
	OUT  0x3,R30
; 0000 025C DDRE=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 025D 
; 0000 025E 
; 0000 025F 
; 0000 0260 PORTF=0x00;
	STS  98,R30
; 0000 0261 DDRF=0x00;
	STS  97,R30
; 0000 0262 
; 0000 0263 
; 0000 0264 PORTG=0x00;
	STS  101,R30
; 0000 0265 DDRG=0x00;
	STS  100,R30
; 0000 0266 
; 0000 0267 TCCR3A=0x00;
	STS  139,R30
; 0000 0268 TCCR3B=0x09;
	LDI  R30,LOW(9)
	STS  138,R30
; 0000 0269 TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 026A TCNT3L=0x00;
	STS  136,R30
; 0000 026B ICR3H=0x00;
	STS  129,R30
; 0000 026C ICR3L=0x00;
	STS  128,R30
; 0000 026D OCR3AH=0xFF;
	LDI  R30,LOW(255)
	STS  135,R30
; 0000 026E OCR3AL=0xFF;
	STS  134,R30
; 0000 026F OCR3BH=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0270 OCR3BL=0x00;
	STS  132,R30
; 0000 0271 OCR3CH=0x00;
	STS  131,R30
; 0000 0272 OCR3CL=0x00;
	STS  130,R30
; 0000 0273 
; 0000 0274 // External Interrupt(s) initialization
; 0000 0275 EICRA=0x00;
	STS  106,R30
; 0000 0276 EICRB=0xAA;
	LDI  R30,LOW(170)
	OUT  0x3A,R30
; 0000 0277 EIMSK=0xF0;
	LDI  R30,LOW(240)
	OUT  0x39,R30
; 0000 0278 EIFR=0xF0;
	OUT  0x38,R30
; 0000 0279 
; 0000 027A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 027B TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 027C ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 027D 
; 0000 027E // USART0 initialization
; 0000 027F /*
; 0000 0280 UCSR0A=0x00;
; 0000 0281 UCSR0B=0x18;
; 0000 0282 UCSR0C=0x06;
; 0000 0283 UBRR0H=0x00;
; 0000 0284 UBRR0L=0x67;
; 0000 0285 */
; 0000 0286 // USART0 initialization
; 0000 0287 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0288 // USART0 Receiver: Off
; 0000 0289 // USART0 Transmitter: On
; 0000 028A // USART0 Mode: Asynchronous
; 0000 028B // USART0 Baud Rate: 9600
; 0000 028C UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 028D UCSR0B=(0<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(72)
	OUT  0xA,R30
; 0000 028E UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 028F UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0290 UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0291 
; 0000 0292 // USART1 initialization
; 0000 0293 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 0294 UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 0295 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 0296 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 0297 UBRR1L=0x67;
	LDI  R30,LOW(103)
	STS  153,R30
; 0000 0298 
; 0000 0299 // Analog Comparator initialization
; 0000 029A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 029B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 029C 
; 0000 029D // ADC initialization
; 0000 029E ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 029F ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 02A0 
; 0000 02A1 // SPI initialization
; 0000 02A2 SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 02A3 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 02A4 
; 0000 02A5 // TWI initializatioN
; 0000 02A6 TWCR=0x00;
	STS  116,R30
; 0000 02A7 
; 0000 02A8 // I2C Bus initialization
; 0000 02A9 i2c_init();
	CALL _i2c_init
; 0000 02AA 
; 0000 02AB // DS1307 Real Time Clock initialization
; 0000 02AC rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _rtc_init
; 0000 02AD 
; 0000 02AE 
; 0000 02AF lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 02B0 
; 0000 02B1 // Global enable interrupts
; 0000 02B2 #asm("sei")
	sei
; 0000 02B3 
; 0000 02B4 
; 0000 02B5 while(1)
_0x9C:
; 0000 02B6 {
; 0000 02B7 
; 0000 02B8    Screen_sel();
	RCALL _Screen_sel
; 0000 02B9 }
	RJMP _0x9C
; 0000 02BA 
; 0000 02BB }
_0x9F:
	RJMP _0x9F
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
	CALL SUBOPT_0x13
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x13
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
_0x2120008:
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
	CALL SUBOPT_0x31
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x32
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x33
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x33
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
	CALL SUBOPT_0x36
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
	CALL SUBOPT_0x36
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
_0x2120007:
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
	CALL SUBOPT_0x37
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x37
	RJMP _0x2120006
__floor1:
    brtc __floor0
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
_0x2120006:
	ADIW R28,4
	RET
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x39
	CALL __CPD02
	BRLT _0x204000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x2120005
_0x204000C:
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x39
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x204000D
	CALL SUBOPT_0x3C
	CALL __ADDF12
	CALL SUBOPT_0x3B
	__SUBWRN 16,17,1
_0x204000D:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x38
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3A
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x39
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3F
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
_exp:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x40
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x204000F
	CALL SUBOPT_0x41
	RJMP _0x2120004
_0x204000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2040010
	__GETD1N 0x3F800000
	RJMP _0x2120004
_0x2040010:
	CALL SUBOPT_0x40
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040011
	__GETD1N 0x7F7FFFFF
	RJMP _0x2120004
_0x2040011:
	CALL SUBOPT_0x40
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL __PUTPARD1
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x40
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x3E
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x39
	CALL __MULF12
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3F
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x3A
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3F
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
_0x2120004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	SBIW R28,4
	CALL SUBOPT_0x42
	CALL __CPD10
	BRNE _0x2040012
	CALL SUBOPT_0x41
	RJMP _0x2120003
_0x2040012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2040013
	CALL SUBOPT_0x43
	CALL __CPD10
	BRNE _0x2040014
	__GETD1N 0x3F800000
	RJMP _0x2120003
_0x2040014:
	CALL SUBOPT_0x42
	CALL SUBOPT_0x44
	RJMP _0x2120003
_0x2040013:
	CALL SUBOPT_0x43
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x37
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x43
	CALL __CPD12
	BREQ _0x2040015
	CALL SUBOPT_0x41
	RJMP _0x2120003
_0x2040015:
	CALL SUBOPT_0x42
	CALL __ANEGF1
	CALL SUBOPT_0x44
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2040016
	CALL SUBOPT_0x42
	RJMP _0x2120003
_0x2040016:
	CALL SUBOPT_0x42
	CALL __ANEGF1
_0x2120003:
	ADIW R28,12
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

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2060004
	SBI  0x15,4
	RJMP _0x2060005
_0x2060004:
	CBI  0x15,4
_0x2060005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2060006
	SBI  0x15,5
	RJMP _0x2060007
_0x2060006:
	CBI  0x15,5
_0x2060007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2060008
	SBI  0x15,6
	RJMP _0x2060009
_0x2060008:
	CBI  0x15,6
_0x2060009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x206000A
	SBI  0x15,7
	RJMP _0x206000B
_0x206000A:
	CBI  0x15,7
_0x206000B:
	__DELAY_USB 5
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2120002
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x2120002
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
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
	CALL SUBOPT_0x45
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x45
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060010
_0x2060011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060013
	RJMP _0x2120002
_0x2060013:
_0x2060010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2120002
_lcd_puts:
	ST   -Y,R17
_0x2060014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060014
_0x2060016:
	LDD  R17,Y+0
	RJMP _0x2120001
_lcd_putsf:
	ST   -Y,R17
_0x2060017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060017
_0x2060019:
	LDD  R17,Y+0
	RJMP _0x2120001
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
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x2
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
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
_0x2120002:
	ADIW R28,1
	RET

	.CSEG
_rtc_init:
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
	LDI  R30,LOW(208)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(7)
	ST   -Y,R30
	CALL _i2c_write
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_stop
_0x2120001:
	ADIW R28,3
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

	.DSEG
_recFunc_G000:
	.BYTE 0xC8
_tx_buffer0:
	.BYTE 0x40
_tx_counter0:
	.BYTE 0x1
_on_button_state:
	.BYTE 0x2
_off_button_state:
	.BYTE 0x2
_Screen:
	.BYTE 0x2
_Current_Screen:
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
_set_flag:
	.BYTE 0x2
_flag:
	.BYTE 0x2
_main_screen_trigger:
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
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOVW R30,R16
	ADD  R30,R8
	ADC  R31,R9
	SBIW R30,1
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	MOVW R30,R16
	ADD  R30,R8
	ADC  R31,R9
	MOVW R18,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R16
	CPC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,172
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	__POINTW1FN _0x0,172
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,176
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDS  R30,_voltage
	LDS  R31,_voltage+1
	LDS  R22,_voltage+2
	LDS  R23,_voltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDS  R30,_current
	LDS  R31,_current+1
	LDS  R22,_current+2
	LDS  R23,_current+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	CALL __MODW21
	STS  _Pointer_vert,R30
	STS  _Pointer_vert+1,R31
	JMP  _pointer_display_vert

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDS  R26,_Screen
	LDS  R27,_Screen+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDS  R30,_Screen
	LDS  R31,_Screen+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	STS  _Screen,R30
	STS  _Screen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x17:
	CALL _lcd_clear
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x14
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x14
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1B:
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
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDS  R26,_voltage
	LDS  R27,_voltage+1
	LDS  R24,_voltage+2
	LDS  R25,_voltage+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	__ADDD1N 1
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	STS  _voltage,R30
	STS  _voltage+1,R31
	STS  _voltage+2,R22
	STS  _voltage+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD1N 0x3E8
	CALL __MODD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDS  R26,_Pointer_horiz
	LDS  R27,_Pointer_horiz+1
	CALL __MODW21
	STS  _Pointer_horiz,R30
	STS  _Pointer_horiz+1,R31
	JMP  _pointer_display_horiz

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _flag,R30
	STS  _flag+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	LDS  R26,_current
	LDS  R27,_current+1
	LDS  R24,_current+2
	LDS  R25,_current+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	STS  _current,R30
	STS  _current+1,R31
	STS  _current+2,R22
	STS  _current+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(0)
	STS  _Pointer_vert,R30
	STS  _Pointer_vert+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _input

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x2E:
	ST   -Y,R30
	CALL _read_adc
	CALL __LSRW2
	MOVW R16,R30
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x2F:
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x30:
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x31:
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
SUBOPT_0x32:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
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
SUBOPT_0x35:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x39:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x3A
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
	CALL __PUTPARD1
	CALL _log
	__GETD2S 4
	CALL __MULF12
	CALL __PUTPARD1
	JMP  _exp

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(48)
	ST   -Y,R30
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
	__DELAY_USW 0x7D0
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
