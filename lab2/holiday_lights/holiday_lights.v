module holiday_lights (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
    input  wire [2:0] switch,
	output reg  [15:0] led
);

reg [31:0] cnt;

wire rst_n = ~rst;

/**
 * 表示设备状???的常量
 */
parameter DEVICE_OFF = 2'b00;     // 关机状???
parameter DEVICE_READY = 2'b01;   // 准备状???
parameter DEVICE_ON = 2'b10;      // 运行状???
parameter DEVICE_PAUSE = 2'b11;   // 暂停状???

/**
 * 时钟相关的常??
 */
parameter CLOCK_PERIOD = 32'd4;     // 时钟重置周期
parameter LED_SWITCH_TIME = 32'd4;   // LED切换触发时间

// 设备初始状???为 OFF
reg [1:0] status = DEVICE_OFF;

// 时钟控制条件表达??
wire cnt_end = (cnt == CLOCK_PERIOD);
wire cnt_inc = (cnt != CLOCK_PERIOD && status == DEVICE_ON);


always @(posedge clk or negedge rst_n) begin

    if (~rst_n) begin
        status = DEVICE_PAUSE;
    end

    // 关机状???下按button进入准备状???
    else if (status == DEVICE_OFF) begin
        if (button) begin
            status = DEVICE_READY;
        end
    end

    // 将亮灯位置和按钮对应，准备好后自动切换到??始状??
    else if (status == DEVICE_READY) begin
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
        status = DEVICE_ON;
    end

    // rst键按下后进入的暂停状态定??
    else if (status == DEVICE_PAUSE) begin
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
        if (button) begin
            status = DEVICE_ON;
        end
    end

    // 设备运行状???
    else if (status == DEVICE_ON) begin
        // 运行状???下按button，进入准备状态重置灯的位置和数量，重新再??
        if (button) begin
            status = DEVICE_READY;
        end
        else if (cnt == LED_SWITCH_TIME) begin
            led = { led[14:0], led[15] };
        end
    end
end

// 时钟控制??
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 32'd0;
    else if (cnt_end) cnt <= 32'd0;
    else if (cnt_inc) cnt <= cnt + 32'd1;
end

endmodule