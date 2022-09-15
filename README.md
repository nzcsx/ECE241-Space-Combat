# ECE241_Space_Combat
This is the game I programmed with my lab partner Helen Cui. 
The video showcasing the game can be found at https://www.youtube.com/watch?v=it4D2UQD33M 

# 1.0 Introduction
Different from micro-processors, the inherent parallelism of FPGA provides it with advantage when multiple dissected workloads need simultaneous computation[1], or when inputs and outputs have varying clock rate or bandwidth. [2] However, the advantage of FPGA has yet to be well demonstrated in the game industry. [3] The goal of the project is to create a simple two-player 2D combat game to demonstrate the feasibility of employing FPGA board in games with its inherent advantage. 

# 2.0 Design
## 2.1 Overall Structure

<p align="center"> 
  <img width="600" src="https://github.com/nzcsx/ECE241_Space_Combat/blob/main/README_media/_overall.png" alt="Overall"> <br />
  Fig 2.1.0 overall structure block diagram
</p>

The game takes four types of inputs. It takes PS2 keyboard as player1 input, game controller buttons as player2 input (Fig 2.1.1), KEY[3] as the “start game” feedback signal and KEY[0] as “reset game” signal. 

FSM module stores and updates the current “game state”. That is to say stores ad updates whether the game is at starting screen, or drawing the sprite images, or erasing the sprite images, or waiting for the frame update, or that one character has won the game.

Datapath and related modules implements the gameplay logics, computes and stores the game data. For gameplay logics, by taking the input from the players, it updates the moves states(which represents which moves the character is performing) and deducts health according to the moves states. For game data, it stores and updates the position of both characters and retrieve colour of the sprite image from On-Chip Memory to be drawn on the VGA display.

The game outputs health (in base 10) of both characters to HEX display, and outputs the updated corresponding starting page, sprite image, or winning page to the VGA.

<p align="center"> 
  <img width="500" src="https://github.com/nzcsx/ECE241_Space_Combat/blob/main/README_media/controller.png" alt="Controller"> <br />
  Fig 2.1.0 Custom-built game controller
</p>

<p align="center">  
  <img width="500" src="https://github.com/nzcsx/ECE241_Space_Combat/blob/main/README_media/hex.png" alt="Hex Display"> <br />
  Fig 2.1.2 HEX display
</p>

## 2.2 User Inputs
The keyboard operates in a different clock rate to CLOCK_50 and keeps sending signals during the time the key is pressed down. Therefore, in the top module file, an keyboard_FSM_alt is instantiated to take the original keyboard signal and to send out a one CLOCK_50 clock cycle of impulse signal per press-and-release. We use six keys for six types of input: A(move left), D(move right), W(fly), S(crouch), J(kick) and L(punch).

Since the keyboard can only sense one key pressing and send one key signal at a time, in order to prevent interference between the inputs of two players, an additional game controller is designed as an input device independent of the keyboard. It has  six buttons for six types of input: move left, move right, jump, crouch, kick and punch.

KEY[3] button acts as a feedback signal that changes from initial state to actual gameplay. KEY[0] resets the entire game and also acts as a feedback signal that changes the game back to the initial state.

