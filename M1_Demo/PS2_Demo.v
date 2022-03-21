
module PS2_Demo (
	// Inputs
	clk,
	reset,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	last_data_received
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				clk;
input				reset;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;
output reg	[7:0]	last_data_received;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/




/*
wire [7:0] last_data_received_temp;
keyboard_FSM s1(HEX0, HEX1, clk,reset,ps2_key_pressed,ps2_key_data,last_data_received_temp);


always @(posedge clk)
begin
	if (reset == 1'b0)
		last_data_received <= 8'h00;
	else 
		last_data_received <= last_data_received_temp;
end
*/

wire enable;
keyboard_FSM_alt s1(HEX0, clk,reset,ps2_key_pressed,ps2_key_data, enable);

always @(posedge clk)
begin
	if (reset == 1'b0)
		last_data_received <= 8'h00;
	else 
		last_data_received <= (enable?ps2_key_data:8'h00);
end


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

//assign HEX2 = 7'h7F;
//assign HEX3 = 7'h7F;
//assign HEX4 = 7'h7F;
//assign HEX5 = 7'h7F;
//assign HEX6 = 7'h7F;
//assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50			(clk),
	.reset				(~reset),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);
endmodule
