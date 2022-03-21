module moves_FSM (clk, resetn, kick_in, punch_in, crouch_in, jump_in, go_state);
	input clk, resetn, kick_in, punch_in, crouch_in, jump_in;
	output [3:0] go_state;
	assign	go_state = current_state;

	//declare four states
	localparam idle_state= 3'b000, kicking_state = 3'b001, punching_state = 3'b010, crouching_state = 3'b011, jumping_state = 3'b100, sweeping_state = 3'b101, jumpkicking_state=3'b110;

	reg [2:0] current_state=idle_state;
	reg [2:0] next_state;
	
	//TRY THIS NOW!!!
	//state transition
	always@(*)
		begin: state_table
			case (current_state)
				idle_state:   
				begin
					if (kick_in) 		next_state = kicking_state;
					else if (punch_in) next_state = punching_state;
					else if (crouch_in) next_state = crouching_state;
					else if (jump_in) next_state = jumping_state;
					else next_state=idle_state;
				end
				kicking_state:
				begin
					if (crouch_in) next_state = crouching_state;
					else if (jump_in) next_state = jumping_state;
					else if (kick_in) next_state = kicking_state;
					else next_state =  idle_state;
				end
				punching_state:
				begin
					if (crouch_in) next_state = crouching_state;
					else if (jump_in) next_state = jumping_state;
					else if (punch_in) next_state = punching_state;
					else next_state =  idle_state;
				end
				crouching_state:
				begin
					if (kick_in) next_state = sweeping_state;
					else if (crouch_in) next_state = crouching_state;
					else next_state =  idle_state;
				end
				jumping_state:
				begin
					if (kick_in) next_state = jumpkicking_state;
					else if (jump_in) next_state = jumping_state;
					else next_state =  idle_state;
				end
				sweeping_state:
				begin
					if (kick_in) next_state = sweeping_state;
					else next_state =  idle_state;
				end
				jumpkicking_state:
				begin 
					if (kick_in) next_state = jumpkicking_state;
					else next_state =  idle_state;
				end
				default: next_state = idle_state;
			endcase
		end
	
	
	//the actual state changes according to the clock edge
	always @(posedge clk)
    begin: state_FFs
         if(resetn == 0)
					current_state <= idle_state;
			else
					current_state <= next_state;
    end

	
endmodule
