module holiday_lights (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
    input  wire [2:0] switch,
	output reg  [15:0] led
);
reg [36:0] cnt;

wire rst_n = ~rst;
reg enable = 1'b0;
wire cnt_end = (cnt == 37'd4);
wire cnt_inc = (cnt != 37'd4 && enable);




// 按下button，状态改�??
always @(posedge clk) begin
    if (button) begin
        enable <= 1'b1;
    end
    else if (~rst_n) begin
        enable <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 37'd0;
    else if (cnt_end) cnt <= 37'd0;
    else if (cnt_inc) cnt <= cnt + 37'd1;
end

always @(posedge clk) begin
    if (enable) begin
        if (cnt == 37'd3) begin
            led <= {led[14:0],led[15]};
        end
    end
    else begin
        case (switch)
            3'b000: led = 16'b0000_0000_0000_0001;
            3'b001: led = 16'b0000_0000_0000_0011;
            3'b010: led = 16'b0000_0000_0000_0111;
            3'b011: led = 16'b0000_0000_0000_1111;
            3'b100: led = 16'b0000_0000_0001_1111;
            3'b101: led = 16'b0000_0000_0011_1111;
            3'b110: led = 16'b0000_0000_0111_1111;
            3'b111: led = 16'b0000_0000_1111_1111;
        endcase
    end
end

endmodule