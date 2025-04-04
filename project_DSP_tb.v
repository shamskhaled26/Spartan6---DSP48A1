module project_DSP_tb#(
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
//............
	parameter OPMODEREG = 1,//
	parameter CARRYINSEL = "OPMODE5",//CARRYIN ...OPMODE[5] ,ELSE ==0
	parameter B_INPUT="DIRECT",// ..CASCADE ,ELSE ==0
	parameter RSTTYPE="SYNC"//   ASYNC
);
	reg [17:0]A;		//INPUT ports
	reg [17:0]B;
	reg [17:0]D;
	reg [47:0]C;//
	reg CARRYIN;
	reg [17:0]BCIN;
	reg RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE;	//Reset INPUT Ports:
	reg CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;//clk enable ports
	reg [47:0]PCIN;//Cascade Ports
	reg clk;			// control INPUT ports
	reg [7:0]OPMODE;

	wire [17:0]BCOUT;	//output ports ....Cascade Ports
	wire [47:0]PCOUT; //Cascade Ports
	wire [47:0]P;
	wire [35:0]M;
	wire CARRYOUT;
	wire CARRYOUTF;


//reg>>wire
project_DSP DUT(A,B,D,BCIN,C,PCIN,CARRYIN,
                RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
                CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
                clk,OPMODE,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

initial begin
clk =1;
    forever #10 clk =~clk;//wait 10nsec for freq 100MHz
end

initial begin
	A = 0;
    B = 0;
    C = 0;
    D = 0;
    OPMODE = 0;
    CARRYIN = 0;
    BCIN = 0;
    PCIN = 0;
    CEA = 0;CEB = 0;CEC = 0;CED = 0;CEM = 0;CEP = 0;CEOPMODE = 0;CECARRYIN = 0;
    RSTP = 1;RSTA = 1;RSTB = 1;RSTM = 1;RSTP = 1;RSTC = 1;RSTD = 1;RSTCARRYIN = 1;RSTOPMODE = 1;
       repeat(4) @(negedge clk) if( P!=0)begin
            $display("error");
            $stop;
        end
    RSTP = 0;RSTA = 0;RSTB = 0;RSTM = 0;RSTP = 0;RSTC = 0;RSTD = 0;RSTCARRYIN = 0;RSTOPMODE = 0;
    CEA = 1;CEB = 1;CEC = 1;CED = 1;CEM = 1;CEP = 1;CEOPMODE = 1;CECARRYIN = 1;
    A =1;
    B =2;
    C =3;
    D =4;
    OPMODE = 8'b0001_1101;
    CARRYIN =0;
    BCIN = 0;
    PCIN =0;
   repeat(4) @(negedge clk);
    A =$random;
    B =$random;
    C =$random;
    D =$random;
    OPMODE = $random;
    CARRYIN =$random;
    BCIN = $random;
    PCIN =$random;
   repeat(4) @(negedge clk);

    A =$random;
    B =$random;
    C =$random;
    D =$random;
    OPMODE = $random;
    CARRYIN =$random;
    BCIN = $random;
    PCIN =$random;
   repeat(4) @(negedge clk);
$stop;
end
initial begin
    $monitor("PCOUT=%d, P=%d, CARRYOUT=%d , CARRYOUTF=%d ,M=%d", PCOUT, P, CARRYOUT,CARRYOUTF , M);
end
endmodule