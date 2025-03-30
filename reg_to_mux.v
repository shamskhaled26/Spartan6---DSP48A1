module reg_to_mux#(parameter sel_reg = 1,parameter size = 18,parameter RSTTYPE = "SYNC")(
	input [size-1:0]in,
	input clk_en,clk,rst,
	output reg [size-1:0]out_reg,
	output reg [size-1:0]out_mux
);
generate 
	if (RSTTYPE=="SYNC")begin
		always @(posedge clk ) begin
			if(rst) begin
				out_reg <= 0;
			end else if(clk_en) begin
				out_reg <=in ;
			end
		end
	end
	else if (RSTTYPE=="ASYNC") begin
		always @(posedge clk or posedge  rst) begin
			if(rst) begin
				out_reg <= 0;
			end else if(clk_en) begin
				out_reg <=in ;
			end
		end
	end
endgenerate

always @(*) out_mux=(sel_reg)?out_reg:in;

endmodule