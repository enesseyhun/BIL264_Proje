`timescale 1ns / 1ps

  module carry_look_ahead_adder(
  input [63:0] a,
  input [63:0] b,
  input cin,
  output cout,
  output [63:0] sum
  );
  
  wire[15:0] g;
  
  carry_look_ahead_4 i1(a[3:0], b[3:0], cin, g[0],sum[3:0]);
  carry_look_ahead_4 i2(a[7:4], b[7:4], g[0], g[1],sum[7:4]);
  carry_look_ahead_4 i3(a[11:8], b[11:8], g[1], g[2],sum[11:8]);
  carry_look_ahead_4 i4(a[15:12], b[15:12], g[2], g[3],sum[15:12]);
  carry_look_ahead_4 i5(a[19:16], b[19:16], g[3], g[4],sum[19:16]);
  carry_look_ahead_4 i6(a[23:20], b[23:20], g[4], g[5],sum[23:20]);
  carry_look_ahead_4 i7(a[27:24], b[27:24], g[5], g[6],sum[27:24]);
  carry_look_ahead_4 i8(a[31:28], b[31:28], g[6], g[7],sum[31:28]);
  carry_look_ahead_4 i9(a[35:32], b[35:32], g[7], g[8],sum[35:32]);
  carry_look_ahead_4 i10(a[39:36], b[39:36], g[8], g[9],sum[39:36]);
  carry_look_ahead_4 i11(a[43:40], b[43:40], g[9], g[10],sum[43:40]);
  carry_look_ahead_4 i12(a[47:44], b[47:44], g[10], g[11],sum[47:44]);
  carry_look_ahead_4 i13(a[51:48], b[51:48], g[11], g[12],sum[51:48]);
  carry_look_ahead_4 i14(a[55:52], b[55:52], g[12], g[13],sum[55:52]);
  carry_look_ahead_4 i15(a[59:56], b[59:56], g[13], g[14],sum[59:56]);
  carry_look_ahead_4 i16(a[63:60], b[63:60], g[14], cout,sum[63:60]);
  
  endmodule
