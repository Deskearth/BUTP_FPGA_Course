module State_Machine(
    input BTN_Ready,//准备按钮
    input BTN_Go,//“开”按钮
    input [2:0] BTN_Player_L,//左侧玩家2-石头、1-剪刀、0-布
    input [2:0] BTN_Player_R,//右侧玩家2-石头、1-剪刀、0-布
    input Sys_Clk,
    input Sys_Rst,
	input Two_Pla_Cho,//是否双人玩家对战选择高电平为选择双人对战
    output reg LED,
    output reg [5:0] LED_Test,
    output [7:0] Pic_Addr,//输出给数据分配器的图片地址
	output [6:0] Segment,
	output [7:0] Scan,
	output piano_out,//蜂鸣器信号
	output lcd_en,
    output lcd_rw,  //因为只执行写操作，所以永远为0.
    output lcd_rs,
    output [7:0] DATA_BUS
);
	
	/*格雷码编码状态*/
    parameter S0 = 4'b0000;//开始界面
    parameter S1 = 4'b0001;//准备状态
    parameter S2 = 4'b0011;//显示出拳
    parameter S3 = 4'b0010;//显示获胜方（五局三胜）
	parameter Music_Lenth = 32'd64;//乐曲小节数
	parameter Music_Divider = 32'd9_000_000;//每一拍的长度
    
	/*寄存器声明*/
    reg [3:0] Curr_St;//现状态
    reg [3:0] Next_St;//下一状态
    reg [3:0] Score_L;//左侧玩家得分寄存器
    reg [3:0] Score_R;//右侧玩家得分寄存器
    reg [7:0] Pic_Addr_Reg;//显示图片地址寄存器
    reg [2:0] Reg_Player_L;//左侧玩家当前出拳寄存器
    reg [2:0] Reg_Player_R;//右侧玩家当前出拳寄存器
	reg [0:0] Reg_Add;//加分状态寄存器，保证每次只加一分
	reg [0:0] Reg_End;//比赛结束状态寄存器
	reg [0:0] Music_En;//音乐播放使能
	reg [4:0] tone;//设置蜂鸣器音调
	reg [4:0] music [255:0];//《欢乐颂》的谱子
	reg [31:0] Music_Cnt;//音乐节拍计数器
	reg [7:0] Tone_Now;//当前音节
	reg [127:0] row_1;//LCD第一行显示字符
	reg [127:0] row_2;//LCD第二行显示字符
	reg [0:0]	Two_Pla_Def;//双人玩家对战模式寄存器写1位处于双人对战模式
	
	/*连线声明*/
	wire [7:0] Score_L_Char;//翻译后的LCD编码
	wire [7:0] Score_R_Char;//翻译后的LCD编码
	wire [1:0] Dat_4Hz;//开机界面图片地址切换寄存器
    wire key_pulse;
    wire Clk_1Hz;//1Hz信号
	wire [2:0] Rand_3bits;//人机对战中随机生成的出拳
	wire key_pulse_Ready;
	wire key_pulse_Go;
	wire [2:0]key_pulse_BTN_L;
	wire [2:0]key_pulse_BTN_R;
    
    assign Pic_Addr = Pic_Addr_Reg;
    
    initial begin
        Curr_St <= S0;
		Score_L <= 4'd0;
		Score_R <= 4'd0;
		Reg_Add <= 0;//加分状态寄存器复位
		Reg_End <= 0;//比赛结束寄存器复位
	end
	
	initial begin//《欢乐颂》，每一行四拍一小节
		music[0] <= 5'd3; music[1] <= 5'd0; music[2] <= 5'd3; music[3] <= 5'd0; music[4] <= 5'd4; music[5] <= 5'd0; music[6] <= 5'd5; music[7] <= 5'd0; 
		music[8] <= 5'd5; music[9] <= 5'd0; music[10] <= 5'd4; music[11] <= 5'd0; music[12] <= 5'd3; music[13] <= 5'd0; music[14] <= 5'd2; music[15] <= 5'd0; 
		music[16] <= 5'd1; music[17] <= 5'd0; music[18] <= 5'd1; music[19] <= 5'd0; music[20] <= 5'd2; music[21] <= 5'd0; music[22] <= 5'd3; music[23] <= 5'd0; 
		music[24] <= 5'd3; music[25] <= 5'd3; music[26] <= 5'd3; music[27] <= 5'd0; music[28] <= 5'd2; music[29] <= 5'd0; music[30] <= 5'd2; music[31] <= 5'd2; 
		music[32] <= 5'd3; music[33] <= 5'd0; music[34] <= 5'd3; music[35] <= 5'd0; music[36] <= 5'd4; music[37] <= 5'd0; music[38] <= 5'd5; music[39] <= 5'd0; 
		music[40] <= 5'd5; music[41] <= 5'd0; music[42] <= 5'd4; music[43] <= 5'd0; music[44] <= 5'd3; music[45] <= 5'd0; music[46] <= 5'd2; music[47] <= 5'd0; 
		music[48] <= 5'd1; music[49] <= 5'd0; music[50] <= 5'd1; music[51] <= 5'd0; music[52] <= 5'd2; music[53] <= 5'd0; music[54] <= 5'd3; music[55] <= 5'd0; 
		music[56] <= 5'd2; music[57] <= 5'd2; music[58] <= 5'd0; music[59] <= 5'd1; music[60] <= 5'd0; music[61] <= 5'd1; music[62] <= 5'd1; music[63] <= 5'd1; 
	end
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin//状态转换
        if(!Sys_Rst)
            Curr_St <= S0;
        else
            Curr_St<=Next_St;
    end
    
    
    always@(*)begin//状态转移条件
        if((Curr_St == S0) && (key_pulse_Ready == 1))begin
            Next_St <= S1;
        end
        
        else if((Curr_St == S1) && (key_pulse_Go == 1) && (Reg_Player_L!=3'b0 && Reg_Player_R!=3'b0))begin
            Next_St <= S2;
        end
		
		else if((Curr_St == S2) && (key_pulse_Ready == 1) && (Reg_End == 0))begin
            Next_St <= S1;
        end
		
		else if((Curr_St == S1) && (Reg_End == 1))begin
            Next_St <= S3;
        end
		
        else
            Next_St <= Curr_St;
    end  
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin//状态机输出
        if(!Sys_Rst)begin
            //LED<=0;
            Reg_Player_L<=3'b000;
            Reg_Player_R<=3'b000;
            Pic_Addr_Reg <= 8'hFF;
			Score_L <= 4'd0;
			Score_R <= 4'd0;
			Reg_Add <= 0;
			Music_En <= 1'b0;
			Reg_End <= 1'b0;
        end
        
        else if(Curr_St == S0)begin//开始界面
            //LED <= Clk_1Hz;//仅测试用，LED闪烁显示正在开始界面
			if(Dat_4Hz == 4'h0)
				Pic_Addr_Reg <= 8'h0B;
			else if(Dat_4Hz == 4'h1)
				Pic_Addr_Reg <= 8'h0C;
			else if(Dat_4Hz == 4'h2)
				Pic_Addr_Reg <= 8'h0D;
			else if(Dat_4Hz == 4'h3)
				Pic_Addr_Reg <= 8'h0E;
			else
				;
			if(Two_Pla_Cho == 1'b1)begin//双人对战
				row_1<="Welcome!        ";
				row_2<="Two Players Mode";
				Two_Pla_Def <= 1'b1;
			end
			else begin//人机对战
				row_1<="Welcome!        ";
				row_2<="Single Player   ";
				Two_Pla_Def <= 1'b0;
			end
			Music_En <= 1'b1;
        end
        
        else if(Curr_St == S1)begin
			Music_En <= 1'b0;
            Pic_Addr_Reg <= 8'hFF;
            //LED<=0;//进入准备界面后关闭测试LED
			Reg_Add <= 1'b0;
			row_1<="Please Choose   ";
			row_2<="                ";
			
			if(Score_L == 4'd3 || Score_R == 4'd3)//判断比赛是否结束
				Reg_End <= 1'b1;//比赛结束寄存器置位
			else
				Reg_End <= 1'b0;
					
			if(Two_Pla_Def == 1'b1)begin//双人对战
				
				case(key_pulse_BTN_L)
					3'b100:Reg_Player_L<=3'b100;
					3'b010:Reg_Player_L<=3'b010;
					3'b001:Reg_Player_L<=3'b001;
					default:Reg_Player_L<=Reg_Player_L;
				endcase
				case(key_pulse_BTN_R)
					3'b100:Reg_Player_R<=3'b100;
					3'b010:Reg_Player_R<=3'b010;
					3'b001:Reg_Player_R<=3'b001;
					default:Reg_Player_R<=Reg_Player_R;
				endcase
					
			end
			
			else begin//人机对战
				case(key_pulse_BTN_R)
					3'b100:Reg_Player_R<=3'b100;
					3'b010:Reg_Player_R<=3'b010;
					3'b001:Reg_Player_R<=3'b001;
					default:Reg_Player_R<=Reg_Player_R;
				endcase
				
				Reg_Player_L <= Rand_3bits;
			end
        end
        
        else if(Curr_St == S2)begin//修改比分
			row_1 <= "Score:          ";
			row_2[63:56] <= Score_R_Char;row_2[71:64] <= ":";row_2[79:72] <= Score_L_Char;row_2[39:0]<="     ";row_2[127:80]<="      ";
			if(Reg_Player_L==3'b001 && Reg_Player_R==3'b001)begin//左石头右石头
				Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h00;
					Score_L <= Score_L;
					Score_R <= Score_R;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b001 && Reg_Player_R==3'b010)begin//左石头右剪刀
				Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h01;
					Score_L <= Score_L + 4'd1;
					Score_R <= Score_R;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b001 && Reg_Player_R==3'b100)begin//左石头右布
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h02;
					Score_L <= Score_L;
					Score_R <= Score_R + 4'd1;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b010 && Reg_Player_R==3'b001)begin//左剪刀右石头
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h03;
					Score_L <= Score_L;
					Score_R <= Score_R + 4'd1;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b010 && Reg_Player_R==3'b010)begin//左剪刀右剪刀
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h04;
					Score_L <= Score_L;
					Score_R <= Score_R;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b010 && Reg_Player_R==3'b100)begin//左剪刀右布
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h05;
					Score_L <= Score_L + 4'd1;
					Score_R <= Score_R;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b100 && Reg_Player_R==3'b001)begin//左布右石头
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h06;
					Score_L <= Score_L + 4'd1;
					Score_R <= Score_R;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b100 && Reg_Player_R==3'b010)begin//左布右剪刀
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h07;
					Score_L <= Score_L;
					Score_R <= Score_R + 4'd1;
				end
				else
					;
            end
            else if(Reg_Player_L==3'b100 && Reg_Player_R==3'b100)begin//左布右布
                Reg_Add <= 1;
				if(Reg_Add == 0)begin
					Pic_Addr_Reg <= 8'h08;
					Score_L <= Score_L;
					Score_R <= Score_R;
				end
				else
					;
            end
            else 
                Pic_Addr_Reg <= 8'h00;
        end
        
		else if(Curr_St == S3)begin
			if(Score_L > Score_R)begin
				row_1 <= "Left Wins       ";
				row_2 <= "Congratulations!";
				if(Dat_4Hz == 4'h0)
				Pic_Addr_Reg <= 8'h09;
				else if(Dat_4Hz == 4'h1)
					Pic_Addr_Reg <= 8'h09;
				else if(Dat_4Hz == 4'h2)
					Pic_Addr_Reg <= 8'hFF;
				else if(Dat_4Hz == 4'h3)
					Pic_Addr_Reg <= 8'hFF;
				else
					;
			end
			else begin
				row_1 <= "Right Wins      ";
				row_2 <= "Congratulations!";
				if(Dat_4Hz == 4'h0)
				Pic_Addr_Reg <= 8'h0A;
				else if(Dat_4Hz == 4'h1)
					Pic_Addr_Reg <= 8'h0A;
				else if(Dat_4Hz == 4'h2)
					Pic_Addr_Reg <= 8'hFF;
				else if(Dat_4Hz == 4'h3)
					Pic_Addr_Reg <= 8'hFF;
				else
					;
			end
		end
		  
        else
            ;
	end

/**********************音乐播放**************************/	
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
			Music_Cnt <= 32'd0;
		else if(Music_Cnt < Music_Divider)
			Music_Cnt <= Music_Cnt + 1'd1;
		else
			Music_Cnt <= 32'd0;
	end
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)
			Tone_Now <= 0;
		else if(Music_Cnt == Music_Divider)begin
			if(Tone_Now < Music_Lenth)
				Tone_Now <= Tone_Now + 1'd1;
			else
				Tone_Now <= 8'd0;
		end
		else;
	end
	
	always@(posedge Sys_Clk)begin
		if(!Sys_Rst)
			tone <= 5'b0;
		else if(Music_En)
			tone <= music[Tone_Now];
		else 
			tone <= 5'b0;
	end
/*****************************************************/	


	
/************仅测试用，LED显示当前出拳*****************   
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst)
            ;//LED_Test <= 6'b0;
        else begin
            LED_Test[5:3] <= Reg_Player_L;
			LED_Test[2:0] <= Reg_Player_R;
		end
    end
************仅测试用，LED显示当前出拳*****************/
    debounce #(.N(1)) debounce_u1(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Ready),
        .key_pulse (key_pulse_Ready)
        );
          
    debounce #(.N(1)) debounce_u2(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Go),
        .key_pulse (key_pulse_Go)
        );
		
		debounce #(.N(1)) debounce_u3(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Player_L[0]),
        .key_pulse (key_pulse_BTN_L[0])
        );
		
		debounce #(.N(1)) debounce_u4(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Player_L[1]),
        .key_pulse (key_pulse_BTN_L[1])
        );
		
		debounce #(.N(1)) debounce_u5(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Player_L[2]),
        .key_pulse (key_pulse_BTN_L[2])
        );
		
		debounce #(.N(1)) debounce_u6(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Player_R[0]),
        .key_pulse (key_pulse_BTN_R[0])
        );
		
		debounce #(.N(1)) debounce_u7(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Player_R[1]),
        .key_pulse (key_pulse_BTN_R[1])
        );
		
		debounce #(.N(1)) debounce_u8(                               
        .clk (Sys_Clk),
        .rst (Sys_Rst),
        .R_key (BTN_Player_R[2]),
        .key_pulse (key_pulse_BTN_R[2])
        );
          
    Clk_1Hz Clk_1Hz_u(
        .Sys_Clk (Sys_Clk),
        .Sys_Rst (Sys_Rst),
        .Clk_1Hz(Clk_1Hz)
        );
		
	Dat_4Hz Dat_4Hz_u(
        .Sys_Clk (Sys_Clk),
        .Sys_Rst (Sys_Rst),
        .Dat_4Hz (Dat_4Hz)
        );
		
	Segment Segment_u(
		.Sys_Clk (Sys_Clk),
		.Sys_Rst (Sys_Rst),
		.Score_L (Score_L),
		.Score_R (Score_R),
		.Segment (Segment),
		.Scan    (Scan)
		);
     
	Buzzer Buzzer_u(
		.Sys_Clk   (Sys_Clk),
		.Sys_Rst   (Sys_Rst),
		.tone	   (tone),
		.piano_out (piano_out)
		);
		
	LCD1602 LCD1602_u(
		.Sys_Clk (Sys_Clk),
		.Sys_Rst (Sys_Rst),
		.row_1	 (row_1),
		.row_2	 (row_2),
		.lcd_en	 (lcd_en),
		.lcd_rw	 (lcd_rw),
		.lcd_rs	 (lcd_rs),
		.DATA_BUS(DATA_BUS),
		.Score_L (Score_L),
		.Score_R (Score_R),
		.Score_L_Char(Score_L_Char),
		.Score_R_Char(Score_R_Char)
		);
		
	Gen_Rand Gen_Rand_u(
		.Sys_Clk (Sys_Clk),
		.Sys_Rst (Sys_Rst),
		.Rand_3bits (Rand_3bits)
		);
	 
endmodule

/*********************时钟分频****************************/
module Clk_1Hz(
    input Sys_Clk,
    input Sys_Rst,
    output reg Clk_1Hz
    );
    
    parameter Divider = 32'h17D7840;
    
    reg [31:0] Cnt;
    
    initial
        Clk_1Hz<=1'b0;
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if (!Sys_Rst)
            Cnt<=32'h0;
        else if(Cnt<Divider)
            Cnt<=Cnt+1'b1;
        else 
            Cnt<=32'h0;
    end
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst)
            Clk_1Hz<=1'b0;
        else if(Cnt==Divider)
            Clk_1Hz<=~Clk_1Hz;
        else
            Clk_1Hz<=Clk_1Hz;
    end
    
endmodule

module Dat_4Hz(
    input Sys_Clk,
    input Sys_Rst,
    output reg [1:0] Dat_4Hz//开机界面图片地址切换寄存器
    );
    
    parameter Divider = 32'h5B8D80;
    
    reg [31:0] Cnt_4Hz;//4Hz开机界面计数器
	
    initial
        Cnt_4Hz <= 32'h0;
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if (!Sys_Rst)
            Cnt_4Hz <= 32'h0;
        else if(Cnt_4Hz<Divider)
            Cnt_4Hz <= Cnt_4Hz + 1'b1;
        else 
            Cnt_4Hz <= 32'h0;
    end
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst)
            Dat_4Hz <= 2'b0;
        else if(Cnt_4Hz == Divider)
            Dat_4Hz <= Dat_4Hz + 1'b1;
        else
            Dat_4Hz <= Dat_4Hz;
    end
endmodule

/************开关图片显示测试************/
//module Test_Sw(
//    output [7:0] Pic_Addr
//    );
//    
//    reg [7:0] Reg_Pic_Addr;
//    initial
//        Reg_Pic_Addr<=8'h07;
//    assign Pic_Addr = Reg_Pic_Addr;
//    
//endmodule
/************开关图片显示测试************/