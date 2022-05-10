`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/08 09:00:33
// Design Name: 
// Module Name: State_control
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


module State_control(
    input clk,
    input rst,
    input press_start,
    input time_finish,
    input no_score,
    output reg [1:0] game_state,
    output reg die_flash,
    output reg restart
    );
    parameter RESTART = 2'b00;
    parameter START = 2'b01;
    parameter PLAY = 2'b10;
    parameter DIE = 2'b11;
    
    parameter time_flash = 200_000_000; //200_000_000 
    parameter flash_1 = 25_000_000;     //25_000_000
    parameter flash_2 = 50_000_000;     //50_000_000
    parameter flash_3 = 75_000_000;     //75_000_000
    parameter flash_4 = 100_000_000;    //100_000_000
    parameter flash_5 = 125_000_000;    //125_000_000
    parameter flash_6 = 150_000_000;    //150_000_000
    
    reg time_finish_lock;
    always @ (posedge clk)
        time_finish_lock <= time_finish;
    assign no_time = ~time_finish_lock & time_finish;
    
    reg[31:0] clk_cnt;
    always @ (posedge clk)
    begin
        if (rst)
            begin
            game_state <= START;
            clk_cnt <= 0;
            die_flash <= 1;
            restart <= 0;            
            end
        else
            begin
            case (game_state)
                RESTART:
                    begin
                    if (clk_cnt <= 5) //游戏开始等待
                        begin
                        game_state <= game_state;
                        clk_cnt <= clk_cnt + 1;
                        restart <= 1;
                        end
                    else 
                        begin
                        game_state <= START;
                        clk_cnt <= 0;
                        restart <= 0;
                        end
                    end
                START:
                    begin
                    if (press_start)
                        game_state <= PLAY;
                    else
                        game_state <= game_state;
                    end
                PLAY:
                    begin
                    if (no_time | no_score)
                        game_state <= DIE;
                    else
                        game_state <= game_state;
                    end
                DIE:
                    begin
                    if (clk_cnt <= time_flash) //死亡闪烁
                        begin
                            game_state <= game_state;
                            clk_cnt <= clk_cnt + 1;
                            if (clk_cnt == flash_1)
                                die_flash <= 0;
                            else if (clk_cnt == flash_2)
                                die_flash <= 1;
                            else if (clk_cnt == flash_3)
                                die_flash <= 0;
                            else if (clk_cnt == flash_4)
                                die_flash <= 1; 
                            else if (clk_cnt == flash_5)
                                die_flash <= 0;
                            else if (clk_cnt == flash_6)
                                die_flash <= 1;                          
                        end
                    else
                        begin           //返回等待
                            die_flash <= 1;
                            clk_cnt <= 0;
                            game_state <= RESTART;
                        end
                    end
                default:
                    begin           //返回等待
                        die_flash <= 1;
                        clk_cnt <= 0;
                        game_state <= RESTART;
                    end                       
            endcase            
            end            
    end
    
endmodule
