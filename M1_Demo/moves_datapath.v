module moves_datapath(clk,reset,distance,player1_state,player2_state,player1_health,player2_health);
input clk,reset;
input [7:0] distance;
input [2:0] player1_state,player2_state;
output reg [5:0] player1_health=20;//multi-bits
output	  [5:0] player2_health ;//80-player1_health

localparam idle_state= 3'b000, kicking_state = 3'b001, punching_state = 3'b010, crouching_state = 3'b011, jumping_state = 3'b100, sweeping_state = 3'b101, jumpkicking_state=3'b110;

always@(posedge clk, negedge reset)
begin
	if (!reset)
	begin
		player1_health<=20;
	end
	else
	begin
		if (distance>1)//>=1 ?
			player1_health<=player1_health;
			
		else if (player1_state==idle_state && player2_state==idle_state)
			player1_health<=player1_health;
		else if (player1_state==idle_state && player2_state==punching_state)
			player1_health<=(player1_health<1)?0:player1_health-1;
		else if (player1_state==idle_state && player2_state==kicking_state)
			player1_health<=(player1_health<2)?0:player1_health-2;
		else if (player1_state==idle_state && player2_state==jumping_state)
			player1_health<=player1_health;
		else if (player1_state==idle_state && player2_state==crouching_state)
			player1_health<=player1_health;
		else if (player1_state==idle_state && player2_state==sweeping_state)
			player1_health<=(player1_health<3)?0:player1_health-3;
		else if (player1_state==idle_state && player2_state==jumpkicking_state)
			player1_health<=(player1_health<4)?0:player1_health-4;
			
		else if (player1_state==punching_state && player2_state==idle_state)
			player1_health<=(player1_health>39)?40:player1_health+1;
		else if (player1_state==punching_state && player2_state==punching_state)
			player1_health<=player1_health;
		else if (player1_state==punching_state && player2_state==kicking_state)
			player1_health<=(player1_health<1)?0:player1_health-1;
		else if (player1_state==punching_state && player2_state==jumping_state)
			player1_health<=(player1_health>39)?40:player1_health+1;
		else if (player1_state==punching_state && player2_state==crouching_state)
			player1_health<=player1_health;
		else if (player1_state==punching_state && player2_state==sweeping_state)
			player1_health<=(player1_health<3)?0:player1_health-3;
		else if (player1_state==punching_state && player2_state==jumpkicking_state)
			player1_health<=(player1_health<3)?0:player1_health-3;
			
		else if (player1_state==kicking_state && player2_state==idle_state)
			player1_health<=(player1_health>38)?40:player1_health+2;
		else if (player1_state==kicking_state && player2_state==punching_state)
			player1_health<=(player1_health>39)?40:player1_health+1;
		else if (player1_state==kicking_state && player2_state==kicking_state)
			player1_health<=player1_health;
		else if (player1_state==kicking_state && player2_state==jumping_state)
			player1_health<=player1_health;
		else if (player1_state==kicking_state && player2_state==crouching_state)
			player1_health<=(player1_health>38)?40:player1_health+2;
		else if (player1_state==kicking_state && player2_state==sweeping_state)
			player1_health<=(player1_health<1)?0:player1_health-1;
		else if (player1_state==kicking_state && player2_state==jumpkicking_state)
			player1_health<=(player1_health<4)?0:player1_health-4;
			
		else if (player1_state==jumping_state && player2_state==idle_state)
			player1_health<=player1_health;
		else if (player1_state==jumping_state && player2_state==punching_state)
			player1_health<=(player1_health<1)?0:player1_health-1;
		else if (player1_state==jumping_state && player2_state==kicking_state)
			player1_health<=player1_health;
		else if (player1_state==jumping_state && player2_state==jumping_state)
			player1_health<=player1_health;
		else if (player1_state==jumping_state && player2_state==crouching_state)
			player1_health<=player1_health;
		else if (player1_state==jumping_state && player2_state==sweeping_state)
			player1_health<=player1_health;
		else if (player1_state==jumping_state && player2_state==jumpkicking_state)
			player1_health<=(player1_health<4)?0:player1_health-4;
			
		else if (player1_state==crouching_state && player2_state==idle_state)
			player1_health<=player1_health;
		else if (player1_state==crouching_state && player2_state==punching_state)
			player1_health<=player1_health;
		else if (player1_state==crouching_state && player2_state==kicking_state)
			player1_health<=(player1_health<2)?0:player1_health-2;
		else if (player1_state==crouching_state && player2_state==jumping_state)
			player1_health<=player1_health;
		else if (player1_state==crouching_state && player2_state==crouching_state)
			player1_health<=player1_health;
		else if (player1_state==crouching_state && player2_state==sweeping_state)
			player1_health<=(player1_health<3)?0:player1_health-3;
		else if (player1_state==crouching_state && player2_state==jumpkicking_state)
			player1_health<=player1_health;
			
		else if (player1_state==jumpkicking_state && player2_state==idle_state)
			player1_health<=(player1_health>36)?40:player1_health+4;
		else if (player1_state==jumpkicking_state && player2_state==punching_state)
			player1_health<=(player1_health>37)?40:player1_health+3;
		else if (player1_state==jumpkicking_state && player2_state==kicking_state)
			player1_health<=(player1_health>36)?40:player1_health+4;
		else if (player1_state==jumpkicking_state && player2_state==jumping_state)
			player1_health<=(player1_health>36)?40:player1_health+4;
		else if (player1_state==jumpkicking_state && player2_state==crouching_state)
			player1_health<=player1_health;
		else if (player1_state==jumpkicking_state && player2_state==sweeping_state)
			player1_health<=player1_health;
		else if (player1_state==jumpkicking_state && player2_state==jumpkicking_state)
			player1_health<=player1_health;
		
		else if (player1_state==sweeping_state && player2_state==idle_state)
			player1_health<=(player1_health>37)?40:player1_health+3;
		else if (player1_state==sweeping_state && player2_state==punching_state)
			player1_health<=(player1_health>37)?40:player1_health+3;
		else if (player1_state==sweeping_state && player2_state==kicking_state)
			player1_health<=(player1_health>39)?40:player1_health+1;
		else if (player1_state==sweeping_state && player2_state==jumping_state)
			player1_health<=player1_health;
		else if (player1_state==sweeping_state && player2_state==crouching_state)
			player1_health<=(player1_health>37)?40:player1_health+3;
		else if (player1_state==sweeping_state && player2_state==sweeping_state)
			player1_health<=player1_health;
		else if (player1_state==sweeping_state && player2_state==jumpkicking_state)
			player1_health<=player1_health;
		
		else
			player1_health<=player1_health;
	end
end

assign player2_health=7'd40-player1_health;
endmodule 