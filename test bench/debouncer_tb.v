`timescale 1ns / 1ps

module debouncer_tb();

reg button_in,clk,rst;
wire button_out;

debouncer dut(button_out,button_in,clk,rst);

always begin
    clk = 0; #5;
    clk = 1; #5;
end

initial begin
    rst = 0;
    button_in = 0;
    #10;
    rst = 1;
    // bouncing
    button_in = 1; #50; button_in = 0; #50; button_in = 1; #50; button_in = 0; #50;
    // stable
    button_in = 1; #1000;
    // bouncing
    button_in = 0; #50; button_in = 1; #50; button_in = 0; #50; button_in = 1; #50;
    // stable
    button_in = 0; #1000;
    
    
    // bouncing
    button_in = 1; #50; button_in = 0; #50; button_in = 1; #50; button_in = 0; #50;
    // stable
    button_in = 1; #1000;
    // bouncing
    button_in = 0; #50; button_in = 1; #50; button_in = 0; #50; button_in = 1; #50;
    // stable
    button_in = 0; #1000;
    
    $finish;
end

endmodule
