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
parameter TRIGGER_TIME = 28'd10000000;

parameter WRITE_PERIOD = 16'd2;
parameter WRITE_TRIGGER = 16'd2;

parameter DEVICE_RESET = 3'b000;
parameter DEVICE_NOT_WORK = 3'b001;
parameter DEVICE_WRITE = 3'b010;
parameter DEVICE_READ = 3'b011;

reg [2:0] status = DEVICE_RESET;


reg [27:0] read_cnt;
wire read_cnt_end = (read_cnt == CLOCK_PERIOD);
wire read_cnt_inc = (read_cnt != CLOCK_PERIOD && status == DEVICE_READ);

reg [15:0] write_cnt;
wire write_cnt_end = (write_cnt == WRITE_PERIOD);
wire write_cnt_inc = (write_cnt != WRITE_PERIOD && status == DEVICE_WRITE);

reg [3:0] written_nums = 4'b0;
reg [4:0] enlighted_nums = 5'b0;
reg [15:0] light_status = 16'b0000_0000_0000_0000;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) read_cnt <= 28'b0;
    else if (read_cnt_end) read_cnt <= 28'b0;
    else if (read_cnt_inc) read_cnt <= read_cnt + 28'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)  write_cnt <= 16'b0;
    else if (write_cnt_end) write_cnt <= 16'b0;
    else if (write_cnt_inc) write_cnt <= write_cnt + 16'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        status = DEVICE_RESET;
        ena = 0;
        wea = 0;
    end
    else if (status == DEVICE_RESET) begin
        light_status = 16'b0000_0000_0000_0000;
        led = light_status;
        status = DEVICE_NOT_WORK;
    end
    else if (status == DEVICE_NOT_WORK) begin
        if (button) begin
            status = DEVICE_WRITE;
        end
    end
    else if (status == DEVICE_WRITE) begin
        ena = 0;
        if (addra == 4'd15) begin
            addra = 4'b0;
            dina = 16'b0;
            status = DEVICE_READ;
            ena = 1;
            wea = 0;
            led = 16'b0000_0000_0000_0001;
        end
        else begin
            if (write_cnt == WRITE_TRIGGER) begin
                ena = 1;
                wea = 1;
                addra = written_nums;
                light_status = (light_status << 1) + 16'b1;
                dina = light_status;
                written_nums = written_nums + 4'b1;
            end
        end
    end
    else if (status == DEVICE_READ) begin
        if (addra != 4'd14) begin
            ena = 0;
            led = douta;
            if (read_cnt == TRIGGER_TIME) begin
                ena = 1;
                wea = 0;
                addra = addra + 4'd1;
            end
        end
        else begin
            wea = 0;
            if (led == 16'b0111_1111_1111_1111) begin
                if (read_cnt == TRIGGER_TIME) begin
                    led = 16'b1111_1111_1111_1111;
                    ena = 0;
                end
            end
            else if (led != 16'b1111_1111_1111_1111) begin
                ena = 1;
                led = douta;
            end
        end
    end

end

endmodule
