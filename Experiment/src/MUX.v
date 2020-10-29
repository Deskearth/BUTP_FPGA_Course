module MUX(
    input wire [7:0] Pic_Addr,
    input Sys_Clk,
    input Sys_Rst,
    output reg [63:0] MUX_COL
    );

    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst)
            MUX_COL<=64'h0;
        else if(Pic_Addr==8'h00)begin//左石头右石头   地址：0x00
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h42;MUX_COL[31:24]<=8'hE7;
            MUX_COL[39:32]<=8'hE7;MUX_COL[47:40]<=8'h42;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;
        end
        else if(Pic_Addr==8'h01)begin//左石头右剪刀   地址：0x01
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h22;MUX_COL[31:24]<=8'hC7;
            MUX_COL[39:32]<=8'hC7;MUX_COL[47:40]<=8'h22;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end
        else if(Pic_Addr==8'h02)begin//左石头右布    地址：0x02
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'hE2;MUX_COL[31:24]<=8'hE7;
            MUX_COL[39:32]<=8'hE7;MUX_COL[47:40]<=8'hE2;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end
        else if(Pic_Addr==8'h03)begin//左剪刀右石头   地址：0x03
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h44;MUX_COL[31:24]<=8'hE3;
            MUX_COL[39:32]<=8'hE3;MUX_COL[47:40]<=8'h44;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end 
        else if(Pic_Addr==8'h04)begin//左剪刀右剪刀   地址：0x04
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h24;MUX_COL[31:24]<=8'hC3;
            MUX_COL[39:32]<=8'hC3;MUX_COL[47:40]<=8'h24;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;
        end
        else if(Pic_Addr==8'h05)begin//左剪刀右布   地址：0x05
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'hE4;MUX_COL[31:24]<=8'hE3;
            MUX_COL[39:32]<=8'hE3;MUX_COL[47:40]<=8'hE4;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end    
        else if(Pic_Addr==8'h06)begin//左布右石头   地址：0x06
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h47;MUX_COL[31:24]<=8'hE7;
            MUX_COL[39:32]<=8'hE7;MUX_COL[47:40]<=8'h47;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end  
        else if(Pic_Addr==8'h07)begin//左布右剪刀   地址：0x07
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h27;MUX_COL[31:24]<=8'hC7;
            MUX_COL[39:32]<=8'hC7;MUX_COL[47:40]<=8'h27;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end  
        else if(Pic_Addr==8'h08)begin//左布右布   地址：0x08
            MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'hE7;MUX_COL[31:24]<=8'hE7;
            MUX_COL[39:32]<=8'hE7;MUX_COL[47:40]<=8'hE7;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;            
        end
		else if(Pic_Addr==8'h09)begin//甲胜利	  地址：0x09
			MUX_COL[7 :0 ]<=8'h08;MUX_COL[15:8 ]<=8'h08;
            MUX_COL[23:16]<=8'h08;MUX_COL[31:24]<=8'h3E;
            MUX_COL[39:32]<=8'h2A;MUX_COL[47:40]<=8'h3E;
            MUX_COL[55:48]<=8'h2A;MUX_COL[63:56]<=8'h3E;
		end
		else if(Pic_Addr==8'h0A)begin//乙胜利	  地址：0x0A
			MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h7C;
            MUX_COL[23:16]<=8'h042;MUX_COL[31:24]<=8'h04;
            MUX_COL[39:32]<=8'h08;MUX_COL[47:40]<=8'h10;
            MUX_COL[55:48]<=8'h20;MUX_COL[63:56]<=8'h7E;
		end
		else if(Pic_Addr==8'h0B)begin//开机界面0  地址：0x0B
			MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h00;MUX_COL[31:24]<=8'h18;
            MUX_COL[39:32]<=8'h18;MUX_COL[47:40]<=8'h00;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;
		end
		else if(Pic_Addr==8'h0C)begin//开机界面1  地址：0x0C
			MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h00;
            MUX_COL[23:16]<=8'h3C;MUX_COL[31:24]<=8'h24;
            MUX_COL[39:32]<=8'h24;MUX_COL[47:40]<=8'h3C;
            MUX_COL[55:48]<=8'h00;MUX_COL[63:56]<=8'h00;
		end
		else if(Pic_Addr==8'h0D)begin//开机界面2  地址：0x0D
			MUX_COL[7 :0 ]<=8'h00;MUX_COL[15:8 ]<=8'h7E;
            MUX_COL[23:16]<=8'h42;MUX_COL[31:24]<=8'h42;
            MUX_COL[39:32]<=8'h42;MUX_COL[47:40]<=8'h42;
            MUX_COL[55:48]<=8'h7E;MUX_COL[63:56]<=8'h00;
		end
		else if(Pic_Addr==8'h0E)begin//开机界面3  地址：0x0E
			MUX_COL[7 :0 ]<=8'hFF;MUX_COL[15:8 ]<=8'h81;
            MUX_COL[23:16]<=8'h81;MUX_COL[31:24]<=8'h81;
            MUX_COL[39:32]<=8'h81;MUX_COL[47:40]<=8'h81;
            MUX_COL[55:48]<=8'h81;MUX_COL[63:56]<=8'hFF;
		end
        else if(Pic_Addr==8'hFF)     //息屏       地址：0xFF
            MUX_COL[63:0]<=64'h0;
        else//其他情况不显示
            MUX_COL[63:0]<=64'h0;
    end
    
endmodule 