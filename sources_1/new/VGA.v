`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 23:28:32
// Design Name: 
// Module Name: VGA
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


module VGA(
	input clk,
	input rst,
    input flag_add1,
    input flag_add2,
    input flag_reduce2,
    input enable_add1,
    input enable_add2,
    input enable_reduce2,
    input [3:0] mouse_add1_location,
    input [3:0] mouse_add2_location,
    input [3:0] mouse_reduce2_location,
    input [3:0] Tens_scores,
    input [3:0] Ones_scores,
    input [3:0] Tens_time,
    input [3:0] Ones_time,
	output reg hsync,
	output reg vsync,
	output reg [11:0] color_out
);
	reg [19:0]clk_cnt;
	reg [9:0]line_cnt;

	// 蓝—绿—红
	parameter Red = 12'b0000_0000_1111;    //红
	parameter Green = 12'b0000_1111_0000;  //绿
	parameter Yellow = 12'b0000_1111_1111;  //黄
	parameter Blue = 12'b1111_0000_0000;  //蓝
	parameter Grey = 12'b1100_1100_1100; 
	parameter White = 12'b1111_1111_1111; 
	parameter Black = 12'b0000_0000_0000;
	parameter Grass_green = 12'b0000_1000_0000;  //深绿
	parameter Old_red = 12'b0000_0000_1010;  //深红
	parameter Baby_blue = 12'b1111_1111_0110;  //浅蓝
	parameter Baby_red = 12'b0110_0110_1111;  //浅红
	parameter Baby_yellow = 12'b0110_1111_1111;  //浅黄
    parameter Orange = 12'b000_0110_1111;  //橘色
    parameter Brown = 12'b0000_0101_1001;
    
	reg[9:0]x_pos;
	reg[9:0]y_pos;
		
	always@(posedge clk) 
	begin
		if(rst) 
		begin
			clk_cnt <= 0;
			line_cnt <= 0;
			hsync <= 1;
			vsync <= 1;
		end
		else begin
 //           if (clk_cnt >= 144 + 18)
                x_pos <= clk_cnt - 144 - 18; //-144 - 18
  //          else
  //              x_pos <= 0;
  //          if (clk_cnt >= 33 + 10)
                y_pos <= line_cnt - 33 - 9; //33 - 9
  //          else
  //              y_pos <= 0;	
			if(clk_cnt == 0) begin
			    hsync <= 0;
				clk_cnt <= clk_cnt + 1;
            end
			else if(clk_cnt == 96) begin
				hsync <= 1;
				clk_cnt <= clk_cnt + 1;
            end
			else if(clk_cnt == 799) begin
				clk_cnt <= 0;
				line_cnt <= line_cnt + 1;
			end
			else clk_cnt <= clk_cnt + 1;
			if(line_cnt == 0) begin
				vsync <= 0;
            end
			else if(line_cnt == 2) begin
				vsync <= 1;
			end
			else if(line_cnt == 521) begin
				line_cnt <= 0;
				vsync <= 0;
			end
		end
    end
    
    wire location_0_line, location_0_body, location_0_stone, location_0_eyes;
    wire location_1_line, location_1_body, location_1_stone, location_1_eyes;
    wire location_2_line, location_2_body, location_2_stone, location_2_eyes;
    wire location_3_line, location_3_body, location_3_stone, location_3_eyes;
    wire location_4_line, location_4_body, location_4_stone, location_4_eyes;
    wire location_5_line, location_5_body, location_5_stone, location_5_eyes;
    wire location_6_line, location_6_body, location_6_stone, location_6_eyes;
    wire location_7_line, location_7_body, location_7_stone, location_7_eyes;
    wire location_8_line, location_8_body, location_8_stone, location_8_eyes;
    wire location_9_line, location_9_body, location_9_stone, location_9_eyes;
    wire location_a_line, location_a_body, location_a_stone, location_a_eyes;
    wire location_b_line, location_b_body, location_b_stone, location_b_eyes;
    wire location_c_line, location_c_body, location_c_stone, location_c_eyes;
    wire location_d_line, location_d_body, location_d_stone, location_d_eyes;
    wire location_e_line, location_e_body, location_e_stone, location_e_eyes;
    wire location_f_line, location_f_body, location_f_stone, location_f_eyes;
        
    wire location_time;
    wire location_score;
    
    wire Time_ten_0, Time_ten_1, Time_ten_2, Time_ten_3, Time_ten_4, Time_ten_5, Time_ten_6, Time_ten_7, Time_ten_8, Time_ten_9; 
    wire Time_unit_0, Time_unit_1, Time_unit_2, Time_unit_3, Time_unit_4, Time_unit_5, Time_unit_6, Time_unit_7, Time_unit_8, Time_unit_9; 
    wire Score_ten_0, Score_ten_1, Score_ten_2, Score_ten_3, Score_ten_4, Score_ten_5, Score_ten_6, Score_ten_7, Score_ten_8, Score_ten_9; 
    wire Score_unit_0, Score_unit_1, Score_unit_2, Score_unit_3, Score_unit_4, Score_unit_5, Score_unit_6, Score_unit_7, Score_unit_8, Score_unit_9; 

	reg two_frame;     
	initial two_frame = 0;    
	always @ (posedge clk)
    begin
        if (x_pos == 0 && y_pos == 0)
           two_frame <= ~two_frame;
        else
           two_frame <= two_frame;
    end

	reg [8:0] count_frame;
	initial count_frame = 0;
	reg [1:0] flash;
	initial flash = 0;
	always @ (posedge two_frame)
	begin
        if (count_frame == 8'd20)
            begin
            count_frame <= 0;
            if (flash == 2)
                flash <= 0;
            else
                flash <= flash + 1;
            end
        else
            begin
            count_frame <=  count_frame + 1;
            flash <= flash;
            end
	end
    wire [7:0] flash_x;
    wire [7:0] flash_y;
    assign flash_x = (x_pos>=510) ? x_pos - 510 : 0;
    assign flash_y = (y_pos>=41) ? y_pos - 41 : 0;
    
    always@(posedge clk) 
    begin
        if(x_pos >= 0 && x_pos < 640 && y_pos >= 0 && y_pos < 480) 
            begin
            if(x_pos >= 0 && x_pos < 480)
                begin
                if ((x_pos >= 0 && x_pos < 8) || (x_pos >= 116 && x_pos < 124) || (x_pos >= 236 && x_pos < 244) || (x_pos >= 356 && x_pos < 364) || (x_pos >= 472 && x_pos < 480) || (y_pos >= 0 && y_pos < 8) || (y_pos >= 116 && y_pos < 124) || (y_pos >= 236 && y_pos < 244) || (y_pos >= 356 && y_pos < 364) || (y_pos >= 472 && y_pos < 480))
                    begin
                    color_out <= White;
                    end
                else
                    begin
                    if (x_pos >= 36-20 && x_pos < 84+20) //用于判断1，4，7，0
                        begin
                            if (y_pos >= 36-20 && y_pos < 84+20)  //用于判断1
                                begin
                                    if (mouse_add1_location == 4'h1)
                                        begin
                                        if ( location_1_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_1_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_1_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_1_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h1)
                                        begin
                                        if ( location_1_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_1_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_1_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_1_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h1)
                                        begin
                                        if ( location_1_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_1_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_1_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_1_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 156-20 && y_pos < 204+20) //用于判断4
                                begin
                                    if (mouse_add1_location == 4'h4)
                                        begin
                                        if ( location_4_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_4_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_4_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_4_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h4)
                                        begin
                                        if ( location_4_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_4_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_4_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_4_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h4)
                                        begin
                                        if ( location_4_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_4_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_4_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_4_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 276-20 && y_pos < 324+20) //用于判断7
                                begin
                                    if (mouse_add1_location == 4'h7)
                                        begin
                                        if ( location_7_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_7_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_7_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_7_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h7)
                                        begin
                                        if ( location_7_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_7_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_7_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_7_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h7)
                                        begin
                                        if ( location_7_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_7_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_7_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_7_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 394-20 && y_pos < 444+20) //用于判断0
                                begin
                                    if (mouse_add1_location == 4'h0)
                                        begin
                                        if ( location_0_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_0_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_0_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_0_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h0)
                                        begin
                                        if ( location_0_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_0_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_0_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_0_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h0)
                                        begin
                                        if ( location_0_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_0_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_0_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_0_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else
                                begin
                                    color_out <= Grass_green;
                                end
                        end
                    else if (x_pos >= 156-20 && x_pos < 204+20)   //用于判断2，5，8，F
                        begin
                            if (y_pos >= 36-20 && y_pos < 84+20)  //用于判断2
                                begin
                                    if (mouse_add1_location == 4'h2)
                                        begin
                                        if ( location_2_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_2_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_2_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_2_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h2)
                                        begin
                                        if ( location_2_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_2_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_2_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_2_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h2)
                                        begin
                                        if ( location_2_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_2_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_2_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_2_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 156-20 && y_pos < 204+20) //用于判断5
                                begin
                                    if (mouse_add1_location == 4'h5)
                                        begin
                                        if ( location_5_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_5_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_5_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_5_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h5)
                                        begin
                                        if ( location_5_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_5_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_5_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_5_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h5)
                                        begin
                                        if ( location_5_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_5_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_5_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_5_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 276-20 && y_pos < 324+20) //用于判断8
                                begin
                                    if (mouse_add1_location == 4'h8)
                                        begin
                                        if ( location_8_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_8_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_8_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_8_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h8)
                                        begin
                                        if ( location_8_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_8_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_8_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_8_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h8)
                                        begin
                                        if ( location_8_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_8_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_8_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_8_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 394-20 && y_pos < 444+20) //用于判断F
                                begin
                                    if (mouse_add1_location == 4'hf)
                                        begin
                                        if ( location_f_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_f_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_f_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_f_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'hf)
                                        begin
                                        if ( location_f_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_f_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_f_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_f_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'hf)
                                        begin
                                        if ( location_f_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_f_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_f_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_f_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else
                                begin
                                    color_out <= Grass_green;
                                end
                        end
                    else if (x_pos >= 276-20 && x_pos < 324+20)  //用于判断3，6，9，E
                        begin
                            if (y_pos >= 36-20 && y_pos < 84+20)  //用于判断3
                                begin
                                    if (mouse_add1_location == 4'h3)
                                        begin
                                        if ( location_3_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_3_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_3_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_3_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h3)
                                        begin
                                        if ( location_3_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_3_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_3_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_3_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h3)
                                        begin
                                        if ( location_3_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_3_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_3_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_3_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 156-20 && y_pos < 204+20) //用于判断6
                                begin
                                    if (mouse_add1_location == 4'h6)
                                        begin
                                        if ( location_6_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_6_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_6_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_6_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h6)
                                        begin
                                        if ( location_6_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_6_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_6_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_6_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h6)
                                        begin
                                        if ( location_6_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_6_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_6_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_6_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 276-20 && y_pos < 324+20) //用于判断9
                                begin
                                    if (mouse_add1_location == 4'h9)
                                        begin
                                        if ( location_9_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_9_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_9_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_9_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'h9)
                                        begin
                                        if ( location_9_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_9_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_9_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_9_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'h9)
                                        begin
                                        if ( location_9_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_9_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_9_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_9_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 394-20 && y_pos < 444+20) //用于判断E
                                begin
                                    if (mouse_add1_location == 4'he)
                                        begin
                                        if ( location_e_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_e_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_e_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_e_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'he)
                                        begin
                                        if ( location_e_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_e_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_e_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_e_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'he)
                                        begin
                                        if ( location_e_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_e_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_e_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_e_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else
                                color_out <= Grass_green;
                        end
                    else if (x_pos >= 394-20 && x_pos < 444+20)   //用于判断A，B，C，D
                        begin
                            if (y_pos >= 36-20 && y_pos < 84+20)  //用于判断A
                                begin
                                    if (mouse_add1_location == 4'ha)
                                        begin
                                        if ( location_a_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_a_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_a_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_a_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'ha)
                                        begin
                                        if ( location_a_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_a_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_a_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_a_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'ha)
                                        begin
                                        if ( location_a_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_a_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_a_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_a_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 156-20 && y_pos < 204+20) //用于判断B
                                begin
                                    if (mouse_add1_location == 4'hb)
                                        begin
                                        if ( location_b_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_b_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_b_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_b_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'hb)
                                        begin
                                        if ( location_b_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_b_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_b_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_b_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'hb)
                                        begin
                                        if ( location_b_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_b_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_b_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_b_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 276-20 && y_pos < 324+20) //用于判断C
                                begin
                                    if (mouse_add1_location == 4'hc)
                                        begin
                                        if ( location_c_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_c_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_c_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_c_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'hc)
                                        begin
                                        if ( location_c_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_c_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_c_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_c_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'hc)
                                        begin
                                        if ( location_c_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_c_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_c_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_c_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else if (y_pos >= 394-20 && y_pos < 444+20) //用于判断D
                                begin
                                    if (mouse_add1_location == 4'hd)
                                        begin
                                        if ( location_d_line == 1 )
                                            if (flag_add1 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_d_stone == 1)
                                            if (flag_add1 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_d_body == 1)
                                            if (flag_add1 == 1 && enable_add1 == 1)     color_out <= Baby_blue;
                                            else if (flag_add1 == 1 && enable_add1 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_d_eyes == 1)
                                            if (flag_add1 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end        
                                    else if (mouse_add2_location == 4'hd)
                                        begin
                                        if ( location_d_line == 1 )
                                            if (flag_add2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_d_stone == 1)
                                            if (flag_add2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_d_body == 1)
                                            if (flag_add2 == 1 && enable_add2 == 1)     color_out <= Baby_yellow;
                                            else if (flag_add2 == 1 && enable_add2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_d_eyes == 1)
                                            if (flag_add2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else if (mouse_reduce2_location == 4'hd)
                                        begin
                                        if ( location_d_line == 1 )
                                            if (flag_reduce2 == 1 )     color_out <= Black;
                                            else   color_out <= Grass_green;
                                        else if (location_d_stone == 1)
                                            if (flag_reduce2 == 1 )     color_out <= Brown;
                                            else   color_out <= Grass_green;
                                        else if (location_d_body == 1)
                                            if (flag_reduce2 == 1 && enable_reduce2 == 1)     color_out <= Baby_red;
                                            else if (flag_reduce2 == 1 && enable_reduce2 == 0)    color_out <= Black;
                                            else    color_out <= Grass_green;
                                        else if (location_d_eyes == 1)
                                            if (flag_reduce2 == 1 )     color_out <= White;
                                            else    color_out <= Grass_green;
                                        else
                                            color_out <= Grass_green;
                                        end
                                    else
                                        color_out <= Grass_green;
                                end
                            else
                                begin
                                    color_out <= Grass_green;
                                end
                        end
                    else    //
                        begin
                        color_out <= Grass_green;
                        end
                    end
                end
            else    //地鼠,计分以及时间
                begin
                    if (y_pos >= 0 && y_pos < 120)  // flash动画
                        begin
                        if (flash == 2) //第三幅砸
                            begin
                            if ((flash_x + flash_y >= 36 )&&(flash_x + flash_y <= 56) && ( (flash_y>= flash_x)&& (flash_y - flash_x <= 8)  ||(flash_y< flash_x) &&(flash_x - flash_y <= 34)  ))
                                color_out <= White;
                            else if ((flash_x + flash_y >= 57 )&&(flash_x + flash_y <= 97)&& (flash_y < flash_x) && (flash_x - flash_y <= 17 ) && (flash_x - flash_y >= 9))
                                color_out <= White;
                            else if (flash_x >= 11 && flash_x <= 23 && flash_y >= 42 && flash_y <= 45)
                                color_out <= Baby_blue;
                            else if (flash_x >= 12 && flash_x <= 22 && flash_y >= 40 && flash_y <= 41)
                                color_out <= Baby_blue;    
                            else if (flash_x >= 13 && flash_x <= 21 && flash_y >= 36 && flash_y <= 39)
                                color_out <= Baby_blue;    
                            else if (((flash_x >= 16 && flash_x <= 18)||(flash_x >= 10 && flash_x <= 14)||(flash_x >= 20 && flash_x <= 24) )&& flash_y == 35)
                                color_out <= Baby_blue; 
                            else if (((flash_x >= 10 && flash_x <= 14)||(flash_x >= 20 && flash_x <= 24)) && (flash_y == 34 || flash_y == 36))
                                color_out <= Baby_blue;
                            else if (((flash_x >= 11 && flash_x <= 13)||(flash_x >= 21 && flash_x <= 23)) && (flash_y == 33 || flash_y == 37))
                                color_out <= Baby_blue;    
                            else if (flash_x >= 5 && flash_x <= 70 && flash_y>= 46 && flash_y<= 48)
                                color_out <= White;
                            else
                                color_out <= Old_red;
                            end
                        else if (flash == 1)  //第二幅 (出现地鼠)
                            begin
                            if (flash_x >= 41 && flash_x <= 70 && flash_y >= 1 && flash_y <= 15)
                                color_out <= White;
                            else if (flash_x >= 53 && flash_x <= 58 && flash_y >= 16 && flash_y <= 44)
                                color_out <= White;
                            else if (flash_x >= 11 && flash_x <= 23 && flash_y >= 42 && flash_y <= 45)
                                color_out <= Baby_blue;
                            else if (flash_x >= 12 && flash_x <= 22 && flash_y >= 40 && flash_y <= 41)
                                color_out <= Baby_blue;    
                            else if (flash_x >= 13 && flash_x <= 21 && flash_y >= 36 && flash_y <= 39)
                                color_out <= Baby_blue;    
                            else if (((flash_x >= 16 && flash_x <= 18)||(flash_x >= 10 && flash_x <= 14)||(flash_x >= 20 && flash_x <= 24) )&& flash_y == 35)
                                color_out <= Baby_blue; 
                            else if (((flash_x >= 10 && flash_x <= 14)||(flash_x >= 20 && flash_x <= 24)) && (flash_y == 34 || flash_y == 36))
                                color_out <= Baby_blue;
                            else if (((flash_x >= 11 && flash_x <= 13)||(flash_x >= 21 && flash_x <= 23)) && (flash_y == 33 || flash_y == 37))
                                color_out <= Baby_blue;    
                            else if (flash_x >= 5 && flash_x <= 70 && flash_y>= 46 && flash_y<= 48)
                                color_out <= White;
                            else
                                color_out <= Old_red;
                            end
                        else
                            begin
                            if (flash_x >= 41 && flash_x <= 70 && flash_y >= 1 && flash_y <= 15)
                                color_out <= White;
                            else if (flash_x >= 53 && flash_x <= 58 && flash_y >= 16 && flash_y <= 44)
                                color_out <= White;
                            else if (flash_x >= 5 && flash_x <= 70 && flash_y>= 46 && flash_y<= 48)
                                color_out <= White;
                            else
                                color_out <= Old_red;
                            end
                        end
                    else if (location_score || location_time)
                        color_out <= White;
                    else if (y_pos >= 170 && y_pos < 270) 
                        begin
                        if (x_pos<550)
                            case (Tens_time)
                                0:  if(Time_ten_0)  color_out <= White;
                                    else    color_out <= Old_red;
                                1:  if(Time_ten_1)  color_out <= White;
                                    else    color_out <= Old_red;
                                2:  if(Time_ten_2)  color_out <= White;
                                    else    color_out <= Old_red;
                                3:  if(Time_ten_3)  color_out <= White;
                                    else    color_out <= Old_red;
                                4:  if(Time_ten_4)  color_out <= White;
                                    else    color_out <= Old_red;
                                5:  if(Time_ten_5)  color_out <= White;
                                    else    color_out <= Old_red;
                                6:  if(Time_ten_6)  color_out <= White;
                                    else    color_out <= Old_red;
                                default:   color_out <= Old_red;
                            endcase
                        else
                            case (Ones_time)
                                0:  if(Time_unit_0)  color_out <= White;
                                    else    color_out <= Old_red;
                                1:  if(Time_unit_1)  color_out <= White;
                                    else    color_out <= Old_red;
                                2:  if(Time_unit_2)  color_out <= White;
                                    else    color_out <= Old_red;
                                3:  if(Time_unit_3)  color_out <= White;
                                    else    color_out <= Old_red;
                                4:  if(Time_unit_4)  color_out <= White;
                                    else    color_out <= Old_red;
                                5:  if(Time_unit_5)  color_out <= White;
                                    else    color_out <= Old_red;
                                6:  if(Time_unit_6)  color_out <= White;
                                    else    color_out <= Old_red;
                                7:  if(Time_unit_7)  color_out <= White;
                                    else    color_out <= Old_red;
                                8:  if(Time_unit_8)  color_out <= White;
                                    else    color_out <= Old_red;
                                9:  if(Time_unit_9)  color_out <= White;
                                    else    color_out <= Old_red;
                                default:   color_out <= Old_red;
                            endcase
                        end
                    else if (y_pos >= 330) 
                        begin
                        if (x_pos<550)
                            case (Tens_scores)
                                0:  if(Score_ten_0)  color_out <= White;
                                    else    color_out <= Old_red;
                                1:  if(Score_ten_1)  color_out <= White;
                                    else    color_out <= Old_red;
                                2:  if(Score_ten_2)  color_out <= White;
                                    else    color_out <= Old_red;
                                3:  if(Score_ten_3)  color_out <= White;
                                    else    color_out <= Old_red;
                                4:  if(Score_ten_4)  color_out <= White;
                                    else    color_out <= Old_red;
                                5:  if(Score_ten_5)  color_out <= White;
                                    else    color_out <= Old_red;
                                6:  if(Score_ten_6)  color_out <= White;
                                    else    color_out <= Old_red;
                                7:  if(Score_ten_7)  color_out <= White;
                                    else    color_out <= Old_red;
                                8:  if(Score_ten_8)  color_out <= White;
                                    else    color_out <= Old_red;
                                9:  if(Score_ten_9)  color_out <= White;
                                    else    color_out <= Old_red;
                                default:   color_out <= Old_red;
                            endcase
                        else
                            case (Ones_scores)
                                0:  if(Score_unit_0)  color_out <= White;
                                    else    color_out <= Old_red;
                                1:  if(Score_unit_1)  color_out <= White;
                                    else    color_out <= Old_red;
                                2:  if(Score_unit_2)  color_out <= White;
                                    else    color_out <= Old_red;
                                3:  if(Score_unit_3)  color_out <= White;
                                    else    color_out <= Old_red;
                                4:  if(Score_unit_4)  color_out <= White;
                                    else    color_out <= Old_red;
                                5:  if(Score_unit_5)  color_out <= White;
                                    else    color_out <= Old_red;
                                6:  if(Score_unit_6)  color_out <= White;
                                    else    color_out <= Old_red;
                                7:  if(Score_unit_7)  color_out <= White;
                                    else    color_out <= Old_red;
                                8:  if(Score_unit_8)  color_out <= White;
                                    else    color_out <= Old_red;
                                9:  if(Score_unit_9)  color_out <= White;
                                    else    color_out <= Old_red;
                                default:   color_out <= Old_red;
                            endcase
                        end
                    else
                        color_out <= Old_red;
                end
            end
        else // 消隐
            color_out <= Black; 
    end
    

	assign location_1_line = ( x_pos-25==10 && y_pos-25>= 58 && y_pos-25<= 62) || 
                            ( x_pos-25==11 && ((y_pos-25>= 57 && y_pos-25<= 58) || (y_pos-25>= 62 && y_pos-25 <=63 ))) ||
                            ( x_pos-25==12 && ((y_pos-25>= 54 && y_pos-25<= 57) || (y_pos-25>= 63 && y_pos-25 <=64 ))) ||
                            ( x_pos-25==13 && (y_pos-25==53 || y_pos-25== 57 || y_pos-25 ==64 )) ||
                            ( x_pos-25==14 && ((y_pos-25>= 25 && y_pos-25<= 58) || y_pos-25== 64 )) ||
                            ( x_pos-25==15 && ((y_pos-25>= 20 && y_pos-25<= 25) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25==16 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25==17 && ((y_pos-25>= 13 && y_pos-25<= 17) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25==18 && ((y_pos-25>= 11 && y_pos-25<= 13) || y_pos-25== 58 || (y_pos-25>= 61 && y_pos-25 <=65 ))) ||
                            ( x_pos-25==19 && ((y_pos-25>= 9  && y_pos-25<= 11) || (y_pos-25>= 59 && y_pos-25 <=61 )|| (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25==20 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25>= 66 && y_pos-25 <=67 ))) ||
                            ( x_pos-25==21 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 60 || y_pos-25 ==67))  ||
                            ( x_pos-25==22 && ((y_pos-25>= 6 && y_pos-25<= 7) || y_pos-25== 60 || (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25==23 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=61 ))) ||
                            ( x_pos-25==24 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=62 ))) ||
                            ( x_pos-25==25 && ((y_pos-25>= 3 && y_pos-25<= 4) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25==26 && ( y_pos-25== 3 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25==27 && ((y_pos-25>= 2 && y_pos-25<= 3) || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25==28 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25==29 && ((y_pos-25>= 1 && y_pos-25<= 2) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25==30 && ( y_pos-25== 1 || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25==31 && ( y_pos-25== 1 || (y_pos-25>= 60 && y_pos-25 <=63 )|| y_pos-25 ==67))  ||
                            ( x_pos-25==32 && ( y_pos-25== 1 || (y_pos-25>= 63 && y_pos-25 <=67 )|| y_pos-25 ==60))  ||
                            ( x_pos-25==33 && ( y_pos-25== 1 || (y_pos-25>= 67 && y_pos-25 <=68 )|| y_pos-25 ==60))  ||
                            ( x_pos-25==34 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==35 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==36 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==37 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==38 && ( y_pos-25== 1 || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==39 && ( y_pos-25== 1 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| (y_pos-25>= 60 && y_pos-25 <=61 ) || y_pos-25 ==68))  ||
                            ( x_pos-25==40 && ( y_pos-25== 1 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 61 && y_pos-25 <=63 ) || y_pos-25 ==68 ))  ||
                            ( x_pos-25==41 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 62 && y_pos-25 <=64 ) || y_pos-25 ==68 ))  ||
                            ( x_pos-25==42 && ( y_pos-25== 2 || (y_pos-25>= 20 && y_pos-25 <=25 )|| (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 64 && y_pos-25 <=68 ))) ||
                            ( x_pos-25==43 && ( y_pos-25== 2 || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25==44 && ((y_pos-25>= 2 && y_pos-25<= 3) || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25==45 && ( y_pos-25== 3 || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25==46 && ((y_pos-25>= 3 && y_pos-25<= 4) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==47 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==48 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==49 && ((y_pos-25>= 6 && y_pos-25<= 7) || (y_pos-25>= 60 && y_pos-25 <=62 ) || y_pos-25 ==68))  ||
                            ( x_pos-25==50 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25==51 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25==52 && ((y_pos-25>= 9  && y_pos-25<= 10) || (y_pos-25>= 63 && y_pos-25 <=67 ))) ||
                            ( x_pos-25==53 && ((y_pos-25>= 10  && y_pos-25<= 12)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25==54 && ((y_pos-25>= 12  && y_pos-25<= 14)  || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25==55 && ((y_pos-25>= 14  && y_pos-25<= 17)  || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25==56 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25==57 && ((y_pos-25>= 20  && y_pos-25<= 24) || (y_pos-25>= 67 && y_pos-25 <=68 )|| (y_pos-25== 60 ))) ||
                            ( x_pos-25==58 && ((y_pos-25>= 24  && y_pos-25<= 60) || (y_pos-25== 67 ))) ||
                            ( x_pos-25==59 && ((y_pos-25>= 66 && y_pos-25<= 67) || y_pos-25== 55 || y_pos-25 ==60))  ||
                            ( x_pos-25==60 && ((y_pos-25>= 55  && y_pos-25<= 57) || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25== 66 ))) ||
                            ( x_pos-25==61 && ((y_pos-25>= 57 && y_pos-25<= 59) || (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25==62 && ( y_pos-25== 59 || y_pos-25 ==65))  ||
                            ( x_pos-25==63 && ((y_pos-25>= 59 && y_pos-25<= 60) || y_pos-25== 65 ))  ||
                            ( x_pos-25==64 && (y_pos-25>= 60 && y_pos-25<= 64) ) ;
    assign location_1_body = ( x_pos-25==15 && (y_pos-25> 25 && y_pos-25< 58)) ||
                            ( x_pos-25==16 && (y_pos-25> 20 && y_pos-25< 58)) ||
                            ( x_pos-25==17 && (y_pos-25> 17 && y_pos-25< 58)) ||
                            ( x_pos-25==18 && (y_pos-25> 13 && y_pos-25< 58)) ||
                            ( x_pos-25==19 && (y_pos-25> 11 && y_pos-25< 59)) ||
                            ( x_pos-25==20 && (y_pos-25> 9 && y_pos-25< 59)) ||
                            ( x_pos-25==21 && (y_pos-25> 8 && y_pos-25< 60))  ||
                            ( x_pos-25==22 && (y_pos-25> 7 && y_pos-25< 60)) ||
                            ( x_pos-25==23 && (y_pos-25> 6 && y_pos-25< 60)) ||
                            ( x_pos-25==24 && (y_pos-25> 5 && y_pos-25< 61)) ||
                            ( x_pos-25==25 && ((y_pos-25> 4 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 62))) ||
                            ( x_pos-25==26 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25==27 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 63))) ||
                            ( x_pos-25==28 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 64))) ||
                            ( x_pos-25==29 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 65))) ||
                            ( x_pos-25==30 && (y_pos-25> 1 && y_pos-25< 61)) ||
                            ( x_pos-25==31 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==32 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==33 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==34 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==35 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==36 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==37 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25==38 && ((y_pos-25> 1 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 60))) ||
                            ( x_pos-25==39 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 60))) ||
                            ( x_pos-25==40 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 61))) ||
                            ( x_pos-25==41 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25==42 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 61))) ||
                            ( x_pos-25==43 && (y_pos-25> 2 && y_pos-25< 61))  ||
                            ( x_pos-25==44 && (y_pos-25> 3 && y_pos-25< 61))  ||
                            ( x_pos-25==45 && (y_pos-25> 3 && y_pos-25< 60)) ||
                            ( x_pos-25==46 && (y_pos-25> 4 && y_pos-25< 60))  ||
                            ( x_pos-25==47 && (y_pos-25> 5 && y_pos-25< 60))  ||
                            ( x_pos-25==48 && (y_pos-25> 6 && y_pos-25< 60))  ||
                            ( x_pos-25==49 && (y_pos-25> 7 && y_pos-25< 60))  ||
                            ( x_pos-25==50 && (y_pos-25> 8 && y_pos-25< 62))  ||
                            ( x_pos-25==51 && (y_pos-25> 9 && y_pos-25< 62))  ||
                            ( x_pos-25==52 && (y_pos-25> 10 && y_pos-25< 63))  ||
                            ( x_pos-25==53 && (y_pos-25> 12 && y_pos-25< 62))  ||
                            ( x_pos-25==54 && (y_pos-25> 14 && y_pos-25< 61))  ||
                            ( x_pos-25==55 && (y_pos-25> 17 && y_pos-25< 60))  ||
                            ( x_pos-25==56 && (y_pos-25> 20 && y_pos-25< 60))  ||
                            ( x_pos-25==57 && (y_pos-25> 24 && y_pos-25< 60))  ;
    assign location_1_stone = ( x_pos-25==11 && (y_pos-25> 58 && y_pos-25< 62)) ||
                            ( x_pos-25==12 && (y_pos-25> 57 && y_pos-25< 63)) ||
                            ( x_pos-25==13 && ((y_pos-25> 53 && y_pos-25< 57)||(y_pos-25> 57 && y_pos-25< 64))) ||
                            ( x_pos-25==14 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25==15 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25==16 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25==17 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25==18 && (y_pos-25> 58 && y_pos-25< 61)) ||
                            ( x_pos-25==19 && (y_pos-25> 61 && y_pos-25< 65)) ||
                            ( x_pos-25==20 && (y_pos-25> 60 && y_pos-25< 66)) ||
                            ( x_pos-25==21 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25==22 && (y_pos-25> 60 && y_pos-25< 67)) ||
                            ( x_pos-25==23 && (y_pos-25> 61 && y_pos-25< 68)) ||
                            ( x_pos-25==24 && (y_pos-25> 62 && y_pos-25< 68)) ||
                            ( x_pos-25==25 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==26 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==27 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==28 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==29 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==30 && (y_pos-25> 62 && y_pos-25< 67)) ||
                            ( x_pos-25==31 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25==32 && (y_pos-25> 60 && y_pos-25< 63))  ||
                            ( x_pos-25==33 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25==34 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==35 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==36 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==37 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==38 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==39 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25==40 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25==41 && (y_pos-25> 64 && y_pos-25< 68))  ||
                            ( x_pos-25==42 && (y_pos-25> 62 && y_pos-25< 64)) ||
                            ( x_pos-25==43 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25==44 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25==45 && (y_pos-25> 61 && y_pos-25< 67)) ||
                            ( x_pos-25==46 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==47 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==48 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==49 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==50 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==51 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25==53 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25==54 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25==55 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25==56 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==57 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25==58 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25==59 && (y_pos-25> 55 && y_pos-25 !=60 && y_pos-25< 66))  ||
                            ( x_pos-25==60 && (y_pos-25> 57&& y_pos-25 !=60 && y_pos-25 !=59  && y_pos-25< 66))  ||
                            ( x_pos-25==61 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25==62 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25==63 && (y_pos-25> 60 && y_pos-25< 65)) ;
    assign location_1_eyes = ( x_pos-25== 26 && (y_pos-25>= 20 && y_pos-25 <= 22) ) || ( x_pos-25== 39 && (y_pos-25 >= 20 && y_pos-25<= 22));


	assign location_4_line = ( x_pos-25==10 && y_pos-25-120>= 58 && y_pos-25-120<= 62) || 
                            ( x_pos-25==11 && ((y_pos-25-120>= 57 && y_pos-25-120<= 58) || (y_pos-25-120>= 62 && y_pos-25-120 <=63 ))) ||
                            ( x_pos-25==12 && ((y_pos-25-120>= 54 && y_pos-25-120<= 57) || (y_pos-25-120>= 63 && y_pos-25-120 <=64 ))) ||
                            ( x_pos-25==13 && (y_pos-25-120==53 || y_pos-25-120== 57 || y_pos-25-120 ==64 )) ||
                            ( x_pos-25==14 && ((y_pos-25-120>= 25 && y_pos-25-120<= 58) || y_pos-25-120== 64 )) ||
                            ( x_pos-25==15 && ((y_pos-25-120>= 20 && y_pos-25-120<= 25) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25==16 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25==17 && ((y_pos-25-120>= 13 && y_pos-25-120<= 17) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25==18 && ((y_pos-25-120>= 11 && y_pos-25-120<= 13) || y_pos-25-120== 58 || (y_pos-25-120>= 61 && y_pos-25-120 <=65 ))) ||
                            ( x_pos-25==19 && ((y_pos-25-120>= 9  && y_pos-25-120<= 11) || (y_pos-25-120>= 59 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25==20 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120>= 66 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25==21 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 60 || y_pos-25-120 ==67))  ||
                            ( x_pos-25==22 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || y_pos-25-120== 60 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25==23 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 ))) ||
                            ( x_pos-25==24 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ))) ||
                            ( x_pos-25==25 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==26 && ( y_pos-25-120== 3 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==27 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==28 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==29 && ((y_pos-25-120>= 1 && y_pos-25-120<= 2) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==30 && ( y_pos-25-120== 1 || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25==31 && ( y_pos-25-120== 1 || (y_pos-25-120>= 60 && y_pos-25-120 <=63 )|| y_pos-25-120 ==67))  ||
                            ( x_pos-25==32 && ( y_pos-25-120== 1 || (y_pos-25-120>= 63 && y_pos-25-120 <=67 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25==33 && ( y_pos-25-120== 1 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25==34 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==35 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==36 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==37 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==38 && ( y_pos-25-120== 1 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==39 && ( y_pos-25-120== 1 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 60 && y_pos-25-120 <=61 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25==40 && ( y_pos-25-120== 1 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=63 ) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25==41 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 62 && y_pos-25-120 <=64 ) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25==42 && ( y_pos-25-120== 2 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 64 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25==43 && ( y_pos-25-120== 2 || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25==44 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25==45 && ( y_pos-25-120== 3 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25==46 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==47 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==48 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==49 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25==50 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==51 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25==52 && ((y_pos-25-120>= 9  && y_pos-25-120<= 10) || (y_pos-25-120>= 63 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25==53 && ((y_pos-25-120>= 10  && y_pos-25-120<= 12)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25==54 && ((y_pos-25-120>= 12  && y_pos-25-120<= 14)  || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25==55 && ((y_pos-25-120>= 14  && y_pos-25-120<= 17)  || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25==56 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25==57 && ((y_pos-25-120>= 20  && y_pos-25-120<= 24) || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| (y_pos-25-120== 60 ))) ||
                            ( x_pos-25==58 && ((y_pos-25-120>= 24  && y_pos-25-120<= 60) || (y_pos-25-120== 67 ))) ||
                            ( x_pos-25==59 && ((y_pos-25-120>= 66 && y_pos-25-120<= 67) || y_pos-25-120== 55 || y_pos-25-120 ==60))  ||
                            ( x_pos-25==60 && ((y_pos-25-120>= 55  && y_pos-25-120<= 57) || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120== 66 ))) ||
                            ( x_pos-25==61 && ((y_pos-25-120>= 57 && y_pos-25-120<= 59) || (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25==62 && ( y_pos-25-120== 59 || y_pos-25-120 ==65))  ||
                            ( x_pos-25==63 && ((y_pos-25-120>= 59 && y_pos-25-120<= 60) || y_pos-25-120== 65 ))  ||
                            ( x_pos-25==64 && (y_pos-25-120>= 60 && y_pos-25-120<= 64) ) ;
    assign location_4_body = ( x_pos-25==15 && (y_pos-25-120> 25 && y_pos-25-120< 58)) ||
                            ( x_pos-25==16 && (y_pos-25-120> 20 && y_pos-25-120< 58)) ||
                            ( x_pos-25==17 && (y_pos-25-120> 17 && y_pos-25-120< 58)) ||
                            ( x_pos-25==18 && (y_pos-25-120> 13 && y_pos-25-120< 58)) ||
                            ( x_pos-25==19 && (y_pos-25-120> 11 && y_pos-25-120< 59)) ||
                            ( x_pos-25==20 && (y_pos-25-120> 9 && y_pos-25-120< 59)) ||
                            ( x_pos-25==21 && (y_pos-25-120> 8 && y_pos-25-120< 60))  ||
                            ( x_pos-25==22 && (y_pos-25-120> 7 && y_pos-25-120< 60)) ||
                            ( x_pos-25==23 && (y_pos-25-120> 6 && y_pos-25-120< 60)) ||
                            ( x_pos-25==24 && (y_pos-25-120> 5 && y_pos-25-120< 61)) ||
                            ( x_pos-25==25 && ((y_pos-25-120> 4 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 62))) ||
                            ( x_pos-25==26 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25==27 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 63))) ||
                            ( x_pos-25==28 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 64))) ||
                            ( x_pos-25==29 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 65))) ||
                            ( x_pos-25==30 && (y_pos-25-120> 1 && y_pos-25-120< 61)) ||
                            ( x_pos-25==31 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==32 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==33 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==34 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==35 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==36 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==37 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25==38 && ((y_pos-25-120> 1 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 60))) ||
                            ( x_pos-25==39 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 60))) ||
                            ( x_pos-25==40 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 61))) ||
                            ( x_pos-25==41 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25==42 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 61))) ||
                            ( x_pos-25==43 && (y_pos-25-120> 2 && y_pos-25-120< 61))  ||
                            ( x_pos-25==44 && (y_pos-25-120> 3 && y_pos-25-120< 61))  ||
                            ( x_pos-25==45 && (y_pos-25-120> 3 && y_pos-25-120< 60)) ||
                            ( x_pos-25==46 && (y_pos-25-120> 4 && y_pos-25-120< 60))  ||
                            ( x_pos-25==47 && (y_pos-25-120> 5 && y_pos-25-120< 60))  ||
                            ( x_pos-25==48 && (y_pos-25-120> 6 && y_pos-25-120< 60))  ||
                            ( x_pos-25==49 && (y_pos-25-120> 7 && y_pos-25-120< 60))  ||
                            ( x_pos-25==50 && (y_pos-25-120> 8 && y_pos-25-120< 62))  ||
                            ( x_pos-25==51 && (y_pos-25-120> 9 && y_pos-25-120< 62))  ||
                            ( x_pos-25==52 && (y_pos-25-120> 10 && y_pos-25-120< 63))  ||
                            ( x_pos-25==53 && (y_pos-25-120> 12 && y_pos-25-120< 62))  ||
                            ( x_pos-25==54 && (y_pos-25-120> 14 && y_pos-25-120< 61))  ||
                            ( x_pos-25==55 && (y_pos-25-120> 17 && y_pos-25-120< 60))  ||
                            ( x_pos-25==56 && (y_pos-25-120> 20 && y_pos-25-120< 60))  ||
                            ( x_pos-25==57 && (y_pos-25-120> 24 && y_pos-25-120< 60))  ;
    assign location_4_stone = ( x_pos-25==11 && (y_pos-25-120> 58 && y_pos-25-120< 62)) ||
                            ( x_pos-25==12 && (y_pos-25-120> 57 && y_pos-25-120< 63)) ||
                            ( x_pos-25==13 && ((y_pos-25-120> 53 && y_pos-25-120< 57)||(y_pos-25-120> 57 && y_pos-25-120< 64))) ||
                            ( x_pos-25==14 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25==15 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25==16 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25==17 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25==18 && (y_pos-25-120> 58 && y_pos-25-120< 61)) ||
                            ( x_pos-25==19 && (y_pos-25-120> 61 && y_pos-25-120< 65)) ||
                            ( x_pos-25==20 && (y_pos-25-120> 60 && y_pos-25-120< 66)) ||
                            ( x_pos-25==21 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25==22 && (y_pos-25-120> 60 && y_pos-25-120< 67)) ||
                            ( x_pos-25==23 && (y_pos-25-120> 61 && y_pos-25-120< 68)) ||
                            ( x_pos-25==24 && (y_pos-25-120> 62 && y_pos-25-120< 68)) ||
                            ( x_pos-25==25 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==26 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==27 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==28 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==29 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==30 && (y_pos-25-120> 62 && y_pos-25-120< 67)) ||
                            ( x_pos-25==31 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25==32 && (y_pos-25-120> 60 && y_pos-25-120< 63))  ||
                            ( x_pos-25==33 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25==34 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==35 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==36 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==37 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==38 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==39 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25==40 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25==41 && (y_pos-25-120> 64 && y_pos-25-120< 68))  ||
                            ( x_pos-25==42 && (y_pos-25-120> 62 && y_pos-25-120< 64)) ||
                            ( x_pos-25==43 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25==44 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25==45 && (y_pos-25-120> 61 && y_pos-25-120< 67)) ||
                            ( x_pos-25==46 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==47 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==48 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==49 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==50 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==51 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25==53 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25==54 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25==55 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25==56 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==57 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25==58 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25==59 && (y_pos-25-120> 55 && y_pos-25-120 !=60 && y_pos-25-120< 66))  ||
                            ( x_pos-25==60 && (y_pos-25-120> 57&& y_pos-25-120 !=60 && y_pos-25-120 !=59  && y_pos-25-120< 66))  ||
                            ( x_pos-25==61 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25==62 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25==63 && (y_pos-25-120> 60 && y_pos-25-120< 65)) ;
    assign location_4_eyes = ( x_pos-25== 26 && (y_pos-25-120>= 20 && y_pos-25-120 <= 22) ) || ( x_pos-25== 39 && (y_pos-25-120 >= 20 && y_pos-25-120<= 22));


	assign location_7_line = ( x_pos-25==10 && y_pos-25-240>= 58 && y_pos-25-240<= 62) || 
                            ( x_pos-25==11 && ((y_pos-25-240>= 57 && y_pos-25-240<= 58) || (y_pos-25-240>= 62 && y_pos-25-240 <=63 ))) ||
                            ( x_pos-25==12 && ((y_pos-25-240>= 54 && y_pos-25-240<= 57) || (y_pos-25-240>= 63 && y_pos-25-240 <=64 ))) ||
                            ( x_pos-25==13 && (y_pos-25-240==53 || y_pos-25-240== 57 || y_pos-25-240 ==64 )) ||
                            ( x_pos-25==14 && ((y_pos-25-240>= 25 && y_pos-25-240<= 58) || y_pos-25-240== 64 )) ||
                            ( x_pos-25==15 && ((y_pos-25-240>= 20 && y_pos-25-240<= 25) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25==16 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25==17 && ((y_pos-25-240>= 13 && y_pos-25-240<= 17) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25==18 && ((y_pos-25-240>= 11 && y_pos-25-240<= 13) || y_pos-25-240== 58 || (y_pos-25-240>= 61 && y_pos-25-240 <=65 ))) ||
                            ( x_pos-25==19 && ((y_pos-25-240>= 9  && y_pos-25-240<= 11) || (y_pos-25-240>= 59 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25==20 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240>= 66 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25==21 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 60 || y_pos-25-240 ==67))  ||
                            ( x_pos-25==22 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || y_pos-25-240== 60 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25==23 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 ))) ||
                            ( x_pos-25==24 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ))) ||
                            ( x_pos-25==25 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==26 && ( y_pos-25-240== 3 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==27 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==28 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==29 && ((y_pos-25-240>= 1 && y_pos-25-240<= 2) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==30 && ( y_pos-25-240== 1 || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25==31 && ( y_pos-25-240== 1 || (y_pos-25-240>= 60 && y_pos-25-240 <=63 )|| y_pos-25-240 ==67))  ||
                            ( x_pos-25==32 && ( y_pos-25-240== 1 || (y_pos-25-240>= 63 && y_pos-25-240 <=67 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25==33 && ( y_pos-25-240== 1 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25==34 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==35 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==36 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==37 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==38 && ( y_pos-25-240== 1 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==39 && ( y_pos-25-240== 1 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 60 && y_pos-25-240 <=61 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25==40 && ( y_pos-25-240== 1 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=63 ) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25==41 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 62 && y_pos-25-240 <=64 ) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25==42 && ( y_pos-25-240== 2 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 64 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25==43 && ( y_pos-25-240== 2 || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25==44 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25==45 && ( y_pos-25-240== 3 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25==46 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==47 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==48 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==49 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25==50 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==51 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25==52 && ((y_pos-25-240>= 9  && y_pos-25-240<= 10) || (y_pos-25-240>= 63 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25==53 && ((y_pos-25-240>= 10  && y_pos-25-240<= 12)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25==54 && ((y_pos-25-240>= 12  && y_pos-25-240<= 14)  || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25==55 && ((y_pos-25-240>= 14  && y_pos-25-240<= 17)  || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25==56 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25==57 && ((y_pos-25-240>= 20  && y_pos-25-240<= 24) || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| (y_pos-25-240== 60 ))) ||
                            ( x_pos-25==58 && ((y_pos-25-240>= 24  && y_pos-25-240<= 60) || (y_pos-25-240== 67 ))) ||
                            ( x_pos-25==59 && ((y_pos-25-240>= 66 && y_pos-25-240<= 67) || y_pos-25-240== 55 || y_pos-25-240 ==60))  ||
                            ( x_pos-25==60 && ((y_pos-25-240>= 55  && y_pos-25-240<= 57) || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240== 66 ))) ||
                            ( x_pos-25==61 && ((y_pos-25-240>= 57 && y_pos-25-240<= 59) || (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25==62 && ( y_pos-25-240== 59 || y_pos-25-240 ==65))  ||
                            ( x_pos-25==63 && ((y_pos-25-240>= 59 && y_pos-25-240<= 60) || y_pos-25-240== 65 ))  ||
                            ( x_pos-25==64 && (y_pos-25-240>= 60 && y_pos-25-240<= 64) ) ;
    assign location_7_body = ( x_pos-25==15 && (y_pos-25-240> 25 && y_pos-25-240< 58)) ||
                            ( x_pos-25==16 && (y_pos-25-240> 20 && y_pos-25-240< 58)) ||
                            ( x_pos-25==17 && (y_pos-25-240> 17 && y_pos-25-240< 58)) ||
                            ( x_pos-25==18 && (y_pos-25-240> 13 && y_pos-25-240< 58)) ||
                            ( x_pos-25==19 && (y_pos-25-240> 11 && y_pos-25-240< 59)) ||
                            ( x_pos-25==20 && (y_pos-25-240> 9 && y_pos-25-240< 59)) ||
                            ( x_pos-25==21 && (y_pos-25-240> 8 && y_pos-25-240< 60))  ||
                            ( x_pos-25==22 && (y_pos-25-240> 7 && y_pos-25-240< 60)) ||
                            ( x_pos-25==23 && (y_pos-25-240> 6 && y_pos-25-240< 60)) ||
                            ( x_pos-25==24 && (y_pos-25-240> 5 && y_pos-25-240< 61)) ||
                            ( x_pos-25==25 && ((y_pos-25-240> 4 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 62))) ||
                            ( x_pos-25==26 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25==27 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 63))) ||
                            ( x_pos-25==28 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 64))) ||
                            ( x_pos-25==29 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 65))) ||
                            ( x_pos-25==30 && (y_pos-25-240> 1 && y_pos-25-240< 61)) ||
                            ( x_pos-25==31 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==32 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==33 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==34 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==35 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==36 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==37 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25==38 && ((y_pos-25-240> 1 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 60))) ||
                            ( x_pos-25==39 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 60))) ||
                            ( x_pos-25==40 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 61))) ||
                            ( x_pos-25==41 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25==42 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 61))) ||
                            ( x_pos-25==43 && (y_pos-25-240> 2 && y_pos-25-240< 61))  ||
                            ( x_pos-25==44 && (y_pos-25-240> 3 && y_pos-25-240< 61))  ||
                            ( x_pos-25==45 && (y_pos-25-240> 3 && y_pos-25-240< 60)) ||
                            ( x_pos-25==46 && (y_pos-25-240> 4 && y_pos-25-240< 60))  ||
                            ( x_pos-25==47 && (y_pos-25-240> 5 && y_pos-25-240< 60))  ||
                            ( x_pos-25==48 && (y_pos-25-240> 6 && y_pos-25-240< 60))  ||
                            ( x_pos-25==49 && (y_pos-25-240> 7 && y_pos-25-240< 60))  ||
                            ( x_pos-25==50 && (y_pos-25-240> 8 && y_pos-25-240< 62))  ||
                            ( x_pos-25==51 && (y_pos-25-240> 9 && y_pos-25-240< 62))  ||
                            ( x_pos-25==52 && (y_pos-25-240> 10 && y_pos-25-240< 63))  ||
                            ( x_pos-25==53 && (y_pos-25-240> 12 && y_pos-25-240< 62))  ||
                            ( x_pos-25==54 && (y_pos-25-240> 14 && y_pos-25-240< 61))  ||
                            ( x_pos-25==55 && (y_pos-25-240> 17 && y_pos-25-240< 60))  ||
                            ( x_pos-25==56 && (y_pos-25-240> 20 && y_pos-25-240< 60))  ||
                            ( x_pos-25==57 && (y_pos-25-240> 24 && y_pos-25-240< 60))  ;
    assign location_7_stone = ( x_pos-25==11 && (y_pos-25-240> 58 && y_pos-25-240< 62)) ||
                            ( x_pos-25==12 && (y_pos-25-240> 57 && y_pos-25-240< 63)) ||
                            ( x_pos-25==13 && ((y_pos-25-240> 53 && y_pos-25-240< 57)||(y_pos-25-240> 57 && y_pos-25-240< 64))) ||
                            ( x_pos-25==14 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25==15 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25==16 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25==17 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25==18 && (y_pos-25-240> 58 && y_pos-25-240< 61)) ||
                            ( x_pos-25==19 && (y_pos-25-240> 61 && y_pos-25-240< 65)) ||
                            ( x_pos-25==20 && (y_pos-25-240> 60 && y_pos-25-240< 66)) ||
                            ( x_pos-25==21 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25==22 && (y_pos-25-240> 60 && y_pos-25-240< 67)) ||
                            ( x_pos-25==23 && (y_pos-25-240> 61 && y_pos-25-240< 68)) ||
                            ( x_pos-25==24 && (y_pos-25-240> 62 && y_pos-25-240< 68)) ||
                            ( x_pos-25==25 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==26 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==27 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==28 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==29 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==30 && (y_pos-25-240> 62 && y_pos-25-240< 67)) ||
                            ( x_pos-25==31 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25==32 && (y_pos-25-240> 60 && y_pos-25-240< 63))  ||
                            ( x_pos-25==33 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25==34 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==35 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==36 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==37 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==38 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==39 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25==40 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25==41 && (y_pos-25-240> 64 && y_pos-25-240< 68))  ||
                            ( x_pos-25==42 && (y_pos-25-240> 62 && y_pos-25-240< 64)) ||
                            ( x_pos-25==43 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25==44 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25==45 && (y_pos-25-240> 61 && y_pos-25-240< 67)) ||
                            ( x_pos-25==46 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==47 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==48 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==49 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==50 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==51 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25==53 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25==54 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25==55 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25==56 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==57 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25==58 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25==59 && (y_pos-25-240> 55 && y_pos-25-240 !=60 && y_pos-25-240< 66))  ||
                            ( x_pos-25==60 && (y_pos-25-240> 57&& y_pos-25-240 !=60 && y_pos-25-240 !=59  && y_pos-25-240< 66))  ||
                            ( x_pos-25==61 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25==62 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25==63 && (y_pos-25-240> 60 && y_pos-25-240< 65)) ;
    assign location_7_eyes = ( x_pos-25== 26 && (y_pos-25-240>= 20 && y_pos-25-240 <= 22) ) || ( x_pos-25== 39 && (y_pos-25-240 >= 20 && y_pos-25-240<= 22));

	assign location_0_line = ( x_pos-25==10 && y_pos-25-360>= 58 && y_pos-25-360<= 62) || 
                            ( x_pos-25==11 && ((y_pos-25-360>= 57 && y_pos-25-360<= 58) || (y_pos-25-360>= 62 && y_pos-25-360 <=63 ))) ||
                            ( x_pos-25==12 && ((y_pos-25-360>= 54 && y_pos-25-360<= 57) || (y_pos-25-360>= 63 && y_pos-25-360 <=64 ))) ||
                            ( x_pos-25==13 && (y_pos-25-360==53 || y_pos-25-360== 57 || y_pos-25-360 ==64 )) ||
                            ( x_pos-25==14 && ((y_pos-25-360>= 25 && y_pos-25-360<= 58) || y_pos-25-360== 64 )) ||
                            ( x_pos-25==15 && ((y_pos-25-360>= 20 && y_pos-25-360<= 25) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25==16 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25==17 && ((y_pos-25-360>= 13 && y_pos-25-360<= 17) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25==18 && ((y_pos-25-360>= 11 && y_pos-25-360<= 13) || y_pos-25-360== 58 || (y_pos-25-360>= 61 && y_pos-25-360 <=65 ))) ||
                            ( x_pos-25==19 && ((y_pos-25-360>= 9  && y_pos-25-360<= 11) || (y_pos-25-360>= 59 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25==20 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360>= 66 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25==21 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 60 || y_pos-25-360 ==67))  ||
                            ( x_pos-25==22 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || y_pos-25-360== 60 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25==23 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 ))) ||
                            ( x_pos-25==24 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ))) ||
                            ( x_pos-25==25 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==26 && ( y_pos-25-360== 3 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==27 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==28 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==29 && ((y_pos-25-360>= 1 && y_pos-25-360<= 2) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==30 && ( y_pos-25-360== 1 || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25==31 && ( y_pos-25-360== 1 || (y_pos-25-360>= 60 && y_pos-25-360 <=63 )|| y_pos-25-360 ==67))  ||
                            ( x_pos-25==32 && ( y_pos-25-360== 1 || (y_pos-25-360>= 63 && y_pos-25-360 <=67 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25==33 && ( y_pos-25-360== 1 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25==34 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==35 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==36 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==37 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==38 && ( y_pos-25-360== 1 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==39 && ( y_pos-25-360== 1 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 60 && y_pos-25-360 <=61 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25==40 && ( y_pos-25-360== 1 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=63 ) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25==41 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 62 && y_pos-25-360 <=64 ) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25==42 && ( y_pos-25-360== 2 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 64 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25==43 && ( y_pos-25-360== 2 || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25==44 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25==45 && ( y_pos-25-360== 3 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25==46 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==47 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==48 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==49 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25==50 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==51 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25==52 && ((y_pos-25-360>= 9  && y_pos-25-360<= 10) || (y_pos-25-360>= 63 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25==53 && ((y_pos-25-360>= 10  && y_pos-25-360<= 12)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25==54 && ((y_pos-25-360>= 12  && y_pos-25-360<= 14)  || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25==55 && ((y_pos-25-360>= 14  && y_pos-25-360<= 17)  || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25==56 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25==57 && ((y_pos-25-360>= 20  && y_pos-25-360<= 24) || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| (y_pos-25-360== 60 ))) ||
                            ( x_pos-25==58 && ((y_pos-25-360>= 24  && y_pos-25-360<= 60) || (y_pos-25-360== 67 ))) ||
                            ( x_pos-25==59 && ((y_pos-25-360>= 66 && y_pos-25-360<= 67) || y_pos-25-360== 55 || y_pos-25-360 ==60))  ||
                            ( x_pos-25==60 && ((y_pos-25-360>= 55  && y_pos-25-360<= 57) || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360== 66 ))) ||
                            ( x_pos-25==61 && ((y_pos-25-360>= 57 && y_pos-25-360<= 59) || (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25==62 && ( y_pos-25-360== 59 || y_pos-25-360 ==65))  ||
                            ( x_pos-25==63 && ((y_pos-25-360>= 59 && y_pos-25-360<= 60) || y_pos-25-360== 65 ))  ||
                            ( x_pos-25==64 && (y_pos-25-360>= 60 && y_pos-25-360<= 64) ) ;
    assign location_0_body = ( x_pos-25==15 && (y_pos-25-360> 25 && y_pos-25-360< 58)) ||
                            ( x_pos-25==16 && (y_pos-25-360> 20 && y_pos-25-360< 58)) ||
                            ( x_pos-25==17 && (y_pos-25-360> 17 && y_pos-25-360< 58)) ||
                            ( x_pos-25==18 && (y_pos-25-360> 13 && y_pos-25-360< 58)) ||
                            ( x_pos-25==19 && (y_pos-25-360> 11 && y_pos-25-360< 59)) ||
                            ( x_pos-25==20 && (y_pos-25-360> 9 && y_pos-25-360< 59)) ||
                            ( x_pos-25==21 && (y_pos-25-360> 8 && y_pos-25-360< 60))  ||
                            ( x_pos-25==22 && (y_pos-25-360> 7 && y_pos-25-360< 60)) ||
                            ( x_pos-25==23 && (y_pos-25-360> 6 && y_pos-25-360< 60)) ||
                            ( x_pos-25==24 && (y_pos-25-360> 5 && y_pos-25-360< 61)) ||
                            ( x_pos-25==25 && ((y_pos-25-360> 4 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 62))) ||
                            ( x_pos-25==26 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25==27 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 63))) ||
                            ( x_pos-25==28 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 64))) ||
                            ( x_pos-25==29 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 65))) ||
                            ( x_pos-25==30 && (y_pos-25-360> 1 && y_pos-25-360< 61)) ||
                            ( x_pos-25==31 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==32 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==33 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==34 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==35 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==36 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==37 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25==38 && ((y_pos-25-360> 1 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 60))) ||
                            ( x_pos-25==39 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 60))) ||
                            ( x_pos-25==40 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 61))) ||
                            ( x_pos-25==41 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25==42 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 61))) ||
                            ( x_pos-25==43 && (y_pos-25-360> 2 && y_pos-25-360< 61))  ||
                            ( x_pos-25==44 && (y_pos-25-360> 3 && y_pos-25-360< 61))  ||
                            ( x_pos-25==45 && (y_pos-25-360> 3 && y_pos-25-360< 60)) ||
                            ( x_pos-25==46 && (y_pos-25-360> 4 && y_pos-25-360< 60))  ||
                            ( x_pos-25==47 && (y_pos-25-360> 5 && y_pos-25-360< 60))  ||
                            ( x_pos-25==48 && (y_pos-25-360> 6 && y_pos-25-360< 60))  ||
                            ( x_pos-25==49 && (y_pos-25-360> 7 && y_pos-25-360< 60))  ||
                            ( x_pos-25==50 && (y_pos-25-360> 8 && y_pos-25-360< 62))  ||
                            ( x_pos-25==51 && (y_pos-25-360> 9 && y_pos-25-360< 62))  ||
                            ( x_pos-25==52 && (y_pos-25-360> 10 && y_pos-25-360< 63))  ||
                            ( x_pos-25==53 && (y_pos-25-360> 12 && y_pos-25-360< 62))  ||
                            ( x_pos-25==54 && (y_pos-25-360> 14 && y_pos-25-360< 61))  ||
                            ( x_pos-25==55 && (y_pos-25-360> 17 && y_pos-25-360< 60))  ||
                            ( x_pos-25==56 && (y_pos-25-360> 20 && y_pos-25-360< 60))  ||
                            ( x_pos-25==57 && (y_pos-25-360> 24 && y_pos-25-360< 60))  ;
    assign location_0_stone = ( x_pos-25==11 && (y_pos-25-360> 58 && y_pos-25-360< 62)) ||
                            ( x_pos-25==12 && (y_pos-25-360> 57 && y_pos-25-360< 63)) ||
                            ( x_pos-25==13 && ((y_pos-25-360> 53 && y_pos-25-360< 57)||(y_pos-25-360> 57 && y_pos-25-360< 64))) ||
                            ( x_pos-25==14 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25==15 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25==16 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25==17 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25==18 && (y_pos-25-360> 58 && y_pos-25-360< 61)) ||
                            ( x_pos-25==19 && (y_pos-25-360> 61 && y_pos-25-360< 65)) ||
                            ( x_pos-25==20 && (y_pos-25-360> 60 && y_pos-25-360< 66)) ||
                            ( x_pos-25==21 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25==22 && (y_pos-25-360> 60 && y_pos-25-360< 67)) ||
                            ( x_pos-25==23 && (y_pos-25-360> 61 && y_pos-25-360< 68)) ||
                            ( x_pos-25==24 && (y_pos-25-360> 62 && y_pos-25-360< 68)) ||
                            ( x_pos-25==25 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==26 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==27 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==28 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==29 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==30 && (y_pos-25-360> 62 && y_pos-25-360< 67)) ||
                            ( x_pos-25==31 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25==32 && (y_pos-25-360> 60 && y_pos-25-360< 63))  ||
                            ( x_pos-25==33 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25==34 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==35 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==36 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==37 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==38 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==39 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25==40 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25==41 && (y_pos-25-360> 64 && y_pos-25-360< 68))  ||
                            ( x_pos-25==42 && (y_pos-25-360> 62 && y_pos-25-360< 64)) ||
                            ( x_pos-25==43 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25==44 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25==45 && (y_pos-25-360> 61 && y_pos-25-360< 67)) ||
                            ( x_pos-25==46 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==47 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==48 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==49 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==50 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==51 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25==53 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25==54 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25==55 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25==56 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==57 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25==58 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25==59 && (y_pos-25-360> 55 && y_pos-25-360 !=60 && y_pos-25-360< 66))  ||
                            ( x_pos-25==60 && (y_pos-25-360> 57&& y_pos-25-360 !=60 && y_pos-25-360 !=59  && y_pos-25-360< 66))  ||
                            ( x_pos-25==61 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25==62 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25==63 && (y_pos-25-360> 60 && y_pos-25-360< 65)) ;
    assign location_0_eyes = ( x_pos-25== 26 && (y_pos-25-360>= 20 && y_pos-25-360 <= 22) ) || ( x_pos-25== 39 && (y_pos-25-360 >= 20 && y_pos-25-360<= 22));

	assign location_2_line = ( x_pos-25-120==10 && y_pos-25>= 58 && y_pos-25<= 62) || 
                            ( x_pos-25-120==11 && ((y_pos-25>= 57 && y_pos-25<= 58) || (y_pos-25>= 62 && y_pos-25 <=63 ))) ||
                            ( x_pos-25-120==12 && ((y_pos-25>= 54 && y_pos-25<= 57) || (y_pos-25>= 63 && y_pos-25 <=64 ))) ||
                            ( x_pos-25-120==13 && (y_pos-25==53 || y_pos-25== 57 || y_pos-25 ==64 )) ||
                            ( x_pos-25-120==14 && ((y_pos-25>= 25 && y_pos-25<= 58) || y_pos-25== 64 )) ||
                            ( x_pos-25-120==15 && ((y_pos-25>= 20 && y_pos-25<= 25) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-120==16 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-120==17 && ((y_pos-25>= 13 && y_pos-25<= 17) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-120==18 && ((y_pos-25>= 11 && y_pos-25<= 13) || y_pos-25== 58 || (y_pos-25>= 61 && y_pos-25 <=65 ))) ||
                            ( x_pos-25-120==19 && ((y_pos-25>= 9  && y_pos-25<= 11) || (y_pos-25>= 59 && y_pos-25 <=61 )|| (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25-120==20 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25>= 66 && y_pos-25 <=67 ))) ||
                            ( x_pos-25-120==21 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 60 || y_pos-25 ==67))  ||
                            ( x_pos-25-120==22 && ((y_pos-25>= 6 && y_pos-25<= 7) || y_pos-25== 60 || (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-120==23 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=61 ))) ||
                            ( x_pos-25-120==24 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=62 ))) ||
                            ( x_pos-25-120==25 && ((y_pos-25>= 3 && y_pos-25<= 4) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==26 && ( y_pos-25== 3 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==27 && ((y_pos-25>= 2 && y_pos-25<= 3) || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==28 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==29 && ((y_pos-25>= 1 && y_pos-25<= 2) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==30 && ( y_pos-25== 1 || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-120==31 && ( y_pos-25== 1 || (y_pos-25>= 60 && y_pos-25 <=63 )|| y_pos-25 ==67))  ||
                            ( x_pos-25-120==32 && ( y_pos-25== 1 || (y_pos-25>= 63 && y_pos-25 <=67 )|| y_pos-25 ==60))  ||
                            ( x_pos-25-120==33 && ( y_pos-25== 1 || (y_pos-25>= 67 && y_pos-25 <=68 )|| y_pos-25 ==60))  ||
                            ( x_pos-25-120==34 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==35 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==36 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==37 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==38 && ( y_pos-25== 1 || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==39 && ( y_pos-25== 1 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| (y_pos-25>= 60 && y_pos-25 <=61 ) || y_pos-25 ==68))  ||
                            ( x_pos-25-120==40 && ( y_pos-25== 1 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 61 && y_pos-25 <=63 ) || y_pos-25 ==68 ))  ||
                            ( x_pos-25-120==41 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 62 && y_pos-25 <=64) || y_pos-25 ==68 ))  ||
                            ( x_pos-25-120==42 && ( y_pos-25== 2 || (y_pos-25>= 20 && y_pos-25 <=25 )|| (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 64 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-120==43 && ( y_pos-25== 2 || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25-120==44 && ((y_pos-25>= 2 && y_pos-25<= 3) || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25-120==45 && ( y_pos-25== 3 || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-120==46 && ((y_pos-25>= 3 && y_pos-25<= 4) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==47 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==48 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==49 && ((y_pos-25>= 6 && y_pos-25<= 7) || (y_pos-25>= 60 && y_pos-25 <=62 ) || y_pos-25 ==68))  ||
                            ( x_pos-25-120==50 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==51 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-120==52 && ((y_pos-25>= 9  && y_pos-25<= 10) || (y_pos-25>= 63 && y_pos-25 <=67 ))) ||
                            ( x_pos-25-120==53 && ((y_pos-25>= 10  && y_pos-25<= 12)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-120==54 && ((y_pos-25>= 12  && y_pos-25<= 14)  || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25-120==55 && ((y_pos-25>= 14  && y_pos-25<= 17)  || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25-120==56 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-120==57 && ((y_pos-25>= 20  && y_pos-25<= 24) || (y_pos-25>= 67 && y_pos-25 <=68 )|| (y_pos-25== 60 ))) ||
                            ( x_pos-25-120==58 && ((y_pos-25>= 24  && y_pos-25<= 60) || (y_pos-25== 67 ))) ||
                            ( x_pos-25-120==59 && ((y_pos-25>= 66 && y_pos-25<= 67) || y_pos-25== 55 || y_pos-25 ==60))  ||
                            ( x_pos-25-120==60 && ((y_pos-25>= 55  && y_pos-25<= 57) || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25== 66 ))) ||
                            ( x_pos-25-120==61 && ((y_pos-25>= 57 && y_pos-25<= 59) || (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25-120==62 && ( y_pos-25== 59 || y_pos-25 ==65))  ||
                            ( x_pos-25-120==63 && ((y_pos-25>= 59 && y_pos-25<= 60) || y_pos-25== 65 ))  ||
                            ( x_pos-25-120==64 && (y_pos-25>= 60 && y_pos-25<= 64) ) ;
    assign location_2_body = ( x_pos-25-120==15 && (y_pos-25> 25 && y_pos-25< 58)) ||
                            ( x_pos-25-120==16 && (y_pos-25> 20 && y_pos-25< 58)) ||
                            ( x_pos-25-120==17 && (y_pos-25> 17 && y_pos-25< 58)) ||
                            ( x_pos-25-120==18 && (y_pos-25> 13 && y_pos-25< 58)) ||
                            ( x_pos-25-120==19 && (y_pos-25> 11 && y_pos-25< 59)) ||
                            ( x_pos-25-120==20 && (y_pos-25> 9 && y_pos-25< 59)) ||
                            ( x_pos-25-120==21 && (y_pos-25> 8 && y_pos-25< 60))  ||
                            ( x_pos-25-120==22 && (y_pos-25> 7 && y_pos-25< 60)) ||
                            ( x_pos-25-120==23 && (y_pos-25> 6 && y_pos-25< 60)) ||
                            ( x_pos-25-120==24 && (y_pos-25> 5 && y_pos-25< 61)) ||
                            ( x_pos-25-120==25 && ((y_pos-25> 4 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 62))) ||
                            ( x_pos-25-120==26 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25-120==27 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 63))) ||
                            ( x_pos-25-120==28 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 64))) ||
                            ( x_pos-25-120==29 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 65))) ||
                            ( x_pos-25-120==30 && (y_pos-25> 1 && y_pos-25< 61)) ||
                            ( x_pos-25-120==31 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==32 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==33 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==34 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==35 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==36 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==37 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-120==38 && ((y_pos-25> 1 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 60))) ||
                            ( x_pos-25-120==39 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 60))) ||
                            ( x_pos-25-120==40 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 61))) ||
                            ( x_pos-25-120==41 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25-120==42 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 61))) ||
                            ( x_pos-25-120==43 && (y_pos-25> 2 && y_pos-25< 61))  ||
                            ( x_pos-25-120==44 && (y_pos-25> 3 && y_pos-25< 61))  ||
                            ( x_pos-25-120==45 && (y_pos-25> 3 && y_pos-25< 60)) ||
                            ( x_pos-25-120==46 && (y_pos-25> 4 && y_pos-25< 60))  ||
                            ( x_pos-25-120==47 && (y_pos-25> 5 && y_pos-25< 60))  ||
                            ( x_pos-25-120==48 && (y_pos-25> 6 && y_pos-25< 60))  ||
                            ( x_pos-25-120==49 && (y_pos-25> 7 && y_pos-25< 60))  ||
                            ( x_pos-25-120==50 && (y_pos-25> 8 && y_pos-25< 62))  ||
                            ( x_pos-25-120==51 && (y_pos-25> 9 && y_pos-25< 62))  ||
                            ( x_pos-25-120==52 && (y_pos-25> 10 && y_pos-25< 63))  ||
                            ( x_pos-25-120==53 && (y_pos-25> 12 && y_pos-25< 62))  ||
                            ( x_pos-25-120==54 && (y_pos-25> 14 && y_pos-25< 61))  ||
                            ( x_pos-25-120==55 && (y_pos-25> 17 && y_pos-25< 60))  ||
                            ( x_pos-25-120==56 && (y_pos-25> 20 && y_pos-25< 60))  ||
                            ( x_pos-25-120==57 && (y_pos-25> 24 && y_pos-25< 60))  ;
    assign location_2_stone = ( x_pos-25-120==11 && (y_pos-25> 58 && y_pos-25< 62)) ||
                            ( x_pos-25-120==12 && (y_pos-25> 57 && y_pos-25< 63)) ||
                            ( x_pos-25-120==13 && ((y_pos-25> 53 && y_pos-25< 57)||(y_pos-25> 57 && y_pos-25< 64))) ||
                            ( x_pos-25-120==14 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-120==15 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-120==16 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-120==17 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-120==18 && (y_pos-25> 58 && y_pos-25< 61)) ||
                            ( x_pos-25-120==19 && (y_pos-25> 61 && y_pos-25< 65)) ||
                            ( x_pos-25-120==20 && (y_pos-25> 60 && y_pos-25< 66)) ||
                            ( x_pos-25-120==21 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-120==22 && (y_pos-25> 60 && y_pos-25< 67)) ||
                            ( x_pos-25-120==23 && (y_pos-25> 61 && y_pos-25< 68)) ||
                            ( x_pos-25-120==24 && (y_pos-25> 62 && y_pos-25< 68)) ||
                            ( x_pos-25-120==25 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==26 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==27 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==28 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==29 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==30 && (y_pos-25> 62 && y_pos-25< 67)) ||
                            ( x_pos-25-120==31 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25-120==32 && (y_pos-25> 60 && y_pos-25< 63))  ||
                            ( x_pos-25-120==33 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-120==34 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==35 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==36 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==37 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==38 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==39 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25-120==40 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25-120==41 && (y_pos-25> 64 && y_pos-25< 68))  ||
                            ( x_pos-25-120==42 && (y_pos-25> 62 && y_pos-25< 64)) ||
                            ( x_pos-25-120==43 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25-120==44 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25-120==45 && (y_pos-25> 61 && y_pos-25< 67)) ||
                            ( x_pos-25-120==46 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==47 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==48 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==49 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==50 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==51 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25-120==53 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25-120==54 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-120==55 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25-120==56 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==57 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-120==58 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-120==59 && (y_pos-25> 55 && y_pos-25 !=60 && y_pos-25< 66))  ||
                            ( x_pos-25-120==60 && (y_pos-25> 57 && y_pos-25 !=60 && y_pos-25 !=59  &&y_pos-25< 66))  ||
                            ( x_pos-25-120==61 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25-120==62 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25-120==63 && (y_pos-25> 60 && y_pos-25< 65)) ;
    assign location_2_eyes = ( x_pos-25-120== 26 && (y_pos-25>= 20 && y_pos-25 <= 22) ) || ( x_pos-25-120== 39 && (y_pos-25 >= 20 && y_pos-25<= 22));

	assign location_5_line = ( x_pos-25-120==10 && y_pos-25-120>= 58 && y_pos-25-120<= 62) || 
                            ( x_pos-25-120==11 && ((y_pos-25-120>= 57 && y_pos-25-120<= 58) || (y_pos-25-120>= 62 && y_pos-25-120 <=63 ))) ||
                            ( x_pos-25-120==12 && ((y_pos-25-120>= 54 && y_pos-25-120<= 57) || (y_pos-25-120>= 63 && y_pos-25-120 <=64 ))) ||
                            ( x_pos-25-120==13 && (y_pos-25-120==53 || y_pos-25-120== 57 || y_pos-25-120 ==64 )) ||
                            ( x_pos-25-120==14 && ((y_pos-25-120>= 25 && y_pos-25-120<= 58) || y_pos-25-120== 64 )) ||
                            ( x_pos-25-120==15 && ((y_pos-25-120>= 20 && y_pos-25-120<= 25) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-120==16 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-120==17 && ((y_pos-25-120>= 13 && y_pos-25-120<= 17) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-120==18 && ((y_pos-25-120>= 11 && y_pos-25-120<= 13) || y_pos-25-120== 58 || (y_pos-25-120>= 61 && y_pos-25-120 <=65 ))) ||
                            ( x_pos-25-120==19 && ((y_pos-25-120>= 9  && y_pos-25-120<= 11) || (y_pos-25-120>= 59 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25-120==20 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120>= 66 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25-120==21 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 60 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-120==22 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || y_pos-25-120== 60 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-120==23 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 ))) ||
                            ( x_pos-25-120==24 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ))) ||
                            ( x_pos-25-120==25 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==26 && ( y_pos-25-120== 3 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==27 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==28 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==29 && ((y_pos-25-120>= 1 && y_pos-25-120<= 2) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==30 && ( y_pos-25-120== 1 || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-120==31 && ( y_pos-25-120== 1 || (y_pos-25-120>= 60 && y_pos-25-120 <=63 )|| y_pos-25-120 ==67))  ||
                            ( x_pos-25-120==32 && ( y_pos-25-120== 1 || (y_pos-25-120>= 63 && y_pos-25-120 <=67 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25-120==33 && ( y_pos-25-120== 1 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25-120==34 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==35 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==36 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==37 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==38 && ( y_pos-25-120== 1 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==39 && ( y_pos-25-120== 1 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 60 && y_pos-25-120 <=61 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==40 && ( y_pos-25-120== 1 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=63 ) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25-120==41 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 62 && y_pos-25-120 <=64) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25-120==42 && ( y_pos-25-120== 2 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 64 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-120==43 && ( y_pos-25-120== 2 || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-120==44 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-120==45 && ( y_pos-25-120== 3 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-120==46 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==47 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==48 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==49 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==50 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==51 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-120==52 && ((y_pos-25-120>= 9  && y_pos-25-120<= 10) || (y_pos-25-120>= 63 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25-120==53 && ((y_pos-25-120>= 10  && y_pos-25-120<= 12)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-120==54 && ((y_pos-25-120>= 12  && y_pos-25-120<= 14)  || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25-120==55 && ((y_pos-25-120>= 14  && y_pos-25-120<= 17)  || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25-120==56 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-120==57 && ((y_pos-25-120>= 20  && y_pos-25-120<= 24) || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| (y_pos-25-120== 60 ))) ||
                            ( x_pos-25-120==58 && ((y_pos-25-120>= 24  && y_pos-25-120<= 60) || (y_pos-25-120== 67 ))) ||
                            ( x_pos-25-120==59 && ((y_pos-25-120>= 66 && y_pos-25-120<= 67) || y_pos-25-120== 55 || y_pos-25-120 ==60))  ||
                            ( x_pos-25-120==60 && ((y_pos-25-120>= 55  && y_pos-25-120<= 57) || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120== 66 ))) ||
                            ( x_pos-25-120==61 && ((y_pos-25-120>= 57 && y_pos-25-120<= 59) || (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25-120==62 && ( y_pos-25-120== 59 || y_pos-25-120 ==65))  ||
                            ( x_pos-25-120==63 && ((y_pos-25-120>= 59 && y_pos-25-120<= 60) || y_pos-25-120== 65 ))  ||
                            ( x_pos-25-120==64 && (y_pos-25-120>= 60 && y_pos-25-120<= 64) ) ;
    assign location_5_body = ( x_pos-25-120==15 && (y_pos-25-120> 25 && y_pos-25-120< 58)) ||
                            ( x_pos-25-120==16 && (y_pos-25-120> 20 && y_pos-25-120< 58)) ||
                            ( x_pos-25-120==17 && (y_pos-25-120> 17 && y_pos-25-120< 58)) ||
                            ( x_pos-25-120==18 && (y_pos-25-120> 13 && y_pos-25-120< 58)) ||
                            ( x_pos-25-120==19 && (y_pos-25-120> 11 && y_pos-25-120< 59)) ||
                            ( x_pos-25-120==20 && (y_pos-25-120> 9 && y_pos-25-120< 59)) ||
                            ( x_pos-25-120==21 && (y_pos-25-120> 8 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==22 && (y_pos-25-120> 7 && y_pos-25-120< 60)) ||
                            ( x_pos-25-120==23 && (y_pos-25-120> 6 && y_pos-25-120< 60)) ||
                            ( x_pos-25-120==24 && (y_pos-25-120> 5 && y_pos-25-120< 61)) ||
                            ( x_pos-25-120==25 && ((y_pos-25-120> 4 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 62))) ||
                            ( x_pos-25-120==26 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25-120==27 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 63))) ||
                            ( x_pos-25-120==28 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 64))) ||
                            ( x_pos-25-120==29 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 65))) ||
                            ( x_pos-25-120==30 && (y_pos-25-120> 1 && y_pos-25-120< 61)) ||
                            ( x_pos-25-120==31 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==32 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==33 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==34 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==35 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==36 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==37 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==38 && ((y_pos-25-120> 1 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 60))) ||
                            ( x_pos-25-120==39 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 60))) ||
                            ( x_pos-25-120==40 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 61))) ||
                            ( x_pos-25-120==41 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25-120==42 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 61))) ||
                            ( x_pos-25-120==43 && (y_pos-25-120> 2 && y_pos-25-120< 61))  ||
                            ( x_pos-25-120==44 && (y_pos-25-120> 3 && y_pos-25-120< 61))  ||
                            ( x_pos-25-120==45 && (y_pos-25-120> 3 && y_pos-25-120< 60)) ||
                            ( x_pos-25-120==46 && (y_pos-25-120> 4 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==47 && (y_pos-25-120> 5 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==48 && (y_pos-25-120> 6 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==49 && (y_pos-25-120> 7 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==50 && (y_pos-25-120> 8 && y_pos-25-120< 62))  ||
                            ( x_pos-25-120==51 && (y_pos-25-120> 9 && y_pos-25-120< 62))  ||
                            ( x_pos-25-120==52 && (y_pos-25-120> 10 && y_pos-25-120< 63))  ||
                            ( x_pos-25-120==53 && (y_pos-25-120> 12 && y_pos-25-120< 62))  ||
                            ( x_pos-25-120==54 && (y_pos-25-120> 14 && y_pos-25-120< 61))  ||
                            ( x_pos-25-120==55 && (y_pos-25-120> 17 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==56 && (y_pos-25-120> 20 && y_pos-25-120< 60))  ||
                            ( x_pos-25-120==57 && (y_pos-25-120> 24 && y_pos-25-120< 60))  ;
    assign location_5_stone = ( x_pos-25-120==11 && (y_pos-25-120> 58 && y_pos-25-120< 62)) ||
                            ( x_pos-25-120==12 && (y_pos-25-120> 57 && y_pos-25-120< 63)) ||
                            ( x_pos-25-120==13 && ((y_pos-25-120> 53 && y_pos-25-120< 57)||(y_pos-25-120> 57 && y_pos-25-120< 64))) ||
                            ( x_pos-25-120==14 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-120==15 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-120==16 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-120==17 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-120==18 && (y_pos-25-120> 58 && y_pos-25-120< 61)) ||
                            ( x_pos-25-120==19 && (y_pos-25-120> 61 && y_pos-25-120< 65)) ||
                            ( x_pos-25-120==20 && (y_pos-25-120> 60 && y_pos-25-120< 66)) ||
                            ( x_pos-25-120==21 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==22 && (y_pos-25-120> 60 && y_pos-25-120< 67)) ||
                            ( x_pos-25-120==23 && (y_pos-25-120> 61 && y_pos-25-120< 68)) ||
                            ( x_pos-25-120==24 && (y_pos-25-120> 62 && y_pos-25-120< 68)) ||
                            ( x_pos-25-120==25 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==26 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==27 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==28 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==29 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==30 && (y_pos-25-120> 62 && y_pos-25-120< 67)) ||
                            ( x_pos-25-120==31 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==32 && (y_pos-25-120> 60 && y_pos-25-120< 63))  ||
                            ( x_pos-25-120==33 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==34 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==35 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==36 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==37 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==38 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==39 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==40 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==41 && (y_pos-25-120> 64 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==42 && (y_pos-25-120> 62 && y_pos-25-120< 64)) ||
                            ( x_pos-25-120==43 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==44 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==45 && (y_pos-25-120> 61 && y_pos-25-120< 67)) ||
                            ( x_pos-25-120==46 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==47 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==48 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==49 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==50 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==51 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==53 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==54 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==55 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==56 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==57 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-120==58 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-120==59 && (y_pos-25-120> 55 && y_pos-25-120 !=60 && y_pos-25-120< 66))  ||
                            ( x_pos-25-120==60 && (y_pos-25-120> 57 && y_pos-25-120 !=60 && y_pos-25-120 !=59  &&y_pos-25-120< 66))  ||
                            ( x_pos-25-120==61 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25-120==62 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25-120==63 && (y_pos-25-120> 60 && y_pos-25-120< 65)) ;
    assign location_5_eyes = ( x_pos-25-120== 26 && (y_pos-25-120>= 20 && y_pos-25-120 <= 22) ) || ( x_pos-25-120== 39 && (y_pos-25-120 >= 20 && y_pos-25-120<= 22));


	assign location_8_line = ( x_pos-25-120==10 && y_pos-25-240>= 58 && y_pos-25-240<= 62) || 
                            ( x_pos-25-120==11 && ((y_pos-25-240>= 57 && y_pos-25-240<= 58) || (y_pos-25-240>= 62 && y_pos-25-240 <=63 ))) ||
                            ( x_pos-25-120==12 && ((y_pos-25-240>= 54 && y_pos-25-240<= 57) || (y_pos-25-240>= 63 && y_pos-25-240 <=64 ))) ||
                            ( x_pos-25-120==13 && (y_pos-25-240==53 || y_pos-25-240== 57 || y_pos-25-240 ==64 )) ||
                            ( x_pos-25-120==14 && ((y_pos-25-240>= 25 && y_pos-25-240<= 58) || y_pos-25-240== 64 )) ||
                            ( x_pos-25-120==15 && ((y_pos-25-240>= 20 && y_pos-25-240<= 25) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-120==16 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-120==17 && ((y_pos-25-240>= 13 && y_pos-25-240<= 17) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-120==18 && ((y_pos-25-240>= 11 && y_pos-25-240<= 13) || y_pos-25-240== 58 || (y_pos-25-240>= 61 && y_pos-25-240 <=65 ))) ||
                            ( x_pos-25-120==19 && ((y_pos-25-240>= 9  && y_pos-25-240<= 11) || (y_pos-25-240>= 59 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25-120==20 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240>= 66 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25-120==21 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 60 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-120==22 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || y_pos-25-240== 60 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-120==23 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 ))) ||
                            ( x_pos-25-120==24 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ))) ||
                            ( x_pos-25-120==25 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==26 && ( y_pos-25-240== 3 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==27 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==28 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==29 && ((y_pos-25-240>= 1 && y_pos-25-240<= 2) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==30 && ( y_pos-25-240== 1 || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-120==31 && ( y_pos-25-240== 1 || (y_pos-25-240>= 60 && y_pos-25-240 <=63 )|| y_pos-25-240 ==67))  ||
                            ( x_pos-25-120==32 && ( y_pos-25-240== 1 || (y_pos-25-240>= 63 && y_pos-25-240 <=67 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25-120==33 && ( y_pos-25-240== 1 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25-120==34 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==35 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==36 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==37 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==38 && ( y_pos-25-240== 1 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==39 && ( y_pos-25-240== 1 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 60 && y_pos-25-240 <=61 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==40 && ( y_pos-25-240== 1 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=63 ) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25-120==41 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 62 && y_pos-25-240 <=64) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25-120==42 && ( y_pos-25-240== 2 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 64 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-120==43 && ( y_pos-25-240== 2 || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-120==44 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-120==45 && ( y_pos-25-240== 3 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-120==46 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==47 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==48 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==49 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==50 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==51 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-120==52 && ((y_pos-25-240>= 9  && y_pos-25-240<= 10) || (y_pos-25-240>= 63 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25-120==53 && ((y_pos-25-240>= 10  && y_pos-25-240<= 12)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-120==54 && ((y_pos-25-240>= 12  && y_pos-25-240<= 14)  || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25-120==55 && ((y_pos-25-240>= 14  && y_pos-25-240<= 17)  || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25-120==56 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-120==57 && ((y_pos-25-240>= 20  && y_pos-25-240<= 24) || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| (y_pos-25-240== 60 ))) ||
                            ( x_pos-25-120==58 && ((y_pos-25-240>= 24  && y_pos-25-240<= 60) || (y_pos-25-240== 67 ))) ||
                            ( x_pos-25-120==59 && ((y_pos-25-240>= 66 && y_pos-25-240<= 67) || y_pos-25-240== 55 || y_pos-25-240 ==60))  ||
                            ( x_pos-25-120==60 && ((y_pos-25-240>= 55  && y_pos-25-240<= 57) || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240== 66 ))) ||
                            ( x_pos-25-120==61 && ((y_pos-25-240>= 57 && y_pos-25-240<= 59) || (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25-120==62 && ( y_pos-25-240== 59 || y_pos-25-240 ==65))  ||
                            ( x_pos-25-120==63 && ((y_pos-25-240>= 59 && y_pos-25-240<= 60) || y_pos-25-240== 65 ))  ||
                            ( x_pos-25-120==64 && (y_pos-25-240>= 60 && y_pos-25-240<= 64) ) ;
    assign location_8_body = ( x_pos-25-120==15 && (y_pos-25-240> 25 && y_pos-25-240< 58)) ||
                            ( x_pos-25-120==16 && (y_pos-25-240> 20 && y_pos-25-240< 58)) ||
                            ( x_pos-25-120==17 && (y_pos-25-240> 17 && y_pos-25-240< 58)) ||
                            ( x_pos-25-120==18 && (y_pos-25-240> 13 && y_pos-25-240< 58)) ||
                            ( x_pos-25-120==19 && (y_pos-25-240> 11 && y_pos-25-240< 59)) ||
                            ( x_pos-25-120==20 && (y_pos-25-240> 9 && y_pos-25-240< 59)) ||
                            ( x_pos-25-120==21 && (y_pos-25-240> 8 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==22 && (y_pos-25-240> 7 && y_pos-25-240< 60)) ||
                            ( x_pos-25-120==23 && (y_pos-25-240> 6 && y_pos-25-240< 60)) ||
                            ( x_pos-25-120==24 && (y_pos-25-240> 5 && y_pos-25-240< 61)) ||
                            ( x_pos-25-120==25 && ((y_pos-25-240> 4 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 62))) ||
                            ( x_pos-25-120==26 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25-120==27 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 63))) ||
                            ( x_pos-25-120==28 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 64))) ||
                            ( x_pos-25-120==29 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 65))) ||
                            ( x_pos-25-120==30 && (y_pos-25-240> 1 && y_pos-25-240< 61)) ||
                            ( x_pos-25-120==31 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==32 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==33 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==34 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==35 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==36 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==37 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==38 && ((y_pos-25-240> 1 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 60))) ||
                            ( x_pos-25-120==39 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 60))) ||
                            ( x_pos-25-120==40 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 61))) ||
                            ( x_pos-25-120==41 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25-120==42 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 61))) ||
                            ( x_pos-25-120==43 && (y_pos-25-240> 2 && y_pos-25-240< 61))  ||
                            ( x_pos-25-120==44 && (y_pos-25-240> 3 && y_pos-25-240< 61))  ||
                            ( x_pos-25-120==45 && (y_pos-25-240> 3 && y_pos-25-240< 60)) ||
                            ( x_pos-25-120==46 && (y_pos-25-240> 4 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==47 && (y_pos-25-240> 5 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==48 && (y_pos-25-240> 6 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==49 && (y_pos-25-240> 7 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==50 && (y_pos-25-240> 8 && y_pos-25-240< 62))  ||
                            ( x_pos-25-120==51 && (y_pos-25-240> 9 && y_pos-25-240< 62))  ||
                            ( x_pos-25-120==52 && (y_pos-25-240> 10 && y_pos-25-240< 63))  ||
                            ( x_pos-25-120==53 && (y_pos-25-240> 12 && y_pos-25-240< 62))  ||
                            ( x_pos-25-120==54 && (y_pos-25-240> 14 && y_pos-25-240< 61))  ||
                            ( x_pos-25-120==55 && (y_pos-25-240> 17 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==56 && (y_pos-25-240> 20 && y_pos-25-240< 60))  ||
                            ( x_pos-25-120==57 && (y_pos-25-240> 24 && y_pos-25-240< 60))  ;
    assign location_8_stone = ( x_pos-25-120==11 && (y_pos-25-240> 58 && y_pos-25-240< 62)) ||
                            ( x_pos-25-120==12 && (y_pos-25-240> 57 && y_pos-25-240< 63)) ||
                            ( x_pos-25-120==13 && ((y_pos-25-240> 53 && y_pos-25-240< 57)||(y_pos-25-240> 57 && y_pos-25-240< 64))) ||
                            ( x_pos-25-120==14 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-120==15 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-120==16 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-120==17 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-120==18 && (y_pos-25-240> 58 && y_pos-25-240< 61)) ||
                            ( x_pos-25-120==19 && (y_pos-25-240> 61 && y_pos-25-240< 65)) ||
                            ( x_pos-25-120==20 && (y_pos-25-240> 60 && y_pos-25-240< 66)) ||
                            ( x_pos-25-120==21 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==22 && (y_pos-25-240> 60 && y_pos-25-240< 67)) ||
                            ( x_pos-25-120==23 && (y_pos-25-240> 61 && y_pos-25-240< 68)) ||
                            ( x_pos-25-120==24 && (y_pos-25-240> 62 && y_pos-25-240< 68)) ||
                            ( x_pos-25-120==25 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==26 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==27 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==28 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==29 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==30 && (y_pos-25-240> 62 && y_pos-25-240< 67)) ||
                            ( x_pos-25-120==31 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==32 && (y_pos-25-240> 60 && y_pos-25-240< 63))  ||
                            ( x_pos-25-120==33 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==34 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==35 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==36 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==37 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==38 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==39 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==40 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==41 && (y_pos-25-240> 64 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==42 && (y_pos-25-240> 62 && y_pos-25-240< 64)) ||
                            ( x_pos-25-120==43 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==44 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==45 && (y_pos-25-240> 61 && y_pos-25-240< 67)) ||
                            ( x_pos-25-120==46 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==47 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==48 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==49 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==50 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==51 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==53 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==54 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==55 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==56 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==57 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-120==58 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-120==59 && (y_pos-25-240> 55 && y_pos-25-240 !=60 && y_pos-25-240< 66))  ||
                            ( x_pos-25-120==60 && (y_pos-25-240> 57 && y_pos-25-240 !=60 && y_pos-25-240 !=59  &&y_pos-25-240< 66))  ||
                            ( x_pos-25-120==61 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25-120==62 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25-120==63 && (y_pos-25-240> 60 && y_pos-25-240< 65)) ;
    assign location_8_eyes = ( x_pos-25-120== 26 && (y_pos-25-240>= 20 && y_pos-25-240 <= 22) ) || ( x_pos-25-120== 39 && (y_pos-25-240 >= 20 && y_pos-25-240<= 22));

	assign location_f_line = ( x_pos-25-120==10 && y_pos-25-360>= 58 && y_pos-25-360<= 62) || 
                            ( x_pos-25-120==11 && ((y_pos-25-360>= 57 && y_pos-25-360<= 58) || (y_pos-25-360>= 62 && y_pos-25-360 <=63 ))) ||
                            ( x_pos-25-120==12 && ((y_pos-25-360>= 54 && y_pos-25-360<= 57) || (y_pos-25-360>= 63 && y_pos-25-360 <=64 ))) ||
                            ( x_pos-25-120==13 && (y_pos-25-360==53 || y_pos-25-360== 57 || y_pos-25-360 ==64 )) ||
                            ( x_pos-25-120==14 && ((y_pos-25-360>= 25 && y_pos-25-360<= 58) || y_pos-25-360== 64 )) ||
                            ( x_pos-25-120==15 && ((y_pos-25-360>= 20 && y_pos-25-360<= 25) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-120==16 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-120==17 && ((y_pos-25-360>= 13 && y_pos-25-360<= 17) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-120==18 && ((y_pos-25-360>= 11 && y_pos-25-360<= 13) || y_pos-25-360== 58 || (y_pos-25-360>= 61 && y_pos-25-360 <=65 ))) ||
                            ( x_pos-25-120==19 && ((y_pos-25-360>= 9  && y_pos-25-360<= 11) || (y_pos-25-360>= 59 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25-120==20 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360>= 66 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25-120==21 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 60 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-120==22 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || y_pos-25-360== 60 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-120==23 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 ))) ||
                            ( x_pos-25-120==24 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ))) ||
                            ( x_pos-25-120==25 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==26 && ( y_pos-25-360== 3 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==27 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==28 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==29 && ((y_pos-25-360>= 1 && y_pos-25-360<= 2) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==30 && ( y_pos-25-360== 1 || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-120==31 && ( y_pos-25-360== 1 || (y_pos-25-360>= 60 && y_pos-25-360 <=63 )|| y_pos-25-360 ==67))  ||
                            ( x_pos-25-120==32 && ( y_pos-25-360== 1 || (y_pos-25-360>= 63 && y_pos-25-360 <=67 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25-120==33 && ( y_pos-25-360== 1 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25-120==34 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==35 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==36 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==37 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==38 && ( y_pos-25-360== 1 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==39 && ( y_pos-25-360== 1 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 60 && y_pos-25-360 <=61 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==40 && ( y_pos-25-360== 1 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=63 ) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25-120==41 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 62 && y_pos-25-360 <=64) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25-120==42 && ( y_pos-25-360== 2 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 64 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-120==43 && ( y_pos-25-360== 2 || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-120==44 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-120==45 && ( y_pos-25-360== 3 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-120==46 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==47 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==48 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==49 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==50 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==51 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-120==52 && ((y_pos-25-360>= 9  && y_pos-25-360<= 10) || (y_pos-25-360>= 63 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25-120==53 && ((y_pos-25-360>= 10  && y_pos-25-360<= 12)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-120==54 && ((y_pos-25-360>= 12  && y_pos-25-360<= 14)  || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25-120==55 && ((y_pos-25-360>= 14  && y_pos-25-360<= 17)  || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25-120==56 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-120==57 && ((y_pos-25-360>= 20  && y_pos-25-360<= 24) || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| (y_pos-25-360== 60 ))) ||
                            ( x_pos-25-120==58 && ((y_pos-25-360>= 24  && y_pos-25-360<= 60) || (y_pos-25-360== 67 ))) ||
                            ( x_pos-25-120==59 && ((y_pos-25-360>= 66 && y_pos-25-360<= 67) || y_pos-25-360== 55 || y_pos-25-360 ==60))  ||
                            ( x_pos-25-120==60 && ((y_pos-25-360>= 55  && y_pos-25-360<= 57) || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360== 66 ))) ||
                            ( x_pos-25-120==61 && ((y_pos-25-360>= 57 && y_pos-25-360<= 59) || (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25-120==62 && ( y_pos-25-360== 59 || y_pos-25-360 ==65))  ||
                            ( x_pos-25-120==63 && ((y_pos-25-360>= 59 && y_pos-25-360<= 60) || y_pos-25-360== 65 ))  ||
                            ( x_pos-25-120==64 && (y_pos-25-360>= 60 && y_pos-25-360<= 64) ) ;
    assign location_f_body = ( x_pos-25-120==15 && (y_pos-25-360> 25 && y_pos-25-360< 58)) ||
                            ( x_pos-25-120==16 && (y_pos-25-360> 20 && y_pos-25-360< 58)) ||
                            ( x_pos-25-120==17 && (y_pos-25-360> 17 && y_pos-25-360< 58)) ||
                            ( x_pos-25-120==18 && (y_pos-25-360> 13 && y_pos-25-360< 58)) ||
                            ( x_pos-25-120==19 && (y_pos-25-360> 11 && y_pos-25-360< 59)) ||
                            ( x_pos-25-120==20 && (y_pos-25-360> 9 && y_pos-25-360< 59)) ||
                            ( x_pos-25-120==21 && (y_pos-25-360> 8 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==22 && (y_pos-25-360> 7 && y_pos-25-360< 60)) ||
                            ( x_pos-25-120==23 && (y_pos-25-360> 6 && y_pos-25-360< 60)) ||
                            ( x_pos-25-120==24 && (y_pos-25-360> 5 && y_pos-25-360< 61)) ||
                            ( x_pos-25-120==25 && ((y_pos-25-360> 4 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 62))) ||
                            ( x_pos-25-120==26 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25-120==27 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 63))) ||
                            ( x_pos-25-120==28 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 64))) ||
                            ( x_pos-25-120==29 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 65))) ||
                            ( x_pos-25-120==30 && (y_pos-25-360> 1 && y_pos-25-360< 61)) ||
                            ( x_pos-25-120==31 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==32 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==33 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==34 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==35 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==36 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==37 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==38 && ((y_pos-25-360> 1 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 60))) ||
                            ( x_pos-25-120==39 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 60))) ||
                            ( x_pos-25-120==40 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 61))) ||
                            ( x_pos-25-120==41 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25-120==42 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 61))) ||
                            ( x_pos-25-120==43 && (y_pos-25-360> 2 && y_pos-25-360< 61))  ||
                            ( x_pos-25-120==44 && (y_pos-25-360> 3 && y_pos-25-360< 61))  ||
                            ( x_pos-25-120==45 && (y_pos-25-360> 3 && y_pos-25-360< 60)) ||
                            ( x_pos-25-120==46 && (y_pos-25-360> 4 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==47 && (y_pos-25-360> 5 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==48 && (y_pos-25-360> 6 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==49 && (y_pos-25-360> 7 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==50 && (y_pos-25-360> 8 && y_pos-25-360< 62))  ||
                            ( x_pos-25-120==51 && (y_pos-25-360> 9 && y_pos-25-360< 62))  ||
                            ( x_pos-25-120==52 && (y_pos-25-360> 10 && y_pos-25-360< 63))  ||
                            ( x_pos-25-120==53 && (y_pos-25-360> 12 && y_pos-25-360< 62))  ||
                            ( x_pos-25-120==54 && (y_pos-25-360> 14 && y_pos-25-360< 61))  ||
                            ( x_pos-25-120==55 && (y_pos-25-360> 17 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==56 && (y_pos-25-360> 20 && y_pos-25-360< 60))  ||
                            ( x_pos-25-120==57 && (y_pos-25-360> 24 && y_pos-25-360< 60))  ;
    assign location_f_stone = ( x_pos-25-120==11 && (y_pos-25-360> 58 && y_pos-25-360< 62)) ||
                            ( x_pos-25-120==12 && (y_pos-25-360> 57 && y_pos-25-360< 63)) ||
                            ( x_pos-25-120==13 && ((y_pos-25-360> 53 && y_pos-25-360< 57)||(y_pos-25-360> 57 && y_pos-25-360< 64))) ||
                            ( x_pos-25-120==14 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-120==15 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-120==16 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-120==17 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-120==18 && (y_pos-25-360> 58 && y_pos-25-360< 61)) ||
                            ( x_pos-25-120==19 && (y_pos-25-360> 61 && y_pos-25-360< 65)) ||
                            ( x_pos-25-120==20 && (y_pos-25-360> 60 && y_pos-25-360< 66)) ||
                            ( x_pos-25-120==21 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==22 && (y_pos-25-360> 60 && y_pos-25-360< 67)) ||
                            ( x_pos-25-120==23 && (y_pos-25-360> 61 && y_pos-25-360< 68)) ||
                            ( x_pos-25-120==24 && (y_pos-25-360> 62 && y_pos-25-360< 68)) ||
                            ( x_pos-25-120==25 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==26 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==27 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==28 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==29 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==30 && (y_pos-25-360> 62 && y_pos-25-360< 67)) ||
                            ( x_pos-25-120==31 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==32 && (y_pos-25-360> 60 && y_pos-25-360< 63))  ||
                            ( x_pos-25-120==33 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==34 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==35 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==36 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==37 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==38 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==39 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==40 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==41 && (y_pos-25-360> 64 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==42 && (y_pos-25-360> 62 && y_pos-25-360< 64)) ||
                            ( x_pos-25-120==43 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==44 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==45 && (y_pos-25-360> 61 && y_pos-25-360< 67)) ||
                            ( x_pos-25-120==46 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==47 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==48 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==49 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==50 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==51 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==53 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==54 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==55 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==56 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==57 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-120==58 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-120==59 && (y_pos-25-360> 55 && y_pos-25-360 !=60 && y_pos-25-360< 66))  ||
                            ( x_pos-25-120==60 && (y_pos-25-360> 57 && y_pos-25-360 !=60 && y_pos-25-360 !=59  &&y_pos-25-360< 66))  ||
                            ( x_pos-25-120==61 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25-120==62 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25-120==63 && (y_pos-25-360> 60 && y_pos-25-360< 65)) ;
    assign location_f_eyes = ( x_pos-25-120== 26 && (y_pos-25-360>= 20 && y_pos-25-360 <= 22) ) || ( x_pos-25-120== 39 && (y_pos-25-360 >= 20 && y_pos-25-360<= 22));

	assign location_3_line = ( x_pos-25-240==10 && y_pos-25>= 58 && y_pos-25<= 62) || 
                            ( x_pos-25-240==11 && ((y_pos-25>= 57 && y_pos-25<= 58) || (y_pos-25>= 62 && y_pos-25 <=63 ))) ||
                            ( x_pos-25-240==12 && ((y_pos-25>= 54 && y_pos-25<= 57) || (y_pos-25>= 63 && y_pos-25 <=64 ))) ||
                            ( x_pos-25-240==13 && (y_pos-25==53 || y_pos-25== 57 || y_pos-25 ==64 )) ||
                            ( x_pos-25-240==14 && ((y_pos-25>= 25 && y_pos-25<= 58) || y_pos-25== 64 )) ||
                            ( x_pos-25-240==15 && ((y_pos-25>= 20 && y_pos-25<= 25) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-240==16 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-240==17 && ((y_pos-25>= 13 && y_pos-25<= 17) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-240==18 && ((y_pos-25>= 11 && y_pos-25<= 13) || y_pos-25== 58 || (y_pos-25>= 61 && y_pos-25 <=65 ))) ||
                            ( x_pos-25-240==19 && ((y_pos-25>= 9  && y_pos-25<= 11) || (y_pos-25>= 59 && y_pos-25 <=61 )|| (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25-240==20 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25>= 66 && y_pos-25 <=67 ))) ||
                            ( x_pos-25-240==21 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 60 || y_pos-25 ==67))  ||
                            ( x_pos-25-240==22 && ((y_pos-25>= 6 && y_pos-25<= 7) || y_pos-25== 60 || (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-240==23 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=61 ))) ||
                            ( x_pos-25-240==24 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=62 ))) ||
                            ( x_pos-25-240==25 && ((y_pos-25>= 3 && y_pos-25<= 4) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==26 && ( y_pos-25== 3 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==27 && ((y_pos-25>= 2 && y_pos-25<= 3) || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==28 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==29 && ((y_pos-25>= 1 && y_pos-25<= 2) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==30 && ( y_pos-25== 1 || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-240==31 && ( y_pos-25== 1 || (y_pos-25>= 60 && y_pos-25 <=63 )|| y_pos-25 ==67))  ||
                            ( x_pos-25-240==32 && ( y_pos-25== 1 || (y_pos-25>= 63 && y_pos-25 <=67 )|| y_pos-25 ==60))  ||
                            ( x_pos-25-240==33 && ( y_pos-25== 1 || (y_pos-25>= 67 && y_pos-25 <=68 )|| y_pos-25 ==60))  ||
                            ( x_pos-25-240==34 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==35 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==36 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==37 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==38 && ( y_pos-25== 1 || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==39 && ( y_pos-25== 1 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| (y_pos-25>= 60 && y_pos-25 <=61 ) || y_pos-25 ==68))  ||
                            ( x_pos-25-240==40 && ( y_pos-25== 1 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 61 && y_pos-25 <=63 ) || y_pos-25 ==68 ))  ||
                            ( x_pos-25-240==41 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 62 && y_pos-25 <=64) || y_pos-25 ==68 ))  ||
                            ( x_pos-25-240==42 && ( y_pos-25== 2 || (y_pos-25>= 20 && y_pos-25 <=25 )|| (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 64 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-240==43 && ( y_pos-25== 2 || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25-240==44 && ((y_pos-25>= 2 && y_pos-25<= 3) || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25-240==45 && ( y_pos-25== 3 || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-240==46 && ((y_pos-25>= 3 && y_pos-25<= 4) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==47 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==48 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==49 && ((y_pos-25>= 6 && y_pos-25<= 7) || (y_pos-25>= 60 && y_pos-25 <=62 ) || y_pos-25 ==68))  ||
                            ( x_pos-25-240==50 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==51 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-240==52 && ((y_pos-25>= 9  && y_pos-25<= 10) || (y_pos-25>= 63 && y_pos-25 <=67 ))) ||
                            ( x_pos-25-240==53 && ((y_pos-25>= 10  && y_pos-25<= 12)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-240==54 && ((y_pos-25>= 12  && y_pos-25<= 14)  || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25-240==55 && ((y_pos-25>= 14  && y_pos-25<= 17)  || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25-240==56 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-240==57 && ((y_pos-25>= 20  && y_pos-25<= 24) || (y_pos-25>= 67 && y_pos-25 <=68 )|| (y_pos-25== 60 ))) ||
                            ( x_pos-25-240==58 && ((y_pos-25>= 24  && y_pos-25<= 60) || (y_pos-25== 67 ))) ||
                            ( x_pos-25-240==59 && ((y_pos-25>= 66 && y_pos-25<= 67) || y_pos-25== 55 || y_pos-25 ==60))  ||
                            ( x_pos-25-240==60 && ((y_pos-25>= 55  && y_pos-25<= 57) || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25== 66 ))) ||
                            ( x_pos-25-240==61 && ((y_pos-25>= 57 && y_pos-25<= 59) || (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25-240==62 && ( y_pos-25== 59 || y_pos-25 ==65))  ||
                            ( x_pos-25-240==63 && ((y_pos-25>= 59 && y_pos-25<= 60) || y_pos-25== 65 ))  ||
                            ( x_pos-25-240==64 && (y_pos-25>= 60 && y_pos-25<= 64) ) ;
    assign location_3_body = ( x_pos-25-240==15 && (y_pos-25> 25 && y_pos-25< 58)) ||
                            ( x_pos-25-240==16 && (y_pos-25> 20 && y_pos-25< 58)) ||
                            ( x_pos-25-240==17 && (y_pos-25> 17 && y_pos-25< 58)) ||
                            ( x_pos-25-240==18 && (y_pos-25> 13 && y_pos-25< 58)) ||
                            ( x_pos-25-240==19 && (y_pos-25> 11 && y_pos-25< 59)) ||
                            ( x_pos-25-240==20 && (y_pos-25> 9 && y_pos-25< 59)) ||
                            ( x_pos-25-240==21 && (y_pos-25> 8 && y_pos-25< 60))  ||
                            ( x_pos-25-240==22 && (y_pos-25> 7 && y_pos-25< 60)) ||
                            ( x_pos-25-240==23 && (y_pos-25> 6 && y_pos-25< 60)) ||
                            ( x_pos-25-240==24 && (y_pos-25> 5 && y_pos-25< 61)) ||
                            ( x_pos-25-240==25 && ((y_pos-25> 4 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 62))) ||
                            ( x_pos-25-240==26 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25-240==27 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 63))) ||
                            ( x_pos-25-240==28 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 64))) ||
                            ( x_pos-25-240==29 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 65))) ||
                            ( x_pos-25-240==30 && (y_pos-25> 1 && y_pos-25< 61)) ||
                            ( x_pos-25-240==31 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==32 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==33 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==34 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==35 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==36 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==37 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-240==38 && ((y_pos-25> 1 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 60))) ||
                            ( x_pos-25-240==39 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 60))) ||
                            ( x_pos-25-240==40 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 61))) ||
                            ( x_pos-25-240==41 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25-240==42 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 61))) ||
                            ( x_pos-25-240==43 && (y_pos-25> 2 && y_pos-25< 61))  ||
                            ( x_pos-25-240==44 && (y_pos-25> 3 && y_pos-25< 61))  ||
                            ( x_pos-25-240==45 && (y_pos-25> 3 && y_pos-25< 60)) ||
                            ( x_pos-25-240==46 && (y_pos-25> 4 && y_pos-25< 60))  ||
                            ( x_pos-25-240==47 && (y_pos-25> 5 && y_pos-25< 60))  ||
                            ( x_pos-25-240==48 && (y_pos-25> 6 && y_pos-25< 60))  ||
                            ( x_pos-25-240==49 && (y_pos-25> 7 && y_pos-25< 60))  ||
                            ( x_pos-25-240==50 && (y_pos-25> 8 && y_pos-25< 62))  ||
                            ( x_pos-25-240==51 && (y_pos-25> 9 && y_pos-25< 62))  ||
                            ( x_pos-25-240==52 && (y_pos-25> 10 && y_pos-25< 63))  ||
                            ( x_pos-25-240==53 && (y_pos-25> 12 && y_pos-25< 62))  ||
                            ( x_pos-25-240==54 && (y_pos-25> 14 && y_pos-25< 61))  ||
                            ( x_pos-25-240==55 && (y_pos-25> 17 && y_pos-25< 60))  ||
                            ( x_pos-25-240==56 && (y_pos-25> 20 && y_pos-25< 60))  ||
                            ( x_pos-25-240==57 && (y_pos-25> 24 && y_pos-25< 60))  ;
    assign location_3_stone = ( x_pos-25-240==11 && (y_pos-25> 58 && y_pos-25< 62)) ||
                            ( x_pos-25-240==12 && (y_pos-25> 57 && y_pos-25< 63)) ||
                            ( x_pos-25-240==13 && ((y_pos-25> 53 && y_pos-25< 57)||(y_pos-25> 57 && y_pos-25< 64))) ||
                            ( x_pos-25-240==14 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-240==15 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-240==16 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-240==17 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-240==18 && (y_pos-25> 58 && y_pos-25< 61)) ||
                            ( x_pos-25-240==19 && (y_pos-25> 61 && y_pos-25< 65)) ||
                            ( x_pos-25-240==20 && (y_pos-25> 60 && y_pos-25< 66)) ||
                            ( x_pos-25-240==21 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-240==22 && (y_pos-25> 60 && y_pos-25< 67)) ||
                            ( x_pos-25-240==23 && (y_pos-25> 61 && y_pos-25< 68)) ||
                            ( x_pos-25-240==24 && (y_pos-25> 62 && y_pos-25< 68)) ||
                            ( x_pos-25-240==25 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==26 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==27 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==28 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==29 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==30 && (y_pos-25> 62 && y_pos-25< 67)) ||
                            ( x_pos-25-240==31 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25-240==32 && (y_pos-25> 60 && y_pos-25< 63))  ||
                            ( x_pos-25-240==33 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-240==34 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==35 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==36 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==37 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==38 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==39 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25-240==40 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25-240==41 && (y_pos-25> 64 && y_pos-25< 68))  ||
                            ( x_pos-25-240==42 && (y_pos-25> 62 && y_pos-25< 64)) ||
                            ( x_pos-25-240==43 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25-240==44 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25-240==45 && (y_pos-25> 61 && y_pos-25< 67)) ||
                            ( x_pos-25-240==46 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==47 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==48 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==49 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==50 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==51 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25-240==53 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25-240==54 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-240==55 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25-240==56 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==57 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-240==58 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-240==59 && (y_pos-25> 55 && y_pos-25 !=60 && y_pos-25< 66))  ||
                            ( x_pos-25-240==60 && (y_pos-25> 57 && y_pos-25 !=60 && y_pos-25 !=59  &&y_pos-25< 66))  ||
                            ( x_pos-25-240==61 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25-240==62 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25-240==63 && (y_pos-25> 60 && y_pos-25< 65)) ;
    assign location_3_eyes = ( x_pos-25-240== 26 && (y_pos-25>= 20 && y_pos-25 <= 22) ) || ( x_pos-25-240== 39 && (y_pos-25 >= 20 && y_pos-25<= 22));


	assign location_6_line = ( x_pos-25-240==10 && y_pos-25-120>= 58 && y_pos-25-120<= 62) || 
                            ( x_pos-25-240==11 && ((y_pos-25-120>= 57 && y_pos-25-120<= 58) || (y_pos-25-120>= 62 && y_pos-25-120 <=63 ))) ||
                            ( x_pos-25-240==12 && ((y_pos-25-120>= 54 && y_pos-25-120<= 57) || (y_pos-25-120>= 63 && y_pos-25-120 <=64 ))) ||
                            ( x_pos-25-240==13 && (y_pos-25-120==53 || y_pos-25-120== 57 || y_pos-25-120 ==64 )) ||
                            ( x_pos-25-240==14 && ((y_pos-25-120>= 25 && y_pos-25-120<= 58) || y_pos-25-120== 64 )) ||
                            ( x_pos-25-240==15 && ((y_pos-25-120>= 20 && y_pos-25-120<= 25) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-240==16 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-240==17 && ((y_pos-25-120>= 13 && y_pos-25-120<= 17) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-240==18 && ((y_pos-25-120>= 11 && y_pos-25-120<= 13) || y_pos-25-120== 58 || (y_pos-25-120>= 61 && y_pos-25-120 <=65 ))) ||
                            ( x_pos-25-240==19 && ((y_pos-25-120>= 9  && y_pos-25-120<= 11) || (y_pos-25-120>= 59 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25-240==20 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120>= 66 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25-240==21 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 60 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-240==22 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || y_pos-25-120== 60 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-240==23 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 ))) ||
                            ( x_pos-25-240==24 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ))) ||
                            ( x_pos-25-240==25 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==26 && ( y_pos-25-120== 3 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==27 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==28 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==29 && ((y_pos-25-120>= 1 && y_pos-25-120<= 2) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==30 && ( y_pos-25-120== 1 || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-240==31 && ( y_pos-25-120== 1 || (y_pos-25-120>= 60 && y_pos-25-120 <=63 )|| y_pos-25-120 ==67))  ||
                            ( x_pos-25-240==32 && ( y_pos-25-120== 1 || (y_pos-25-120>= 63 && y_pos-25-120 <=67 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25-240==33 && ( y_pos-25-120== 1 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25-240==34 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==35 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==36 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==37 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==38 && ( y_pos-25-120== 1 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==39 && ( y_pos-25-120== 1 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 60 && y_pos-25-120 <=61 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==40 && ( y_pos-25-120== 1 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=63 ) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25-240==41 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 62 && y_pos-25-120 <=64) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25-240==42 && ( y_pos-25-120== 2 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 64 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-240==43 && ( y_pos-25-120== 2 || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-240==44 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-240==45 && ( y_pos-25-120== 3 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-240==46 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==47 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==48 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==49 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==50 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==51 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-240==52 && ((y_pos-25-120>= 9  && y_pos-25-120<= 10) || (y_pos-25-120>= 63 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25-240==53 && ((y_pos-25-120>= 10  && y_pos-25-120<= 12)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-240==54 && ((y_pos-25-120>= 12  && y_pos-25-120<= 14)  || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25-240==55 && ((y_pos-25-120>= 14  && y_pos-25-120<= 17)  || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25-240==56 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-240==57 && ((y_pos-25-120>= 20  && y_pos-25-120<= 24) || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| (y_pos-25-120== 60 ))) ||
                            ( x_pos-25-240==58 && ((y_pos-25-120>= 24  && y_pos-25-120<= 60) || (y_pos-25-120== 67 ))) ||
                            ( x_pos-25-240==59 && ((y_pos-25-120>= 66 && y_pos-25-120<= 67) || y_pos-25-120== 55 || y_pos-25-120 ==60))  ||
                            ( x_pos-25-240==60 && ((y_pos-25-120>= 55  && y_pos-25-120<= 57) || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120== 66 ))) ||
                            ( x_pos-25-240==61 && ((y_pos-25-120>= 57 && y_pos-25-120<= 59) || (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25-240==62 && ( y_pos-25-120== 59 || y_pos-25-120 ==65))  ||
                            ( x_pos-25-240==63 && ((y_pos-25-120>= 59 && y_pos-25-120<= 60) || y_pos-25-120== 65 ))  ||
                            ( x_pos-25-240==64 && (y_pos-25-120>= 60 && y_pos-25-120<= 64) ) ;
    assign location_6_body = ( x_pos-25-240==15 && (y_pos-25-120> 25 && y_pos-25-120< 58)) ||
                            ( x_pos-25-240==16 && (y_pos-25-120> 20 && y_pos-25-120< 58)) ||
                            ( x_pos-25-240==17 && (y_pos-25-120> 17 && y_pos-25-120< 58)) ||
                            ( x_pos-25-240==18 && (y_pos-25-120> 13 && y_pos-25-120< 58)) ||
                            ( x_pos-25-240==19 && (y_pos-25-120> 11 && y_pos-25-120< 59)) ||
                            ( x_pos-25-240==20 && (y_pos-25-120> 9 && y_pos-25-120< 59)) ||
                            ( x_pos-25-240==21 && (y_pos-25-120> 8 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==22 && (y_pos-25-120> 7 && y_pos-25-120< 60)) ||
                            ( x_pos-25-240==23 && (y_pos-25-120> 6 && y_pos-25-120< 60)) ||
                            ( x_pos-25-240==24 && (y_pos-25-120> 5 && y_pos-25-120< 61)) ||
                            ( x_pos-25-240==25 && ((y_pos-25-120> 4 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 62))) ||
                            ( x_pos-25-240==26 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25-240==27 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 63))) ||
                            ( x_pos-25-240==28 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 64))) ||
                            ( x_pos-25-240==29 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 65))) ||
                            ( x_pos-25-240==30 && (y_pos-25-120> 1 && y_pos-25-120< 61)) ||
                            ( x_pos-25-240==31 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==32 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==33 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==34 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==35 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==36 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==37 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==38 && ((y_pos-25-120> 1 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 60))) ||
                            ( x_pos-25-240==39 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 60))) ||
                            ( x_pos-25-240==40 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 61))) ||
                            ( x_pos-25-240==41 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25-240==42 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 61))) ||
                            ( x_pos-25-240==43 && (y_pos-25-120> 2 && y_pos-25-120< 61))  ||
                            ( x_pos-25-240==44 && (y_pos-25-120> 3 && y_pos-25-120< 61))  ||
                            ( x_pos-25-240==45 && (y_pos-25-120> 3 && y_pos-25-120< 60)) ||
                            ( x_pos-25-240==46 && (y_pos-25-120> 4 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==47 && (y_pos-25-120> 5 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==48 && (y_pos-25-120> 6 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==49 && (y_pos-25-120> 7 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==50 && (y_pos-25-120> 8 && y_pos-25-120< 62))  ||
                            ( x_pos-25-240==51 && (y_pos-25-120> 9 && y_pos-25-120< 62))  ||
                            ( x_pos-25-240==52 && (y_pos-25-120> 10 && y_pos-25-120< 63))  ||
                            ( x_pos-25-240==53 && (y_pos-25-120> 12 && y_pos-25-120< 62))  ||
                            ( x_pos-25-240==54 && (y_pos-25-120> 14 && y_pos-25-120< 61))  ||
                            ( x_pos-25-240==55 && (y_pos-25-120> 17 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==56 && (y_pos-25-120> 20 && y_pos-25-120< 60))  ||
                            ( x_pos-25-240==57 && (y_pos-25-120> 24 && y_pos-25-120< 60))  ;
    assign location_6_stone = ( x_pos-25-240==11 && (y_pos-25-120> 58 && y_pos-25-120< 62)) ||
                            ( x_pos-25-240==12 && (y_pos-25-120> 57 && y_pos-25-120< 63)) ||
                            ( x_pos-25-240==13 && ((y_pos-25-120> 53 && y_pos-25-120< 57)||(y_pos-25-120> 57 && y_pos-25-120< 64))) ||
                            ( x_pos-25-240==14 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-240==15 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-240==16 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-240==17 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-240==18 && (y_pos-25-120> 58 && y_pos-25-120< 61)) ||
                            ( x_pos-25-240==19 && (y_pos-25-120> 61 && y_pos-25-120< 65)) ||
                            ( x_pos-25-240==20 && (y_pos-25-120> 60 && y_pos-25-120< 66)) ||
                            ( x_pos-25-240==21 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==22 && (y_pos-25-120> 60 && y_pos-25-120< 67)) ||
                            ( x_pos-25-240==23 && (y_pos-25-120> 61 && y_pos-25-120< 68)) ||
                            ( x_pos-25-240==24 && (y_pos-25-120> 62 && y_pos-25-120< 68)) ||
                            ( x_pos-25-240==25 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==26 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==27 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==28 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==29 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==30 && (y_pos-25-120> 62 && y_pos-25-120< 67)) ||
                            ( x_pos-25-240==31 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==32 && (y_pos-25-120> 60 && y_pos-25-120< 63))  ||
                            ( x_pos-25-240==33 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==34 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==35 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==36 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==37 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==38 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==39 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==40 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==41 && (y_pos-25-120> 64 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==42 && (y_pos-25-120> 62 && y_pos-25-120< 64)) ||
                            ( x_pos-25-240==43 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==44 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==45 && (y_pos-25-120> 61 && y_pos-25-120< 67)) ||
                            ( x_pos-25-240==46 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==47 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==48 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==49 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==50 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==51 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==53 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==54 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==55 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==56 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==57 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-240==58 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-240==59 && (y_pos-25-120> 55 && y_pos-25-120 !=60 && y_pos-25-120< 66))  ||
                            ( x_pos-25-240==60 && (y_pos-25-120> 57 && y_pos-25-120 !=60 && y_pos-25-120 !=59  &&y_pos-25-120< 66))  ||
                            ( x_pos-25-240==61 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25-240==62 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25-240==63 && (y_pos-25-120> 60 && y_pos-25-120< 65)) ;
    assign location_6_eyes = ( x_pos-25-240== 26 && (y_pos-25-120>= 20 && y_pos-25-120 <= 22) ) || ( x_pos-25-240== 39 && (y_pos-25-120 >= 20 && y_pos-25-120<= 22));
    
	assign location_9_line = ( x_pos-25-240==10 && y_pos-25-240>= 58 && y_pos-25-240<= 62) || 
                            ( x_pos-25-240==11 && ((y_pos-25-240>= 57 && y_pos-25-240<= 58) || (y_pos-25-240>= 62 && y_pos-25-240 <=63 ))) ||
                            ( x_pos-25-240==12 && ((y_pos-25-240>= 54 && y_pos-25-240<= 57) || (y_pos-25-240>= 63 && y_pos-25-240 <=64 ))) ||
                            ( x_pos-25-240==13 && (y_pos-25-240==53 || y_pos-25-240== 57 || y_pos-25-240 ==64 )) ||
                            ( x_pos-25-240==14 && ((y_pos-25-240>= 25 && y_pos-25-240<= 58) || y_pos-25-240== 64 )) ||
                            ( x_pos-25-240==15 && ((y_pos-25-240>= 20 && y_pos-25-240<= 25) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-240==16 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-240==17 && ((y_pos-25-240>= 13 && y_pos-25-240<= 17) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-240==18 && ((y_pos-25-240>= 11 && y_pos-25-240<= 13) || y_pos-25-240== 58 || (y_pos-25-240>= 61 && y_pos-25-240 <=65 ))) ||
                            ( x_pos-25-240==19 && ((y_pos-25-240>= 9  && y_pos-25-240<= 11) || (y_pos-25-240>= 59 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25-240==20 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240>= 66 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25-240==21 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 60 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-240==22 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || y_pos-25-240== 60 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-240==23 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 ))) ||
                            ( x_pos-25-240==24 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ))) ||
                            ( x_pos-25-240==25 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==26 && ( y_pos-25-240== 3 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==27 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==28 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==29 && ((y_pos-25-240>= 1 && y_pos-25-240<= 2) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==30 && ( y_pos-25-240== 1 || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-240==31 && ( y_pos-25-240== 1 || (y_pos-25-240>= 60 && y_pos-25-240 <=63 )|| y_pos-25-240 ==67))  ||
                            ( x_pos-25-240==32 && ( y_pos-25-240== 1 || (y_pos-25-240>= 63 && y_pos-25-240 <=67 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25-240==33 && ( y_pos-25-240== 1 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25-240==34 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==35 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==36 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==37 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==38 && ( y_pos-25-240== 1 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==39 && ( y_pos-25-240== 1 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 60 && y_pos-25-240 <=61 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==40 && ( y_pos-25-240== 1 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=63 ) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25-240==41 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 62 && y_pos-25-240 <=64) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25-240==42 && ( y_pos-25-240== 2 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 64 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-240==43 && ( y_pos-25-240== 2 || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-240==44 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-240==45 && ( y_pos-25-240== 3 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-240==46 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==47 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==48 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==49 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==50 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==51 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-240==52 && ((y_pos-25-240>= 9  && y_pos-25-240<= 10) || (y_pos-25-240>= 63 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25-240==53 && ((y_pos-25-240>= 10  && y_pos-25-240<= 12)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-240==54 && ((y_pos-25-240>= 12  && y_pos-25-240<= 14)  || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25-240==55 && ((y_pos-25-240>= 14  && y_pos-25-240<= 17)  || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25-240==56 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-240==57 && ((y_pos-25-240>= 20  && y_pos-25-240<= 24) || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| (y_pos-25-240== 60 ))) ||
                            ( x_pos-25-240==58 && ((y_pos-25-240>= 24  && y_pos-25-240<= 60) || (y_pos-25-240== 67 ))) ||
                            ( x_pos-25-240==59 && ((y_pos-25-240>= 66 && y_pos-25-240<= 67) || y_pos-25-240== 55 || y_pos-25-240 ==60))  ||
                            ( x_pos-25-240==60 && ((y_pos-25-240>= 55  && y_pos-25-240<= 57) || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240== 66 ))) ||
                            ( x_pos-25-240==61 && ((y_pos-25-240>= 57 && y_pos-25-240<= 59) || (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25-240==62 && ( y_pos-25-240== 59 || y_pos-25-240 ==65))  ||
                            ( x_pos-25-240==63 && ((y_pos-25-240>= 59 && y_pos-25-240<= 60) || y_pos-25-240== 65 ))  ||
                            ( x_pos-25-240==64 && (y_pos-25-240>= 60 && y_pos-25-240<= 64) ) ;
    assign location_9_body = ( x_pos-25-240==15 && (y_pos-25-240> 25 && y_pos-25-240< 58)) ||
                            ( x_pos-25-240==16 && (y_pos-25-240> 20 && y_pos-25-240< 58)) ||
                            ( x_pos-25-240==17 && (y_pos-25-240> 17 && y_pos-25-240< 58)) ||
                            ( x_pos-25-240==18 && (y_pos-25-240> 13 && y_pos-25-240< 58)) ||
                            ( x_pos-25-240==19 && (y_pos-25-240> 11 && y_pos-25-240< 59)) ||
                            ( x_pos-25-240==20 && (y_pos-25-240> 9 && y_pos-25-240< 59)) ||
                            ( x_pos-25-240==21 && (y_pos-25-240> 8 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==22 && (y_pos-25-240> 7 && y_pos-25-240< 60)) ||
                            ( x_pos-25-240==23 && (y_pos-25-240> 6 && y_pos-25-240< 60)) ||
                            ( x_pos-25-240==24 && (y_pos-25-240> 5 && y_pos-25-240< 61)) ||
                            ( x_pos-25-240==25 && ((y_pos-25-240> 4 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 62))) ||
                            ( x_pos-25-240==26 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25-240==27 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 63))) ||
                            ( x_pos-25-240==28 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 64))) ||
                            ( x_pos-25-240==29 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 65))) ||
                            ( x_pos-25-240==30 && (y_pos-25-240> 1 && y_pos-25-240< 61)) ||
                            ( x_pos-25-240==31 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==32 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==33 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==34 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==35 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==36 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==37 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==38 && ((y_pos-25-240> 1 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 60))) ||
                            ( x_pos-25-240==39 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 60))) ||
                            ( x_pos-25-240==40 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 61))) ||
                            ( x_pos-25-240==41 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25-240==42 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 61))) ||
                            ( x_pos-25-240==43 && (y_pos-25-240> 2 && y_pos-25-240< 61))  ||
                            ( x_pos-25-240==44 && (y_pos-25-240> 3 && y_pos-25-240< 61))  ||
                            ( x_pos-25-240==45 && (y_pos-25-240> 3 && y_pos-25-240< 60)) ||
                            ( x_pos-25-240==46 && (y_pos-25-240> 4 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==47 && (y_pos-25-240> 5 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==48 && (y_pos-25-240> 6 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==49 && (y_pos-25-240> 7 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==50 && (y_pos-25-240> 8 && y_pos-25-240< 62))  ||
                            ( x_pos-25-240==51 && (y_pos-25-240> 9 && y_pos-25-240< 62))  ||
                            ( x_pos-25-240==52 && (y_pos-25-240> 10 && y_pos-25-240< 63))  ||
                            ( x_pos-25-240==53 && (y_pos-25-240> 12 && y_pos-25-240< 62))  ||
                            ( x_pos-25-240==54 && (y_pos-25-240> 14 && y_pos-25-240< 61))  ||
                            ( x_pos-25-240==55 && (y_pos-25-240> 17 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==56 && (y_pos-25-240> 20 && y_pos-25-240< 60))  ||
                            ( x_pos-25-240==57 && (y_pos-25-240> 24 && y_pos-25-240< 60))  ;
    assign location_9_stone = ( x_pos-25-240==11 && (y_pos-25-240> 58 && y_pos-25-240< 62)) ||
                            ( x_pos-25-240==12 && (y_pos-25-240> 57 && y_pos-25-240< 63)) ||
                            ( x_pos-25-240==13 && ((y_pos-25-240> 53 && y_pos-25-240< 57)||(y_pos-25-240> 57 && y_pos-25-240< 64))) ||
                            ( x_pos-25-240==14 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-240==15 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-240==16 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-240==17 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-240==18 && (y_pos-25-240> 58 && y_pos-25-240< 61)) ||
                            ( x_pos-25-240==19 && (y_pos-25-240> 61 && y_pos-25-240< 65)) ||
                            ( x_pos-25-240==20 && (y_pos-25-240> 60 && y_pos-25-240< 66)) ||
                            ( x_pos-25-240==21 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==22 && (y_pos-25-240> 60 && y_pos-25-240< 67)) ||
                            ( x_pos-25-240==23 && (y_pos-25-240> 61 && y_pos-25-240< 68)) ||
                            ( x_pos-25-240==24 && (y_pos-25-240> 62 && y_pos-25-240< 68)) ||
                            ( x_pos-25-240==25 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==26 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==27 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==28 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==29 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==30 && (y_pos-25-240> 62 && y_pos-25-240< 67)) ||
                            ( x_pos-25-240==31 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==32 && (y_pos-25-240> 60 && y_pos-25-240< 63))  ||
                            ( x_pos-25-240==33 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==34 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==35 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==36 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==37 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==38 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==39 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==40 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==41 && (y_pos-25-240> 64 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==42 && (y_pos-25-240> 62 && y_pos-25-240< 64)) ||
                            ( x_pos-25-240==43 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==44 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==45 && (y_pos-25-240> 61 && y_pos-25-240< 67)) ||
                            ( x_pos-25-240==46 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==47 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==48 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==49 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==50 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==51 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==53 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==54 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==55 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==56 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==57 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-240==58 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-240==59 && (y_pos-25-240> 55 && y_pos-25-240 !=60 && y_pos-25-240< 66))  ||
                            ( x_pos-25-240==60 && (y_pos-25-240> 57 && y_pos-25-240 !=60 && y_pos-25-240 !=59  &&y_pos-25-240< 66))  ||
                            ( x_pos-25-240==61 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25-240==62 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25-240==63 && (y_pos-25-240> 60 && y_pos-25-240< 65)) ;
    assign location_9_eyes = ( x_pos-25-240== 26 && (y_pos-25-240>= 20 && y_pos-25-240 <= 22) ) || ( x_pos-25-240== 39 && (y_pos-25-240 >= 20 && y_pos-25-240<= 22));

  
	assign location_e_line = ( x_pos-25-240==10 && y_pos-25-360>= 58 && y_pos-25-360<= 62) || 
                            ( x_pos-25-240==11 && ((y_pos-25-360>= 57 && y_pos-25-360<= 58) || (y_pos-25-360>= 62 && y_pos-25-360 <=63 ))) ||
                            ( x_pos-25-240==12 && ((y_pos-25-360>= 54 && y_pos-25-360<= 57) || (y_pos-25-360>= 63 && y_pos-25-360 <=64 ))) ||
                            ( x_pos-25-240==13 && (y_pos-25-360==53 || y_pos-25-360== 57 || y_pos-25-360 ==64 )) ||
                            ( x_pos-25-240==14 && ((y_pos-25-360>= 25 && y_pos-25-360<= 58) || y_pos-25-360== 64 )) ||
                            ( x_pos-25-240==15 && ((y_pos-25-360>= 20 && y_pos-25-360<= 25) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-240==16 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-240==17 && ((y_pos-25-360>= 13 && y_pos-25-360<= 17) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-240==18 && ((y_pos-25-360>= 11 && y_pos-25-360<= 13) || y_pos-25-360== 58 || (y_pos-25-360>= 61 && y_pos-25-360 <=65 ))) ||
                            ( x_pos-25-240==19 && ((y_pos-25-360>= 9  && y_pos-25-360<= 11) || (y_pos-25-360>= 59 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25-240==20 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360>= 66 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25-240==21 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 60 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-240==22 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || y_pos-25-360== 60 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-240==23 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 ))) ||
                            ( x_pos-25-240==24 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ))) ||
                            ( x_pos-25-240==25 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==26 && ( y_pos-25-360== 3 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==27 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==28 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==29 && ((y_pos-25-360>= 1 && y_pos-25-360<= 2) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==30 && ( y_pos-25-360== 1 || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-240==31 && ( y_pos-25-360== 1 || (y_pos-25-360>= 60 && y_pos-25-360 <=63 )|| y_pos-25-360 ==67))  ||
                            ( x_pos-25-240==32 && ( y_pos-25-360== 1 || (y_pos-25-360>= 63 && y_pos-25-360 <=67 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25-240==33 && ( y_pos-25-360== 1 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25-240==34 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==35 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==36 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==37 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==38 && ( y_pos-25-360== 1 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==39 && ( y_pos-25-360== 1 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 60 && y_pos-25-360 <=61 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==40 && ( y_pos-25-360== 1 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=63 ) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25-240==41 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 62 && y_pos-25-360 <=64) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25-240==42 && ( y_pos-25-360== 2 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 64 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-240==43 && ( y_pos-25-360== 2 || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-240==44 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-240==45 && ( y_pos-25-360== 3 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-240==46 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==47 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==48 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==49 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==50 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==51 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-240==52 && ((y_pos-25-360>= 9  && y_pos-25-360<= 10) || (y_pos-25-360>= 63 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25-240==53 && ((y_pos-25-360>= 10  && y_pos-25-360<= 12)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-240==54 && ((y_pos-25-360>= 12  && y_pos-25-360<= 14)  || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25-240==55 && ((y_pos-25-360>= 14  && y_pos-25-360<= 17)  || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25-240==56 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-240==57 && ((y_pos-25-360>= 20  && y_pos-25-360<= 24) || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| (y_pos-25-360== 60 ))) ||
                            ( x_pos-25-240==58 && ((y_pos-25-360>= 24  && y_pos-25-360<= 60) || (y_pos-25-360== 67 ))) ||
                            ( x_pos-25-240==59 && ((y_pos-25-360>= 66 && y_pos-25-360<= 67) || y_pos-25-360== 55 || y_pos-25-360 ==60))  ||
                            ( x_pos-25-240==60 && ((y_pos-25-360>= 55  && y_pos-25-360<= 57) || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360== 66 ))) ||
                            ( x_pos-25-240==61 && ((y_pos-25-360>= 57 && y_pos-25-360<= 59) || (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25-240==62 && ( y_pos-25-360== 59 || y_pos-25-360 ==65))  ||
                            ( x_pos-25-240==63 && ((y_pos-25-360>= 59 && y_pos-25-360<= 60) || y_pos-25-360== 65 ))  ||
                            ( x_pos-25-240==64 && (y_pos-25-360>= 60 && y_pos-25-360<= 64) ) ;
    assign location_e_body = ( x_pos-25-240==15 && (y_pos-25-360> 25 && y_pos-25-360< 58)) ||
                            ( x_pos-25-240==16 && (y_pos-25-360> 20 && y_pos-25-360< 58)) ||
                            ( x_pos-25-240==17 && (y_pos-25-360> 17 && y_pos-25-360< 58)) ||
                            ( x_pos-25-240==18 && (y_pos-25-360> 13 && y_pos-25-360< 58)) ||
                            ( x_pos-25-240==19 && (y_pos-25-360> 11 && y_pos-25-360< 59)) ||
                            ( x_pos-25-240==20 && (y_pos-25-360> 9 && y_pos-25-360< 59)) ||
                            ( x_pos-25-240==21 && (y_pos-25-360> 8 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==22 && (y_pos-25-360> 7 && y_pos-25-360< 60)) ||
                            ( x_pos-25-240==23 && (y_pos-25-360> 6 && y_pos-25-360< 60)) ||
                            ( x_pos-25-240==24 && (y_pos-25-360> 5 && y_pos-25-360< 61)) ||
                            ( x_pos-25-240==25 && ((y_pos-25-360> 4 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 62))) ||
                            ( x_pos-25-240==26 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25-240==27 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 63))) ||
                            ( x_pos-25-240==28 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 64))) ||
                            ( x_pos-25-240==29 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 65))) ||
                            ( x_pos-25-240==30 && (y_pos-25-360> 1 && y_pos-25-360< 61)) ||
                            ( x_pos-25-240==31 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==32 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==33 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==34 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==35 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==36 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==37 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==38 && ((y_pos-25-360> 1 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 60))) ||
                            ( x_pos-25-240==39 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 60))) ||
                            ( x_pos-25-240==40 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 61))) ||
                            ( x_pos-25-240==41 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25-240==42 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 61))) ||
                            ( x_pos-25-240==43 && (y_pos-25-360> 2 && y_pos-25-360< 61))  ||
                            ( x_pos-25-240==44 && (y_pos-25-360> 3 && y_pos-25-360< 61))  ||
                            ( x_pos-25-240==45 && (y_pos-25-360> 3 && y_pos-25-360< 60)) ||
                            ( x_pos-25-240==46 && (y_pos-25-360> 4 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==47 && (y_pos-25-360> 5 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==48 && (y_pos-25-360> 6 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==49 && (y_pos-25-360> 7 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==50 && (y_pos-25-360> 8 && y_pos-25-360< 62))  ||
                            ( x_pos-25-240==51 && (y_pos-25-360> 9 && y_pos-25-360< 62))  ||
                            ( x_pos-25-240==52 && (y_pos-25-360> 10 && y_pos-25-360< 63))  ||
                            ( x_pos-25-240==53 && (y_pos-25-360> 12 && y_pos-25-360< 62))  ||
                            ( x_pos-25-240==54 && (y_pos-25-360> 14 && y_pos-25-360< 61))  ||
                            ( x_pos-25-240==55 && (y_pos-25-360> 17 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==56 && (y_pos-25-360> 20 && y_pos-25-360< 60))  ||
                            ( x_pos-25-240==57 && (y_pos-25-360> 24 && y_pos-25-360< 60))  ;
    assign location_e_stone = ( x_pos-25-240==11 && (y_pos-25-360> 58 && y_pos-25-360< 62)) ||
                            ( x_pos-25-240==12 && (y_pos-25-360> 57 && y_pos-25-360< 63)) ||
                            ( x_pos-25-240==13 && ((y_pos-25-360> 53 && y_pos-25-360< 57)||(y_pos-25-360> 57 && y_pos-25-360< 64))) ||
                            ( x_pos-25-240==14 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-240==15 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-240==16 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-240==17 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-240==18 && (y_pos-25-360> 58 && y_pos-25-360< 61)) ||
                            ( x_pos-25-240==19 && (y_pos-25-360> 61 && y_pos-25-360< 65)) ||
                            ( x_pos-25-240==20 && (y_pos-25-360> 60 && y_pos-25-360< 66)) ||
                            ( x_pos-25-240==21 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==22 && (y_pos-25-360> 60 && y_pos-25-360< 67)) ||
                            ( x_pos-25-240==23 && (y_pos-25-360> 61 && y_pos-25-360< 68)) ||
                            ( x_pos-25-240==24 && (y_pos-25-360> 62 && y_pos-25-360< 68)) ||
                            ( x_pos-25-240==25 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==26 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==27 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==28 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==29 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==30 && (y_pos-25-360> 62 && y_pos-25-360< 67)) ||
                            ( x_pos-25-240==31 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==32 && (y_pos-25-360> 60 && y_pos-25-360< 63))  ||
                            ( x_pos-25-240==33 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==34 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==35 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==36 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==37 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==38 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==39 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==40 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==41 && (y_pos-25-360> 64 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==42 && (y_pos-25-360> 62 && y_pos-25-360< 64)) ||
                            ( x_pos-25-240==43 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==44 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==45 && (y_pos-25-360> 61 && y_pos-25-360< 67)) ||
                            ( x_pos-25-240==46 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==47 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==48 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==49 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==50 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==51 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==53 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==54 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==55 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==56 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==57 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-240==58 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-240==59 && (y_pos-25-360> 55 && y_pos-25-360 !=60 && y_pos-25-360< 66))  ||
                            ( x_pos-25-240==60 && (y_pos-25-360> 57 && y_pos-25-360 !=60 && y_pos-25-360 !=59  &&y_pos-25-360< 66))  ||
                            ( x_pos-25-240==61 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25-240==62 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25-240==63 && (y_pos-25-360> 60 && y_pos-25-360< 65)) ;
    assign location_e_eyes = ( x_pos-25-240== 26 && (y_pos-25-360>= 20 && y_pos-25-360 <= 22) ) || ( x_pos-25-240== 39 && (y_pos-25-360 >= 20 && y_pos-25-360<= 22));
    
	assign location_a_line = ( x_pos-25-360==10 && y_pos-25>= 58 && y_pos-25<= 62) || 
                            ( x_pos-25-360==11 && ((y_pos-25>= 57 && y_pos-25<= 58) || (y_pos-25>= 62 && y_pos-25 <=63 ))) ||
                            ( x_pos-25-360==12 && ((y_pos-25>= 54 && y_pos-25<= 57) || (y_pos-25>= 63 && y_pos-25 <=64 ))) ||
                            ( x_pos-25-360==13 && (y_pos-25==53 || y_pos-25== 57 || y_pos-25 ==64 )) ||
                            ( x_pos-25-360==14 && ((y_pos-25>= 25 && y_pos-25<= 58) || y_pos-25== 64 )) ||
                            ( x_pos-25-360==15 && ((y_pos-25>= 20 && y_pos-25<= 25) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-360==16 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-360==17 && ((y_pos-25>= 13 && y_pos-25<= 17) || y_pos-25== 58 || y_pos-25 ==64)) ||
                            ( x_pos-25-360==18 && ((y_pos-25>= 11 && y_pos-25<= 13) || y_pos-25== 58 || (y_pos-25>= 61 && y_pos-25 <=65 ))) ||
                            ( x_pos-25-360==19 && ((y_pos-25>= 9  && y_pos-25<= 11) || (y_pos-25>= 59 && y_pos-25 <=61 )|| (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25-360==20 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25>= 66 && y_pos-25 <=67 ))) ||
                            ( x_pos-25-360==21 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 60 || y_pos-25 ==67))  ||
                            ( x_pos-25-360==22 && ((y_pos-25>= 6 && y_pos-25<= 7) || y_pos-25== 60 || (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-360==23 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=61 ))) ||
                            ( x_pos-25-360==24 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 68 || (y_pos-25>= 60 && y_pos-25 <=62 ))) ||
                            ( x_pos-25-360==25 && ((y_pos-25>= 3 && y_pos-25<= 4) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==26 && ( y_pos-25== 3 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==27 && ((y_pos-25>= 2 && y_pos-25<= 3) || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==28 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==29 && ((y_pos-25>= 1 && y_pos-25<= 2) || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==30 && ( y_pos-25== 1 || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-360==31 && ( y_pos-25== 1 || (y_pos-25>= 60 && y_pos-25 <=63 )|| y_pos-25 ==67))  ||
                            ( x_pos-25-360==32 && ( y_pos-25== 1 || (y_pos-25>= 63 && y_pos-25 <=67 )|| y_pos-25 ==60))  ||
                            ( x_pos-25-360==33 && ( y_pos-25== 1 || (y_pos-25>= 67 && y_pos-25 <=68 )|| y_pos-25 ==60))  ||
                            ( x_pos-25-360==34 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==35 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==36 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==37 && ( y_pos-25== 1 || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==38 && ( y_pos-25== 1 || (y_pos-25>= 20 && y_pos-25 <=25 )|| y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==39 && ( y_pos-25== 1 || y_pos-25== 19 || (y_pos-25>= 23 && y_pos-25 <=26 )|| (y_pos-25>= 60 && y_pos-25 <=61 ) || y_pos-25 ==68))  ||
                            ( x_pos-25-360==40 && ( y_pos-25== 1 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 61 && y_pos-25 <=63 ) || y_pos-25 ==68 ))  ||
                            ( x_pos-25-360==41 && ( y_pos-25== 2 || (y_pos-25>= 19 && y_pos-25 <=26 )|| (y_pos-25>= 62 && y_pos-25 <=64) || y_pos-25 ==68 ))  ||
                            ( x_pos-25-360==42 && ( y_pos-25== 2 || (y_pos-25>= 20 && y_pos-25 <=25 )|| (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25>= 64 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-360==43 && ( y_pos-25== 2 || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25-360==44 && ((y_pos-25>= 2 && y_pos-25<= 3) || y_pos-25== 61 || y_pos-25 ==67))  ||
                            ( x_pos-25-360==45 && ( y_pos-25== 3 || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-360==46 && ((y_pos-25>= 3 && y_pos-25<= 4) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==47 && ((y_pos-25>= 4 && y_pos-25<= 5) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==48 && ((y_pos-25>= 5 && y_pos-25<= 6) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==49 && ((y_pos-25>= 6 && y_pos-25<= 7) || (y_pos-25>= 60 && y_pos-25 <=62 ) || y_pos-25 ==68))  ||
                            ( x_pos-25-360==50 && ((y_pos-25>= 7 && y_pos-25<= 8) || y_pos-25== 62 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==51 && ((y_pos-25>= 8  && y_pos-25<= 9)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-360==52 && ((y_pos-25>= 9  && y_pos-25<= 10) || (y_pos-25>= 63 && y_pos-25 <=67 ))) ||
                            ( x_pos-25-360==53 && ((y_pos-25>= 10  && y_pos-25<= 12)  || (y_pos-25>= 62 && y_pos-25 <=63 )|| (y_pos-25>= 67 && y_pos-25 <=68 ))) ||
                            ( x_pos-25-360==54 && ((y_pos-25>= 12  && y_pos-25<= 14)  || (y_pos-25>= 61 && y_pos-25 <=62 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25-360==55 && ((y_pos-25>= 14  && y_pos-25<= 17)  || (y_pos-25>= 60 && y_pos-25 <=61 )|| (y_pos-25== 68 ))) ||
                            ( x_pos-25-360==56 && ((y_pos-25>= 17 && y_pos-25<= 20) || y_pos-25== 60 || y_pos-25 ==68))  ||
                            ( x_pos-25-360==57 && ((y_pos-25>= 20  && y_pos-25<= 24) || (y_pos-25>= 67 && y_pos-25 <=68 )|| (y_pos-25== 60 ))) ||
                            ( x_pos-25-360==58 && ((y_pos-25>= 24  && y_pos-25<= 60) || (y_pos-25== 67 ))) ||
                            ( x_pos-25-360==59 && ((y_pos-25>= 66 && y_pos-25<= 67) || y_pos-25== 55 || y_pos-25 ==60))  ||
                            ( x_pos-25-360==60 && ((y_pos-25>= 55  && y_pos-25<= 57) || (y_pos-25>= 59 && y_pos-25 <=60 )|| (y_pos-25== 66 ))) ||
                            ( x_pos-25-360==61 && ((y_pos-25>= 57 && y_pos-25<= 59) || (y_pos-25>= 65 && y_pos-25 <=66 ))) ||
                            ( x_pos-25-360==62 && ( y_pos-25== 59 || y_pos-25 ==65))  ||
                            ( x_pos-25-360==63 && ((y_pos-25>= 59 && y_pos-25<= 60) || y_pos-25== 65 ))  ||
                            ( x_pos-25-360==64 && (y_pos-25>= 60 && y_pos-25<= 64) ) ;
    assign location_a_body = ( x_pos-25-360==15 && (y_pos-25> 25 && y_pos-25< 58)) ||
                            ( x_pos-25-360==16 && (y_pos-25> 20 && y_pos-25< 58)) ||
                            ( x_pos-25-360==17 && (y_pos-25> 17 && y_pos-25< 58)) ||
                            ( x_pos-25-360==18 && (y_pos-25> 13 && y_pos-25< 58)) ||
                            ( x_pos-25-360==19 && (y_pos-25> 11 && y_pos-25< 59)) ||
                            ( x_pos-25-360==20 && (y_pos-25> 9 && y_pos-25< 59)) ||
                            ( x_pos-25-360==21 && (y_pos-25> 8 && y_pos-25< 60))  ||
                            ( x_pos-25-360==22 && (y_pos-25> 7 && y_pos-25< 60)) ||
                            ( x_pos-25-360==23 && (y_pos-25> 6 && y_pos-25< 60)) ||
                            ( x_pos-25-360==24 && (y_pos-25> 5 && y_pos-25< 61)) ||
                            ( x_pos-25-360==25 && ((y_pos-25> 4 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 62))) ||
                            ( x_pos-25-360==26 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25-360==27 && ((y_pos-25> 3 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 63))) ||
                            ( x_pos-25-360==28 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 64))) ||
                            ( x_pos-25-360==29 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 65))) ||
                            ( x_pos-25-360==30 && (y_pos-25> 1 && y_pos-25< 61)) ||
                            ( x_pos-25-360==31 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==32 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==33 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==34 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==35 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==36 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==37 && (y_pos-25> 1 && y_pos-25< 60))  ||
                            ( x_pos-25-360==38 && ((y_pos-25> 1 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 60))) ||
                            ( x_pos-25-360==39 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 60))) ||
                            ( x_pos-25-360==40 && ((y_pos-25> 1 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 61))) ||
                            ( x_pos-25-360==41 && ((y_pos-25> 2 && y_pos-25< 19)||(y_pos-25> 26 && y_pos-25< 62))) ||
                            ( x_pos-25-360==42 && ((y_pos-25> 2 && y_pos-25< 20)||(y_pos-25> 25 && y_pos-25< 61))) ||
                            ( x_pos-25-360==43 && (y_pos-25> 2 && y_pos-25< 61))  ||
                            ( x_pos-25-360==44 && (y_pos-25> 3 && y_pos-25< 61))  ||
                            ( x_pos-25-360==45 && (y_pos-25> 3 && y_pos-25< 60)) ||
                            ( x_pos-25-360==46 && (y_pos-25> 4 && y_pos-25< 60))  ||
                            ( x_pos-25-360==47 && (y_pos-25> 5 && y_pos-25< 60))  ||
                            ( x_pos-25-360==48 && (y_pos-25> 6 && y_pos-25< 60))  ||
                            ( x_pos-25-360==49 && (y_pos-25> 7 && y_pos-25< 60))  ||
                            ( x_pos-25-360==50 && (y_pos-25> 8 && y_pos-25< 62))  ||
                            ( x_pos-25-360==51 && (y_pos-25> 9 && y_pos-25< 62))  ||
                            ( x_pos-25-360==52 && (y_pos-25> 10 && y_pos-25< 63))  ||
                            ( x_pos-25-360==53 && (y_pos-25> 12 && y_pos-25< 62))  ||
                            ( x_pos-25-360==54 && (y_pos-25> 14 && y_pos-25< 61))  ||
                            ( x_pos-25-360==55 && (y_pos-25> 17 && y_pos-25< 60))  ||
                            ( x_pos-25-360==56 && (y_pos-25> 20 && y_pos-25< 60))  ||
                            ( x_pos-25-360==57 && (y_pos-25> 24 && y_pos-25< 60))  ;
    assign location_a_stone = ( x_pos-25-360==11 && (y_pos-25> 58 && y_pos-25< 62)) ||
                            ( x_pos-25-360==12 && (y_pos-25> 57 && y_pos-25< 63)) ||
                            ( x_pos-25-360==13 && ((y_pos-25> 53 && y_pos-25< 57)||(y_pos-25> 57 && y_pos-25< 64))) ||
                            ( x_pos-25-360==14 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-360==15 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-360==16 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-360==17 && (y_pos-25> 58 && y_pos-25< 64)) ||
                            ( x_pos-25-360==18 && (y_pos-25> 58 && y_pos-25< 61)) ||
                            ( x_pos-25-360==19 && (y_pos-25> 61 && y_pos-25< 65)) ||
                            ( x_pos-25-360==20 && (y_pos-25> 60 && y_pos-25< 66)) ||
                            ( x_pos-25-360==21 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-360==22 && (y_pos-25> 60 && y_pos-25< 67)) ||
                            ( x_pos-25-360==23 && (y_pos-25> 61 && y_pos-25< 68)) ||
                            ( x_pos-25-360==24 && (y_pos-25> 62 && y_pos-25< 68)) ||
                            ( x_pos-25-360==25 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==26 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==27 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==28 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==29 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==30 && (y_pos-25> 62 && y_pos-25< 67)) ||
                            ( x_pos-25-360==31 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25-360==32 && (y_pos-25> 60 && y_pos-25< 63))  ||
                            ( x_pos-25-360==33 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-360==34 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==35 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==36 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==37 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==38 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==39 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25-360==40 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25-360==41 && (y_pos-25> 64 && y_pos-25< 68))  ||
                            ( x_pos-25-360==42 && (y_pos-25> 62 && y_pos-25< 64)) ||
                            ( x_pos-25-360==43 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25-360==44 && (y_pos-25> 61 && y_pos-25< 67))  ||
                            ( x_pos-25-360==45 && (y_pos-25> 61 && y_pos-25< 67)) ||
                            ( x_pos-25-360==46 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==47 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==48 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==49 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==50 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==51 && (y_pos-25> 63 && y_pos-25< 68))  ||
                            ( x_pos-25-360==53 && (y_pos-25> 63 && y_pos-25< 67))  ||
                            ( x_pos-25-360==54 && (y_pos-25> 62 && y_pos-25< 68))  ||
                            ( x_pos-25-360==55 && (y_pos-25> 61 && y_pos-25< 68))  ||
                            ( x_pos-25-360==56 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==57 && (y_pos-25> 60 && y_pos-25< 68))  ||
                            ( x_pos-25-360==58 && (y_pos-25> 60 && y_pos-25< 67))  ||
                            ( x_pos-25-360==59 && (y_pos-25> 55 && y_pos-25 !=60 && y_pos-25< 66))  ||
                            ( x_pos-25-360==60 && (y_pos-25> 57 && y_pos-25 !=60 && y_pos-25 !=59  &&y_pos-25< 66))  ||
                            ( x_pos-25-360==61 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25-360==62 && (y_pos-25> 59 && y_pos-25< 65))  ||
                            ( x_pos-25-360==63 && (y_pos-25> 60 && y_pos-25< 65)) ;
    assign location_a_eyes = ( x_pos-25-360== 26 && (y_pos-25>= 20 && y_pos-25 <= 22) ) || ( x_pos-25-360== 39 && (y_pos-25 >= 20 && y_pos-25<= 22));


	assign location_b_line = ( x_pos-25-360==10 && y_pos-25-120>= 58 && y_pos-25-120<= 62) || 
                            ( x_pos-25-360==11 && ((y_pos-25-120>= 57 && y_pos-25-120<= 58) || (y_pos-25-120>= 62 && y_pos-25-120 <=63 ))) ||
                            ( x_pos-25-360==12 && ((y_pos-25-120>= 54 && y_pos-25-120<= 57) || (y_pos-25-120>= 63 && y_pos-25-120 <=64 ))) ||
                            ( x_pos-25-360==13 && (y_pos-25-120==53 || y_pos-25-120== 57 || y_pos-25-120 ==64 )) ||
                            ( x_pos-25-360==14 && ((y_pos-25-120>= 25 && y_pos-25-120<= 58) || y_pos-25-120== 64 )) ||
                            ( x_pos-25-360==15 && ((y_pos-25-120>= 20 && y_pos-25-120<= 25) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-360==16 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-360==17 && ((y_pos-25-120>= 13 && y_pos-25-120<= 17) || y_pos-25-120== 58 || y_pos-25-120 ==64)) ||
                            ( x_pos-25-360==18 && ((y_pos-25-120>= 11 && y_pos-25-120<= 13) || y_pos-25-120== 58 || (y_pos-25-120>= 61 && y_pos-25-120 <=65 ))) ||
                            ( x_pos-25-360==19 && ((y_pos-25-120>= 9  && y_pos-25-120<= 11) || (y_pos-25-120>= 59 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25-360==20 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120>= 66 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25-360==21 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 60 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-360==22 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || y_pos-25-120== 60 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-360==23 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 ))) ||
                            ( x_pos-25-360==24 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 68 || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ))) ||
                            ( x_pos-25-360==25 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==26 && ( y_pos-25-120== 3 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==27 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==28 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==29 && ((y_pos-25-120>= 1 && y_pos-25-120<= 2) || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==30 && ( y_pos-25-120== 1 || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-360==31 && ( y_pos-25-120== 1 || (y_pos-25-120>= 60 && y_pos-25-120 <=63 )|| y_pos-25-120 ==67))  ||
                            ( x_pos-25-360==32 && ( y_pos-25-120== 1 || (y_pos-25-120>= 63 && y_pos-25-120 <=67 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25-360==33 && ( y_pos-25-120== 1 || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| y_pos-25-120 ==60))  ||
                            ( x_pos-25-360==34 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==35 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==36 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==37 && ( y_pos-25-120== 1 || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==38 && ( y_pos-25-120== 1 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==39 && ( y_pos-25-120== 1 || y_pos-25-120== 19 || (y_pos-25-120>= 23 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 60 && y_pos-25-120 <=61 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==40 && ( y_pos-25-120== 1 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=63 ) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25-360==41 && ( y_pos-25-120== 2 || (y_pos-25-120>= 19 && y_pos-25-120 <=26 )|| (y_pos-25-120>= 62 && y_pos-25-120 <=64) || y_pos-25-120 ==68 ))  ||
                            ( x_pos-25-360==42 && ( y_pos-25-120== 2 || (y_pos-25-120>= 20 && y_pos-25-120 <=25 )|| (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120>= 64 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-360==43 && ( y_pos-25-120== 2 || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-360==44 && ((y_pos-25-120>= 2 && y_pos-25-120<= 3) || y_pos-25-120== 61 || y_pos-25-120 ==67))  ||
                            ( x_pos-25-360==45 && ( y_pos-25-120== 3 || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-360==46 && ((y_pos-25-120>= 3 && y_pos-25-120<= 4) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==47 && ((y_pos-25-120>= 4 && y_pos-25-120<= 5) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==48 && ((y_pos-25-120>= 5 && y_pos-25-120<= 6) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==49 && ((y_pos-25-120>= 6 && y_pos-25-120<= 7) || (y_pos-25-120>= 60 && y_pos-25-120 <=62 ) || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==50 && ((y_pos-25-120>= 7 && y_pos-25-120<= 8) || y_pos-25-120== 62 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==51 && ((y_pos-25-120>= 8  && y_pos-25-120<= 9)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-360==52 && ((y_pos-25-120>= 9  && y_pos-25-120<= 10) || (y_pos-25-120>= 63 && y_pos-25-120 <=67 ))) ||
                            ( x_pos-25-360==53 && ((y_pos-25-120>= 10  && y_pos-25-120<= 12)  || (y_pos-25-120>= 62 && y_pos-25-120 <=63 )|| (y_pos-25-120>= 67 && y_pos-25-120 <=68 ))) ||
                            ( x_pos-25-360==54 && ((y_pos-25-120>= 12  && y_pos-25-120<= 14)  || (y_pos-25-120>= 61 && y_pos-25-120 <=62 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25-360==55 && ((y_pos-25-120>= 14  && y_pos-25-120<= 17)  || (y_pos-25-120>= 60 && y_pos-25-120 <=61 )|| (y_pos-25-120== 68 ))) ||
                            ( x_pos-25-360==56 && ((y_pos-25-120>= 17 && y_pos-25-120<= 20) || y_pos-25-120== 60 || y_pos-25-120 ==68))  ||
                            ( x_pos-25-360==57 && ((y_pos-25-120>= 20  && y_pos-25-120<= 24) || (y_pos-25-120>= 67 && y_pos-25-120 <=68 )|| (y_pos-25-120== 60 ))) ||
                            ( x_pos-25-360==58 && ((y_pos-25-120>= 24  && y_pos-25-120<= 60) || (y_pos-25-120== 67 ))) ||
                            ( x_pos-25-360==59 && ((y_pos-25-120>= 66 && y_pos-25-120<= 67) || y_pos-25-120== 55 || y_pos-25-120 ==60))  ||
                            ( x_pos-25-360==60 && ((y_pos-25-120>= 55  && y_pos-25-120<= 57) || (y_pos-25-120>= 59 && y_pos-25-120 <=60 )|| (y_pos-25-120== 66 ))) ||
                            ( x_pos-25-360==61 && ((y_pos-25-120>= 57 && y_pos-25-120<= 59) || (y_pos-25-120>= 65 && y_pos-25-120 <=66 ))) ||
                            ( x_pos-25-360==62 && ( y_pos-25-120== 59 || y_pos-25-120 ==65))  ||
                            ( x_pos-25-360==63 && ((y_pos-25-120>= 59 && y_pos-25-120<= 60) || y_pos-25-120== 65 ))  ||
                            ( x_pos-25-360==64 && (y_pos-25-120>= 60 && y_pos-25-120<= 64) ) ;
    assign location_b_body = ( x_pos-25-360==15 && (y_pos-25-120> 25 && y_pos-25-120< 58)) ||
                            ( x_pos-25-360==16 && (y_pos-25-120> 20 && y_pos-25-120< 58)) ||
                            ( x_pos-25-360==17 && (y_pos-25-120> 17 && y_pos-25-120< 58)) ||
                            ( x_pos-25-360==18 && (y_pos-25-120> 13 && y_pos-25-120< 58)) ||
                            ( x_pos-25-360==19 && (y_pos-25-120> 11 && y_pos-25-120< 59)) ||
                            ( x_pos-25-360==20 && (y_pos-25-120> 9 && y_pos-25-120< 59)) ||
                            ( x_pos-25-360==21 && (y_pos-25-120> 8 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==22 && (y_pos-25-120> 7 && y_pos-25-120< 60)) ||
                            ( x_pos-25-360==23 && (y_pos-25-120> 6 && y_pos-25-120< 60)) ||
                            ( x_pos-25-360==24 && (y_pos-25-120> 5 && y_pos-25-120< 61)) ||
                            ( x_pos-25-360==25 && ((y_pos-25-120> 4 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 62))) ||
                            ( x_pos-25-360==26 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25-360==27 && ((y_pos-25-120> 3 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 63))) ||
                            ( x_pos-25-360==28 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 64))) ||
                            ( x_pos-25-360==29 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 65))) ||
                            ( x_pos-25-360==30 && (y_pos-25-120> 1 && y_pos-25-120< 61)) ||
                            ( x_pos-25-360==31 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==32 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==33 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==34 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==35 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==36 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==37 && (y_pos-25-120> 1 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==38 && ((y_pos-25-120> 1 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 60))) ||
                            ( x_pos-25-360==39 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 60))) ||
                            ( x_pos-25-360==40 && ((y_pos-25-120> 1 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 61))) ||
                            ( x_pos-25-360==41 && ((y_pos-25-120> 2 && y_pos-25-120< 19)||(y_pos-25-120> 26 && y_pos-25-120< 62))) ||
                            ( x_pos-25-360==42 && ((y_pos-25-120> 2 && y_pos-25-120< 20)||(y_pos-25-120> 25 && y_pos-25-120< 61))) ||
                            ( x_pos-25-360==43 && (y_pos-25-120> 2 && y_pos-25-120< 61))  ||
                            ( x_pos-25-360==44 && (y_pos-25-120> 3 && y_pos-25-120< 61))  ||
                            ( x_pos-25-360==45 && (y_pos-25-120> 3 && y_pos-25-120< 60)) ||
                            ( x_pos-25-360==46 && (y_pos-25-120> 4 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==47 && (y_pos-25-120> 5 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==48 && (y_pos-25-120> 6 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==49 && (y_pos-25-120> 7 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==50 && (y_pos-25-120> 8 && y_pos-25-120< 62))  ||
                            ( x_pos-25-360==51 && (y_pos-25-120> 9 && y_pos-25-120< 62))  ||
                            ( x_pos-25-360==52 && (y_pos-25-120> 10 && y_pos-25-120< 63))  ||
                            ( x_pos-25-360==53 && (y_pos-25-120> 12 && y_pos-25-120< 62))  ||
                            ( x_pos-25-360==54 && (y_pos-25-120> 14 && y_pos-25-120< 61))  ||
                            ( x_pos-25-360==55 && (y_pos-25-120> 17 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==56 && (y_pos-25-120> 20 && y_pos-25-120< 60))  ||
                            ( x_pos-25-360==57 && (y_pos-25-120> 24 && y_pos-25-120< 60))  ;
    assign location_b_stone = ( x_pos-25-360==11 && (y_pos-25-120> 58 && y_pos-25-120< 62)) ||
                            ( x_pos-25-360==12 && (y_pos-25-120> 57 && y_pos-25-120< 63)) ||
                            ( x_pos-25-360==13 && ((y_pos-25-120> 53 && y_pos-25-120< 57)||(y_pos-25-120> 57 && y_pos-25-120< 64))) ||
                            ( x_pos-25-360==14 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-360==15 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-360==16 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-360==17 && (y_pos-25-120> 58 && y_pos-25-120< 64)) ||
                            ( x_pos-25-360==18 && (y_pos-25-120> 58 && y_pos-25-120< 61)) ||
                            ( x_pos-25-360==19 && (y_pos-25-120> 61 && y_pos-25-120< 65)) ||
                            ( x_pos-25-360==20 && (y_pos-25-120> 60 && y_pos-25-120< 66)) ||
                            ( x_pos-25-360==21 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==22 && (y_pos-25-120> 60 && y_pos-25-120< 67)) ||
                            ( x_pos-25-360==23 && (y_pos-25-120> 61 && y_pos-25-120< 68)) ||
                            ( x_pos-25-360==24 && (y_pos-25-120> 62 && y_pos-25-120< 68)) ||
                            ( x_pos-25-360==25 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==26 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==27 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==28 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==29 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==30 && (y_pos-25-120> 62 && y_pos-25-120< 67)) ||
                            ( x_pos-25-360==31 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==32 && (y_pos-25-120> 60 && y_pos-25-120< 63))  ||
                            ( x_pos-25-360==33 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==34 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==35 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==36 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==37 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==38 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==39 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==40 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==41 && (y_pos-25-120> 64 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==42 && (y_pos-25-120> 62 && y_pos-25-120< 64)) ||
                            ( x_pos-25-360==43 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==44 && (y_pos-25-120> 61 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==45 && (y_pos-25-120> 61 && y_pos-25-120< 67)) ||
                            ( x_pos-25-360==46 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==47 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==48 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==49 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==50 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==51 && (y_pos-25-120> 63 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==53 && (y_pos-25-120> 63 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==54 && (y_pos-25-120> 62 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==55 && (y_pos-25-120> 61 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==56 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==57 && (y_pos-25-120> 60 && y_pos-25-120< 68))  ||
                            ( x_pos-25-360==58 && (y_pos-25-120> 60 && y_pos-25-120< 67))  ||
                            ( x_pos-25-360==59 && (y_pos-25-120> 55 && y_pos-25-120 !=60 && y_pos-25-120< 66))  ||
                            ( x_pos-25-360==60 && (y_pos-25-120> 57 && y_pos-25-120 !=60 && y_pos-25-120 !=59  &&y_pos-25-120< 66))  ||
                            ( x_pos-25-360==61 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25-360==62 && (y_pos-25-120> 59 && y_pos-25-120< 65))  ||
                            ( x_pos-25-360==63 && (y_pos-25-120> 60 && y_pos-25-120< 65)) ;
    assign location_b_eyes = ( x_pos-25-360== 26 && (y_pos-25-120>= 20 && y_pos-25-120 <= 22) ) || ( x_pos-25-360== 39 && (y_pos-25-120 >= 20 && y_pos-25-120<= 22));


	assign location_c_line = ( x_pos-25-360==10 && y_pos-25-240>= 58 && y_pos-25-240<= 62) || 
                            ( x_pos-25-360==11 && ((y_pos-25-240>= 57 && y_pos-25-240<= 58) || (y_pos-25-240>= 62 && y_pos-25-240 <=63 ))) ||
                            ( x_pos-25-360==12 && ((y_pos-25-240>= 54 && y_pos-25-240<= 57) || (y_pos-25-240>= 63 && y_pos-25-240 <=64 ))) ||
                            ( x_pos-25-360==13 && (y_pos-25-240==53 || y_pos-25-240== 57 || y_pos-25-240 ==64 )) ||
                            ( x_pos-25-360==14 && ((y_pos-25-240>= 25 && y_pos-25-240<= 58) || y_pos-25-240== 64 )) ||
                            ( x_pos-25-360==15 && ((y_pos-25-240>= 20 && y_pos-25-240<= 25) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-360==16 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-360==17 && ((y_pos-25-240>= 13 && y_pos-25-240<= 17) || y_pos-25-240== 58 || y_pos-25-240 ==64)) ||
                            ( x_pos-25-360==18 && ((y_pos-25-240>= 11 && y_pos-25-240<= 13) || y_pos-25-240== 58 || (y_pos-25-240>= 61 && y_pos-25-240 <=65 ))) ||
                            ( x_pos-25-360==19 && ((y_pos-25-240>= 9  && y_pos-25-240<= 11) || (y_pos-25-240>= 59 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25-360==20 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240>= 66 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25-360==21 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 60 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-360==22 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || y_pos-25-240== 60 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-360==23 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 ))) ||
                            ( x_pos-25-360==24 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 68 || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ))) ||
                            ( x_pos-25-360==25 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==26 && ( y_pos-25-240== 3 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==27 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==28 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==29 && ((y_pos-25-240>= 1 && y_pos-25-240<= 2) || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==30 && ( y_pos-25-240== 1 || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-360==31 && ( y_pos-25-240== 1 || (y_pos-25-240>= 60 && y_pos-25-240 <=63 )|| y_pos-25-240 ==67))  ||
                            ( x_pos-25-360==32 && ( y_pos-25-240== 1 || (y_pos-25-240>= 63 && y_pos-25-240 <=67 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25-360==33 && ( y_pos-25-240== 1 || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| y_pos-25-240 ==60))  ||
                            ( x_pos-25-360==34 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==35 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==36 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==37 && ( y_pos-25-240== 1 || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==38 && ( y_pos-25-240== 1 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==39 && ( y_pos-25-240== 1 || y_pos-25-240== 19 || (y_pos-25-240>= 23 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 60 && y_pos-25-240 <=61 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==40 && ( y_pos-25-240== 1 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=63 ) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25-360==41 && ( y_pos-25-240== 2 || (y_pos-25-240>= 19 && y_pos-25-240 <=26 )|| (y_pos-25-240>= 62 && y_pos-25-240 <=64) || y_pos-25-240 ==68 ))  ||
                            ( x_pos-25-360==42 && ( y_pos-25-240== 2 || (y_pos-25-240>= 20 && y_pos-25-240 <=25 )|| (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240>= 64 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-360==43 && ( y_pos-25-240== 2 || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-360==44 && ((y_pos-25-240>= 2 && y_pos-25-240<= 3) || y_pos-25-240== 61 || y_pos-25-240 ==67))  ||
                            ( x_pos-25-360==45 && ( y_pos-25-240== 3 || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-360==46 && ((y_pos-25-240>= 3 && y_pos-25-240<= 4) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==47 && ((y_pos-25-240>= 4 && y_pos-25-240<= 5) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==48 && ((y_pos-25-240>= 5 && y_pos-25-240<= 6) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==49 && ((y_pos-25-240>= 6 && y_pos-25-240<= 7) || (y_pos-25-240>= 60 && y_pos-25-240 <=62 ) || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==50 && ((y_pos-25-240>= 7 && y_pos-25-240<= 8) || y_pos-25-240== 62 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==51 && ((y_pos-25-240>= 8  && y_pos-25-240<= 9)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-360==52 && ((y_pos-25-240>= 9  && y_pos-25-240<= 10) || (y_pos-25-240>= 63 && y_pos-25-240 <=67 ))) ||
                            ( x_pos-25-360==53 && ((y_pos-25-240>= 10  && y_pos-25-240<= 12)  || (y_pos-25-240>= 62 && y_pos-25-240 <=63 )|| (y_pos-25-240>= 67 && y_pos-25-240 <=68 ))) ||
                            ( x_pos-25-360==54 && ((y_pos-25-240>= 12  && y_pos-25-240<= 14)  || (y_pos-25-240>= 61 && y_pos-25-240 <=62 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25-360==55 && ((y_pos-25-240>= 14  && y_pos-25-240<= 17)  || (y_pos-25-240>= 60 && y_pos-25-240 <=61 )|| (y_pos-25-240== 68 ))) ||
                            ( x_pos-25-360==56 && ((y_pos-25-240>= 17 && y_pos-25-240<= 20) || y_pos-25-240== 60 || y_pos-25-240 ==68))  ||
                            ( x_pos-25-360==57 && ((y_pos-25-240>= 20  && y_pos-25-240<= 24) || (y_pos-25-240>= 67 && y_pos-25-240 <=68 )|| (y_pos-25-240== 60 ))) ||
                            ( x_pos-25-360==58 && ((y_pos-25-240>= 24  && y_pos-25-240<= 60) || (y_pos-25-240== 67 ))) ||
                            ( x_pos-25-360==59 && ((y_pos-25-240>= 66 && y_pos-25-240<= 67) || y_pos-25-240== 55 || y_pos-25-240 ==60))  ||
                            ( x_pos-25-360==60 && ((y_pos-25-240>= 55  && y_pos-25-240<= 57) || (y_pos-25-240>= 59 && y_pos-25-240 <=60 )|| (y_pos-25-240== 66 ))) ||
                            ( x_pos-25-360==61 && ((y_pos-25-240>= 57 && y_pos-25-240<= 59) || (y_pos-25-240>= 65 && y_pos-25-240 <=66 ))) ||
                            ( x_pos-25-360==62 && ( y_pos-25-240== 59 || y_pos-25-240 ==65))  ||
                            ( x_pos-25-360==63 && ((y_pos-25-240>= 59 && y_pos-25-240<= 60) || y_pos-25-240== 65 ))  ||
                            ( x_pos-25-360==64 && (y_pos-25-240>= 60 && y_pos-25-240<= 64) ) ;
    assign location_c_body = ( x_pos-25-360==15 && (y_pos-25-240> 25 && y_pos-25-240< 58)) ||
                            ( x_pos-25-360==16 && (y_pos-25-240> 20 && y_pos-25-240< 58)) ||
                            ( x_pos-25-360==17 && (y_pos-25-240> 17 && y_pos-25-240< 58)) ||
                            ( x_pos-25-360==18 && (y_pos-25-240> 13 && y_pos-25-240< 58)) ||
                            ( x_pos-25-360==19 && (y_pos-25-240> 11 && y_pos-25-240< 59)) ||
                            ( x_pos-25-360==20 && (y_pos-25-240> 9 && y_pos-25-240< 59)) ||
                            ( x_pos-25-360==21 && (y_pos-25-240> 8 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==22 && (y_pos-25-240> 7 && y_pos-25-240< 60)) ||
                            ( x_pos-25-360==23 && (y_pos-25-240> 6 && y_pos-25-240< 60)) ||
                            ( x_pos-25-360==24 && (y_pos-25-240> 5 && y_pos-25-240< 61)) ||
                            ( x_pos-25-360==25 && ((y_pos-25-240> 4 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 62))) ||
                            ( x_pos-25-360==26 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25-360==27 && ((y_pos-25-240> 3 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 63))) ||
                            ( x_pos-25-360==28 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 64))) ||
                            ( x_pos-25-360==29 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 65))) ||
                            ( x_pos-25-360==30 && (y_pos-25-240> 1 && y_pos-25-240< 61)) ||
                            ( x_pos-25-360==31 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==32 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==33 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==34 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==35 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==36 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==37 && (y_pos-25-240> 1 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==38 && ((y_pos-25-240> 1 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 60))) ||
                            ( x_pos-25-360==39 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 60))) ||
                            ( x_pos-25-360==40 && ((y_pos-25-240> 1 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 61))) ||
                            ( x_pos-25-360==41 && ((y_pos-25-240> 2 && y_pos-25-240< 19)||(y_pos-25-240> 26 && y_pos-25-240< 62))) ||
                            ( x_pos-25-360==42 && ((y_pos-25-240> 2 && y_pos-25-240< 20)||(y_pos-25-240> 25 && y_pos-25-240< 61))) ||
                            ( x_pos-25-360==43 && (y_pos-25-240> 2 && y_pos-25-240< 61))  ||
                            ( x_pos-25-360==44 && (y_pos-25-240> 3 && y_pos-25-240< 61))  ||
                            ( x_pos-25-360==45 && (y_pos-25-240> 3 && y_pos-25-240< 60)) ||
                            ( x_pos-25-360==46 && (y_pos-25-240> 4 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==47 && (y_pos-25-240> 5 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==48 && (y_pos-25-240> 6 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==49 && (y_pos-25-240> 7 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==50 && (y_pos-25-240> 8 && y_pos-25-240< 62))  ||
                            ( x_pos-25-360==51 && (y_pos-25-240> 9 && y_pos-25-240< 62))  ||
                            ( x_pos-25-360==52 && (y_pos-25-240> 10 && y_pos-25-240< 63))  ||
                            ( x_pos-25-360==53 && (y_pos-25-240> 12 && y_pos-25-240< 62))  ||
                            ( x_pos-25-360==54 && (y_pos-25-240> 14 && y_pos-25-240< 61))  ||
                            ( x_pos-25-360==55 && (y_pos-25-240> 17 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==56 && (y_pos-25-240> 20 && y_pos-25-240< 60))  ||
                            ( x_pos-25-360==57 && (y_pos-25-240> 24 && y_pos-25-240< 60))  ;
    assign location_c_stone = ( x_pos-25-360==11 && (y_pos-25-240> 58 && y_pos-25-240< 62)) ||
                            ( x_pos-25-360==12 && (y_pos-25-240> 57 && y_pos-25-240< 63)) ||
                            ( x_pos-25-360==13 && ((y_pos-25-240> 53 && y_pos-25-240< 57)||(y_pos-25-240> 57 && y_pos-25-240< 64))) ||
                            ( x_pos-25-360==14 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-360==15 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-360==16 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-360==17 && (y_pos-25-240> 58 && y_pos-25-240< 64)) ||
                            ( x_pos-25-360==18 && (y_pos-25-240> 58 && y_pos-25-240< 61)) ||
                            ( x_pos-25-360==19 && (y_pos-25-240> 61 && y_pos-25-240< 65)) ||
                            ( x_pos-25-360==20 && (y_pos-25-240> 60 && y_pos-25-240< 66)) ||
                            ( x_pos-25-360==21 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==22 && (y_pos-25-240> 60 && y_pos-25-240< 67)) ||
                            ( x_pos-25-360==23 && (y_pos-25-240> 61 && y_pos-25-240< 68)) ||
                            ( x_pos-25-360==24 && (y_pos-25-240> 62 && y_pos-25-240< 68)) ||
                            ( x_pos-25-360==25 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==26 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==27 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==28 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==29 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==30 && (y_pos-25-240> 62 && y_pos-25-240< 67)) ||
                            ( x_pos-25-360==31 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==32 && (y_pos-25-240> 60 && y_pos-25-240< 63))  ||
                            ( x_pos-25-360==33 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==34 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==35 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==36 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==37 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==38 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==39 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==40 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==41 && (y_pos-25-240> 64 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==42 && (y_pos-25-240> 62 && y_pos-25-240< 64)) ||
                            ( x_pos-25-360==43 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==44 && (y_pos-25-240> 61 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==45 && (y_pos-25-240> 61 && y_pos-25-240< 67)) ||
                            ( x_pos-25-360==46 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==47 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==48 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==49 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==50 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==51 && (y_pos-25-240> 63 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==53 && (y_pos-25-240> 63 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==54 && (y_pos-25-240> 62 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==55 && (y_pos-25-240> 61 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==56 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==57 && (y_pos-25-240> 60 && y_pos-25-240< 68))  ||
                            ( x_pos-25-360==58 && (y_pos-25-240> 60 && y_pos-25-240< 67))  ||
                            ( x_pos-25-360==59 && (y_pos-25-240> 55 && y_pos-25-240 !=60 && y_pos-25-240< 66))  ||
                            ( x_pos-25-360==60 && (y_pos-25-240> 57 && y_pos-25-240 !=60 && y_pos-25-240 !=59  &&y_pos-25-240< 66))  ||
                            ( x_pos-25-360==61 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25-360==62 && (y_pos-25-240> 59 && y_pos-25-240< 65))  ||
                            ( x_pos-25-360==63 && (y_pos-25-240> 60 && y_pos-25-240< 65)) ;
    assign location_c_eyes = ( x_pos-25-360== 26 && (y_pos-25-240>= 20 && y_pos-25-240 <= 22) ) || ( x_pos-25-360== 39 && (y_pos-25-240 >= 20 && y_pos-25-240<= 22));


	assign location_d_line = ( x_pos-25-360==10 && y_pos-25-360>= 58 && y_pos-25-360<= 62) || 
                            ( x_pos-25-360==11 && ((y_pos-25-360>= 57 && y_pos-25-360<= 58) || (y_pos-25-360>= 62 && y_pos-25-360 <=63 ))) ||
                            ( x_pos-25-360==12 && ((y_pos-25-360>= 54 && y_pos-25-360<= 57) || (y_pos-25-360>= 63 && y_pos-25-360 <=64 ))) ||
                            ( x_pos-25-360==13 && (y_pos-25-360==53 || y_pos-25-360== 57 || y_pos-25-360 ==64 )) ||
                            ( x_pos-25-360==14 && ((y_pos-25-360>= 25 && y_pos-25-360<= 58) || y_pos-25-360== 64 )) ||
                            ( x_pos-25-360==15 && ((y_pos-25-360>= 20 && y_pos-25-360<= 25) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-360==16 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-360==17 && ((y_pos-25-360>= 13 && y_pos-25-360<= 17) || y_pos-25-360== 58 || y_pos-25-360 ==64)) ||
                            ( x_pos-25-360==18 && ((y_pos-25-360>= 11 && y_pos-25-360<= 13) || y_pos-25-360== 58 || (y_pos-25-360>= 61 && y_pos-25-360 <=65 ))) ||
                            ( x_pos-25-360==19 && ((y_pos-25-360>= 9  && y_pos-25-360<= 11) || (y_pos-25-360>= 59 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25-360==20 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360>= 66 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25-360==21 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 60 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-360==22 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || y_pos-25-360== 60 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-360==23 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 ))) ||
                            ( x_pos-25-360==24 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 68 || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ))) ||
                            ( x_pos-25-360==25 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==26 && ( y_pos-25-360== 3 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==27 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==28 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==29 && ((y_pos-25-360>= 1 && y_pos-25-360<= 2) || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==30 && ( y_pos-25-360== 1 || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-360==31 && ( y_pos-25-360== 1 || (y_pos-25-360>= 60 && y_pos-25-360 <=63 )|| y_pos-25-360 ==67))  ||
                            ( x_pos-25-360==32 && ( y_pos-25-360== 1 || (y_pos-25-360>= 63 && y_pos-25-360 <=67 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25-360==33 && ( y_pos-25-360== 1 || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| y_pos-25-360 ==60))  ||
                            ( x_pos-25-360==34 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==35 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==36 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==37 && ( y_pos-25-360== 1 || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==38 && ( y_pos-25-360== 1 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==39 && ( y_pos-25-360== 1 || y_pos-25-360== 19 || (y_pos-25-360>= 23 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 60 && y_pos-25-360 <=61 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==40 && ( y_pos-25-360== 1 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=63 ) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25-360==41 && ( y_pos-25-360== 2 || (y_pos-25-360>= 19 && y_pos-25-360 <=26 )|| (y_pos-25-360>= 62 && y_pos-25-360 <=64) || y_pos-25-360 ==68 ))  ||
                            ( x_pos-25-360==42 && ( y_pos-25-360== 2 || (y_pos-25-360>= 20 && y_pos-25-360 <=25 )|| (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360>= 64 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-360==43 && ( y_pos-25-360== 2 || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-360==44 && ((y_pos-25-360>= 2 && y_pos-25-360<= 3) || y_pos-25-360== 61 || y_pos-25-360 ==67))  ||
                            ( x_pos-25-360==45 && ( y_pos-25-360== 3 || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-360==46 && ((y_pos-25-360>= 3 && y_pos-25-360<= 4) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==47 && ((y_pos-25-360>= 4 && y_pos-25-360<= 5) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==48 && ((y_pos-25-360>= 5 && y_pos-25-360<= 6) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==49 && ((y_pos-25-360>= 6 && y_pos-25-360<= 7) || (y_pos-25-360>= 60 && y_pos-25-360 <=62 ) || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==50 && ((y_pos-25-360>= 7 && y_pos-25-360<= 8) || y_pos-25-360== 62 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==51 && ((y_pos-25-360>= 8  && y_pos-25-360<= 9)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-360==52 && ((y_pos-25-360>= 9  && y_pos-25-360<= 10) || (y_pos-25-360>= 63 && y_pos-25-360 <=67 ))) ||
                            ( x_pos-25-360==53 && ((y_pos-25-360>= 10  && y_pos-25-360<= 12)  || (y_pos-25-360>= 62 && y_pos-25-360 <=63 )|| (y_pos-25-360>= 67 && y_pos-25-360 <=68 ))) ||
                            ( x_pos-25-360==54 && ((y_pos-25-360>= 12  && y_pos-25-360<= 14)  || (y_pos-25-360>= 61 && y_pos-25-360 <=62 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25-360==55 && ((y_pos-25-360>= 14  && y_pos-25-360<= 17)  || (y_pos-25-360>= 60 && y_pos-25-360 <=61 )|| (y_pos-25-360== 68 ))) ||
                            ( x_pos-25-360==56 && ((y_pos-25-360>= 17 && y_pos-25-360<= 20) || y_pos-25-360== 60 || y_pos-25-360 ==68))  ||
                            ( x_pos-25-360==57 && ((y_pos-25-360>= 20  && y_pos-25-360<= 24) || (y_pos-25-360>= 67 && y_pos-25-360 <=68 )|| (y_pos-25-360== 60 ))) ||
                            ( x_pos-25-360==58 && ((y_pos-25-360>= 24  && y_pos-25-360<= 60) || (y_pos-25-360== 67 ))) ||
                            ( x_pos-25-360==59 && ((y_pos-25-360>= 66 && y_pos-25-360<= 67) || y_pos-25-360== 55 || y_pos-25-360 ==60))  ||
                            ( x_pos-25-360==60 && ((y_pos-25-360>= 55  && y_pos-25-360<= 57) || (y_pos-25-360>= 59 && y_pos-25-360 <=60 )|| (y_pos-25-360== 66 ))) ||
                            ( x_pos-25-360==61 && ((y_pos-25-360>= 57 && y_pos-25-360<= 59) || (y_pos-25-360>= 65 && y_pos-25-360 <=66 ))) ||
                            ( x_pos-25-360==62 && ( y_pos-25-360== 59 || y_pos-25-360 ==65))  ||
                            ( x_pos-25-360==63 && ((y_pos-25-360>= 59 && y_pos-25-360<= 60) || y_pos-25-360== 65 ))  ||
                            ( x_pos-25-360==64 && (y_pos-25-360>= 60 && y_pos-25-360<= 64) ) ;
    assign location_d_body = ( x_pos-25-360==15 && (y_pos-25-360> 25 && y_pos-25-360< 58)) ||
                            ( x_pos-25-360==16 && (y_pos-25-360> 20 && y_pos-25-360< 58)) ||
                            ( x_pos-25-360==17 && (y_pos-25-360> 17 && y_pos-25-360< 58)) ||
                            ( x_pos-25-360==18 && (y_pos-25-360> 13 && y_pos-25-360< 58)) ||
                            ( x_pos-25-360==19 && (y_pos-25-360> 11 && y_pos-25-360< 59)) ||
                            ( x_pos-25-360==20 && (y_pos-25-360> 9 && y_pos-25-360< 59)) ||
                            ( x_pos-25-360==21 && (y_pos-25-360> 8 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==22 && (y_pos-25-360> 7 && y_pos-25-360< 60)) ||
                            ( x_pos-25-360==23 && (y_pos-25-360> 6 && y_pos-25-360< 60)) ||
                            ( x_pos-25-360==24 && (y_pos-25-360> 5 && y_pos-25-360< 61)) ||
                            ( x_pos-25-360==25 && ((y_pos-25-360> 4 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 62))) ||
                            ( x_pos-25-360==26 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25-360==27 && ((y_pos-25-360> 3 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 63))) ||
                            ( x_pos-25-360==28 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 64))) ||
                            ( x_pos-25-360==29 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 65))) ||
                            ( x_pos-25-360==30 && (y_pos-25-360> 1 && y_pos-25-360< 61)) ||
                            ( x_pos-25-360==31 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==32 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==33 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==34 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==35 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==36 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==37 && (y_pos-25-360> 1 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==38 && ((y_pos-25-360> 1 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 60))) ||
                            ( x_pos-25-360==39 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 60))) ||
                            ( x_pos-25-360==40 && ((y_pos-25-360> 1 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 61))) ||
                            ( x_pos-25-360==41 && ((y_pos-25-360> 2 && y_pos-25-360< 19)||(y_pos-25-360> 26 && y_pos-25-360< 62))) ||
                            ( x_pos-25-360==42 && ((y_pos-25-360> 2 && y_pos-25-360< 20)||(y_pos-25-360> 25 && y_pos-25-360< 61))) ||
                            ( x_pos-25-360==43 && (y_pos-25-360> 2 && y_pos-25-360< 61))  ||
                            ( x_pos-25-360==44 && (y_pos-25-360> 3 && y_pos-25-360< 61))  ||
                            ( x_pos-25-360==45 && (y_pos-25-360> 3 && y_pos-25-360< 60)) ||
                            ( x_pos-25-360==46 && (y_pos-25-360> 4 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==47 && (y_pos-25-360> 5 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==48 && (y_pos-25-360> 6 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==49 && (y_pos-25-360> 7 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==50 && (y_pos-25-360> 8 && y_pos-25-360< 62))  ||
                            ( x_pos-25-360==51 && (y_pos-25-360> 9 && y_pos-25-360< 62))  ||
                            ( x_pos-25-360==52 && (y_pos-25-360> 10 && y_pos-25-360< 63))  ||
                            ( x_pos-25-360==53 && (y_pos-25-360> 12 && y_pos-25-360< 62))  ||
                            ( x_pos-25-360==54 && (y_pos-25-360> 14 && y_pos-25-360< 61))  ||
                            ( x_pos-25-360==55 && (y_pos-25-360> 17 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==56 && (y_pos-25-360> 20 && y_pos-25-360< 60))  ||
                            ( x_pos-25-360==57 && (y_pos-25-360> 24 && y_pos-25-360< 60))  ;
    assign location_d_stone = ( x_pos-25-360==11 && (y_pos-25-360> 58 && y_pos-25-360< 62)) ||
                            ( x_pos-25-360==12 && (y_pos-25-360> 57 && y_pos-25-360< 63)) ||
                            ( x_pos-25-360==13 && ((y_pos-25-360> 53 && y_pos-25-360< 57)||(y_pos-25-360> 57 && y_pos-25-360< 64))) ||
                            ( x_pos-25-360==14 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-360==15 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-360==16 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-360==17 && (y_pos-25-360> 58 && y_pos-25-360< 64)) ||
                            ( x_pos-25-360==18 && (y_pos-25-360> 58 && y_pos-25-360< 61)) ||
                            ( x_pos-25-360==19 && (y_pos-25-360> 61 && y_pos-25-360< 65)) ||
                            ( x_pos-25-360==20 && (y_pos-25-360> 60 && y_pos-25-360< 66)) ||
                            ( x_pos-25-360==21 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==22 && (y_pos-25-360> 60 && y_pos-25-360< 67)) ||
                            ( x_pos-25-360==23 && (y_pos-25-360> 61 && y_pos-25-360< 68)) ||
                            ( x_pos-25-360==24 && (y_pos-25-360> 62 && y_pos-25-360< 68)) ||
                            ( x_pos-25-360==25 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==26 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==27 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==28 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==29 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==30 && (y_pos-25-360> 62 && y_pos-25-360< 67)) ||
                            ( x_pos-25-360==31 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==32 && (y_pos-25-360> 60 && y_pos-25-360< 63))  ||
                            ( x_pos-25-360==33 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==34 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==35 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==36 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==37 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==38 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==39 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==40 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==41 && (y_pos-25-360> 64 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==42 && (y_pos-25-360> 62 && y_pos-25-360< 64)) ||
                            ( x_pos-25-360==43 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==44 && (y_pos-25-360> 61 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==45 && (y_pos-25-360> 61 && y_pos-25-360< 67)) ||
                            ( x_pos-25-360==46 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==47 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==48 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==49 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==50 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==51 && (y_pos-25-360> 63 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==53 && (y_pos-25-360> 63 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==54 && (y_pos-25-360> 62 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==55 && (y_pos-25-360> 61 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==56 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==57 && (y_pos-25-360> 60 && y_pos-25-360< 68))  ||
                            ( x_pos-25-360==58 && (y_pos-25-360> 60 && y_pos-25-360< 67))  ||
                            ( x_pos-25-360==59 && (y_pos-25-360> 55 && y_pos-25-360 !=60 && y_pos-25-360< 66))  ||
                            ( x_pos-25-360==60 && (y_pos-25-360> 57 && y_pos-25-360 !=60 && y_pos-25-360 !=59  &&y_pos-25-360< 66))  ||
                            ( x_pos-25-360==61 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25-360==62 && (y_pos-25-360> 59 && y_pos-25-360< 65))  ||
                            ( x_pos-25-360==63 && (y_pos-25-360> 60 && y_pos-25-360< 65)) ;
    assign location_d_eyes = ( x_pos-25-360== 26 && (y_pos-25-360>= 20 && y_pos-25-360 <= 22) ) || ( x_pos-25-360== 39 && (y_pos-25-360 >= 20 && y_pos-25-360<= 22));

    assign location_time = (( x_pos-467>= 17 && x_pos-467<= 24 && y_pos-120>= 5 && y_pos-120<= 12) || 
                            ( x_pos-467>= 25 && x_pos-467<= 32 && y_pos-120>= 5 && y_pos-120<= 44) ||
                            ( x_pos-467>= 33 && x_pos-467<= 40 && y_pos-120>= 5 && y_pos-120<= 12) ||
                            
                            ( x_pos-465>= 49 && x_pos-465<= 52 && ((y_pos-120>= 5 && y_pos-120<= 12)||(y_pos-120>= 37 && y_pos-120<= 44))) ||
                            ( x_pos-465>= 53 && x_pos-465<= 60 && y_pos-120>= 5 && y_pos-120<= 44) ||
                            ( x_pos-465>= 61 && x_pos-465<= 64 && ((y_pos-120>= 5 && y_pos-120<= 12)||(y_pos-120>= 37 && y_pos-120<= 44))) ||
                            
                            ( x_pos-463>= 73 && x_pos-463<= 80 && y_pos-120>= 5 && y_pos-120<= 44) ||
                            ( x_pos-463>= 81 && x_pos-463<= 84 && y_pos-120>= 9 && y_pos-120<= 24) ||
                            ( x_pos-463>= 85 && x_pos-463<= 88 && y_pos-120>= 13 && y_pos-120<= 28) ||
                            ( x_pos-463>= 89 && x_pos-463<= 92 && y_pos-120>= 17 && y_pos-120<= 32) ||
                            ( x_pos-463>= 93 && x_pos-463<= 96 && y_pos-120>= 13 && y_pos-120<= 28) ||
                            ( x_pos-463>= 97 && x_pos-463<= 100 && y_pos-120>= 9 && y_pos-120<= 24) ||
                            ( x_pos-463>= 101 && x_pos-463<= 108 && y_pos-120>= 5 && y_pos-120<= 44) ||
                            
                            ( x_pos-461>= 117 && x_pos-461<= 124 && y_pos-120>= 5 && y_pos-120<= 44) ||
                            ( x_pos-461>= 125 && x_pos-461<= 136 && ((y_pos-120>= 5 && y_pos-120<= 12)||(y_pos-120>= 21 && y_pos-120<= 28)||(y_pos-120>= 37 && y_pos-120<= 44))) ||
                            ( x_pos-461>= 137 && x_pos-461<= 140 && ((y_pos-120>= 5 && y_pos-120<= 12)||(y_pos-120>= 37 && y_pos-120<= 44))) )  ;
 
    assign location_score = (( x_pos-480 >= 4 && x_pos-480 <= 9 && ((y_pos-290>= 1 && y_pos-290<= 24)||(y_pos-290>= 33 && y_pos-290<= 40))) ||
                            ( x_pos-480 >= 10 && x_pos-480 <= 15 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 17 && y_pos-290<= 24)||(y_pos-290>= 33 && y_pos-290<= 40))) ||
                            ( x_pos-480 >= 16 && x_pos-480 <= 21 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 17 && y_pos-290<= 40))) ||
                            
                            ( x_pos-481 >= 28 && x_pos-481 <= 33 && y_pos-290>= 1 && y_pos-290<= 40) ||
                            ( x_pos-481 >= 34 && x_pos-481 <= 39 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 33 && y_pos-290<= 40))) ||
                            ( x_pos-481 >= 40 && x_pos-481 <= 45 && ((y_pos-290>= 1 && y_pos-290<= 12)||(y_pos-290>= 25 && y_pos-290<= 40))) ||
                            
                            ( x_pos-482 >= 52 && x_pos-482 <= 57 && y_pos-290>= 1 && y_pos-290<= 40) ||
                            ( x_pos-482 >= 58 && x_pos-482 <= 63 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 33 && y_pos-290<= 40))) ||
                            ( x_pos-482 >= 64 && x_pos-482 <= 69 && y_pos-290>= 1 && y_pos-290<= 40) ||
                            
                            ( x_pos-483 >= 76 && x_pos-483 <= 81 && y_pos-290>= 1 && y_pos-290<= 40) ||
                            ( x_pos-483 >= 82 && x_pos-483 <= 84 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 21 && y_pos-290<= 32))) ||
                            ( x_pos-483 >= 85 && x_pos-483 <= 87 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 21 && y_pos-290<= 36))) ||
                            ( x_pos-483 >= 88 && x_pos-483 <= 90 && ((y_pos-290>= 1 && y_pos-290<= 24)||(y_pos-290>= 29 && y_pos-290<= 40))) ||
                            ( x_pos-483 >= 91 && x_pos-483 <= 93 && ((y_pos-290>= 1 && y_pos-290<= 24)||(y_pos-290>= 33 && y_pos-290<= 40))) ||
                            
                            ( x_pos-484 >= 100 && x_pos-484 <= 105 && y_pos-290>= 1 && y_pos-290<= 40) ||
                            ( x_pos-484 >= 106 && x_pos-484 <= 114 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 17 && y_pos-290<= 24)||(y_pos-290>= 33 && y_pos-290<= 40))) ||
                            ( x_pos-484 >= 115 && x_pos-484 <= 117 && ((y_pos-290>= 1 && y_pos-290<= 8)||(y_pos-290>= 33 && y_pos-290<= 40))) )  ;
                            
                            
    assign Time_ten_0 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_ten_1 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 190>= 41 && y_pos - 190<= 50) ;          
    assign Time_ten_2 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 21 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && ((y_pos - 190 >=1 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ;                                   
    assign Time_ten_3 = ( x_pos - 510 >= 1 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 &&  y_pos - 190>= 1 && y_pos - 190<= 50)  ; 
    assign Time_ten_4 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 190>= 1 && y_pos - 190<= 30) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && y_pos - 190>= 21 && y_pos - 190<= 30) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_ten_5 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 21 && y_pos - 190 <= 50))) ;                                   
    assign Time_ten_6 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 21 && y_pos - 190 <= 50))) ;                                   
    assign Time_ten_7 = ( x_pos - 510 >=1 && x_pos - 510 <=20 && y_pos - 190>= 1 && y_pos - 190<= 10) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_ten_8 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_ten_9 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ; 
    
    assign Time_unit_0 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_unit_1 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 190>= 41 && y_pos - 190<= 50) ;          
    assign Time_unit_2 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 21 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && ((y_pos - 190 >=1 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ;                                   
    assign Time_unit_3 = ( x_pos - 550 >= 1 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 &&  y_pos - 190>= 1 && y_pos - 190<= 50)  ; 
    assign Time_unit_4 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 190>= 1 && y_pos - 190<= 30) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && y_pos - 190>= 21 && y_pos - 190<= 30) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_unit_5 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 21 && y_pos - 190 <= 50))) ;                                   
    assign Time_unit_6 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >= 21 && y_pos - 190 <= 50))) ;                                   
    assign Time_unit_7 = ( x_pos - 550 >=1 && x_pos - 550 <=20 && y_pos - 190>= 1 && y_pos - 190<= 10) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_unit_8 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 190>= 1 && y_pos - 190<= 50) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ;  
    assign Time_unit_9 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 190 >=1 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 190 >=1 && y_pos - 190 <=10)||(y_pos - 190 >=21 && y_pos - 190 <=30)||(y_pos - 190 >= 41 && y_pos - 190 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 190>= 1 && y_pos - 190<= 50) ; 
                                     
    assign Score_ten_0 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_ten_1 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 360>= 41 && y_pos - 360<= 50) ;          
    assign Score_ten_2 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 21 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && ((y_pos - 360 >=1 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ;                                   
    assign Score_ten_3 = ( x_pos - 510 >= 1 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 &&  y_pos - 360>= 1 && y_pos - 360<= 50)  ; 
    assign Score_ten_4 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 360>= 1 && y_pos - 360<= 30) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && y_pos - 360>= 21 && y_pos - 360<= 30) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_ten_5 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 21 && y_pos - 360 <= 50))) ;                                   
    assign Score_ten_6 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 21 && y_pos - 360 <= 50))) ;                                   
    assign Score_ten_7 = ( x_pos - 510 >=1 && x_pos - 510 <=20 && y_pos - 360>= 1 && y_pos - 360<= 10) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_ten_8 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_ten_9 = ( x_pos - 510 >=1 && x_pos - 510 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 11 && x_pos - 510 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 510 >= 21 && x_pos - 510 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ; 
    
    assign Score_unit_0 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_unit_1 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 360>= 41 && y_pos - 360<= 50) ;          
    assign Score_unit_2 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 21 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && ((y_pos - 360 >=1 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ;                                   
    assign Score_unit_3 = ( x_pos - 550 >= 1 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 &&  y_pos - 360>= 1 && y_pos - 360<= 50)  ; 
    assign Score_unit_4 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 360>= 1 && y_pos - 360<= 30) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && y_pos - 360>= 21 && y_pos - 360<= 30) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_unit_5 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 21 && y_pos - 360 <= 50))) ;                                   
    assign Score_unit_6 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >= 21 && y_pos - 360 <= 50))) ;                                   
    assign Score_unit_7 = ( x_pos - 550 >=1 && x_pos - 550 <=20 && y_pos - 360>= 1 && y_pos - 360<= 10) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_unit_8 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && y_pos - 360>= 1 && y_pos - 360<= 50) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ;  
    assign Score_unit_9 = ( x_pos - 550 >=1 && x_pos - 550 <=10 && ((y_pos - 360 >=1 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 11 && x_pos - 550 <= 20 && ((y_pos - 360 >=1 && y_pos - 360 <=10)||(y_pos - 360 >=21 && y_pos - 360 <=30)||(y_pos - 360 >= 41 && y_pos - 360 <= 50))) ||
                        ( x_pos - 550 >= 21 && x_pos - 550 <= 30 && y_pos - 360>= 1 && y_pos - 360<= 50) ; 
                                     
                       
                        
    
  
endmodule
