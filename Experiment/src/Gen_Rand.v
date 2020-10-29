module Gen_Rand(
	input Sys_Clk,
	input Sys_Rst,
	output reg [2:0]Rand_3bits
	);
	
	reg [31:0] Cnt;
	reg [1:0]Switch;
	parameter Divider_3 = 16777777;//三分频
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
			Cnt <= 32'b0;
		else if(Cnt < Divider_3)
			Cnt <= Cnt+1'b1;
		else begin
			Cnt <= 32'b0;
			Switch <= Switch + 1'b1;
		end
		
		case(Switch)
			2'b00:	Rand_3bits <= 3'b001;
			2'b01:	Rand_3bits <= 3'b010;
			2'b10:	Rand_3bits <= 3'b100;
			default: Switch <= 2'b00;
		endcase
	end
	
endmodule