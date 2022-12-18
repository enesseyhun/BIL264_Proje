`timescale 1ns / 1ps

module adders_muxed(
input [63:0] a,
input [63:0] b,
input cin,
input [1:0] adder_select,
output reg cout,
output reg [63:0] sum
);


localparam RCA = 2'b00;
localparam CLA = 2'b01;
localparam CSEA = 2'b10;
localparam CSA = 2'b11;
    
wire cout_1;
wire[63:0] sum_1;

wire cout_2;
wire[63:0] sum_2;

wire cout_3;
wire[63:0] sum_3;

wire cout_4;
wire[63:0] sum_4;

ripple_carry_64_bit ripple_carry_64_bit_inst(
.a(a),
.b(b),
.cin(cin),
.cout(cout_1),
.sum(sum_1));    
    
  
carry_look_ahead_adder carry_look_ahead_adder_inst(
.a(a),
.b(b),
.cin(cin),
.cout(cout_2),
.sum(sum_2));  


carry_select_adder_64bit carry_select_adder_64bit_inst(
.a(a),
.b(b),
.cin(cin),
.cout(cout_3),
.sum(sum_3));

carry_skip_64bit carry_skip_64bit_inst(
.a(a),
.b(b),
.cin(cin),
.cout(cout_4),
.sum(sum_4));

always @*
begin
    case(adder_select)
    RCA: begin
        sum = sum_1;
        cout = cout_1;
    end
    CLA: begin
        sum = sum_2;
        cout = cout_2;
    end
    CSEA: begin
        sum = sum_3;
        cout = cout_3;
    end
    CSA: begin
        sum = sum_4;
        cout = cout_4;
    end
    endcase
end
  
endmodule
