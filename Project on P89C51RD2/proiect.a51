	       value_0 EQU 00h
	       
		U4_PA EQU 8000h
		U4_PB EQU 8001h
		U4_PC EQU 8002h
		U4_CC EQU 8003h
		Cmd_U4 EQU   80h
		
		U5_PA EQU 8004h
		U5_PB EQU 8005h
		U5_PC EQU 8006h
		U5_CC EQU 8007h
		Cmd_U5   EQU 80h
		
		U6_C0 EQU 8008h	;adresa canal 0 8253
		U6_CC EQU 800Bh ;adresa cuvant de comanda 8253
		
		OMPS_U6  EQU	03h		;high
		OMS_U6 	 EQU 	02h		;low
		Cmd_U6	 EQU	34h		;cuvantul de comanda 

			
		Adr_Clk1 EQU 100h
		Adr_Clk2 EQU 101h
		Adr_Clk3 EQU 102h
		Adr_Clk4 EQU 103h
		Adr_Clk5 EQU 104h
		Adr_Clk6 EQU 105h
		
	ORG 03h 	
		LJMP clock
			
	ORG 0h
Start:	LJMP PP
	
	ORG 100h
PP:		
		MOV	A,#value_0
		MOV	DPTR,#Adr_Clk1
		MOVX	@DPTR,A
		LCALL 	Init_seg
		LCALL 	Init_U6
		SJMP	 $
		
Init_seg:	 ;programare U4
		 MOV 	A,#Cmd_U4
		MOV 	DPTR,#U4_CC
		MOVX 	@DPTR,A
		
		; programare U5
		MOV 	A,#Cmd_U5
		MOV 	DPTR,#U5_CC
		MOVX 	@DPTR,A
		
		 ;initializare U4 PA
		MOV 	A,#value_0
		MOV 	DPTR,#U4_PA
		LCALL 	afis 
		
		;initializare U4 PB
		MOV 	DPTR,#U4_PB
		LCALL 	afis 
			
		 ;initializare U4 PC
		MOV 	DPTR,#U4_PC
		LCALL 	afis 
			
		 ;initializare U5 PA
		MOV 	DPTR,#U5_PA
		LCALL 	afis 
			
		; initializare U5 PB
		MOV 	DPTR,#U5_PB
		LCALL 	afis 
			
		; initializare U5 PC
		MOV 	DPTR,#U5_PC
		LCALL 	afis 
		RET
			
	ORG 200h
clock:	MOV 	DPTR, #Adr_Clk1	
		MOVX 	A, @DPTR
		INC 	A
		MOVX	@DPTR, A
		MOV 	DPTR, #U4_PA
		CJNE 	A, #0Ah, aux
		MOV 	DPTR, #Adr_Clk1
		MOV 	A, #00h
		MOVX	@DPTR, A
		MOV 	DPTR, #U4_PA
		ACALL 	afis
		
		MOV   	DPTR, #Adr_Clk2	
		MOVX 	A, @DPTR
		INC		A
		MOVX	@DPTR, A
		MOV 	DPTR, #U4_PB
		CJNE 	A, #06h, aux
		MOV 	DPTR, #Adr_Clk2
		MOV 	A, #00h
		MOVX	@DPTR, A
		MOV 	DPTR, #U4_PB
		ACALL 	afis
		
		MOV   	DPTR, #Adr_Clk3	
		MOVX 	A, @DPTR
		INC		A
		MOVX	@DPTR, A
		MOV 	DPTR, #U4_PC
		CJNE 	A, #0Ah, aux
		MOV 	DPTR, #Adr_Clk3
		MOV 	A, #00h
		MOVX	@DPTR, A
		MOV 	DPTR, #U4_PC
		ACALL 	afis
		
		MOV   	DPTR, #Adr_Clk4	
		MOVX 	A, @DPTR
		INC		A
		MOVX	@DPTR, A
		MOV 	DPTR, #U5_PA
		CJNE 	A, #06h, aux
		MOV 	DPTR, #Adr_Clk4
		MOV 	A, #00h
		MOVX	@DPTR, A
		MOV 	DPTR, #U5_PA
		ACALL 	afis
		
		MOV   	DPTR, #Adr_Clk5	
		MOVX 	A, @DPTR
		INC		A
		MOVX	@DPTR, A
		CJNE 	A, #04h, cont	;verficare reset 1
		
		MOV   	DPTR, #Adr_Clk6
		MOVX 	A, @DPTR
		CJNE	A, #02h, cont	;verificare reset 2
		ACALL 	Init_seg	;reset
		RETI

aux: 	ACALL afis
		RETI
		
cont:	MOV   	DPTR, #Adr_Clk5	
		MOVX 	A, @DPTR
		MOV 	DPTR, #U5_PB
		CJNE 	A, #0Ah, aux
		
		MOV 	DPTR, #Adr_Clk5
		MOV 	A, #00h
		MOVX	@DPTR, A
		MOV 	DPTR, #U5_PB
		ACALL 	afis
		MOV   	DPTR, #Adr_Clk6	;incrementare contor 6
		MOVX 	A, @DPTR
		INC		A
		MOVX	@DPTR, A
		MOV 	DPTR, #U5_PC
		ACALL 	afis
		RETI
			
Init_U6: 	CLR 	IE.7 ;dezactivare globala a intreruperilor
			MOV 	A,#Cmd_U6 ;incarca cuvantul de comanda
			MOV 	DPTR,#U6_CC ;incarca in DPTR adresa cuvantului de comanda
			MOVX 	@DPTR,A 
			MOV 	DPTR,#U6_C0
			MOV 	A,#OMPS_U6
			MOVX 	@DPTR,A
			MOV 	A,#OMS_U6
			MOVX 	@DPTR,A
			SETB 	TCON.0
			SETB 	IE.0
			SETB 	IE.7 ;validare globala a intreruperilor
			RET
			
afis: 	PUSH 	ACC
		PUSH 	DPL
		PUSH 	DPH
		ANL 	A,#0Fh
		MOV 	DPTR,#sseg
		MOVC 	A,@A+DPTR
		POP 	DPH
		POP 	DPL
		MOVX 	@DPTR,A
		POP 	ACC
		RET
		
sseg: 	DB 3Fh, 06h, 5Bh, 4Fh, 66h, 6Dh, 7Dh, 07h, 7Fh, 6Fh
	
	END