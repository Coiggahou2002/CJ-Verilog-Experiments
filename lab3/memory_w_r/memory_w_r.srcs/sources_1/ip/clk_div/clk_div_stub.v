// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Wed Nov 17 00:17:03 2021
// Host        : DESKTOP-5AR01AB running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {d:/CJ-Documents/User Desktop of
//               Windows/CJ-Verilog-Experiments/lab3/memory_w_r/memory_w_r.srcs/sources_1/ip/clk_div/clk_div_stub.v}
// Design      : clk_div
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_div(clk_out1, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,locked,clk_in1" */;
  output clk_out1;
  output locked;
  input clk_in1;
endmodule
