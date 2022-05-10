`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 23:26:35
// Design Name: 
// Module Name: clk_unit
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


module clk_unit(
	input clk,
	input rst,
	output reg clk_n
	);
	
    reg clk_tmp;
    always @(posedge clk_tmp or posedge rst) begin
       if (rst)
        clk_n <= 0;
      else
        clk_n <= ~clk_n;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_tmp <= 0;
        else
            clk_tmp <= ~clk_tmp;
    end
endmodule
