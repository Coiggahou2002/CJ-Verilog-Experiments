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
 * ��ʾ�豸״???�ĳ���
 */
parameter DEVICE_OFF = 2'b00;     // �ػ�״???
parameter DEVICE_READY = 2'b01;   // ׼��״???
parameter DEVICE_ON = 2'b10;      // ����״???
parameter DEVICE_PAUSE = 2'b11;   // ��ͣ״???

/**
 * ʱ����صĳ�??
 */
parameter CLOCK_PERIOD = 32'd4;     // ʱ����������
parameter LED_SWITCH_TIME = 32'd4;   // LED�л�����ʱ��

// �豸��ʼ״???Ϊ OFF
reg [1:0] status = DEVICE_OFF;

// ʱ�ӿ����������??
wire cnt_end = (cnt == CLOCK_PERIOD);
wire cnt_inc = (cnt != CLOCK_PERIOD && status == DEVICE_ON);


always @(posedge clk or negedge rst_n) begin

    if (~rst_n) begin
        status = DEVICE_PAUSE;
    end

    // �ػ�״???�°�button����׼��״???
    else if (status == DEVICE_OFF) begin
        if (button) begin
            status = DEVICE_READY;
        end
    end

    // ������λ�úͰ�ť��Ӧ��׼���ú��Զ��л���??ʼ״??
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

    // rst�����º�������ͣ״̬��??
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

    // �豸����״???
    else if (status == DEVICE_ON) begin
        // ����״???�°�button������׼��״̬���õƵ�λ�ú�������������??
        if (button) begin
            status = DEVICE_READY;
        end
        else if (cnt == LED_SWITCH_TIME) begin
            led = { led[14:0], led[15] };
        end
    end
end

// ʱ�ӿ���??
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 32'd0;
    else if (cnt_end) cnt <= 32'd0;
    else if (cnt_inc) cnt <= cnt + 32'd1;
end

endmodule