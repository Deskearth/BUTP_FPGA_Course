module LCD1602(
    input Sys_Clk,
    input Sys_Rst,
	input [127:0] row_1,
	input [127:0] row_2,
	input [3:0] Score_L,
	input [3:0] Score_R,
    output lcd_en,
    output lcd_rw,  //因为只执行写操作，所以永远为0.
    output reg lcd_rs,
    output reg [7:0] DATA_BUS,
	output reg [7:0] Score_L_Char,//输出翻译后的L编码
	output reg [7:0] Score_R_Char//输出翻译后的R编码
    );
	
reg  [5:0]    Curr_St ;
reg  [5:0]    Next_St ;

parameter TIME_20MS = 1000_000 ;

parameter TIME_500HZ= 100_000  ;
 
parameter Prepare=8'h00;//数据线拉低（0x00）                     
parameter Set_Function=8'h01;//设定功能指令，显示两行，每个字符5x7，数据总线为8位(0x38)       
parameter Disp_Off=8'h03;//显示功能关闭,无光标，光标不闪烁(0x08)
parameter Disp_Clear=8'h02;//清屏指令(0x01)
parameter Entry_Mode=8'h06;//写入新数据后光标后移，显示屏不移动(0x06)
parameter Disp_On=8'h07;//显示功能开启，无光标，光标不闪烁(0x0c)
parameter Row1_Addr=8'h05;//显示位置（0,0）（0x80）      
parameter Row1_0=8'h04;//光标跳转到第一行第一个字符00+80（0x80）
parameter Row1_1=8'h0C;parameter Row1_2=8'h0D;
parameter Row1_3=8'h0F;parameter Row1_4=8'h0E;
parameter Row1_5=8'h0A;parameter Row1_6=8'h0B;
parameter Row1_7=8'h09;parameter Row1_8=8'h08;
parameter Row1_9=8'h18;parameter Row1_A=8'h19;
parameter Row1_B=8'h1B;parameter Row1_C=8'h1A;
parameter Row1_D=8'h1E;parameter Row1_E=8'h1F;
parameter Row1_F=8'h1D  ;

parameter Row2_ADDR=8'h1C  ;//光标跳转到第二行第一个字符40+80(1,0)(0xC0)
parameter Row2_0=8'h14;parameter Row2_1=8'h15;
parameter Row2_2=8'h17;parameter Row2_3=8'h16;
parameter Row2_4=8'h12;parameter Row2_5=8'h13;
parameter Row2_6=8'h11;parameter Row2_7=8'h10;
parameter Row2_8=8'h30;parameter Row2_9=8'h31;
parameter Row2_A=8'h33;parameter Row2_B=8'h32;
parameter Row2_C=8'h36;parameter Row2_D=8'h37;
parameter Row2_E=8'h35;parameter Row2_F=8'h34;


//上电后延时20ms
reg [19:0] cnt_20ms ;
always  @(posedge Sys_Clk or negedge Sys_Rst)begin
    if(Sys_Rst==1'b0)begin
        cnt_20ms<=0;
    end
    else if(cnt_20ms == TIME_20MS -1)begin
        cnt_20ms<=cnt_20ms;
    end
    else
        cnt_20ms<=cnt_20ms + 1 ;
end
wire delay_done = (cnt_20ms==TIME_20MS-1)? 1'b1 : 1'b0 ;

//指令延时20ms
reg [19:0] Cnt_500Hz;
always  @(posedge Sys_Clk or negedge Sys_Rst)begin
    if(Sys_Rst==1'b0)begin
        Cnt_500Hz <= 0;
    end
    else if(delay_done==1)begin
        if(Cnt_500Hz== TIME_500HZ - 1)
            Cnt_500Hz<=0;
        else
            Cnt_500Hz<=Cnt_500Hz + 1 ;
    end
    else
        Cnt_500Hz<=0;
end

assign lcd_en = (Cnt_500Hz>(TIME_500HZ-1)/2)? 1'b0 : 1'b1;  //下降沿的时候写入指令
assign write_flag = (Cnt_500Hz==TIME_500HZ - 1) ? 1'b1 : 1'b0 ;

always  @(posedge Sys_Clk or negedge Sys_Rst)begin
    if(Sys_Rst==1'b0)begin
        Curr_St <= Prepare    ;
    end
    else if(write_flag==1) begin
        Curr_St<= Next_St  ;
    end
    else
        Curr_St<=Curr_St   ;
end

always  @(*)begin//下一状态跳转：
    case (Curr_St)
		Prepare: Next_St = Set_Function;
		Set_Function: Next_St = Disp_Off;
		Disp_Off: Next_St = Disp_Clear;
		Disp_Clear: Next_St = Entry_Mode;
		Entry_Mode: Next_St = Disp_On;
		Disp_On : Next_St = Row1_Addr;
		Row1_Addr: Next_St = Row1_0;
		Row1_0: Next_St = Row1_1;
		Row1_1: Next_St = Row1_2;
		Row1_2: Next_St = Row1_3;
		Row1_3: Next_St = Row1_4;
		Row1_4: Next_St = Row1_5;
		Row1_5: Next_St = Row1_6;
		Row1_6: Next_St = Row1_7;
		Row1_7: Next_St = Row1_8;
		Row1_8: Next_St = Row1_9;
		Row1_9: Next_St = Row1_A;
		Row1_A: Next_St = Row1_B;
		Row1_B: Next_St = Row1_C;
		Row1_C: Next_St = Row1_D;
		Row1_D: Next_St = Row1_E;
		Row1_E: Next_St = Row1_F;
		Row1_F: Next_St = Row2_ADDR;

		Row2_ADDR: Next_St = Row2_0;
		Row2_0: Next_St = Row2_1;
		Row2_1: Next_St = Row2_2;
		Row2_2: Next_St = Row2_3;
		Row2_3: Next_St = Row2_4;
		Row2_4: Next_St = Row2_5;
		Row2_5: Next_St = Row2_6;
		Row2_6: Next_St = Row2_7;
		Row2_7: Next_St = Row2_8;
		Row2_8: Next_St = Row2_9;
		Row2_9: Next_St = Row2_A;
		Row2_A: Next_St = Row2_B;
		Row2_B: Next_St = Row2_C;
		Row2_C: Next_St = Row2_D;
		Row2_D: Next_St = Row2_E;
		Row2_E: Next_St = Row2_F;
		Row2_F: Next_St = Row1_Addr;
		default: Next_St = Next_St;
    endcase 
   end   

   assign lcd_rw = 0;
   always  @(posedge Sys_Clk or negedge Sys_Rst)begin
       if(Sys_Rst==1'b0)begin
           lcd_rs <= 0 ;
       end
       else if(write_flag == 1)begin
           if((Next_St==Set_Function)||(Next_St==Disp_Off)||
              (Next_St==Disp_Clear)||(Next_St==Entry_Mode)||
              (Next_St==Disp_On ) ||(Next_St==Row1_Addr)||
              (Next_St==Row2_ADDR))begin
           lcd_rs<=0 ;
           end 
           else  begin
           lcd_rs<= 1;
           end
       end
       else begin
           lcd_rs<=lcd_rs;
       end     
   end                   

    always  @(posedge Sys_Clk or negedge Sys_Rst)begin//状态机输出
        if(Sys_Rst==1'b0)begin
			DATA_BUS<=0 ;
        end
        else  if(write_flag)begin
            case(Next_St)
				Prepare: DATA_BUS <= 8'h00;
				Set_Function: DATA_BUS <= 8'h38;
				Disp_Off: DATA_BUS <= 8'h08;
				Disp_Clear: DATA_BUS <= 8'h01;
				Entry_Mode: DATA_BUS <= 8'h06;
				Disp_On   : DATA_BUS <= 8'h0c;
				Row1_Addr: DATA_BUS <= 8'h80;
				Row1_0: DATA_BUS <= row_1 [127:120];
				Row1_1: DATA_BUS <= row_1 [119:112];
				Row1_2: DATA_BUS <= row_1 [111:104];
				Row1_3: DATA_BUS <= row_1 [103: 96];
				Row1_4: DATA_BUS <= row_1 [ 95: 88];
				Row1_5: DATA_BUS <= row_1 [ 87: 80];
				Row1_6: DATA_BUS <= row_1 [ 79: 72];
				Row1_7: DATA_BUS <= row_1 [ 71: 64];
				Row1_8: DATA_BUS <= row_1 [ 63: 56];
				Row1_9: DATA_BUS <= row_1 [ 55: 48];
				Row1_A: DATA_BUS <= row_1 [ 47: 40];
				Row1_B: DATA_BUS <= row_1 [ 39: 32];
				Row1_C: DATA_BUS <= row_1 [ 31: 24];
				Row1_D: DATA_BUS <= row_1 [ 23: 16];
				Row1_E: DATA_BUS <= row_1 [ 15:  8];
				Row1_F: DATA_BUS <= row_1 [  7:  0];

				Row2_ADDR: DATA_BUS <= 8'hc0;
				Row2_0: DATA_BUS <= row_2 [127:120];
				Row2_1: DATA_BUS <= row_2 [119:112];
				Row2_2: DATA_BUS <= row_2 [111:104];
				Row2_3: DATA_BUS <= row_2 [103: 96];
				Row2_4: DATA_BUS <= row_2 [ 95: 88];
				Row2_5: DATA_BUS <= row_2 [ 87: 80];
				Row2_6: DATA_BUS <= row_2 [ 79: 72];
				Row2_7: DATA_BUS <= row_2 [ 71: 64];
				Row2_8: DATA_BUS <= row_2 [ 63: 56];
				Row2_9: DATA_BUS <= row_2 [ 55: 48];
				Row2_A: DATA_BUS <= row_2 [ 47: 40];
				Row2_B: DATA_BUS <= row_2 [ 39: 32];
				Row2_C: DATA_BUS <= row_2 [ 31: 24];
				Row2_D: DATA_BUS <= row_2 [ 23: 16];
				Row2_E: DATA_BUS <= row_2 [ 15:  8];
				Row2_F: DATA_BUS <= row_2 [  7:  0];
			endcase                     
		end
    else
        DATA_BUS<=DATA_BUS ;
    end
   
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)begin
			Score_L_Char <= 4'd0;
		end
		else if(Score_L == 4'd0)
			Score_L_Char <= "0";
		else if(Score_L == 4'd1)
			Score_L_Char <= "1";
		else if(Score_L == 4'd2)
			Score_L_Char <= "2";
		else if(Score_L == 4'd3)
			Score_L_Char <= "3";
		else
			Score_L_Char<="e";
	end
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)begin
			Score_R_Char <= 4'd0;
		end
		else if(Score_R == 4'd0)
			Score_R_Char <= "0";
		else if(Score_R == 4'd1)
			Score_R_Char <= "1";
		else if(Score_R == 4'd2)
			Score_R_Char <= "2";
		else if(Score_R == 4'd3)
			Score_R_Char <= "3";
		else
			Score_R_Char<="e";
	end

endmodule 