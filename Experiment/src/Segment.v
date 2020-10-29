module Segment(
	input  		 Sys_Clk,
	input        Sys_Rst,
	input  [3:0] Score_L,
	input  [3:0] Score_R,
	output reg [6:0] Segment,
	output reg [7:0] Scan
	);
	
	reg [23:0]Cnt_200Hz;
	reg [6:0] seg [5:0];//六个七位宽数据
	reg [0:0] Clk_200Hz;
	
	parameter Divider = 24'h1E848;
	
	initial begin
		seg[0] = 7'h3f;	   //  0
		seg[1] = 7'h06;	   //  1
		seg[2] = 7'h5b;	   //  2
		seg[3] = 7'h4f;	   //  3
		seg[4] = 7'h66;	   //  4
		seg[5] = 7'h6d;	   //  5
	end
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
			Cnt_200Hz <= 0;
		else if(Cnt_200Hz < Divider)
			Cnt_200Hz <= Cnt_200Hz+1'b1;
	    else
			Cnt_200Hz <= 24'b0;
	end
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
			Clk_200Hz <= 1'b0;
		else if(Cnt_200Hz == Divider)
			Clk_200Hz <= ~Clk_200Hz;
	    else
			Clk_200Hz <= Clk_200Hz;
	end

	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
            Segment <= 7'h00;
		else if(Clk_200Hz)begin
			Segment <= seg[Score_L];
			Scan <= 8'hFE;
		end
		else if(!Clk_200Hz)begin
			Segment <= seg[Score_R];
			Scan <= 8'hFD;
		end
		else
            Segment <= Segment;
	end
	
endmodule 