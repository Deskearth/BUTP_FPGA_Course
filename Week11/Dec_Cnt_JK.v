module Dec_Cnt_JK(
    input C,
    output Q0,
    output Q1,
    output Q2,
    output Q3r
    );  
    
    wire Q3;
    assign Q3r = ~Q3;
    
    reg HV;wire Vdd;initial HV<=1;  
    assign Vdd = HV;
    
    wire j1,j2,j3,k1,k2,k3;
    
    assign j1 = Q0 & Q3;
    assign j2 = Q1 & Q0;
    assign j3 = Q0 & Q1 & Q2;
    assign k1 = Q0;
    assign k2 = Q0 & ~Q1;
    assign k3 = Q0;
    
    jk_ff jk_ff_u0(
        .clk    (C),
        .q      (Q0),
        .j      (Vdd),
        .k      (Vdd)
    );
    
    jk_ff jk_ff_u1(
        .clk    (C),
        .q      (Q1),
        .j      (j1),
        .k      (k1)
    );
    
    jk_ff jk_ff_u2(
        .clk    (C),
        .q      (Q2),
        .j      (j2),
        .k      (k2)
    );
    
    jk_ff jk_ff_u3(
        .clk    (C),
        .q      (Q3),
        .j      (j3),
        .k      (k3)
    );
    
endmodule

module jk_ff (	//模块名及参数定义
input clk,j,k,rst,set,	
output reg q,
output wire qb
);
assign qb = ~q;
always@(posedge clk or negedge rst or negedge set)
begin
    if (!rst)
       q <= 1'b0;	// 异步清零
    else if (!set)
       q <= 1'b1;  	// 异步置1
     else
          case ({j,k})
              2'b00:	q <= q;	//保持
              2'b01:	q <= 0;	//置0
              2'b10:	q <= 1;	//置1
              2'b11:	q <= ~q;	//翻转
          endcase
end
endmodule
