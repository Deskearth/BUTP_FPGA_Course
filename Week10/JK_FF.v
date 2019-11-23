module JK_FF (
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
