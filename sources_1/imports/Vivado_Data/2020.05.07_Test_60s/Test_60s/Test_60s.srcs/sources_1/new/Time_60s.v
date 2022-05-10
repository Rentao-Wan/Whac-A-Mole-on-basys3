`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 11:57:40
// Design Name: 
// Module Name: Time_60s
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



module Time_60s(
    input Clk,
    input Rst,
    input Start_60s,
    input no_score,
    output Finish_60s,
    output [5:0] Time
    );
    
reg [32:0] count_1Hz = 0;
reg [5:0] count_60s;

reg Clk_1Hz = 0;
reg Gaming = 0;
reg Finish = 1;

parameter Full_time = 6'd60;
parameter Zero_time = 6'd0;
parameter Count_Fenpin = 32'd49_999_999;//d49_999_999; 49 for test

always @ (posedge Clk)  // ��Ƶ����1Hz�ź�Clk_1Hz
begin
    if (count_1Hz == Count_Fenpin)
        begin
        count_1Hz <= 32'd0;
        Clk_1Hz <= ~Clk_1Hz;
        end
    else
        begin
        count_1Hz <= count_1Hz + 1;
        Clk_1Hz <= Clk_1Hz;
        end
end

always @ (posedge Clk)  // ����start��ť����������ź�Start_60s��������Ϸ״̬Gaming=1
begin
    if (Rst)            // ��λ������ʱֹͣ
        Gaming <= 1'b0;    
    else if (Start_60s)     // ��ʼ����������ʱֹͣ
        Gaming <= 1'b1;
    else if (count_60s == Zero_time)    // �������60s������ʱֹͣ
        Gaming <= 1'b0;
    else if (no_score)              // ��������������ʱֹͣ
        Gaming <= 1'b0;
    else
        Gaming <= Gaming;
end

always @ (posedge Clk)   //�Ƿ���ɵ���ʱ
begin
    if (count_60s == Full_time)
        Finish <= 1;
    else if(count_60s != Full_time)
        Finish <= 0;
    else
        Finish <= Finish;
end

always @ (posedge Clk_1Hz)  //��Ϸ״̬�£�����ʱ
begin
    if (Rst)
        count_60s <= Zero_time;
    else if (Gaming == 1'b1 & count_60s > Zero_time)
        count_60s <= count_60s - 1;
    else 
        count_60s <= Full_time;
end

assign Time = count_60s;
assign Finish_60s = Finish;

endmodule
