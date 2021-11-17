module memory_w_r(
	input wire clk,
	input wire rst,
	input wire button,
	input wire [15:0] douta,
	output reg [15:0] led,
	output reg ena,
	output reg wea,
	output reg [3:0] addra,
	output reg [15:0] dina
);
wire rst_n = ~rst;

parameter CLOCK_PERIOD = 28'd10000000;
parameter W_R_TIME = 28'd9999999;

parameter DEVICE_SILENT = 2'b00;
parameter DEVICE_RUN = 2'b01;
reg [1:0] status = DEVICE_SILENT;

reg [27:0] cnt;
wire cnt_end = (cnt == CLOCK_PERIOD);
wire cnt_inc = (cnt != CLOCK_PERIOD && status == DEVICE_RUN);

reg [4:0] enlighted_nums = 5'd0; // 0-15
reg [15:0] light_status = 16'b0000_0000_0000_0001;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 28'b0;
    else if (cnt_end) cnt <= 28'b0;
    else if (cnt_inc) cnt <= cnt + 28'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        light_status = 16'b0000_0000_0000_0000;
        led = light_status;
        enlighted_nums = 4'd0;
        addra = enlighted_nums;
        dina = light_status;
        wea = 1;
        ena = 1;
        status = DEVICE_SILENT;
    end
    else if (status == DEVICE_SILENT) begin
        if (button) begin
            led = 16'b0000_0000_0000_0001;
            status = DEVICE_RUN;
        end
    end
    else if (status == DEVICE_RUN) begin
        led = (enlighted_nums != 5'd16) ? douta : (douta << 1) + 16'b1;
        if (enlighted_nums != 5'd16) begin
            if (cnt == W_R_TIME) begin
                addra = enlighted_nums;
                dina = light_status;
                ena = 1;
                wea = 1;
                light_status = (light_status << 1) + 16'b1;
                enlighted_nums = enlighted_nums + 5'd1;
            end
        end
        else begin
            ena = 0;
            status = DEVICE_SILENT;
        end
    end
end


endmodule