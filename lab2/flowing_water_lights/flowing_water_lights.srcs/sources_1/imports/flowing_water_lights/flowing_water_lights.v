module flowing_water_lights (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led
);

reg [36:0] cnt;
reg [2:0] signal;

wire rst_n = ~rst;

wire cnt_end = (cnt == 37'd900000000);
wire cnt_inc = (cnt != 37'd900000000);

always @(*) begin
	case (signal)
		3'b000: led = 8'b0000_0001;
		3'b001: led = 8'b0000_0010;
		3'b010: led = 8'b0000_0100;
		3'b011: led = 8'b0000_1000;
		3'b100: led = 8'b0001_0000;
		3'b101: led = 8'b0010_0000;
		3'b110: led = 8'b0100_0000;
		3'b111: led = 8'b1000_0000;
	endcase
end

always @(*) begin
	case (cnt)
		37'd100000000: signal = 3'b000;
		37'd200000000: signal = 3'b001;
		37'd300000000: signal = 3'b010;
		37'd400000000: signal = 3'b011;
		37'd500000000: signal = 3'b100;
		37'd600000000: signal = 3'b101;
		37'd700000000: signal = 3'b110;
		37'd800000000: signal = 3'b111;
		default: ;
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) cnt <= 37'd0;
	else if (cnt_end) cnt <= 37'd0;
	else if (cnt_inc) cnt <= cnt + 37'd1;
end

endmodule