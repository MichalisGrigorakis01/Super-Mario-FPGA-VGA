/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/XX/XX
 * Author: Your name here
 * Filename: vga_sync.sv
 * Description: Implements VGA HSYNC and VSYNC timings for 640 x 480 @ 60Hz
 *
 ******************************************************************************/

`timescale 1ns/1ps

module vga_sync(
  input logic clk,
  input logic rst,

  output logic o_pix_valid,
  output logic [9:0] o_col,
  output logic [9:0] o_row,

  output logic o_hsync,
  output logic o_vsync
);

/*
parameter FRAME_HPIXELS           = 640;
parameter FRAME_HFPORCH           = 16;
parameter FRAME_HSPULSE           = 96;
parameter FRAME_HBPORCH           = 48;
parameter FRAME_MAX_HCOUNT        = 800;

parameter FRAME_VLINES            = 480;
parameter FRAME_VFPORCH           = 10;
parameter FRAME_VSPULSE           = 2;
parameter FRAME_VBPORCH           = 29;
parameter FRAME_MAX_VCOUNT        = 521;
*/

// Implement your code here

endmodule
