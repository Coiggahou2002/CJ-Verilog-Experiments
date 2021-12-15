module calculator_display (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       cal_result,
	output wire [7:0] led_en,
	output wire       led_ca,
	output wire       led_cb,
    output wire       led_cc,
	output wire       led_cd,
	output wire       led_ce,
	output wire       led_cf,
	output wire       led_cg,
	output wire       led_dp 
);

// hex characters for digital led
parameter NUMBER_0 = 7'b0000001;
parameter NUMBER_1 = 7'b1001111;
parameter NUMBER_2 = 7'b0010010;
parameter NUMBER_3 = 7'b0000110;
parameter NUMBER_4 = 7'b1001100;
parameter NUMBER_5 = 7'b0100100;
parameter NUMBER_6 = 7'b0100000;
parameter NUMBER_7 = 7'b0001111;
parameter NUMBER_8 = 7'b0000000;
parameter NUMBER_9 = 7'b0001100;
parameter CHAR_A = 7'b0001000;
parameter CHAR_B = 7'b1100000;
parameter CHAR_C = 7'b1110010;
parameter CHAR_D = 7'b1000010;
parameter CHAR_E = 7'b0110000;
parameter CHAR_F = 7'b0111000;




endmodule