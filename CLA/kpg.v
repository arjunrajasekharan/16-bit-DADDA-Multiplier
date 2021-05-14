`include "CLA/kpg_gen.v"

module kpgg(x,ai,bi);

input [7:0] ai,bi;

output [7:0][7:0]x;

kpg kpg_0(x[0],ai[0],bi[0]);
kpg kpg_1(x[1],ai[1],bi[1]);
kpg kpg_2(x[2],ai[2],bi[2]);
kpg kpg_3(x[3],ai[3],bi[3]);
kpg kpg_4(x[4],ai[4],bi[4]);
kpg kpg_5(x[5],ai[5],bi[5]);
kpg kpg_6(x[6],ai[6],bi[6]);
kpg kpg_7(x[7],ai[7],bi[7]);



endmodule
