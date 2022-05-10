`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 13:52:20
// Design Name: 
// Module Name: Time_Top
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


module Time_Top(
    input wire Clk,
    input wire Rst,
    input wire start,
    output wire [6:0] seg,
    output wire [3:0] s,
    output wire Led
    );
    
    wire Start_60s;
    
    key_debounce D1(
        .key(start),
        .clk(Clk),
        .clr(Rst), 
        .key_changed2(Start_60s)
        );
        
    wire [5:0] Time;
    wire Finish_60s;
    Time_60s T1(
        .Clk(Clk),
        .Rst(Rst),
        .Start_60s(Start_60s),
        .Finish_60s(Finish_60s),
        .Time(Time)
        );
        
    assign Led = Finish_60s;
    wire [7:0] binary;
    assign binary = {2'b00,Time};
    
    wire [3:0] Hundreds;
    wire [3:0] Tens;
    wire [3:0] Ones;
    
    BCD B(
        .Clk(Clk),
        .binary(binary),
        .Hundreds(Hundreds),
        .Tens(Tens),
        .Ones(Ones)
        );
    
    x7seg S1(
        .s1_data(Ones),
        .s2_data(Tens),
        .s3_data(Hundreds),
        .s4_data(4'b0000),
        .clk(Clk),
        .seg(seg),
        .s(s)
        );
endmodule
