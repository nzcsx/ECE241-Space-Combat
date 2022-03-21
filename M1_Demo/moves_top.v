module moves_top(
clk, resetn, 
kick_in_1, punch_in_1, crouch_in_1, jump_in_1, 
kick_in_2, punch_in_2, crouch_in_2, jump_in_2, 
distance, 
p1_health1, p1_health0, p2_health1, p2_health0, 
player1_state_out, player2_state_out,
player1_health_out, player2_health_out);

input clk, resetn;
input kick_in_1, punch_in_1, crouch_in_1, jump_in_1;
input kick_in_2, punch_in_2, crouch_in_2, jump_in_2;
input [7:0] distance;
output [6:0] p1_health1;
output [6:0] p1_health0;
output [6:0] p2_health1;
output [6:0] p2_health0;
output [3:0] player1_state_out;
output [3:0] player2_state_out;
assign player1_state_out = go_player1_state;
assign player2_state_out = go_player2_state;
output [5:0] player1_health_out;
output [5:0] player2_health_out;
assign player1_health_out = player1_health;
assign player2_health_out = player2_health;

wire [3:0] go_player1_state;
wire [3:0] go_player2_state;
wire [5:0] player1_health;
wire [5:0] player2_health;

moves_FSM player1 (clk, resetn, kick_in_1, punch_in_1, crouch_in_1, jump_in_1, go_player1_state);
moves_FSM player2 (clk, resetn, kick_in_2, punch_in_2, crouch_in_2, jump_in_2, go_player2_state);
moves_datapath moves_datapath1 (clk,resetn,distance,go_player1_state,go_player2_state,player1_health,player2_health);

Hexadecimal_To_Seven_Segment h7((player1_health/10), p1_health1);
Hexadecimal_To_Seven_Segment h6((player1_health%10), p1_health0);

Hexadecimal_To_Seven_Segment h5((player2_health/10), p2_health1);
Hexadecimal_To_Seven_Segment h4((player2_health%10), p2_health0);
endmodule 