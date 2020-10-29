module Finger_Play(
    input Sys_Clk,
    input Sys_Rst,
    input BTN_Ready,
    input BTN_Go,
    input [2:0] BTN_Player_L,
    input [2:0] BTN_Player_R,
	input Two_Pla_Cho,//是否双人玩家对战选择高电平为选择双人对战
    output LED,
    output wire [5:0] LED_Test,
    output wire [7:0] ROW,
    output wire [7:0] COL,
	output [6:0] Segment,
	output [7:0] Scan,
	output piano_out,
	output lcd_en,
    output lcd_rw,  //因为只执行写操作，所以永远为0.
    output lcd_rs,
    output [7:0] DATA_BUS
    );

    wire [63:0] MUX_COL ;
    wire [7:0]  Pic_Addr;
    

    
/************开关图片显示测试************/    
//    Test_Sw Test_Sw_u(
//        .Pic_Addr  (Pic_Addr)
//        );
/************开关图片显示测试************/
    
    Disp Disp_u(
        .MUX_COL    (MUX_COL),
        .Sys_Clk    (Sys_Clk),
        .Sys_Rst    (Sys_Rst),
        .ROW        (ROW),
        .COL        (COL)
        );
        
    MUX MUX_u(
        .Pic_Addr   (Pic_Addr),
        .Sys_Clk    (Sys_Clk) ,
        .Sys_Rst    (Sys_Rst) ,
        .MUX_COL    (MUX_COL)
        );
        
    State_Machine State_Machine_u(
        .BTN_Ready    (BTN_Ready),
        .BTN_Go       (BTN_Go),
        .BTN_Player_L (BTN_Player_L),
        .BTN_Player_R (BTN_Player_R),
        .Sys_Clk      (Sys_Clk),
        .Sys_Rst      (Sys_Rst),
        .LED          (LED),
        .LED_Test     (LED_Test),
        .Pic_Addr     (Pic_Addr),
		.Segment	  (Segment),
		.Scan		  (Scan),
		.piano_out	  (piano_out),
		.lcd_en		  (lcd_en),
		.lcd_rw	 	  (lcd_rw),
		.lcd_rs		  (lcd_rs),
		.DATA_BUS	  (DATA_BUS),
		.Two_Pla_Cho  (Two_Pla_Cho)
        );
    
endmodule 