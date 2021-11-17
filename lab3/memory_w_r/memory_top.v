module memory_top (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
	output wire [15:0] led   
);
wire rst_n = ~rst;

wire ena;          // memory enable signal, high available
wire wea;          // memory write signal, high to write, low to read
wire [3:0] addra;  // address to write
wire [15:0] dina;  // data in
wire [15:0] douta; // data out

wire clk_g; // 10MHz
wire locked; // set high to get clk_g work

assign locked = 1;

clk_div u_clk_div (
	.clk_in1 (clk),
	.clk_out1 (clk_g),
	.locked (locked)
);

memory_w_r u_memory_w_r (
	.clk (clk_g),
	.rst (rst),
	.button (button),
	.douta (douta),
	.led (led),
	.ena (ena),
	.wea (wea),
	.addra (addra),
	.dina (dina)
);

led_mem u_led_mem (
	.clka (clk_g),
	.ena (ena),
	.wea (wea),
	.addra (addra),
	.dina (dina),
	.douta (douta)
);

endmodule