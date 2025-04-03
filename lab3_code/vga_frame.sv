/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2023/02/06
 * Author: Your name here
 * Filename: vga_frame.sv
 * Description: Your description here
 *
 ******************************************************************************/

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

    input logic i_rom_en,
    input logic [10:0] i_rom_addr,
    output logic [15:0] o_rom_data,


  output logic [3:0] o_red,
  output logic [3:0] o_green,
  output logic [3:0] o_blue
  
);

logic [3:0] red;
logic [3:0] green;
logic [3:0] blue;

logic reg_pix_valid;
logic [9:0] reg_col;
logic [9:0] reg_row;

logic [5:0] reg_player_bcol;
logic [5:0] reg_player_brow;

logic [5:0] reg_exit_bcol;
logic [5:0] reg_exit_brow;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        reg_pix_valid <= '0;
        reg_col <= '0;
        reg_row <= '0;
        
        reg_player_bcol <= '0;
        reg_player_brow <= '0;
        
        reg_exit_bcol <= '0;
        reg_exit_brow <= '0;
     end
     else begin
        reg_pix_valid <= i_pix_valid;
        reg_col <= i_col;
        reg_row <= i_row;
        
        reg_player_bcol <= i_player_bcol;
        reg_player_brow <= i_player_brow;
        
        reg_exit_bcol <= i_exit_bcol;
        reg_exit_brow <= i_exit_brow;
     end
end


always_comb begin
    if(reg_pix_valid == 0) begin
        o_red = 4'h0;
        o_green = 4'h0;
        o_blue = 4'h0;
    end
    else if(reg_col/16 == reg_player_bcol && reg_row/16 == reg_player_brow) begin
        o_blue = playerout[3:0];
        o_green = playerout[7:4];
        o_red = playerout[11:8];
        
    end
    else if(reg_col/16 == reg_exit_bcol && reg_row/16 == reg_exit_brow) begin
        o_blue = exitout[3:0];
        o_green = exitout[7:4];
        o_red = exitout[11:8];
    end
    else begin
        o_blue = mazeout[3:0];
        o_green = mazeout[7:4];
        o_red = mazeout[11:8];
    end
end

logic [15:0] mazeout;
logic [15:0] playerout;
logic [15:0] exitout;



rom_dp #(
    .file("C:\Users\grigo\Desktop\lab3_code\roms\maze1.rom")
)
maze(
    .clk(clk),
    .en(i_pix_valid),
    .addr((i_col/16)*32 + (i_row/16)),
    .dout(mazeout),
    
    .en_b(i_rom_en),
    .addr_b(i_rom_addr),
    .dout_b(o_rom_data)
);

rom #(
    .size(256),
    .width(16),
    .file("C:\Users\grigo\Desktop\lab3_code\roms\player.rom")
)
player(
    .clk(clk),
    .en(i_pix_valid),
    .addr((i_col%16) + (i_row%16)*16),
    .dout(playerout)
);


rom #(
    .size(256),
    .width(16),
    .file("C:\Users\grigo\Desktop\lab3_code\roms\exit.rom")
)
exit(
    .clk(clk),
    .en(i_pix_valid),
    .addr((i_col%16) + (i_row%16)*16),
    .dout(exitout)
);


endmodule
