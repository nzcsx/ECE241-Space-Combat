module keyboard_FSM(HEX3, HEX2, clk,reset,ps2_key_pressed,ps2_key_data,last_data_received_temp);
	output [6:0] HEX2;//newly
	output [6:0] HEX3;//newly
	input 				clk;
	input					reset;
	input 				ps2_key_pressed;
	input 		[7:0]	ps2_key_data;
	output reg	[7:0] last_data_received_temp;
	
	reg done_received;
	
	reg [4:0] current_state, next_state;
	
	localparam 	no_press= 5'b00000, pre_no_press= 5'b00001,
	
					A_start = 5'b00010, A_wait = 5'b00011, //Player1 left
					D_start = 5'b00100, D_wait = 5'b00101, //Player1 right
					J_start = 5'b00110, J_wait = 5'b00111, //Player2 left
					L_start = 5'b01000, L_wait = 5'b01001, //Player2 right
					
					W_start = 5'b01010, W_wait = 5'b01011, //Player1 jump
					S_start = 5'b01100, S_wait = 5'b01101,	//Player1 crouch
					I_start = 5'b01110, I_wait = 5'b01111, //Player2 jump
					K_start = 5'b10000, K_wait = 5'b10001; //Player2 crouch
	
	
	
	//state change according to input
	reg [27:0] count;
	always@(*)
	begin
		case(current_state)//how bout
			pre_no_press:
			begin
			
				if (count==28'b1111111111111111111111111111)
				begin
					next_state = no_press;
					count = 0;
				end
				else
				begin
					next_state = pre_no_press;
					count <= count+1;
				end
			/*
				if (ps2_key_pressed)
					next_state = no_press;
				else
					next_state = pre_no_press;*/
			end
			no_press:
			begin
				count=0;
				if (ps2_key_pressed)
				begin
					case(ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				end
				else
					next_state = no_press;
			end
			
			A_start:
			begin
					next_state = A_wait;
			end
			A_wait:
			begin
				if (ps2_key_data == 8'h1c)
					next_state = A_wait;
				else
					next_state = pre_no_press;
			end
			D_start:
			begin
				next_state = D_wait;
			end
			D_wait:
			begin
				if (ps2_key_data == 8'h23)
					next_state = D_wait;
				else
					next_state = pre_no_press;//
			end
			J_start:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_wait;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			J_wait:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_wait;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			L_start:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_wait;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			L_wait:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_wait;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			
			
			
			
			W_start:
			begin
					next_state = W_wait;
			end
			W_wait:
			begin
				if (ps2_key_data == 8'h1d)
					next_state = W_wait;
				else
					next_state = pre_no_press;
			end
			S_start:
			begin
					next_state = S_wait;
			end
			S_wait:
			begin
				if (ps2_key_data == 8'h1b)
					next_state = S_wait;
				else
					next_state = pre_no_press;
			end
			I_start:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_wait;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			I_wait:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_wait;
						8'h42: next_state = K_start;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			K_start:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_wait;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			K_wait:
			begin
				//if (ps2_key_pressed)
				//begin
					case (ps2_key_data)
						8'h1c: next_state = A_start;
						8'h23: next_state = D_start;
						8'h3b: next_state = J_start;
						8'h4b: next_state = L_start;
						
						8'h1d: next_state = W_start;
						8'h1b: next_state = S_start;
						8'h43: next_state = I_start;
						8'h42: next_state = K_wait;
						
						default: next_state = no_press;
					endcase
				//end
				//else
				//	next_state = no_press;
			end
			default: next_state = no_press;
		endcase
	end
	
	
	
	
	//enable signals 
	always@(*)
	begin
		case(current_state)
			pre_no_press:last_data_received_temp=8'h00;
			no_press: 	last_data_received_temp=8'h00; //no press
			A_start: 	last_data_received_temp=8'h1c;//Player1 left
			A_wait: 		last_data_received_temp=8'h00; //Player1 left
			D_start: 	last_data_received_temp=8'h23;//Player1 right
			D_wait: 		last_data_received_temp=8'h00; //Player1 right
			J_start: 	last_data_received_temp=8'h3b;//Player2 left
			J_wait: 		last_data_received_temp=8'h00; //Player2 left
			L_start: 	last_data_received_temp=8'h4b;//Player2 right
			L_wait: 		last_data_received_temp=8'h00; //Player2 right
			W_start: 	last_data_received_temp=8'h1d;//Player1 jump 
			W_wait: 		last_data_received_temp=8'h00; //Player1 jump
			S_start: 	last_data_received_temp=8'h1b;//Player1 crouch 
			S_wait: 		last_data_received_temp=8'h00; //Player1 crouch
			I_start: 	last_data_received_temp=8'h43;//Player2 jump
			I_wait: 		last_data_received_temp=8'h00; //Player2 jump
			K_start: 	last_data_received_temp=8'h42;//Player2 crouch 
			K_wait: 		last_data_received_temp=8'h00; //Player2 crouch
			default: 	last_data_received_temp=8'h00; //no press
		endcase
	end
	
	
	
	//state change
	always @(posedge clk)
	begin
		if (reset == 0)
			current_state <= no_press;
		else
			current_state <= next_state;
	end 
	
	
	
	Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(current_state[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX3)
	);
	
	Hexadecimal_To_Seven_Segment h233 (
	// Inputs
	.hex_number			(count[4:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX2)
	);
	
endmodule
