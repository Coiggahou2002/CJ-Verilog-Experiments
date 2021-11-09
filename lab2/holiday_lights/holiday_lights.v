module holiday_lights (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
    input  wire [2:0] switch,
	output reg  [7:0] led
);
reg [36:0] cnt;

wire rst_n = ~rst;

wire cnt_end = (cnt == 37'd100000000);
wire cnt_inc = (cnt != 37'd100000000);

reg enable = 1'b0;

// 按下button，状态改变
always @(posedge clk) begin
    if (button) begin
        enable <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 37'd0;
    else if (cnt_end) cnt <= 37'd0;
    else if (cnt_inc) cnt <= cnt + 37'd1;
end

always @(*) begin
    if (enable) begin
        if (cnt == 37'd90000000) begin
            led <= {led[6:0],led[7]};
        end
    end
    else begin
        led[2:0] = switch[2:0];
    end
end

endmodule