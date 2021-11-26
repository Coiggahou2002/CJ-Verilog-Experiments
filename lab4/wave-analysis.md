# 数字逻辑实验四 | 波形分析

> 200110617 蔡嘉豪

## 一、概述

本实验要求能够控制 8 个数码管同时稳定地显示数字，其中 DK0-DK5 显示固定的静态数字，DK7-DK6 循环显示十秒倒计时.

## 二、总思路

使用一个能容纳 0 到 16 毫秒的计数器 `slice_cnt`，每隔 2 ms 给出信号，控制 8 个数码管的是使能信号转移及为其共用的触发信号赋值（其中 DK7-DK6 的触发信号由寄存器变量 `current_dig_6` 和 `current_dig_7` 持久化，每隔 1 s 触发其变化）

使用一个能容纳 0 到 10 秒的计数器 `ten_cnt`，负责在循环十秒倒数的过程中，每隔 1 s 给出信号，控制数码管触发信号的动态改变

## 三、状态定义和转换

设备状态：

```verilog
reg status；
parameter DEVICE_OFF = 0; // 关机或复位
parameter DEVICE_RUN = 1; // 运行
```

数码管触发信号状态常量：

```verilog
parameter NUMBER_0 = 7'b0000001;
parameter NUMBER_1 = 7'b1001111;
parameter NUMBER_2 = 7'b0010010;
parameter NUMBER_3 = 7'b0000110;
parameter NUMBER_4 = 7'b1001100;
parameter NUMBER_5 = 7'b0100100;
parameter NUMBER_6 = 7'b0100000;
parameter NUMBER_7 = 7'b0001111;
parameter NUMBER_8 = 7'b0000000;
parameter NUMBER_9 = 7'b0001100;
```

十秒倒计时时钟触发时机：

```verilog
// Counter for 10 to 0 (For Real Device)
parameter CLOCK_PERIOD = 37'd1100000000;
parameter TRIG_10_SECOND = 37'd100;
parameter TRIG_9_SECOND = 37'd100000000;
parameter TRIG_8_SECOND = 37'd200000000;
parameter TRIG_7_SECOND = 37'd300000000;
parameter TRIG_6_SECOND = 37'd400000000;
parameter TRIG_5_SECOND = 37'd500000000;
parameter TRIG_4_SECOND = 37'd600000000;
parameter TRIG_3_SECOND = 37'd700000000;
parameter TRIG_2_SECOND = 37'd800000000;
parameter TRIG_1_SECOND = 37'd900000000;
parameter TRIG_0_SECOND = 37'd1000000000;
```

数码管快速切换使能触发时机（2 ms）：
```verilog
// Counter for 2ms (For Real Device)
parameter SLICE_PERIOD = 21'd1600000;
parameter DIG_0_TRIG = 21'd1600000;
parameter DIG_1_TRIG = 21'd200000;
parameter DIG_2_TRIG = 21'd400000;
parameter DIG_3_TRIG = 21'd600000;
parameter DIG_4_TRIG = 21'd800000;
parameter DIG_5_TRIG = 21'd1000000;
parameter DIG_6_TRIG = 21'd1200000;
parameter DIG_7_TRIG = 21'd1400000;
```

## 四、波形分析

![](./led_display_ctrl/wave.PNG)

此处仿真中设置的数码管使能切换间隔为 5 个时钟周期，十秒倒计时中每 1 s 换成 2500 个时钟周期

从图中可见，数码管的使能信号低电平快速地逐位转移，超过了人眼的刷新频率，形成视觉暂留效果，人眼看上去就是 8 个数码管同时稳定显示数字

LED 使能信号位在 0-5 时，可以看到对应的触发信号都是一样的，因为 DK0-DK5 一直显示的是固定的数字

LED 使能信号在 6-7 时，每隔 2500 个时钟周期，DK6 会改变一次，而 DK7 每隔 25000 个时钟周期就改变 2 次，因为 DK 7 只在 `0` 和 `1` 之间转换