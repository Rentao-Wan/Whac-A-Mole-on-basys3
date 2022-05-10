`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 09:45:25
// Design Name: 
// Module Name: Scores
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


module Scores(
    input clk,
    input rst,
    input start,
    input add1,
    input add2,
    input reduce2,
    output no_score,
    output reg [7:0] score
    );

    reg flag_score;
    
    initial 
    begin
        flag_score <= 0;
        score <= 8'd0;
    end
    
    always @ (posedge clk)
    begin
        if (rst | start )
            begin
                flag_score <= 0;
                score <= 0;
            end
        else if (add1)
            begin
                score <= score + 1;
                flag_score <= 0;
            end
        else if (add2)
            begin
                score <= score + 2;
                flag_score <= 0;
            end
        else if (reduce2)
            begin
                if (score >= 2)
                    begin
                    score <= score - 2;
                    flag_score <= 0;
                    end
                else
                    begin
                        score <= 0;
                        flag_score <= 1;
                    end
            end
        else
            begin
                score <= score;
            end
    end
    
    reg flag_score_lock;
    always @(posedge clk)
    begin
        flag_score_lock <= flag_score;
    end
    assign no_score = ~flag_score_lock & flag_score;
    
endmodule
