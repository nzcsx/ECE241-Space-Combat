module top
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		SW,
		KEY,							// On Board Keys
		//VGA output
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		//p1 input
		PS2_CLK,
		PS2_DAT,
		//p2 input
		GPIO_0,
		//output
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					
	// Declare your inputs and outputs here
	input [9:0] SW;
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	inout 		PS2_CLK,
					PS2_DAT;
	input		[35:0] GPIO_0;
	output 	[6:0]	HEX0,
						HEX1,
						HEX2,
						HEX3,
						HEX4,
						HEX5;
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [8:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	assignments a1(CLOCK_50, KEY[0], colour, x, y, writeEn,
		~KEY[3],
		//refer to this when make connection
		GPIO_0[10], GPIO_0[12], GPIO_0[14], GPIO_0[16], GPIO_0[18], GPIO_0[20],
		PS2_CLK, PS2_DAT,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5);
	 
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 3;
		defparam VGA.BACKGROUND_IMAGE = "start_screen.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
endmodule





module assignments (clk, resetn, colour_out, x, y, writeEn, 
						start_key,
						KICK_BUTTON, PUNCH_BUTTON, JUMP_BUTTON, CROUCH_BUTTON, LEFT_BUTTON, RIGHT_BUTTON,
						PS2_CLK,PS2_DAT,
						HEX0,
						HEX1,
						HEX2,
						HEX3,
						HEX4,
						HEX5);
	input clk;
	input resetn;
	output [8:0]colour_out;
	output [7:0]x;
	output [6:0]y;
	output writeEn;
	input start_key;
	input KICK_BUTTON, PUNCH_BUTTON, JUMP_BUTTON, CROUCH_BUTTON, LEFT_BUTTON, RIGHT_BUTTON;
	inout 		PS2_CLK,
					PS2_DAT;
	output [6:0]HEX0,
					HEX1,
					HEX2,
					HEX3,
					HEX4,
					HEX5;
	
	//assign HEX0 = 7'h7f;				
	//assign HEX1 = 7'h7f;
	//assign HEX2 = 7'h7f;
	//assign HEX3 = 7'h7f;
	assign HEX4 = 7'h7f;
	assign HEX5 = 7'h7f;
	
	
	wire done_draw, done_wait, done_game, go_reset, go_bkgd, go_draw, go_wait, go_update, go_erase, go_win;
	
	wire [7:0]key_pressed_data;
	PS2_Demo p0(
		// Inputs
		.clk(clk),
		.reset(resetn),
		// Bidirectionals
		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT),
		// Outputs
		.HEX0(),
		.HEX1(),
		.HEX2(),
		.HEX3(),
		.HEX4(),
		.HEX5(),
		.HEX6(),
		.HEX7(),
		.last_data_received(key_pressed_data));
	
	//wire button_enable;
	//buttons_FSM p1(HEX4, clk, resetn, (KICK_BUTTON && PUNCH_BUTTON && JUMP_BUTTON && CROUCH_BUTTON && LEFT_BUTTON && RIGHT_BUTTON), button_enable);
	
	localparam kick_data = 3'b000, punch_data = 3'b001, jump_data = 3'b010, crouch_data = 3'b011, left_data = 3'b100, right_data = 3'b101;
	reg [2:0] button_pressed_data=3'b111;
	always@(*)
	begin
		if(!KICK_BUTTON) button_pressed_data = kick_data;
		else if(!PUNCH_BUTTON) button_pressed_data = punch_data;
		else if(!JUMP_BUTTON) button_pressed_data = jump_data;
		else if(!CROUCH_BUTTON) button_pressed_data = crouch_data;
		else if(!LEFT_BUTTON) button_pressed_data = left_data;
		else if(!RIGHT_BUTTON) button_pressed_data = right_data;
		else button_pressed_data = 3'b111;
	end 

	//implement start_key!!!
	FSM s1 (clk, resetn, start_key, done_draw, done_wait, done_game, go_reset, go_bkgd, go_draw, go_wait, go_update, go_erase, go_win);
	
	datapath d1 (HEX3,HEX2,HEX1,HEX0, clk, resetn, key_pressed_data, button_pressed_data, colour_out, go_reset, go_bkgd, go_draw, go_wait, go_update, go_erase, go_win, done_draw, done_wait, done_game, x, y);
	
	assign writeEn = go_draw;
	
endmodule 