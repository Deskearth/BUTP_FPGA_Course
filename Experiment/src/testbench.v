`timescale 10ns/10ns
module Finger_Play_tb();

parameter T=0.1;
parameter Delay = 5_000_00;
	
	/*输入接口*/
	reg Sys_Clk_t;
	reg Sys_Rst_t;
	reg BTN_Ready_t;
	reg BTN_Go_t;
	reg [2:0] BTN_Player_L_t;
	reg [2:0] BTN_Player_R_t;
	reg Two_Pla_Cho_t;
	
	/*输出接口*/
	wire LED_t;
	wire [5:0] LED_Test_t;
	wire [7:0] ROW_t;
	wire [7:0] COL_t;
	wire [6:0] Segment_t;
	wire [7:0] Scan_t;
	wire piano_out_t;
	wire lcd_en_t;
    wire lcd_rw_t;
    wire lcd_rs_t;
    wire [7:0] DATA_BUS_t;
	
	/*初始化*/
	initial begin
		Sys_Clk_t = 1'b0;
		#(T+1) 
        #(T+1) BTN_Ready_t = 1'b0;
		#(T+1) BTN_Go_t = 1'b0;
		#(T+1) Two_Pla_Cho_t = 1'b1;
		#(T+1) Sys_Rst_t = 1'b1;
        BTN_Player_L_t = 3'b0;
        BTN_Player_R_t = 3'b0;
	end
	
	/*输入测试*/
	always #(10*T) Sys_Clk_t = ~Sys_Clk_t;
    always begin
		#(Delay*T)BTN_Ready_t = 1'b1;#(Delay*T) BTN_Ready_t = 1'b0;
		#(Delay*T)BTN_Player_L_t = 3'b001;BTN_Player_R_t = 3'b001;#(Delay*T)BTN_Player_L_t = 3'b000;BTN_Player_R_t = 3'b000;//左石头右石头
		#(Delay*T)BTN_Go_t = 1'b1;	 #(Delay*T) BTN_Go_t = 1'b0;
		#(Delay*T)BTN_Ready_t = 1'b1;#(Delay*T) BTN_Ready_t = 1'b0;
		#(Delay*T)BTN_Player_L_t = 3'b001;BTN_Player_R_t = 3'b010;#(Delay*T)BTN_Player_L_t = 3'b000;BTN_Player_R_t = 3'b000;//左石头右剪刀
		#(Delay*T)BTN_Go_t = 1'b1;	 #(Delay*T) BTN_Go_t = 1'b0;
		#(Delay*T)BTN_Ready_t = 1'b1;#(Delay*T) BTN_Ready_t = 1'b0;
		#(Delay*T)BTN_Player_L_t = 3'b100;BTN_Player_R_t = 3'b001;#(Delay*T)BTN_Player_L_t = 3'b000;BTN_Player_R_t = 3'b000;//左布右石头
		#(Delay*T)BTN_Go_t = 1'b1;	 #(Delay*T) BTN_Go_t = 1'b0;
		#(Delay*T)BTN_Ready_t = 1'b1;#(Delay*T) BTN_Ready_t = 1'b0;
		#(Delay*T)BTN_Player_L_t = 3'b010;BTN_Player_R_t = 3'b100;#(Delay*T)BTN_Player_L_t = 3'b000;BTN_Player_R_t = 3'b000;//左剪刀右布
		#(Delay*T)BTN_Go_t = 1'b1;	 #(Delay*T) BTN_Go_t = 1'b0;
		#(Delay*T)BTN_Ready_t = 1'b1;#(Delay*T) BTN_Ready_t = 1'b0;
		#(2*Delay*T)Sys_Rst_t = 1'b0;#(Delay*T)Sys_Rst_t = 1'b1;
	end
	
	/*模块例化*/
	Finger_Play Finger_Play_u1(
		.Sys_Clk		(Sys_Clk_t),
		.Sys_Rst		(Sys_Rst_t),
		.BTN_Ready		(BTN_Ready_t),
		.BTN_Go			(BTN_Go_t),
		.BTN_Player_L	(BTN_Player_L_t),
		.BTN_Player_R	(BTN_Player_R_t),
		.Two_Pla_Cho	(Two_Pla_Cho_t),
		.LED			(LED_t),
		.LED_Test		(LED_Test_t),
		.ROW			(ROW_t),
		.COL			(COL_t),
		.Segment		(Segment_t),
		.Scan			(Scan_t),
		.piano_out		(piano_out_t),
		.lcd_en			(lcd_en_t),
		.lcd_rw			(lcd_rw_t),
		.lcd_rs			(lcd_rs_t),
		.DATA_BUS		(DATA_BUS_t)
	);

endmodule 