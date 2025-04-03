/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2023/XX/XX
 * Author: Your name here
 * Filename: maze_controller.sv
 * Description: Your description here
 *
 ******************************************************************************/

module maze_controller(
  input  logic clk,
  input  logic rst,

  input  logic i_control,
  input  logic i_up,
  input  logic i_down,
  input  logic i_left,
  input  logic i_right,

  output logic        o_rom_en,
  output logic [10:0] o_rom_addr,
  input  logic [15:0] i_rom_data,

  output logic [5:0] o_player_bcol,
  output logic [5:0] o_player_brow,

  input  logic [5:0] i_exit_bcol,
  input  logic [5:0] i_exit_brow,

  output logic [7:0] o_leds
);

logic [5:0] new_bcol;
logic [5:0] new_brow;
logic [5:0] temp_col;
logic [5:0] temp_row;
logic [1:0] count;//count for the i_control button
logic start_condition;
logic [3:0] red;
logic [3:0] blue;
logic [3:0] green;
logic [5:0] curr_player_bcol;
logic [5:0] curr_player_brow;
logic move_valid;


typedef enum logic[3:0] {
IDLE,PLAY,UP,DOWN,LEFT,RIGHT,READROM,CHECK,UPDATE,END_state
} FSM_State;
FSM_State Curr_State,Next_State;


//Flip Flops:

//FSM states
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        Curr_State <= IDLE;
    end
    else begin
        Curr_State <= Next_State;
    end
end

//new_bcol
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        new_bcol <= 1;//arxizei apo to (column, row) = (1, 0)
    end
    else begin
        new_bcol <= temp_col;
    end
end

//new_brow
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        new_brow <= 0;//arxizei apo to (column, row) = (1, 0)
    end
    else begin
        new_brow <= temp_row;
    end
end

//count 
always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        count <= 0;
    end
    else begin
        if(i_control) begin
            count <= count + 1;
        end
        else if(i_up || i_down || i_left || i_right) begin
            count <= 0;//stin  periptwsi pou den path8ei 3 synexomenes fores mhdenizoume to count
        end
        else begin
            count <= count;
        end
    end
end

assign start_condition = (count == 3);
assign move_valid = ~(red == 0 && blue == 0 && green == 0);

always_comb begin
    Next_State = Curr_State;
    o_rom_en = 0;
    o_leds = 0;
    
    temp_row = new_brow;
    temp_col = new_bcol;
    
    case(Curr_State)
        //IDLE STATE
        IDLE: begin
            o_leds = 1;
            curr_player_brow = new_brow;
            curr_player_bcol = new_bcol;
            if(start_condition) begin
                Next_State = PLAY;
            end
            else begin
                Next_State = IDLE;
            end
        end
        //PLAY STATE
        PLAY: begin
            o_leds = 2;
            //Check if player has arrived at exit
            if(curr_player_bcol == i_exit_bcol && curr_player_brow == i_exit_brow) begin
                Next_State = END_state;
            end
            else if(i_up) begin
                Next_State = UP;
            end
            else if(i_down) begin
                Next_State = DOWN;
            end
            else if(i_left) begin
                Next_State = LEFT;
            end
            else if(i_right) begin
                Next_State = RIGHT;    
            end
            else begin
                Next_State = PLAY;
            end
        end
        UP: begin
            o_leds = 3;
            temp_row = curr_player_brow - 1;//meiwnetai i grammi kata 1
            temp_col = curr_player_bcol;//den allazei    
            Next_State = READROM;
        end
        DOWN: begin
            o_leds = 4;
            temp_row = curr_player_brow + 1;//ayjanetai i grammi kata 1
            temp_col = curr_player_bcol;//den allazei
            Next_State = READROM;
        end
        LEFT: begin
            o_leds = 5;
            temp_row = curr_player_brow;
            temp_col = curr_player_bcol - 1;//meiwnetai i sthlh kata 1
            Next_State = READROM;
        end
        RIGHT: begin
            o_leds = 6;
            temp_row = curr_player_brow;
            temp_col = curr_player_bcol + 1;//ayjanetai i sthlh kata 1
            Next_State = READROM;
        end
        READROM: begin
            o_leds = 7;
            if(new_brow >= 0 && new_bcol >= 0 && new_brow <= 37 && new_bcol <= 37) begin
                o_rom_en = 1;
                o_rom_addr = new_bcol*32 + new_brow;
            end
            else begin
                temp_col = curr_player_bcol;
                temp_row = curr_player_brow;
            end
            Next_State = CHECK;
        end
        CHECK: begin
            o_leds = 8;
            blue = i_rom_data[3:0];
            green = i_rom_data[7:4];
            red = i_rom_data[11:8];
            
            if(move_valid) begin
                Next_State = UPDATE;
            end
            else begin
                temp_col = curr_player_bcol;
                temp_row = curr_player_brow;
                Next_State = PLAY;
            end
        end
        UPDATE: begin
            o_leds = 9;
            curr_player_bcol = new_bcol;
            curr_player_brow = new_brow;
            Next_State = PLAY;
        end
        END_state: begin
            o_leds = 10;
            if(i_control) begin
                temp_col = 1;
                temp_row = 0;
                Next_State = IDLE; 
            end
        end
        default: begin
            Next_State = IDLE;
        end
    endcase
end

assign o_player_bcol = curr_player_bcol;
assign o_player_brow = curr_player_brow;
endmodule
