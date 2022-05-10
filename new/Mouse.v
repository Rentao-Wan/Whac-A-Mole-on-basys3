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


module Mouse(
    input clk,
    input rst,
    input start,
    input [3:0] key_num,
    input [1:0] game_state,
    output add_1,
    output add_2,
    output reduce_2,
    output flag_add1,
    output flag_add2,
    output flag_reduce2,
    output enable_add1,
    output enable_add2,
    output enable_reduce2,
    output [3:0] mouse_add1_location,
    output [3:0] mouse_add2_location,
    output [3:0] mouse_reduce2_location
    );
    // enable flag location��Ҫ���������vga��ʾ��enable�û���ı����״̬��flag����̽ͷ��location����λ��
    
    reg [3:0] random_location;
    initial random_location <= 4'b0110;
    wire [7:0] random_number_8bit;
    LFSR_random R1(
        .rst_n(rst),    /*rst_n is necessary to prevet locking up*/
        .clk(clk),      /*clock signal*/
        .load(start),     /*load seed to rand_num,active high */
        .seed(8'b10011100),     
        .rand_num(random_number_8bit)
        );
    always @ (posedge clk)          // ʱ�̸��µ����λ��
    begin
        random_location <= random_number_8bit[3:0];
    end
    
    reg [3:0] key_num_lock_1, key_num_lock_2;        // ������һ�ΰ���
    wire key_num_change_flag;        //�жϰ����Ƿ�ı�
    always @ (posedge clk)
    begin
        key_num_lock_1 <= key_num;
        key_num_lock_2 <= key_num_lock_1;
    end
    assign key_num_change_flag = (key_num_lock_2 == key_num_lock_1)? 0:1; //�����źţ��źű仯�������ӳ�1clk��������һ˲�䲻��ȣ�ʹ��s?a:b��s=0����ʱ������1
    //F = (A) ? I1 : I0;
     
    parameter RESTART = 2'b00;
    parameter START = 2'b01;
    parameter PLAY = 2'b10;
    parameter DIE = 2'b11;
    reg [31:0] count;
    parameter t_a1 = 32'd050_000_000;    //d000_000_001
    parameter t_a2 = 32'd070_000_000;    //d299_999_999
    parameter t_r2 = 32'd109_999_999;    //d399_999_999
    parameter t_stop_a1 = 32'd149_999_999;    //d299_999_999
    parameter t_stop_a2 = 32'd129_999_999;    //d099_999_999
    parameter t_stop_r2 = 32'd059_999_999;    //d199_999_999
    parameter time_all = 32'd199_999_999;   //d299_999_999; 29 for simulation
    
    wire [25:0] random_time_for_a1;
    wire [25:0] random_time_for_a2;
    wire [25:0] random_time_for_r2;
    assign random_time_for_a1 = {random_number_8bit,18'b00_0000_0000_0000_0000};
    assign random_time_for_a2 = {random_number_8bit,17'b0_0000_0000_0000_0000};
    assign random_time_for_r2 = {random_number_8bit,17'b0_0000_0000_0000_0000};

    // ��ʵʱ����������ڹ̶�ʱ���������������ʱ��
    reg [31:0] time_a1;                           
    reg [31:0] time_a2;
    reg [31:0] time_r2;
    reg [31:0] time_stop_a1;
    reg [31:0] time_stop_a2;
    reg [31:0] time_stop_r2;
    
    reg [3:0] mouse_a1_location;
    reg [3:0] mouse_a2_location;
    reg [3:0] mouse_r2_location;
    reg flag_a1;
    reg flag_a2;
    reg flag_r2;
    reg enable_a1;
    reg enable_a2;
    reg enable_r2;
    reg add_score1;
    reg add_score2;
    reg reduce_score2;
    reg [2:0] random_location_from_key;  // ����˲���������ֵ��ʹ�õ���λ�õĲ���˳��ͬ
    
    initial
    begin
        add_score1 <= 0;
        add_score2 <= 0;
        reduce_score2 <= 0;
        count <= 0;
        mouse_a1_location <= 0;
        mouse_a2_location <= 0;
        mouse_r2_location <= 0;
        flag_a1 <= 0;
        flag_a2 <= 0;
        flag_r2 <= 0;
        enable_a1 <= 0;
        enable_a2 <= 0;
        enable_r2 <= 0;
        random_location_from_key <= 0;    
    end
    
    wire [3:0] li; //ʱ�̸��µĳ�ʼλ�ã���Ҫ�ж��Ƿ�����֪λ�ô���
    wire [3:0] li_1;
    wire [3:0] li_2;
    wire [3:0] li_3;
    wire [3:0] li_4;
    //li ���� location_initial �����µ�ַ���ܺ;ɵ����������ַ�Լ���һ������ַ�ظ���������Ҫ׼������µĵ�ַ���ֱ���li��li_1��li_2��li_3��li_4
    assign li = random_location + random_location_from_key;
    assign li_1 = li + 1;
    assign li_2 = li + 2;
    assign li_3 = li + 3;
    assign li_4 = li + 4;
    wire [3:0] final_location; // ������µĵ�ַ���������µ�ַ
    assign final_location = (li==key_num || li==mouse_a1_location || li==mouse_a2_location || li==mouse_r2_location) ? ((li_1==key_num || li_1==mouse_a1_location || li_1==mouse_a2_location || li_1==mouse_r2_location)?((li_2==key_num || li_2==mouse_a1_location || li_2==mouse_a2_location || li_2==mouse_r2_location)?((li_3==key_num || li_3==mouse_a1_location || li_3==mouse_a2_location || li_3==mouse_r2_location)?li_4:li_3):li_2):li_1):li; 
    wire test_location;
    assign test_location = key_num == mouse_a1_location || key_num == mouse_a2_location || key_num == mouse_r2_location || mouse_a1_location == mouse_a2_location || mouse_a1_location == mouse_r2_location || mouse_a2_location == mouse_r2_location;
    
    always @ (posedge clk)
        begin
        if (rst)
            begin
            add_score1 <= 0;
            add_score2 <= 0;
            reduce_score2 <= 0;
            count <= 0;
            mouse_a1_location <= 0;
            mouse_a2_location <= 0;
            mouse_r2_location <= 0;
            flag_a1 <= 0;
            flag_a2 <= 0;
            flag_r2 <= 0;
            enable_a1 <= 0;
            enable_a2 <= 0;
            enable_r2 <= 0;
            random_location_from_key <= 0;
            end
        else
            begin
            if (game_state == PLAY)     //��֤������Ϸ״̬
                begin
                if (count == 0)     // ����a1���ֵ����ʱ�̣��Լ����ʱ��
                    begin
                    time_a1 <= t_a1 - random_time_for_a1;
                    time_stop_a1 <= t_stop_a1 +  random_time_for_a1;
                    end
                if (count == 10)   // ����a2���ֵ����ʱ�̣��Լ����ʱ��
                    begin   
                    time_a2 <= t_a2 - random_time_for_a2;
                    time_stop_a2 <= t_stop_a2 +  random_time_for_a2;
                    end
                if (count == time_all[31:1] )   // ����r2���ֵ����ʱ�̣��Լ����ʱ��
                    begin
                    time_r2 <= t_r2 + random_time_for_r2;
                    time_stop_r2 <= t_stop_r2 - random_time_for_r2;
                    end
                if (count == time_a1)     //ÿ��һ��ʱ���������a1λ��
                    begin
                    //��֤����λ������һ����λ�ò�ͬ
                    mouse_a1_location <= final_location;
                    flag_a1 <= 1;   //a1�����ڿ�ʼ
                    enable_a1 <= 1;     //����a1δ�����
                    end
//                else   // ��ͬif else�ж�ͬһ�����޸ģ���Ҫ��֤����ͬʱ�޸�
//                    begin   
//                    mouse_a1_location <= mouse_a1_location;
//                    flag_a1 <= flag_a1;
//                    enable_a1 <= enable_a1;
//                    end

                if (count == time_a2)     //ÿ��һ��ʱ���������a2λ��
                    begin
                    //��֤����λ������һ����λ�ò�ͬ
                    mouse_a2_location <= final_location;
                    flag_a2 <= 1;   //a1�����ڿ�ʼ
                    enable_a2 <= 1;     //����a1δ�����
                    end
                if (count == time_r2)     //ÿ��һ��ʱ���������a2λ��
                    begin
                    //��֤����λ������һ����λ�ò�ͬ
                    mouse_r2_location <= final_location; 
                    flag_r2 <= 1;   //a1�����ڿ�ʼ
                    enable_r2 <= 1;     //����a1δ�����
                    end
                                        
                if (count == time_all)   //һ��ʱ�����
                    begin
                    count <= 0;
                    end
                else 
                    begin
                    count <= count + 1;
//                    flag_a1 <= flag_a1;
//                    flag_a2 <= flag_a2;
//                    flag_r2 <= flag_r2; 
                    end
                if (count == time_stop_a1)  
                    begin
                    flag_a1 <= 0;       //a1�����ڽ���
                    enable_a1 <= 0;
                    end
                if (count == time_stop_a2)  
                    begin
                    flag_a2 <= 0;       //a2�����ڽ���
                    enable_a2 <= 0;
                    end
                if (count == time_stop_r2)    
                    begin
                    flag_r2 <= 0;       //r2�����ڽ���
                    enable_r2 <= 0;    
                    end
                if (key_num_change_flag)        //���°������ж��Ƿ�����������
                    begin
                        // ����ֵ��a1λ��ֵ��ȣ��ҵ�һ�α����£�ʹ�ܴ��ڣ����Ҵ��ڴ���ʱ����
                        add_score1 <= ((enable_a1 == 1) && (flag_a1 == 1) && (key_num == mouse_a1_location)) ? 1'b1:1'b0;
                        // ����ֵ��a1λ��ֵ��ȣ��Ҵ��ڴ���ʱ���ڣ��жϰ���һ�Σ�ʹ��ʵЧ
                        enable_a1 <= ((enable_a1 == 1) && (flag_a1 == 1) && (key_num == mouse_a1_location))? 1'b0:enable_a1;
                        
                        // ����ֵ��a2λ��ֵ��ȣ��ҵ�һ�α����£�ʹ�ܴ��ڣ����Ҵ��ڴ���ʱ����
                        add_score2 <= ((enable_a2 == 1) && (flag_a2 == 1) && (key_num == mouse_a2_location)) ? 1'b1:1'b0;
                        // ����ֵ��a2λ��ֵ��ȣ��Ҵ��ڴ���ʱ���ڣ��жϰ���һ�Σ�ʹ��ʵЧ
                        enable_a2 <= ((enable_a2 == 1) && (flag_a2 == 1) && (key_num == mouse_a2_location))? 1'b0:enable_a2;  
                                              
                        // ����ֵ��r2λ��ֵ��ȣ��ҵ�һ�α����£�ʹ�ܴ��ڣ����Ҵ��ڴ���ʱ����
                        reduce_score2 <= ((enable_r2 == 1) && (flag_r2 == 1) && (key_num == mouse_r2_location)) ? 1'b1:1'b0;
                        // ����ֵ��r2λ��ֵ��ȣ��Ҵ��ڴ���ʱ���ڣ��жϰ���һ�Σ�ʹ��ʵЧ
                        enable_r2 <= ((enable_r2 == 1) && (flag_r2 == 1) && (key_num == mouse_r2_location))? 1'b0:enable_r2;                        
                        
                        random_location_from_key <= random_number_8bit[5:3]; 
                    end
                else
                    begin
                        add_score1 <= 0;      //�����ź�
                        add_score2 <= 0;      //�����ź�
                        reduce_score2 <= 0;      //�����ź�
//                        enable_a1 <=  enable_a1;
                    end
                end
            else        //����Ϸ״̬
                begin
                count <= 0;
                flag_a1 <= 0;
                flag_a2 <= 0;
                flag_r2 <= 0;
                enable_a1 <= 0;
                enable_a2 <= 0;
                enable_r2 <= 0;
                end
            end
        end
 
 
    assign add_1 = add_score1; //�����ź�
    assign add_2 = add_score2; //�����ź�
    assign reduce_2 = reduce_score2; //�����ź�
    assign flag_add1 = flag_a1;
    assign flag_add2 = flag_a2;
    assign flag_reduce2 = flag_r2;
    assign enable_add1 = enable_a1;
    assign enable_add2 = enable_a2;
    assign enable_reduce2 = enable_r2;
    assign mouse_add1_location = mouse_a1_location;
    assign mouse_add2_location = mouse_a2_location;
    assign mouse_reduce2_location = mouse_r2_location;
    
endmodule
