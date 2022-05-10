`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 13:57:15
// Design Name: 
// Module Name: key_debounce
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


module key_debounce(
 input key,clk,clr,
 output key_changed2
    );
 wire key_changed1;
 reg [20:0] count;
 //reg [2:0] count; //for simulation
 reg sample1, sample_locked1, sample2, sample_locked2;
 
 always @(posedge clk or posedge clr)
  if(clr) sample1 <= 0;
  else sample1 <= key;
  
 always @(posedge clk or posedge clr)
  if(clr) sample_locked1 <= 0;
  else sample_locked1 <= sample1; 
 
 assign key_changed1 = ~sample_locked1 & sample1;
 
 always @(posedge clk or posedge clr)
  if(clr) count <= 0;
  else if(key_changed1) count <= 0;
  else count <= count + 1;
 
 always @(posedge clk or posedge clr)
  if(clr) sample2 <= 0;
  else if(count == 2000000)
  //else if(count == 2) // for simulation
   sample2 <= key; 
 
 always @(posedge clk or posedge clr)
  if(clr) sample_locked2 <= 0;
  else sample_locked2 <= sample2; 
 
 assign key_changed2 = ~sample_locked2 & sample2;
 
endmodule
