`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 14:20:44
// Design Name: 
// Module Name: BCD
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
module BCD(
    input Clk,
    input [7:0] binary,
    output reg [3:0] Hundreds,
    output reg [3:0] Tens,
    output reg [3:0] Ones);
    always @ (posedge Clk)
    begin
        case (binary)
            8'd0:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd0; end
            8'd1:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd1; end
            8'd2:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd2; end
            8'd3:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd3; end
            8'd4:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd4; end
            8'd5:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd5; end
            8'd6:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd6; end
            8'd7:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd7; end
            8'd8:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd8; end
            8'd9:   begin  Hundreds <= 4'd0;  Tens <= 4'd0;  Ones <= 4'd9; end
            
            8'd10:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd0; end
            8'd11:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd1; end
            8'd12:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd2; end
            8'd13:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd3; end
            8'd14:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd4; end
            8'd15:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd5; end
            8'd16:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd6; end
            8'd17:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd7; end
            8'd18:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd8; end
            8'd19:   begin  Hundreds <= 4'd0;  Tens <= 4'd1;  Ones <= 4'd9; end
            
            8'd20:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd0; end
            8'd21:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd1; end
            8'd22:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd2; end
            8'd23:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd3; end
            8'd24:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd4; end
            8'd25:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd5; end
            8'd26:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd6; end
            8'd27:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd7; end
            8'd28:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd8; end
            8'd29:   begin  Hundreds <= 4'd0;  Tens <= 4'd2;  Ones <= 4'd9; end
            
            8'd30:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd0; end
            8'd31:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd1; end
            8'd32:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd2; end
            8'd33:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd3; end
            8'd34:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd4; end
            8'd35:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd5; end
            8'd36:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd6; end
            8'd37:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd7; end
            8'd38:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd8; end
            8'd39:   begin  Hundreds <= 4'd0;  Tens <= 4'd3;  Ones <= 4'd9; end
            
            8'd40:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd0; end
            8'd41:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd1; end
            8'd42:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd2; end
            8'd43:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd3; end
            8'd44:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd4; end
            8'd45:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd5; end
            8'd46:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd6; end
            8'd47:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd7; end
            8'd48:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd8; end
            8'd49:   begin  Hundreds <= 4'd0;  Tens <= 4'd4;  Ones <= 4'd9; end
            
            8'd50:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd0; end
            8'd51:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd1; end 
            8'd52:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd2; end 
            8'd53:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd3; end 
            8'd54:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd4; end 
            8'd55:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd5; end 
            8'd56:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd6; end 
            8'd57:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd7; end 
            8'd58:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd8; end 
            8'd59:   begin  Hundreds <= 4'd0;  Tens <= 4'd5;  Ones <= 4'd9; end 
            
            8'd60:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd0; end 
            8'd61:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd1; end 
            8'd62:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd2; end 
            8'd63:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd3; end 
            8'd64:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd4; end 
            8'd65:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd5; end 
            8'd66:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd6; end 
            8'd67:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd7; end 
            8'd68:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd8; end 
            8'd69:   begin  Hundreds <= 4'd0;  Tens <= 4'd6;  Ones <= 4'd9; end 
                              
            8'd70:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd0; end 
            8'd71:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd1; end 
            8'd72:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd2; end 
            8'd73:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd3; end 
            8'd74:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd4; end 
            8'd75:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd5; end 
            8'd76:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd6; end 
            8'd77:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd7; end 
            8'd78:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd8; end 
            8'd79:   begin  Hundreds <= 4'd0;  Tens <= 4'd7;  Ones <= 4'd9; end 
            
            8'd80:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd0; end 
            8'd81:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd1; end 
            8'd82:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd2; end 
            8'd83:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd3; end 
            8'd84:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd4; end 
            8'd85:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd5; end 
            8'd86:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd6; end 
            8'd87:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd7; end 
            8'd88:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd8; end 
            8'd89:   begin  Hundreds <= 4'd0;  Tens <= 4'd8;  Ones <= 4'd9; end 
            
            8'd90:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd0; end 
            8'd91:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd1; end 
            8'd92:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd2; end 
            8'd93:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd3; end 
            8'd94:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd4; end 
            8'd95:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd5; end 
            8'd96:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd6; end 
            8'd97:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd7; end 
            8'd98:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd8; end 
            8'd99:   begin  Hundreds <= 4'd0;  Tens <= 4'd9;  Ones <= 4'd9; end 
            
            default: begin  Hundreds <= 4'd15;  Tens <= 4'd15;  Ones <= 4'd15; end
        endcase
    end
    
endmodule
    