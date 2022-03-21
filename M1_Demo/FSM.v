module FSM (clk, resetn, start_key, done_draw, done_wait, done_game, go_reset, go_bkgd, go_draw, go_wait, go_update, go_erase, go_win);
	input clk;
	input	resetn;
	input start_key;
	input done_draw;
	input	done_wait;
	input done_game;
	output reg go_reset;
	output reg go_bkgd;
	output reg go_draw;
	output reg go_wait;
	output reg go_update;
	output reg go_erase;
	output reg go_win;
	

	//declare four states
	localparam reset_state= 4'b0000, bkgd_state=4'b0101, draw_state = 4'b0001, wait_state = 4'b0010, update_state = 4'b0011, erase_state = 4'b0100, win_state = 4'b0110;

	reg [3:0] current_state = reset_state, next_state;
	
	//state transition
	always@(*)
		begin: state_table
			case (current_state)
				reset_state:   next_state = start_key ? bkgd_state : reset_state;
				bkgd_state:		next_state = done_draw ? draw_state : bkgd_state;
				draw_state:		next_state = done_draw ? wait_state : draw_state;
				wait_state:		next_state = done_wait ? erase_state : wait_state;
				erase_state:	next_state = done_draw ? update_state : erase_state;
				update_state:	next_state = done_game ?  win_state : draw_state;
				win_state:		next_state = win_state;
			endcase
		end 

	//signal changes in each state
	always @(*) 
		begin: enable_signals
			go_reset=1;
			go_bkgd=0;
			go_draw=0;
			go_wait=0;
			go_update=0;
			go_erase=0;
			go_win=0;
			case (current_state)
				reset_state: 
					begin
						go_reset=1;
						go_bkgd=0;
						go_draw=1;
						go_wait=0;
						go_erase=0;
						go_update=0;
						go_win=0;
					end
				bkgd_state: 
					begin
						go_reset=0;
						go_bkgd=1;
						go_draw=1;
						go_wait=0;
						go_erase=0;
						go_update=0;
						go_win=0;
					end
				draw_state:	
					begin
						go_reset=0;
						go_bkgd=0;
						go_draw=1;
						go_wait=0;
						go_erase=0;
						go_update=0;
						go_win=0;
					end	
				wait_state:	
					begin
						go_reset=0;
						go_bkgd=0;
						go_draw=0;
						go_wait=1;
						go_erase=0;
						go_update=0;
						go_win=0;
					end		
				erase_state:
					begin
						go_reset=0;
						go_bkgd=0;
						go_draw=1;
						go_wait=0;
						go_erase=1;
						go_update=0;
						go_win=0;
					end
				update_state:	
					begin
						go_reset=0;
						go_bkgd=0;
						go_draw=0;
						go_wait=0;
						go_erase=0;
						go_update=1;
						go_win=0;
					end
				win_state:
					begin
						go_reset=0;
						go_bkgd=0;
						go_draw=1;
						go_wait=0;
						go_erase=0;
						go_update=0;
						go_win=1;
					end
			endcase
		end
	
	//the actual state changes according to the clock edge
	always @(posedge clk)
    begin: state_FFs
         if(resetn == 0)
					current_state <= reset_state;
			else
					current_state <= next_state;
    end 
endmodule
