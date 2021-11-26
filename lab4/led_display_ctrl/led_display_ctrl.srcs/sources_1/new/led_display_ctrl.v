module led_display_ctrl (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led_en,
	output reg        led_ca,
	output reg        led_cb,
    output reg        led_cc,
	output reg        led_cd,
	output reg        led_ce,
	output reg        led_cf,
	output reg        led_cg,
	output wire       led_dp 
);

parameter DEVICE_OFF = 0;
parameter DEVICE_RUN = 1;
reg status = DEVICE_OFF;

parameter ALL_TUBE_OFF = 8'b1111_1111;
reg [7:0] tube_en_status = ALL_TUBE_OFF;

wire rst_n = ~rst;
assign led_dp = 1;

// Counter for 10 to 0 (For Simulation)
parameter CLOCK_PERIOD = 37'd27500;
parameter TRIG_10_SECOND = 37'd0;
parameter TRIG_9_SECOND = 37'd2500;
parameter TRIG_8_SECOND = 37'd5000;
parameter TRIG_7_SECOND = 37'd7500;
parameter TRIG_6_SECOND = 37'd10000;
parameter TRIG_5_SECOND = 37'd12500;
parameter TRIG_4_SECOND = 37'd15000;
parameter TRIG_3_SECOND = 37'd17500;
parameter TRIG_2_SECOND = 37'd20000;
parameter TRIG_1_SECOND = 37'd22500;
parameter TRIG_0_SECOND = 37'd25000;

// Counter for 10 to 0 (For Real Device)
// parameter CLOCK_PERIOD = 37'd1100000000;
// parameter TRIG_10_SECOND = 37'd100;
// parameter TRIG_9_SECOND = 37'd100000000;
// parameter TRIG_8_SECOND = 37'd200000000;
// parameter TRIG_7_SECOND = 37'd300000000;
// parameter TRIG_6_SECOND = 37'd400000000;
// parameter TRIG_5_SECOND = 37'd500000000;
// parameter TRIG_4_SECOND = 37'd600000000;
// parameter TRIG_3_SECOND = 37'd700000000;
// parameter TRIG_2_SECOND = 37'd800000000;
// parameter TRIG_1_SECOND = 37'd900000000;
// parameter TRIG_0_SECOND = 37'd1000000000;


reg [36:0] ten_cnt;
wire ten_cnt_inc = (ten_cnt != CLOCK_PERIOD && status == DEVICE_RUN);
wire ten_cnt_end = (ten_cnt == CLOCK_PERIOD);
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) ten_cnt <= 37'b0;
	else if (ten_cnt_end) ten_cnt <= 37'b0;
	else if (ten_cnt_inc) ten_cnt <= ten_cnt + 37'b1;
end

// Counter for 5 clk periods (For Simulation)
parameter SLICE_PERIOD = 21'd40;
parameter DIG_0_TRIG = 21'd40;
parameter DIG_1_TRIG = 21'd5;
parameter DIG_2_TRIG = 21'd10;
parameter DIG_3_TRIG = 21'd15;
parameter DIG_4_TRIG = 21'd20;
parameter DIG_5_TRIG = 21'd25;
parameter DIG_6_TRIG = 21'd30;
parameter DIG_7_TRIG = 21'd35;

// Counter for 2ms (For Real Device)
// parameter SLICE_PERIOD = 21'd1600000;
// parameter DIG_0_TRIG = 21'd1600000;
// parameter DIG_1_TRIG = 21'd200000;
// parameter DIG_2_TRIG = 21'd400000;
// parameter DIG_3_TRIG = 21'd600000;
// parameter DIG_4_TRIG = 21'd800000;
// parameter DIG_5_TRIG = 21'd1000000;
// parameter DIG_6_TRIG = 21'd1200000;
// parameter DIG_7_TRIG = 21'd1400000;
reg [20:0] slice_cnt;
wire slice_cnt_inc = (slice_cnt != SLICE_PERIOD && status == DEVICE_RUN);
wire slice_cnt_end = (slice_cnt == SLICE_PERIOD);
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) slice_cnt <= 21'b0;
	else if (slice_cnt_end) slice_cnt <= 21'b0;
	else if (slice_cnt_inc) slice_cnt <= slice_cnt + 21'b1;
end

// Digital Tube Number Binary Strings
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


reg [6:0] current_dig_6 = NUMBER_0;
reg [6:0] current_dig_7 = NUMBER_0;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_dig_6 = NUMBER_0;
        current_dig_7 = NUMBER_0;
    end
    else begin
        case (ten_cnt)
            TRIG_10_SECOND: begin
                current_dig_6 = NUMBER_0;
                current_dig_7 = NUMBER_1;
            end
            TRIG_9_SECOND: begin
                current_dig_6 = NUMBER_9;
                current_dig_7 = NUMBER_0;
            end
            TRIG_8_SECOND: begin
                current_dig_6 = NUMBER_8;
                current_dig_7 = NUMBER_0;
            end
            TRIG_7_SECOND: begin
                current_dig_6 = NUMBER_7;
                current_dig_7 = NUMBER_0;
            end
            TRIG_6_SECOND: begin
                current_dig_6 = NUMBER_6;
                current_dig_7 = NUMBER_0;
            end
            TRIG_5_SECOND: begin
                current_dig_6 = NUMBER_5;
                current_dig_7 = NUMBER_0;
            end
            TRIG_4_SECOND: begin
                current_dig_6 = NUMBER_4;
                current_dig_7 = NUMBER_0;
            end
            TRIG_3_SECOND: begin
                current_dig_6 = NUMBER_3;
                current_dig_7 = NUMBER_0;
            end
            TRIG_2_SECOND: begin
                current_dig_6 = NUMBER_2;
                current_dig_7 = NUMBER_0;
            end
            TRIG_1_SECOND: begin
                current_dig_6 = NUMBER_1;
                current_dig_7 = NUMBER_0;
            end
            TRIG_0_SECOND: begin
                current_dig_6 = NUMBER_0;
                current_dig_7 = NUMBER_0;
            end
        endcase
    end
	
end

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		status = DEVICE_OFF;
	end
	else if (status == DEVICE_OFF) begin
		led_ca = 1;
		led_cb = 1;
		led_cc = 1;
		led_cd = 1;
		led_ce = 1;
		led_cf = 1;
		led_cg = 1;
		if (button) begin
			status = DEVICE_RUN;
			tube_en_status = 8'b1111_1110;
		end
	end
	else if (status == DEVICE_RUN) begin
		case (slice_cnt)
			DIG_0_TRIG: begin
				// Number 7
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = NUMBER_7;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_1_TRIG: begin
				// Number 1
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = NUMBER_1;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_2_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = NUMBER_6;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_3_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = NUMBER_0;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_4_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = NUMBER_0;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_5_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = NUMBER_2;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_6_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = current_dig_6;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
			DIG_7_TRIG: begin
				{led_ca, led_cb, led_cc, led_cd, led_ce, led_cf, led_cg} = current_dig_7;
				tube_en_status = {tube_en_status[6:0], tube_en_status[7]};
				led_en = tube_en_status;
			end
		endcase
	end
end


endmodule