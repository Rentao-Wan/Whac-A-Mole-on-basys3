`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 13:43:18
// Design Name: 
// Module Name: x7seg
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


module x7seg(
     input wire [3:0] s1_data,
        input wire [3:0] s2_data,
        input wire [3:0] s3_data,
        input wire [3:0] s4_data,
        input wire clk,
        output reg [6:0] seg,
        output reg [3:0] s
        );
    
    reg [3:0] data;
    reg [18:0] times;
    
    initial times = 0;
    initial s = 4'b0001;
    
    always @ (posedge clk)
        begin
        times <= times + 19'b1;
        case (times)
            19'd000000: begin s <= ~4'b0001; data <= s1_data; end
            19'd100000: begin s <= ~4'b0010; data <= s2_data; end
            19'd200000: begin s <= ~4'b0100; data <= s3_data; end
            19'd300000: begin s <= ~4'b1000; data <= s4_data; end
        endcase
        if(times == 400000)
            times <= 19'b0;
        end
    
    always @ (posedge clk)
    begin
        case(data)
            4'b0000: seg = 7'b1000000;    //0
            4'b0001: seg = 7'b1111001;    //1
            4'b0010: seg = 7'b0100100;    //2
            4'b0011: seg = 7'b0110000;    //3
            4'b0100: seg = 7'b0011001;    //4
            4'b0101: seg = 7'b0010010;    //5
            4'b0110: seg = 7'b0000010;    //6
            4'b0111: seg = 7'b1111000;    //7
            4'b1000: seg = 7'b0000000;    //8
            4'b1001: seg = 7'b0010000;    //9
            4'b1010: seg = 7'b0001000;    //A
            4'b1011: seg = 7'b0000011;    //b
            4'b1100: seg = 7'b1000110;    //C
            4'b1101: seg = 7'b0100001;    //d
            4'b1110: seg = 7'b0000110;    //E
            4'b1111: seg = 7'b0001110;    //F
        endcase
    end
endmodule