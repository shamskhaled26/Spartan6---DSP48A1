module project_DSP#(
	parameter A0REG = 0,//
	parameter A1REG = 1,//
	parameter B0REG = 0,//
	parameter B1REG = 1,
	parameter CREG = 1,//
	parameter DREG = 1,//
	parameter MREG = 1,//
	parameter PREG = 1,//
	parameter CARRYINREG = 1,//
	parameter CARRYOUTREG = 1,//
	parameter OPMODEREG = 1,
	parameter CARRYINSEL = "OPMODE5",//CARRYIN ...OPMODE[5] ,ELSE ==0
	parameter B_INPUT="DIRECT",// ..CASCADE ,ELSE ==0
	parameter RSTTYPE="SYNC")(
	input [17:0]A,B,D,BCIN,		//input ports
	input [47:0]C,PCIN,//
	input CARRYIN,
	input RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE, 	//Reset Input Ports:
	input CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,			//clk enable ports
	input clk,			// control input ports
	input [7:0]OPMODE,
	output reg [17:0]BCOUT,	//output ports ....Cascade Ports
	output reg [47:0]PCOUT, //Cascade Ports
	output 	[47:0]P,
	output reg [35:0]M,
	output reg CARRYOUT,
	output reg CARRYOUTF);

reg cyi_in;
reg [17:0]out_b,in_b1_reg,add_sub,outZ;
reg [47:0]in_m_reg,inx3,in_p,outX;

wire [47:0]out_muxCYO,out_regCYO,out_muxp,out_p,out_muxM,out_regM,out_muxC,out_regC;
wire [7:0]out_reg_opmode,OPMODE_m;
wire [17:0]out_muxA1,out_regA1,out_regB1,out_muxB1,out_regD,out_muxD,out_regB,out_muxB,out_regA,out_muxA;
wire out_regCYI,out_muxCYI;

//1
reg_to_mux #(.sel_reg(OPMODEREG),.size(8),.RSTTYPE("SYNC")) OPMODE_REG(OPMODE,CEOPMODE,clk,RSTOPMODE,out_reg_opmode,OPMODE_m);
reg_to_mux  #(.sel_reg(DREG ),.size(18),.RSTTYPE("SYNC")) D_REG(D,CED,clk,RSTD,out_regD,out_muxD);
reg_to_mux  #(.sel_reg(B0REG),.size(18),.RSTTYPE("SYNC")) B0_REG(out_b,CEB,clk,RSTB,out_regB,out_muxB);
reg_to_mux  #(.sel_reg(A0REG),.size(18),.RSTTYPE("SYNC")) A0_REG(A,CEA,clk,RSTA,out_regA,out_muxA);
reg_to_mux #(.sel_reg(CREG ),.size(48),.RSTTYPE("SYNC")) C_REG(C,CEC,clk,RSTC,out_regC,out_muxC);
reg_to_mux  #(.sel_reg(B1REG),.size(18),.RSTTYPE("SYNC")) B1_REG(in_b1_reg,CEB,clk,RSTB,out_muxB1,out_regB1);
reg_to_mux  #(.sel_reg(A1REG),.size(18),.RSTTYPE("SYNC")) A1_REG(out_muxA ,CEA,clk,RSTA,out_muxA1,out_regA1);
reg_to_mux  #(.sel_reg(MREG),.size(48),.RSTTYPE("SYNC")	) M_REG(in_m_reg,CEM,clk,RSTM,out_muxM,out_regM);
reg_to_mux #(.sel_reg(CARRYINREG),.size(1),.RSTTYPE("SYNC")) CYI(cyi_in ,CECARRYIN,clk,RSTCARRYIN,out_muxCYI,out_regCYI);
reg_to_mux  #(.sel_reg(CARRYOUTREG),.size(48),.RSTTYPE("SYNC")) CYO(in_p ,CEOPMODE,clk,RSTCARRYIN,out_muxCYO,out_regCYO);
reg_to_mux  #(.sel_reg(PREG),.size(48),.RSTTYPE("SYNC")) P_REG(in_p ,CEP,clk,RSTP,P,out_p);

always @(*) out_b = (B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCIN:0;	
always @(*) begin			
			if(OPMODE_m[6])
				add_sub = out_muxD - out_muxB;
			else
				add_sub = out_muxD + out_muxB;
end
always @(*) in_b1_reg =(OPMODE_m[4])?add_sub:out_muxB;
//2
always @(*) BCOUT=out_muxB1;
always @(*) in_m_reg = out_regA1 * out_regB1;
//3
always @(*) M = out_muxM;//36 bit
always @(*) begin
			if(CARRYINSEL =="OPMODE5")
					cyi_in = OPMODE_m[5];
			else if(CARRYINSEL =="CARRYIN") 
					cyi_in =CARRYIN;
			else cyi_in = 0;
end

//4
//...............X PIPELINING...............//
always @(*) begin 
			case (OPMODE_m[1:0])
				0: outX = 0;
				1: outX = out_muxM;
				2: outX = PCOUT;
				3: outX = inx3;//con
			endcase
end
		//...............Z PIPELINING...............//
always @(*) begin 
			case (OPMODE_m[3:2])
				0: outZ = 0;
				1: outZ = PCIN;
				2: outZ = PCOUT;//pcout
				3: outZ = out_muxC;//out reg c
			endcase                 	
end
always @(*) begin
			if(OPMODE_m[7])
		 			 in_p = outZ-(outX+out_muxCYI);
		 		else in_p = outZ+(outX+out_muxCYI);
end	

	

always @(*) inx3= {D[11:0],A[17:0],B[17:0]};////48 bit							

always @(*) CARRYOUT = out_muxCYO;
always @(*) CARRYOUTF = out_muxCYO;
always @(*) PCOUT = P;

	


endmodule