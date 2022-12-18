`timescale 1ns / 1ps

module generate_p(a,b,p,bp);
input [3:0] a,b;
output [3:0] p;
output bp;
assign p= a^b;//get all propagate bits
assign bp= &p;// and p0p1p2p3 bits
endmodule