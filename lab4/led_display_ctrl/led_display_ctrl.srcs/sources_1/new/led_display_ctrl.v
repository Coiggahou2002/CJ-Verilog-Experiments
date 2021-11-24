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

parameter ALL_TUBE_ON = 8'b0000_0000;
parameter ALL_TUBE_OFF = 8'b1111_1111;

wire rst_n = ~rst;

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		
	end
	else if (status)
end


endmodule