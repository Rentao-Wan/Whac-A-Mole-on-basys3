`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 11:32:58
// Design Name: 
// Module Name: LFSR_random
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


module LFSR_random(
    input               rst_n,    /*rst_n is necessary to prevet locking up*/
    input               clk,      /*clock signal*/
    input               load,     /*load seed to rand_num,active high */
    input      [7:0]    seed,     
    output reg [7:0]    rand_num  /*random number output*/
);


always@(posedge clk)
begin
    if(rst_n)
        rand_num    <=8'b0;
    else if(load)
        rand_num <=seed;    /*load the initial value when load is active*/
    else
        begin
            rand_num[0] <= rand_num[7];
            rand_num[1] <= rand_num[0];
            rand_num[2] <= rand_num[1];
            rand_num[3] <= rand_num[2];
            rand_num[4] <= rand_num[3]^rand_num[7];
            rand_num[5] <= rand_num[4]^rand_num[7];
            rand_num[6] <= rand_num[5]^rand_num[7];
            rand_num[7] <= rand_num[6];
        end
            
end
endmodule
