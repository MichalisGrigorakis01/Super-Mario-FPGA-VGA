/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2023/02/06
 * Author: CS220 Instructors
 * Filename: vga_maze_top.sv
 * Description: The top module that instantiates vga_sync and vga_frame 
 *
 ******************************************************************************/

module vga_maze_top(
  input logic clk,
  input logic rst,

  output logic o_hsync,
  output logic o_vsync,
  output logic [3:0] o_red,
  output logic [3:0] o_green,
  output logic [3:0] o_blue
);

logic pixel_valid;
logic [9:0] col;
logic [9:0] row;

vga_sync vs (
  .clk(clk),
  .rst(rst),
  .o_pix_valid(pixel_valid),
  .o_col(col),
  .o_row(row),
  .o_hsync(o_hsync),
  .o_vsync(o_vsync)
);

vga_frame vf (
  .clk(clk),
  .rst(rst),
  .i_pix_valid(pixel_valid),
  .i_col(col),
  .i_row(row),
  .o_red(o_red),
  .o_green(o_green),
  .o_blue(o_blue)
);

endmodule
