`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 22:49:23
// Design Name: 
// Module Name: Whac_A_Mole
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Whac_A_Mole(
    input clk,
    input rst,
    input press_start,
    inout [7:0] JB,
    output [6:0] seg,
    output [3:0] sel,
    output [11:0] color_out,
    output hsync,
    output vsync,
    output notgaming,
    output [3:0] mouse_add1_location,
    output [3:0] mouse_add2_location, 
    output [3:0] mouse_reduce2_location,
    output [1:0] game_state
    );
    
    wire [3:0] key_num;
    Decoder PmodKYPD(
        .clk(clk),
        .Row(JB[7:4]),
        .Col(JB[3:0]),
        .DecodeOut(key_num)
	);
	
	wire start;
    key_debounce Debounce_start(
        .key(press_start),
        .clk(clk),
        .clr(rst), 
        .key_changed2(start)
        );
	
//	wire [1:0] game_state;
	wire add_1, add_2, reduce_2;
	wire flag_add1, flag_add2, flag_reduce2;
	wire enable_add1, enable_add2, enable_reduce2;
//	wire [3:0] mouse_add1_location, mouse_add2_location, mouse_reduce2_location;
    Mouse Mole_control(
        .clk(clk),
        .rst(rst),
        .start(start),
        .key_num(key_num),
        .game_state(game_state),
        .add_1(add_1),
        .add_2(add_2),
        .reduce_2(reduce_2),
        .flag_add1(flag_add1),
        .flag_add2(flag_add2),
        .flag_reduce2(flag_reduce2),
        .enable_add1(enable_add1),
        .enable_add2(enable_add2),
        .enable_reduce2(enable_reduce2),
        .mouse_add1_location(mouse_add1_location),
        .mouse_add2_location(mouse_add2_location),
        .mouse_reduce2_location(mouse_reduce2_location)
        );
    
    wire no_score;
    wire [7:0] scores;
    Scores Score_count(
        .clk(clk),
        .rst(rst),
        .start(start),
        .add1(add_1),
        .add2(add_2),
        .reduce2(reduce_2),
        .no_score(no_score),
        .score(scores)
        );
    
    wire time_finish;
    wire die_flash;
    wire restart;
    State_control Game_state_control(
        .clk(clk),
        .rst(rst),
        .press_start(start),
        .time_finish(time_finish),
        .no_score(no_score),
        .game_state(game_state),
        .die_flash(die_flash),
        .restart(restart)
        );
    
    wire [5:0] Time_out;
    Time_60s Time_control(
        .Clk(clk),
        .Rst(rst),
        .Start_60s(start),
        .no_score(no_score),
        .Finish_60s(time_finish),
        .Time(Time_out)
        );
    
    assign notgaming = time_finish;
    
    wire [7:0] binary_time;
    assign binary_time = {2'b00,Time_out};
    wire [3:0] Hundreds_time;
    wire [3:0] Tens_time;
    wire [3:0] Ones_time;
    BCD Decimalism_time (
        .Clk(clk),
        .binary(binary_time),
        .Hundreds(Hundreds_time),
        .Tens(Tens_time),
        .Ones(Ones_time)
        );
    wire [7:0] binary_score;
    assign binary_score = scores;
    wire [3:0] Hundreds_scores;
    wire [3:0] Tens_scores;
    wire [3:0] Ones_scores;
    
    BCD Decimalism_scores (
        .Clk(clk),
        .binary(binary_score),
        .Hundreds(Hundreds_scores),
        .Tens(Tens_scores),
        .Ones(Ones_scores)
        );
        
    wire clk_vga;
    clk_unit Clk_for_VGA(
        .clk(clk),
        .rst(rst),
        .clk_n(clk_vga)
        );
        
    VGA Vga_control(
        .clk(clk_vga),
        .rst(rst),
        .flag_add1(flag_add1),
        .flag_add2(flag_add2),
        .flag_reduce2(flag_reduce2),
        .enable_add1(enable_add1),
        .enable_add2(enable_add2),
        .enable_reduce2(enable_reduce2),
        .mouse_add1_location(mouse_add1_location),
        .mouse_add2_location(mouse_add2_location),
        .mouse_reduce2_location(mouse_reduce2_location),
        .Tens_scores(Tens_scores),
        .Ones_scores(Ones_scores),
        .Tens_time(Tens_time),
        .Ones_time(Ones_time),
        .hsync(hsync),
        .vsync(vsync),
        .color_out(color_out)
        );
    
    x7seg Seg_control(
        .s1_data(Ones_scores),
        .s2_data(Tens_scores),
        .s3_data(Ones_time),
        .s4_data(Tens_time),
        .clk(clk),
        .seg(seg),
        .s(sel)
        );
    
endmodule
