module FPGA_74HC595(
        input SH_CP,//移位时钟，上升沿有效
        input ST_CP,//数据输出时钟，上升沿有效
        input MR,//复位（低电平有效）
        input OE,//输出使能(低电平有效)
        input [0:0] DS,//串行输入
        output [7:0] Q
);
    reg [7:0] reg_Q;
    reg [7:0] temp_reg_Q;
    
    assign Q = OE ? 8'bzzzzzzzz:temp_reg_Q;
    
    always@(posedge SH_CP)begin
        reg_Q<={DS,reg_Q[7:1]};
    end
    
    always@(posedge ST_CP)begin
        temp_reg_Q<=reg_Q;
    end
    
endmodule 
