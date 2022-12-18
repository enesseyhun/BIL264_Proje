`timescale 1ns / 1ps


module CSA_TB;

reg [63:0] a;
reg [63:0] b;
reg cin;
wire cout;
wire[63:0] sum;

carry_skip_64bit uut(
.a(a),
.b(b),
.cin(cin),
.cout(cout),
.sum(sum));

initial begin
a=64'd99999;
b=64'd99999;
cin=0;
#10;
a=15;
b=13;
cin=1;
#10;
a=20;
b=100;
cin=0;
#10;
a=5;
b=10;
cin=1;
#10;
end
endmodule
