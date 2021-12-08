module sequence_detection (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	input  wire [7:0] switch,
	output reg        led
);

wire rst_n = ~rst;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [2:0] current_state;
reg [2:0] next_state;

parameter DEVICE_OFF = 2'b00;
parameter DEVICE_READY = 2'b01;
parameter DEVICE_RUN = 2'b10;
reg [1:0] device_state = DEVICE_OFF;

reg out;

reg bit;
reg [3:0] current_char_pos = 4'd8;

// 监控：按钮改变设备状�????
// always @(posedge clk or negedge rst_n) begin
// 	if (~rst_n) begin
// 		device_state <= DEVICE_OFF;
// 	end
// 	else if (button) begin
// 		device_state <= DEVICE_READY;
// 	end
// end

always @(posedge clk) begin
	if (button) begin
		device_state = DEVICE_READY;
	end
end

// 设备状�?�对应行�????
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		device_state = DEVICE_OFF;
	end
	else if (device_state == DEVICE_OFF) begin
		if (button) begin
			device_state = DEVICE_READY;
		end
	end
	else if (device_state == DEVICE_READY) begin
		current_state = S0;
		bit = 1'b0;
		current_char_pos = 4'd8;
		led = 1'b0;
		device_state = DEVICE_RUN;
	end
	else if (device_state == DEVICE_RUN) begin
		if (current_char_pos != 4'd0) begin
			current_char_pos = current_char_pos - 4'd1;
			bit = switch[current_char_pos];
			current_state = next_state;
		end
	end
end

// 负责状�?�转移控�????
always @(*) begin
	case (current_state)
		S0: if (bit == 1'b1) next_state <= S1;
			else next_state <= S0;
		S1: if (bit == 1'b0) next_state <= S2;
			else next_state <= S1;
		S2: if (bit == 1'b0) next_state <= S3;
			else next_state <= S1;
		S3: if (bit == 1'b1) next_state <= S4;
			else next_state <= S0;
		S4: if (bit == 1'b0) next_state <= S5;
			else next_state <= S1;
		S5: if (bit == 1'b1) next_state <= S1;
			else next_state <= S3;
		default: next_state <= S0;
	endcase
end

// 负责out和亮�????
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		out <= 1'b0;
		led <= 1'b0;
	end
	else begin
		if (current_state == S5) begin
			out <= 1'b1;
			led <= 1'b1;
		end
		else out <= 1'b0;
	end
end
		   
endmodule