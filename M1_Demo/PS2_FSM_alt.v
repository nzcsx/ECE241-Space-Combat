module keyboard_FSM_alt(HEX0, clk,reset,ps2_key_pressed,ps2_key_data,enable);
	output [6:0] HEX0;//newly
	input 				clk;
	input					reset;
	input 				ps2_key_pressed;
	input 		[7:0]	ps2_key_data;
	output reg	 		enable;
	
	reg done_received;
	
	reg [4:0] current_state, next_state;
	
	localparam 	wait_state=2'b00, pre_state=2'b01, start_state=2'b10;
	
	
	
	//state change according to input
	reg [27:0] count;
	always@(*)
	begin
		case(current_state)//how bout
			wait_state:		next_state=(ps2_key_data==8'hf0)?pre_state:wait_state;
			pre_state:		next_state=(ps2_key_data==8'hf0)?pre_state:start_state;
			start_state:	next_state=wait_state;
			default: 		next_state=wait_state;
		endcase
	end
	
	
	
	
	//enable signals 
	always@(*)
	begin
		case(current_state)
			wait_state:		enable=0;
			pre_state:		enable=0;
			start_state:	enable=1;
			default: 		enable=0;
		endcase
	end
	
	
	
	//state change
	always @(posedge clk)
	begin
		if (reset == 0)
			current_state <= wait_state;
		else
			current_state <= next_state;
	end 
	
	
	
	Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(current_state[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX0)
	);
endmodule
