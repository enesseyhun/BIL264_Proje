`timescale 1ns / 1ps



module ripple_carry_64_bit(a, b, cin,sum, cout);
input [63:0] a;
input [63:0] b;
input cin;
output [63:0] sum;
output cout;

wire [15:0] c;

ripple_carry_4_bit i1 (
.a(a[3:0]),
.b(b[3:0]),
.cin(cin), 
.sum(sum[3:0]),
.cout(c[0]));

ripple_carry_4_bit i2 (
.a(a[7:4]),
.b(b[7:4]),
.cin(c[0]),
.sum(sum[7:4]),
.cout(c[1]));

ripple_carry_4_bit i3(
.a(a[11:8]),
.b(b[11:8]),
.cin(c[1]),
.sum(sum[11:8]),
.cout(c[2]));

ripple_carry_4_bit i4(
.a(a[15:12]),
.b(b[15:12]),
.cin(c[2]),
.sum(sum[15:12]),
.cout(c[3]));

ripple_carry_4_bit i5 (
.a(a[19:16]),
.b(b[19:16]),
.cin(c[3]), 
.sum(sum[19:16]),
.cout(c[4]));

ripple_carry_4_bit i6 (
.a(a[23:20]),
.b(b[23:20]),
.cin(c[4]),
.sum(sum[23:20]),
.cout(c[5]));

ripple_carry_4_bit i7(
.a(a[27:24]),
.b(b[27:24]),
.cin(c[5]),
.sum(sum[27:24]),
.cout(c[6]));

ripple_carry_4_bit i8(
.a(a[31:28]),
.b(b[31:28]),
.cin(c[6]),
.sum(sum[31:28]),
.cout(c[7]));

ripple_carry_4_bit i9 (
.a(a[35:32]),
.b(b[35:32]),
.cin(c[7]), 
.sum(sum[35:32]),
.cout(c[8]));

ripple_carry_4_bit i10 (
.a(a[39:36]),
.b(b[39:36]),
.cin(c[8]),
.sum(sum[39:36]),
.cout(c[9]));

ripple_carry_4_bit i11(
.a(a[43:40]),
.b(b[43:40]),
.cin(c[9]),
.sum(sum[43:40]),
.cout(c[10]));

ripple_carry_4_bit i12(
.a(a[47:44]),
.b(b[47:44]),
.cin(c[10]),
.sum(sum[47:44]),
.cout(c[11]));

ripple_carry_4_bit i13 (
.a(a[51:48]),
.b(b[51:48]),
.cin(c[11]), 
.sum(sum[51:48]),
.cout(c[12]));

ripple_carry_4_bit i14 (
.a(a[55:52]),
.b(b[55:52]),
.cin(c[12]),
.sum(sum[55:52]),
.cout(c[13]));

ripple_carry_4_bit i15(
.a(a[59:56]),
.b(b[59:56]),
.cin(c[13]),
.sum(sum[59:56]),
.cout(c[14]));

ripple_carry_4_bit i16(
.a(a[63:60]),
.b(b[63:60]),
.cin(c[14]),
.sum(sum[63:60]),
.cout(cout));

endmodule
