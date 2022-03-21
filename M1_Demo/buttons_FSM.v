module buttons_FSM(HEX4, clk, reset, key_pressed, enable);
	output [6:0]HEX4;
	input clk, reset, key_pressed;
	output reg enable=0;
	
    reg [1:0] current_state=2'd10, next_state; 
	 
	 localparam [1:0] start_state    = 2'd00,
							wait_state     = 2'd01,
							no_press_state = 2'd10;
	
	always@(*)
	begin
		case(current_state)
			no_press_state: next_state= key_pressed?no_press_state:start_state;
			start_state:	next_state= wait_state;
			wait_state: 	next_state= key_pressed?no_press_state:wait_state;
			default: next_state=no_press_state;
		endcase
	end
	
	always @(*)
   begin: enable_signals
		case(current_state)
			no_press_state: enable = 0;
			start_state:	 enable = 1;
			wait_state: 	 enable = 0;
			default:			 enable = 0;
		endcase
	end
	
	 reg [3:0] state_change_count=0;
    always@(posedge clk)
    begin: state_FFs
        if(!reset)
		  begin
            current_state <= no_press_state;
				state_change_count=0;
			end
        else
		  begin
            current_state <= next_state;
				state_change_count<= state_change_count + ((current_state==start_state)?1:0);
			end
    end
	 
	 Hexadecimal_To_Seven_Segment debug3(state_change_count[3:0],HEX4);
endmodule 