module Key_Cnt(
	input Sys_Clk,
	input Sys_Rst,
	input Key_Up,
	input Key_Down,
	output reg LED_R,
	output reg LED_G,
	output [8:0] seg_led_1,
	output [8:0] seg_led_2
	);
	
	reg  [7:0] Key_Cnt;
	wire [0:0] Key_Pulse_Up;
	wire [0:0] Key_Pulse_Down;
	reg  [3:0] Ones;
	reg	 [3:0] Tens;
	
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)begin
			Key_Cnt <= 8'd0;
			LED_R <= 1'b1;
			LED_G <= 1'b1;		
		end
		
		else if(Key_Pulse_Up)begin
			Key_Cnt <= Key_Cnt + 8'd1;
			LED_R <= 1'b1;
			LED_G <= 1'b0;
			if(Key_Cnt == 8'd100)
				Key_Cnt <= 8'd0;
		end
		
		else if(Key_Pulse_Down)begin
			Key_Cnt <= Key_Cnt - 8'd1;
			LED_R <= 1'b0;
			LED_G <= 1'b1;
			if(Key_Cnt == 8'd0)
				Key_Cnt <= 8'd0;
		end
		
		else
			Key_Cnt <= Key_Cnt;
	end
	
	always@(posedge Sys_Clk or negedge Sys_Rst)begin
		if(!Sys_Rst)begin
			Ones <= 4'd0;
			Tens <= 4'd0;
		end
		else begin
			Tens <= Key_Cnt / 8'd10;
			Ones <= Key_Cnt % 8'd10;
		end
	end
	
	debounce debounce_u1(
		.clk		(Sys_Clk),
		.rst		(Sys_Rst),
		.key		(Key_Up),
		.key_pulse  (Key_Pulse_Up)
		);
		
	debounce debounce_u2(
		.clk		(Sys_Clk),
		.rst		(Sys_Rst),
		.key		(Key_Down),
		.key_pulse  (Key_Pulse_Down)
		);
		
	LED LED_u(
		.seg_data_1	(Tens),
		.seg_data_2	(Ones),
		.seg_led_1	(seg_led_1),
		.seg_led_2	(seg_led_2)
		);
	
endmodule

