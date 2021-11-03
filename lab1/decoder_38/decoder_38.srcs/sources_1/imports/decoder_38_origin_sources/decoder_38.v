module decoder_38 (
    input  wire       clk   ,
	input  wire       rst   ,
	input  wire [2:0] enable,
	input  wire [2:0] switch,
	output reg  [7:0] led
);
        
    always @ (*) begin
        if (enable == 3'b100) begin
            case (switch)
                3'b000: led = 8'b1111_1110;
                3'b001: led = 8'b1111_1101;
                3'b010: led = 8'b1111_1011;
                3'b011: led = 8'b1111_0111;
                3'b100: led = 8'b1110_1111;
                3'b101: led = 8'b1101_1111;
                3'b110: led = 8'b1011_1111;
                3'b111: led = 8'b0111_1111;
                default: led = 8'b1111_1111;
            endcase
        end
        else led = 8'b1111_1111;
        
    end

endmodule