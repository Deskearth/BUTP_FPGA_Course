module Buzzer
(
input					Sys_Clk,		//系统时钟
input					Sys_Rst,	//系统复位，低有效
input			[4:0]	tone,		//蜂鸣器音节控制
output	reg				piano_out	//蜂鸣器控制输出
);

reg [23:0] time_end;

always@(tone) begin
	case(tone)
		5'd0:	time_end =  24'd0;
		5'd1:	time_end =	24'd95563;	//L1,
		5'd2:	time_end =	24'd84980;	//L2,
		5'd3:	time_end =	24'd75724;	//L3,
		5'd4:	time_end =	24'd71472;	//L4,
		5'd5:	time_end =	24'd63668;	//L5,
		5'd6:	time_end =	24'd56722;	//L6,
		5'd7:	time_end =	24'd50045;	//L7,
		5'd8:	time_end =	24'd47690;	//M1,
		5'd9:	time_end =	24'd42494;	//M2,
		5'd10:	time_end =	24'd37856;	//M3,
		5'd11:	time_end =	24'd35730;	//M4,
		5'd12:	time_end =	24'd31832;	//M5,
		5'd13:	time_end =	24'd28358;	//M6,
		5'd14:	time_end =	24'd25263;	//M7,
		5'd15:	time_end =	24'd23878;	//H1,
		5'd24:	time_end =	24'd21245;	//H2,
		5'd17:	time_end =	24'd18923;	//H3,
		5'd18:	time_end =	24'd17863;	//H4,
		5'd19:	time_end =	24'd15912;	//H5,
		5'd20:	time_end =	24'd14177;	//H6,
		5'd21:	time_end =	24'd12629;	//H7,
		default:time_end =	24'd65535;	
	endcase
end
 
reg [31:0] time_cnt;
//当蜂鸣器使能时，计数器按照计数终值（分频系数）计数
always@(posedge Sys_Clk or negedge Sys_Rst) begin
	if(!Sys_Rst)
		time_cnt <= 1'b0;
	else if(time_cnt>=time_end)
		time_cnt <= 1'b0;
	else
		time_cnt <= time_cnt + 1'b1;
end
 
//根据计数器的周期，翻转蜂鸣器控制信号
always@(posedge Sys_Clk or negedge Sys_Rst) begin
	if(!Sys_Rst)
		piano_out <= 1'b0; 
	else if(tone==5'd0)
		piano_out <= 1'b0;
	else if(time_cnt==time_end && tone != 5'd0)
		piano_out <= ~piano_out;	//蜂鸣器控制输出翻转，两次翻转为1Hz
	else
		piano_out <= piano_out;
end
 
endmodule 