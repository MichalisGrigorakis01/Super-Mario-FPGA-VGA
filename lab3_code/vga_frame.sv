/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/XX/XX
 * Author: Your name here
 * Filename: vga_frame.sv
 * Description: Your description here
 *
 ******************************************************************************/

`timescale 1ns/1ps

module vga_frame(
  input logic clk,
  input logic rst,

  input logic i_pix_valid,
  input logic [9:0] i_col,
  input logic [9:0] i_row,

  input logic [5:0] i_player_bcol,
  input logic [5:0] i_player_brow,

  input logic [5:0] i_exit_bcol,
  input logic [5:0] i_exit_brow,

  output logic [3:0] o_red,
  output logic [3:0] o_green,
  output logic [3:0] o_blue
);

// Implement your code here

/*
// ROM Template Instantiation
rom #(
  .size(2048),
  .file("roms/maze1.rom") 
)
maze_rom (
  .clk(clk),
  .en(maze_en),
  .addr(maze_addr),
  .dout(maze_pixel)
);
*/

endmodule
