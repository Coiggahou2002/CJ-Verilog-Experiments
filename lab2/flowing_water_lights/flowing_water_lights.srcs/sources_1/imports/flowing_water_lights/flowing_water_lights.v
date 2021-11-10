module flowing_water_lights (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire       button,
	output reg  [7:0] led
);
reg [36:0] cnt;

wire rst_n = ~rst;

wire cnt_end = (cnt == 37'd100000000);
wire cnt_inc = (cnt != 37'd100000000);

reg enable = 1'b0;

initial begin
    led = 8'b0000_0001;
end

always @(posedge clk) begin
    if (button) begin
        enable <= 1'b1;
    end
end

always @(posedge clk) begin
    if (enable) begin
        if (~rst_n) begin
            led <= 8'b0000_0001;
        end
        else if (cnt == 37'd99999999) begin
            led <= {led[6:0],led[7]};
        end
    end
    else begin
        led <= 8'b0000_0001;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 37'd0;
    else if (cnt_end) cnt <= 37'd0;
    else if (cnt_inc) cnt <= cnt + 37'd1;
end

endmodule