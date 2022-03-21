module datapath (HEX3,HEX2,HEX1,HEX0, clk_50, resetn, key_pressed_data, button_pressed_data, colour_out, go_reset, go_bkgd, go_draw, go_wait, go_update, go_erase, go_win, done_draw, done_wait, done_game, x_out, y_out);
	output [6:0] HEX3; //newly
	output [6:0] HEX2; //newly
	output [6:0] HEX1; //newly
	output [6:0] HEX0; //newly
	input clk_50;
	input resetn;
	input [7:0]key_pressed_data; 	//newly declared
	input [2:0]button_pressed_data;
	input go_reset;
	input go_bkgd;
	input go_draw;
	input go_wait;
	input go_update;
	input go_erase;
	input go_win;
	output reg [8:0]colour_out;
	output done_draw;
	output done_wait;
	output reg done_game=0;
	output reg [7:0]x_out;
	output reg [6:0]y_out;
	
	
	//wait-block
	reg [7:0] key_update_data=8'h00;
	reg [2:0] button_update_data=3'b111;
	reg [27:0]out=28'd9999999;
	always@(posedge clk_50)
	begin
		if(!resetn)
		begin
			out<=28'd9999999;
			key_update_data=8'h00;
			button_update_data=3'b111;
		end
		else if (go_wait)
		begin
			if (out[27:0]==28'd0)
				out<=28'd9999999;
			else
				out<=out-1;
			
			if (out[27:0]==28'd9999999)
			begin
				key_update_data=8'h00;
				button_update_data=3'b111;
			end
			else 
			begin
				if (key_pressed_data!=8'h00)//change
					key_update_data<=key_pressed_data;
				if (button_pressed_data!=3'b111)
					button_update_data<=button_pressed_data;
			end
		end
	end
	assign done_wait = (out==28'd0) ? 1:0;
	
	
	//player1 horizontal update-block
	localparam kick_key=8'h3b, punch_key=8'h4b, jump_key=8'h1d, crouch_key=8'h1b, left_key=8'h1c, right_key=8'h23;
	reg [7:0] x_start1=8'd1;
	reg [6:0] y_start1=7'd0;
	always@(posedge clk_50)
	begin
		if (!resetn)
		begin
				x_start1=8'd1;
				y_start1=7'd0;
		end
		else if (go_update && (key_update_data==left_key)  && ((x_start1-1)>0))
			x_start1<=x_start1-1;
		else if (go_update && (key_update_data==right_key) && ((x_start1+1)<=117) 	&& ((x_start1+1)<=(x_start2-44)))
			x_start1<=x_start1+1;
	end
	
	//player2 horizontal update-block
	localparam kick_button = 3'b000, punch_button = 3'b001, jump_button = 3'b010, crouch_button = 3'b011, left_button = 3'b100, right_button = 3'b101;
	reg [7:0] x_start2=8'd115;
	reg [6:0] y_start2=7'd0;
	always@(posedge clk_50)
	begin
		if (!resetn)
		begin
				x_start2=8'd115;
				y_start2=7'd0;
		end
		else if (go_update && (button_update_data==left_button) && ((x_start2-1)>0) 	&& x_start1<=(x_start2-1-44))
			x_start2<=x_start2-1;
		else if (go_update && (button_update_data==right_button)&& (x_start2+1)<=117)
			x_start2<=x_start2+1;
	end
	
	
	reg [1:0] GameState=0;
	localparam no_wins=2'b00, player1_wins=2'b10, player2_wins=2'b01;
	always@(*)
	begin
		if (go_reset)
		begin
			GameState=no_wins;
			done_game=0;
		end
		else if (player1_health==40)
		begin
			GameState=player1_wins;
			done_game=1;
		end
		else if (player2_health==40)
		begin
			GameState=player2_wins;
			done_game=1;
		end
		else
			done_game=0;
	end

	
	//draw-block and erase-block: x,y
	reg [14:0]screen_temp;
	reg [14:0]bkgd0_temp;
	reg [13:0]temp;
	reg [14:0]win_temp;
	always@(posedge clk_50)
	begin
		if(!go_draw)
		begin
				temp<=8800;
				screen_temp<=19200;
				bkgd0_temp<=19200;
				win_temp<=19200;
				x_out <= x_start1;
				y_out <= y_start1;
		end
		else if (go_draw)
		begin
			//in reset state
			if (go_reset)
			begin
				if (screen_temp!=0) 
				begin
					screen_temp <= screen_temp-1;
					x_out <= (screen_temp-1)%160;
					y_out <= (screen_temp-1)/160;
				end
				else if(screen_temp==0)
					screen_temp<=19200;
			end
			//in bkgd state
			else if (go_bkgd)
			begin
				if (bkgd0_temp!=0) 
				begin
					bkgd0_temp <= bkgd0_temp-1;
					x_out <= (bkgd0_temp-1)%160;
					y_out <= (bkgd0_temp-1)/160;
				end
				else if(bkgd0_temp==0)
					bkgd0_temp<=19200;
			end
			//not in those state
			else if (!go_reset && !go_bkgd && !go_win)
			begin
				if (temp!=0) temp <= temp-1;
				
				if(temp > 4400)
				begin
					x_out <= x_start1 + (temp-1-4400)%44;
					y_out <= y_start1 + (temp-1-4400)/44;
				end
				else if (temp <= 4400)
				begin
					x_out <= x_start2 + (temp-1)%44;
					y_out <= y_start2 + (temp-1)/44;
				end
			end
			else if (go_win)
			begin
				if (win_temp!=0) 
				begin
					win_temp <= win_temp-1;
					x_out <= (win_temp-1)%160;
					y_out <= (win_temp-1)/160;
				end
				else if(win_temp==0)
					win_temp<=19200;
			end
		end
	end

	//Hexadecimal_To_Seven_Segment debug3(x_start1[6:4],HEX2);
	//Hexadecimal_To_Seven_Segment debug2(x_start1[3:0],HEX2);
	//Hexadecimal_To_Seven_Segment debug1(y_start1[6:4],HEX1);
	//Hexadecimal_To_Seven_Segment debug0(y_start1[3:0],HEX0);
	
	
	//draw-block and erase-block: color_selection
	wire [3:0] player1_state, player2_state;
	wire [5:0] player1_health,player2_health;
	wire [7:0] dist_between;
	assign dist_between=(x_start2-x_start1-44);
	moves_top m_t1 (
	.clk(clk_50), .resetn(resetn), 
	.kick_in_1(key_update_data==8'h3b), .punch_in_1(key_update_data==8'h4b), .crouch_in_1(key_update_data==8'h1b), .jump_in_1(key_update_data==8'h1d), 
	.kick_in_2(button_update_data==kick_button), .punch_in_2(button_update_data==punch_button), .crouch_in_2(button_update_data==crouch_button), .jump_in_2(button_update_data==jump_button), 
	.distance(), 
	.p1_health1(), .p1_health0(), .p2_health1(), .p2_health0(),
	.player1_state_out(player1_state), .player2_state_out(player2_state),
	.player1_health_out(), .player2_health_out());
	
	moves_top m_t2 (
	.clk(done_wait), .resetn(resetn), 
	.kick_in_1(key_update_data==8'h3b), .punch_in_1(key_update_data==8'h4b), .crouch_in_1(key_update_data==8'h1b), .jump_in_1(key_update_data==8'h1d), 
	.kick_in_2(button_update_data==kick_button), .punch_in_2(button_update_data==punch_button), .crouch_in_2(button_update_data==crouch_button), .jump_in_2(button_update_data==jump_button), 
	.distance(dist_between), 
	.p1_health1(HEX3), .p1_health0(HEX2), .p2_health1(HEX1), .p2_health0(HEX0),
	.player1_state_out(), .player2_state_out(),
	.player1_health_out(player1_health), .player2_health_out(player2_health));
	//sprite colors
	reg [8:0] sprite_color;
		//	p1 colors	
	wire [12:0] sprite_pixel_address;
	assign sprite_pixel_address=(temp>4400)?(temp-4400-1):(temp-1);	
	wire [8:0] sprite1_idle_color;
	wire [8:0] sprite1_kicking_color;
	wire [8:0] sprite1_punching_color;
	wire [8:0] sprite1_crouching_color;
	wire [8:0] sprite1_jumping_color;
	wire [8:0] sprite1_sweeping_color;
	wire [8:0] sprite1_jumpkicking_color;
	sprite1_idle_rom m12( sprite_pixel_address, clk_50, sprite1_idle_color);
	sprite1_kicking_rom m13( sprite_pixel_address, clk_50, sprite1_kicking_color);
	sprite1_punching_rom m14( sprite_pixel_address, clk_50, sprite1_punching_color);
	sprite1_crouching_rom m15( sprite_pixel_address, clk_50, sprite1_crouching_color);
	sprite1_jumping_rom m16( sprite_pixel_address, clk_50, sprite1_jumping_color);
	sprite1_sweeping_rom m17( sprite_pixel_address, clk_50, sprite1_sweeping_color);
	sprite1_jumpkicking_rom m18( sprite_pixel_address, clk_50, sprite1_jumpkicking_color);
		//	p2 colors
	wire [8:0] sprite2_idle_color;
	wire [8:0] sprite2_kicking_color;
	wire [8:0] sprite2_punching_color;
	wire [8:0] sprite2_crouching_color;
	wire [8:0] sprite2_jumping_color;
	wire [8:0] sprite2_sweeping_color;
	wire [8:0] sprite2_jumpkicking_color;
	sprite2_idle_rom m22( sprite_pixel_address, clk_50, sprite2_idle_color);
	sprite2_kicking_rom m23( sprite_pixel_address, clk_50, sprite2_kicking_color);
	sprite2_punching_rom m24( sprite_pixel_address, clk_50, sprite2_punching_color);
	sprite2_crouching_rom m25( sprite_pixel_address, clk_50, sprite2_crouching_color);
	sprite2_jumping_rom m26( sprite_pixel_address, clk_50, sprite2_jumping_color);
	sprite2_sweeping_rom m27( sprite_pixel_address, clk_50, sprite2_sweeping_color);
	sprite2_jumpkicking_rom m28( sprite_pixel_address, clk_50, sprite2_jumpkicking_color);
	always@(*)
	begin
		if (temp>4400)
		begin
			case(player1_state)
				3'b000: sprite_color=sprite1_idle_color;
				3'b100: sprite_color=sprite1_jumping_color;
				3'b001: sprite_color=sprite1_kicking_color;
				3'b010: sprite_color=sprite1_punching_color;
				3'b011: sprite_color=sprite1_crouching_color;
				3'b101: sprite_color=sprite1_sweeping_color;
				3'b110: sprite_color=sprite1_jumpkicking_color;			
				default: sprite_color=sprite1_idle_color;
			endcase
		end
		else
		begin
			case(player2_state)// change to p2 ver.
				3'b000: sprite_color=sprite2_idle_color;
				3'b100: sprite_color=sprite2_jumping_color;
				3'b001: sprite_color=sprite2_kicking_color;
				3'b010: sprite_color=sprite2_punching_color;
				3'b011: sprite_color=sprite2_crouching_color;
				3'b101: sprite_color=sprite2_sweeping_color;
				3'b110: sprite_color=sprite2_jumpkicking_color;			
				default: sprite_color=sprite2_idle_color;
			endcase
		end
	end
		// background color
	wire [8:0]bkgd_color;
	wire [14:0]bkgd_pixel_address;
	assign bkgd_pixel_address=(temp>4400)?
										(y_start1 + (temp-1-4400)/44)*15'd160 	+	(x_start1 + (temp-1-4400)%44):
										(y_start2 + (temp-1)/44)*15'd160 		+	(x_start2 + (temp-1)%44);
	background_rom m3(bkgd_pixel_address, clk_50, bkgd_color);
	//start screen color
	wire [8:0]start_screen_color;
	wire [14:0]start_pixel_address;
	assign start_pixel_address=screen_temp-1;
	startscreen_rom m1(start_pixel_address, clk_50, start_screen_color);
	//background initializer color
	wire [8:0]bkgd0_color;
	wire [14:0]bkgd0_pixel_address;
	assign bkgd0_pixel_address=bkgd0_temp-1;
	background_rom m2(bkgd0_pixel_address, clk_50, bkgd0_color);
	//win color
	wire [8:0]win_color;
	wire [8:0]p1_win_color;
	wire [8:0]p2_win_color;
	wire [14:0]win_pixel_address;
	assign win_pixel_address=win_temp-1;
	p1_win_rom wm1(win_pixel_address, clk_50, p1_win_color);
	p2_win_rom wm2(win_pixel_address, clk_50, p2_win_color);
	assign win_color=(GameState==player1_wins)?p1_win_color:p2_win_color;

	//final colour selection
	always@(*)
	begin
		if (go_reset)															colour_out = start_screen_color;
		else if (go_bkgd)														colour_out = bkgd0_color;
		else if (go_win)														colour_out = win_color;
		else if (go_erase || sprite_color==9'b0)						colour_out = bkgd_color;
		else																		colour_out = sprite_color;
	end
	
	assign done_draw =(temp==0 || screen_temp==0 || bkgd0_temp==0);
endmodule
