module Back_Light(
	input  Sys_Clk,
	input  Sys_Rst,
	input  Left,Right,Emer,
	output reg LED_G1,LED_G2,LED_R1,LED_R2
	);
	
	reg [23:0] Cnt_1Hz;
	parameter Diveider = 24'h5B8D80;
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
			Cnt_1Hz <= 24'h0;
		else if(Cnt_1Hz < Diveider)
			Cnt_1Hz <= Cnt_1Hz + 1'b1;
		else
			Cnt_1Hz <= 24'h0;
	end
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)begin
			LED_G1 <= 1'b1;LED_G2 <= 1'b1;LED_R1 <= 1'b1; LED_R2 <= 1'b1;
		end
		else if(Left == 1'b0 && Right == 1'b1 && Emer == 1'b1)begin
			if(Cnt_1Hz == Diveider)begin
				LED_G1 <= ~LED_G1;LED_G2 <= 1'b1;
				LED_R1 <= ~LED_R1;LED_R2 <= 1'b1;
			end
			else begin
				LED_G1 <= LED_G1;LED_G2 <= 1'b1;
				LED_R1 <= LED_R1;LED_R2 <= 1'b1;
			end
		end
		else if(Left == 1'b1 && Right == 1'b0 && Emer == 1'b1)begin
			if(Cnt_1Hz == Diveider)begin
				LED_G1 <= 1'b1;LED_G2 <= ~LED_G2;
				LED_R1 <= 1'b1;LED_R2 <= ~LED_R2;
			end
			else begin
				LED_G1 <= 1'b1;LED_G2 <= LED_G2;
				LED_R1 <= 1'b1;LED_R2 <= LED_R2;
			end
		end
		else if(Left == 1'b1 && Right == 1'b1 && Emer == 1'b0)begin
			if(Cnt_1Hz == Diveider)begin
				LED_G1 <= 1'b1;LED_G2 <= 1'b1;
				LED_R1 <= ~LED_R1;LED_R2 <= ~LED_R2;
			end
			else begin
				LED_G1 <= 1'b1;LED_G2 <= 1'b1;
				LED_R1 <= LED_R1;LED_R2 <= LED_R2;
			end
		end
		else begin
			LED_G1 <= 1'b1;LED_G2 <= 1'b1;LED_R1 <= 1'b1; LED_R2 <= 1'b1;
		end
	end
	
endmodule 
