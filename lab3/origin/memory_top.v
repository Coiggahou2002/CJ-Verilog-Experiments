module memory_top (
    input  wire        clk   ,
	input  wire        rst   ,
	input  wire        button,
	output wire [15:0] led   
);

clk_div u_clk_div (
	.clk_in1 (clk),
	.clk_out1 (clk_g),
	.locked (locked)
);

memory_w_r u_memory_w_r (

);

led_mem u_led_mem (

);

endmodule