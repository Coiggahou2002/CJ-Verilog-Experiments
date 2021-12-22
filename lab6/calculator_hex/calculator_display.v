module calculator_display (
    input  wire        clk   , // 10MHz
	input  wire        rst   ,
	input  wire        button,
	input  wire [31:0] cal_result,
	output reg [7:0]   led_en,
	output reg         led_ca,
	output reg         led_cb,
    output reg         led_cc,
	output reg         led_cd,
	output reg         led_ce,
	output reg         led_cf,
	output reg         led_cg,
	output reg         led_dp 
);

wire rst_n = ~rst;

parameter ENABLED = 1'b1;
parameter OFF = 1'b0;
reg status = OFF;

parameter ALL_TUBES_OFF = 8'b1111_1111;
reg [7:0] tube_en_status = ALL_TUBES_OFF;

/**
 * display signals of hex characters
 */
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


// Counter for 5 clk periods (For Simulation)
//parameter SLICE_PERIOD = 21'd40;
//parameter DIG_0_TRIG = 21'd40;
//parameter DIG_1_TRIG = 21'd5;
//parameter DIG_2_TRIG = 21'd10;
//parameter DIG_3_TRIG = 21'd15;
//parameter DIG_4_TRIG = 21'd20;
//parameter DIG_5_TRIG = 21'd25;
//parameter DIG_6_TRIG = 21'd30;
//parameter DIG_7_TRIG = 21'd35;

// Counter for 2ms (For Real Device)
 parameter SLICE_PERIOD = 21'd160000;
 parameter DIG_0_TRIG = 21'd160000;
 parameter DIG_1_TRIG = 21'd20000;
 parameter DIG_2_TRIG = 21'd40000;
 parameter DIG_3_TRIG = 21'd60000;
 parameter DIG_4_TRIG = 21'd80000;
 parameter DIG_5_TRIG = 21'd100000;
 parameter DIG_6_TRIG = 21'd120000;
 parameter DIG_7_TRIG = 21'd140000;

/**
 * Counts to control led signal switching
 */
reg [20:0] slice_cnt;
wire slice_cnt_inc = (slice_cnt != SLICE_PERIOD && status == ENABLED);
wire slice_cnt_end = (slice_cnt == SLICE_PERIOD);
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) slice_cnt <= 21'b0;
	else if (slice_cnt_end) slice_cnt <= 21'b0;
	else if (slice_cnt_inc) slice_cnt <= slice_cnt + 21'b1;
end


// translation from 4 width binary to hex
reg [6:0] binary2hex [15:0];

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		led_dp = 1;
		status = OFF;
		led_en = ALL_TUBES_OFF;
		binary2hex[4'b0000] = NUMBER_0;
		binary2hex[4'b0001] = NUMBER_1;
		binary2hex[4'b0010] = NUMBER_2;
		binary2hex[4'b0011] = NUMBER_3;
		binary2hex[4'b0100] = NUMBER_4;
		binary2hex[4'b0101] = NUMBER_5;
		binary2hex[4'b0110] = NUMBER_6;
		binary2hex[4'b0111] = NUMBER_7;
		binary2hex[4'b1000] = NUMBER_8;
		binary2hex[4'b1001] = NUMBER_9;
		binary2hex[4'b1010] = CHAR_A;
		binary2hex[4'b1011] = CHAR_B;
		binary2hex[4'b1100] = CHAR_C;
		binary2hex[4'b1101] = CHAR_D;
		binary2hex[4'b1110] = CHAR_E;
		binary2hex[4'b1111] = CHAR_F;
	end
	else if (status == OFF) begin
		led_ca = 1;
		led_cb = 1;
		led_cc = 1;
		led_cd = 1;
		led_ce = 1;
		led_cf = 1;
		led_cg = 1;
		if (button) begin
			status = ENABLED;
			tube_en_status = 8'b1111_1110;
		end
	end
	else if (status == ENABLED) begin
		case (slice_cnt)
			DIG_0_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[3:0]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_1_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[7:4]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_2_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[11:8]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_3_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[15:12]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_4_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[19:16]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_5_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[23:20]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_6_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[27:24]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_7_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = binary2hex[cal_result[31:28]];
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
		endcase
	end
end


endmodule