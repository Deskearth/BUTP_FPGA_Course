`timescale 10ns/10ns
module Buzzer_tb();

parameter T=1;

	reg Sys_Clk_u;
	reg Sys_Rst_u;
	reg [4:0] test_u;
	wire piano_out_u;

	initial begin
		Sys_Clk_u = 1'b0;
		Sys_Rst_u = 1'b0;
		test_u	  = 1'b0;
		#(T+1) Sys_Rst_u = 1'b1;
	end
	
	always #(1*T) Sys_Clk_u = ~Sys_Clk_u;
	
	always begin
		#(20_000_000*T)test_u = test_u + 5'd3;
	end

	Buzzer Buzzer_u1(
		.Sys_Clk (Sys_Clk_u),
		.Sys_Rst (Sys_Rst_u),
		.tone	 (test_u),
		.piano_out	 (piano_out_u)
	);

endmodule