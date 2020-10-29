module Disp(
    input wire [63:0] MUX_COL,
    input wire Sys_Clk,
    input wire Sys_Rst,
    output reg [7:0] ROW,
    output reg [7:0] COL
);

    parameter Div_400_Max = 17'h1E848;//分频调节
    
    reg [17:0] Div_400;//分频计数器
    reg [3:0] Cnt_400;//扫描计数器
    
    initial begin
       ROW <= 8'hFF; 
       COL <= 8'h00;
       Div_400 <= 17'h0000;
       Cnt_400 <= 4'b0000;
    end
        
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst) 
            Div_400 <= 17'h00;
        else if(Div_400<Div_400_Max) 
            Div_400 <= Div_400 + 1'b1;
        else 
            Div_400 <= 17'h0000;
        
    end
    
    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst)
            Cnt_400 <= 4'b0000;
        else if(Div_400==Div_400_Max && Cnt_400<=4'b111)
            Cnt_400 <= Cnt_400+1'b1;
        else if(Cnt_400==4'b1000)
            Cnt_400 <= 4'b0000;
        else ;
    end

    always@(posedge Sys_Clk or negedge Sys_Rst)begin
        if(!Sys_Rst)begin
            ROW <= 8'hFF; 
            COL <= 8'h00;
        end
        else if(Cnt_400==4'b0000)begin//第0行
            ROW <= 8'hFE; 
            COL <= MUX_COL[7:0];
        end
        else if(Cnt_400==4'b0001)begin//第1行
            ROW <= 8'hFD;
            COL <= MUX_COL[15:8];
        end
        else if(Cnt_400==4'b0010)begin//第2行
            ROW <= 8'hFB;
            COL <= MUX_COL[23:16];
        end
        else if(Cnt_400==4'b0011)begin//第3行
            ROW <= 8'hF7;
            COL <= MUX_COL[31:24];
        end
        else if(Cnt_400==4'b0100)begin//第4行
            ROW <= 8'hEF;
            COL <= MUX_COL[39:32];
        end
        else if(Cnt_400==4'b0101)begin//第5行
            ROW <= 8'hDF;
            COL <= MUX_COL[47:40];
        end
        else if(Cnt_400==4'b0110)begin//第6行
            ROW <= 8'hBF;
            COL <= MUX_COL[55:48];
        end
        else if(Cnt_400==4'b0111)begin//第7行
            ROW <= 8'h7F;
            COL <= MUX_COL[63:56];
        end
        else ;
    end
    
endmodule 