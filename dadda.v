
`include "CLA/32adder.v"

module compressor(x1, x2, x3, x4, cin, s, c, cout);
    input x1, x2, x3, x4, cin;
    output s, c, cout;
    wire s_inter = x1 ^ x2 ^ x3;

    assign cout = x1 & x2 | x2 & x3 | x3 & x1;
    assign s = x4 ^ cin ^ s_inter;
    assign c = s_inter & x4 | x4 & cin | cin & s_inter;

endmodule

module half_adder(a, b, s, c);

    input a, b;
    output s, c;

    assign s = a ^ b;
    assign c = a & b;

endmodule

module full_adder(a, b, cin, s, c);
    input a, b, cin;
    output s, c;

    assign s = a ^ b ^ cin;
    assign c = a & b | b & cin | a & cin;

endmodule

module AND(a, b, c);
    input [15:0] a;
    input b;
    output [15:0] c;

    assign c[0] = a[0] & b;
    assign c[1] = a[1] & b;
    assign c[2] = a[2] & b;
    assign c[3] = a[3] & b;
    assign c[4] = a[4] & b;
    assign c[5] = a[5] & b;
    assign c[6] = a[6] & b;
    assign c[7] = a[7] & b;
    assign c[8] = a[8] & b;
    assign c[9] = a[9] & b;
    assign c[10] = a[10] & b;
    assign c[11] = a[11] & b;
    assign c[12] = a[12] & b;
    assign c[13] = a[13] & b;
    assign c[14] = a[14] & b;
    assign c[15] = a[15] & b;

endmodule


module dadda_multiplier(a, b, y);

    input [15:0] a, b;
    output [31:0] y;


    wire [15:0] p[15:0];

    AND a1(a, b[0], p[0]);//calls module that will and b[0] with every bit of a.
    AND a2(a, b[1], p[1]);
    AND a3(a, b[2], p[2]);
    AND a4(a, b[3], p[3]);
    AND a5(a, b[4], p[4]);
    AND a6(a, b[5], p[5]);
    AND a7(a, b[6], p[6]);
    AND a8(a, b[7], p[7]);
    AND a9(a, b[8], p[8]);
    AND a10(a, b[9], p[9]);
    AND a11(a, b[10], p[10]);
    AND a12(a, b[11], p[11]);
    AND a13(a, b[12], p[12]);
    AND a14(a, b[13], p[13]);
    AND a15(a, b[14], p[14]);
    AND a16(a, b[15], p[15]);


    //level 1

    wire [33:0] ts0;
    wire [20:0] tc0;
    wire [30:0] tc1, tc2;
    wire [53:0] ts1, ts2;
    wire [52:0] tc3;
    wire [90:0] tc5;
    wire [3:0] tse, tce;

    half_adder h00 (p[0][8], p[1][7], ts0[0], tc1[0]); //9

    full_adder f00 (p[0][9], p[1][8], p[2][7], ts0[1], tc0[0]); //10
    half_adder h01 (p[3][6], tc1[0], ts0[2], tc1[1]);

    compressor c00 (p[0][10], p[1][9], p[2][8], p[3][7], tc1[1], ts0[3], tc0[1], tc1[2]); //11
    half_adder h02 (p[4][6], p[5][5], ts0[4], tc1[3]);

    compressor c01 (p[0][11], p[1][10], p[2][9], p[3][8], tc1[2], ts0[5], tc0[2], tc1[4]); //12
    full_adder f01 (p[4][7], p[5][6], tc1[3], ts0[6], tc1[5]);

    compressor c02 (p[0][12], p[1][11], p[2][10], p[3][9], tc1[4], ts0[7], tc0[3], tc1[6]); //13
    full_adder f02 (p[4][8], p[5][7], tc1[5], ts0[8], tc1[7]);
    half_adder e00 (p[6][6], p[7][5], tse[0], tce[0]);

    compressor c03 (p[0][13], p[1][12], p[2][11], p[3][10], tc1[6], ts0[9], tc0[4], tc1[8]); //14
    compressor c04 (p[4][9], p[5][8], p[6][7], p[7][6], tc1[7], ts0[10], tc0[5], tc1[9]);

    compressor c05 (p[0][14], p[1][13], p[2][12], p[3][11], tc1[8], ts0[11], tc0[6], tc1[10]); //15
    compressor c06 (p[4][10], p[5][9], p[6][8], p[7][7], tc1[9], ts0[12], tc0[7], tc1[11]);
    half_adder h03 (p[8][6], p[9][5], ts0[13], tc1[12]);

    compressor c07 (p[0][15], p[1][14], p[2][13], p[3][12], tc1[10], ts0[14], tc0[8], tc1[13]); //16
    compressor c08 (p[4][11], p[5][10], p[6][9], p[7][8], tc1[11], ts0[15], tc0[9], tc1[14]);
    full_adder f03 (p[8][7], p[9][6], tc1[12], ts0[16], tc1[15]);
    half_adder h04 (p[10][5], p[11][4], ts0[17], tc1[16]);

    compressor c09 (p[1][15], p[2][14], p[3][13], p[4][12], tc1[13], ts0[18], tc0[10], tc1[17]); //15
    compressor c10 (p[5][11], p[6][10], p[7][9], p[8][8], tc1[14], ts0[19], tc0[11], tc1[18]);
    full_adder f04 (p[9][7], p[10][6], tc1[15], ts0[20], tc1[19]);
    half_adder h05 (p[11][5], tc1[16], ts0[21], tc1[20]);

    compressor c11 (p[2][15], p[3][14], p[4][13], p[5][12], tc1[17], ts0[22], tc0[12], tc1[21]); //14
    compressor c12 (p[6][11], p[7][10], p[8][9], p[9][8], tc1[18], ts0[23], tc0[13], tc1[22]);
    full_adder f05 (p[10][7], tc1[19], tc1[20], ts0[24], tc1[23]);

    compressor c13 (p[3][15], p[4][14], p[5][13], p[6][12], tc1[21], ts0[25], tc0[14], tc1[24]); //13
    compressor c14 (p[7][11], p[8][10], p[9][9], tc1[22], tc1[23], ts0[26], tc0[15], tc1[25]);

    compressor c15 (p[4][15], p[5][14], p[6][13], p[7][12], tc1[24], ts0[27], tc0[16], tc1[26]); //12
    full_adder f06 (p[8][11], p[9][10], tc1[25], ts0[28], tc1[27]);

    compressor c16 (p[5][15], p[6][14], p[7][13], p[8][12], tc1[26], ts0[29], tc0[17], tc1[28]); //11
    half_adder h06 (p[9][11], tc1[27], ts0[30], tc1[29]);

    compressor c17 (p[6][15], p[7][14], p[8][13], p[9][12], tc1[28], ts0[31], tc0[18], tc1[30]); //10

    full_adder f07 (p[7][15], p[8][14], tc1[30], ts0[32], tc0[19]); //9

    half_adder h07 (p[8][15], 1'b0, ts0[33], tc0[20]); //8 here

    //level 2

    half_adder h100 (p[0][4], p[1][3], ts1[0], tc3[0]); //5

    full_adder f100 (p[0][5], p[1][4], tc3[0], ts1[1], tc2[0]); //6
    half_adder h101 (p[2][3], p[3][2], ts1[2], tc3[1]);

    compressor c100 (p[0][6], p[1][5], p[2][4], p[3][3], tc3[1], ts1[3], tc2[1], tc3[2]); //7
    half_adder h102 (p[4][2], p[5][1], ts1[4], tc3[3]);



    compressor c101 (p[0][7], p[1][6], p[2][5], p[3][4], tc3[2], ts1[5], tc2[2], tc3[4]); //8
    full_adder f101 (p[4][3], p[5][2], tc3[3], ts1[6], tc3[5]);

    //old stage addition begins

    compressor E101 (ts0[0], p[2][6], p[3][5], p[4][4], tc3[4], ts1[7], tc2[3], tc3[6]); //8
    full_adder f102 (p[5][3], p[6][2], tc3[5], ts1[8], tc3[7]);

    compressor c102 (ts0[1], ts0[2], p[4][5], p[5][4], tc3[6], ts1[9], tc2[4], tc3[8]); //8
    full_adder f103 (p[6][3], p[7][2], tc3[7], ts1[10], tc3[9]);

    compressor c103 (ts0[3], ts0[4], tc0[0], p[6][4], tc3[8], ts1[11], tc2[5], tc3[10]); //7
    full_adder f104 (p[7][3], p[8][2], tc3[9], ts1[12], tc3[11]);
    half_adder h103 (p[9][1], p[10][0], ts1[13], tc3[12]);

    compressor c104 (ts0[5], ts0[6], tc0[1], p[6][5], tc3[10], ts1[14], tc2[6], tc3[13]); //8
    compressor c105 (p[7][4], p[8][3], p[9][2], tc3[11], tc3[12], ts1[15], tc2[7], tc3[14]);


    compressor c106 (ts0[7], ts0[8], tse[0], tc0[2], tc3[13], ts1[16], tc2[8], tc3[15]); //8
    full_adder f106 (p[8][4], p[9][3], tc3[14], ts1[17], tc3[16]);
    half_adder h104 (p[10][2], p[11][1], ts1[18], tc3[17]);

    compressor c107 (ts0[9], ts0[10], tc0[3], tce[0], tc3[15], ts1[19], tc2[9], tc3[18]); //8
    compressor c108 (p[8][5], p[9][4], p[10][3], p[11][2], tc3[16], ts1[20], tc2[10], tc3[19]);
    half_adder h105 (p[12][1], tc3[17], ts1[21], tc3[20]);

    compressor c109 (ts0[11], ts0[12], tc0[4], tc0[5], tc3[18], ts1[22], tc2[11], tc3[21]); //8
    compressor c110 (ts0[13], p[10][4], p[11][3], p[12][2], tc3[19], ts1[23], tc2[12], tc3[22]);
    half_adder h106 (p[13][1], tc3[20], ts1[24], tc3[23]);

    compressor c111 (ts0[14], ts0[15], tc0[6], tc0[7], tc3[21], ts1[25], tc2[13], tc3[24]); //8
    compressor c112 (ts0[16], ts0[17], p[12][3], p[13][2], tc3[22], ts1[26], tc2[14], tc3[25]);
    half_adder h107 (p[14][1], tc3[23], ts1[27], tc3[26]);

    compressor c113 (ts0[18], ts0[19], tc0[8], tc0[9], tc3[24], ts1[28], tc2[15], tc3[27]); //8
    compressor c114 (ts0[20], ts0[21], p[12][4], p[13][3], tc3[25], ts1[29], tc2[16], tc3[28]);
    half_adder h108 (p[14][2], tc3[26], ts1[30], tc3[29]);

    compressor c115 (ts0[22], ts0[23], tc0[10], tc0[11], tc3[27], ts1[31], tc2[17], tc3[30]); //8
    compressor c116 (ts0[24], p[11][6], p[12][5], p[13][4], tc3[28], ts1[32], tc2[18], tc3[31]);
    half_adder h109 (p[14][3], tc3[29], ts1[33], tc3[32]);

    compressor c117 (ts0[25], ts0[26], tc0[12], tc0[13], tc3[30], ts1[34], tc2[19], tc3[33]); //8
    compressor c118 (p[10][8], p[11][7], p[12][6], p[13][5], tc3[31], ts1[35], tc2[20], tc3[34]);
    half_adder h110 (p[14][4], tc3[32], ts1[36], tc3[35]);

    compressor c119 (ts0[27], ts0[28], tc0[14], tc0[15], tc3[33], ts1[37], tc2[21], tc3[36]); //8
    compressor c120 (p[10][9], p[11][8], p[12][7], p[13][6], tc3[34], ts1[38], tc2[22], tc3[37]);
    half_adder E110 (p[14][5], tc3[35], ts1[39], tc3[38]);

    compressor c121 (ts0[29], ts0[30], tc0[16], p[10][10], tc3[36], ts1[40], tc2[23], tc3[39]); //8
    compressor c122 (p[11][9], p[12][8], p[13][7], tc3[37], tc3[38], ts1[41], tc2[24], tc3[40]);

    compressor c123 (ts0[31], tc0[17], p[10][11], p[11][10], tc3[39], ts1[42], tc2[25], tc3[41]); //8
    full_adder f107 (p[12][9], p[13][8], tc3[40], ts1[43], tc3[42]);
    half_adder h111 (p[14][7], p[15][6], ts1[44], tc3[43]);

    compressor c124 (ts0[32], tc0[18], p[9][13], p[10][12], tc3[41], ts1[45], tc2[26], tc3[44]); //8
    compressor c125 (p[11][11], p[12][10], p[13][9], tc3[42], tc3[43], ts1[46], tc2[27], tc3[45]);

    compressor c126 (ts0[33], tc0[19], p[9][14], p[10][13], tc3[44], ts1[47], tc2[28], tc3[46]); //8
    half_adder h112 (p[11][12], tc3[45], ts1[48], tc3[47]);

    compressor c127 (tc0[20], p[9][15], p[10][14], p[11][13], tc3[46], ts1[49], tc2[29], tc3[48]); //7
    full_adder f108 (p[12][12], p[13][11], tc3[47], ts1[50], tc3[49]);

    compressor c128 (p[10][15], p[11][14], p[12][13], tc3[48], tc3[49], ts1[51], tc2[30], tc3[50]); //6

    full_adder f109 (p[11][15], p[12][14], tc3[50], ts1[52], tc3[51]); //5

    half_adder h113 (p[12][15], tc3[51], ts1[53], tc3[52]); //4

    // level 3

    half_adder h200 (p[0][2], p[1][1], ts2[0], tc5[0]); //3

    full_adder f200 (p[0][3], p[1][2], tc5[0], ts2[1], tc5[1]); //4
    half_adder h201 (p[2][1], p[3][0], ts2[2], tc5[2]);

    //old 2nd stage addition begins

    compressor c200 (ts1[0], p[2][2], p[3][1], tc5[1], tc5[2], ts2[3], tc5[3], tc5[4]); //4

    compressor c201 (ts1[1], ts1[2], p[4][1], tc5[3], tc5[4], ts2[4], tc5[5], tc5[6]); //4

    compressor c202 (ts1[3], ts1[4], tc2[0], tc5[5], tc5[6], ts2[5], tc5[7], tc5[8]); //3


    compressor c203 (ts1[5], ts1[6], tc2[1], tc5[7], tc5[8], ts2[6], tc5[9], tc5[10]); //4
    half_adder h202 (p[6][1], p[7][0], ts2[7], tc5[11]);

    //old 2nd stage + 1st stage
    compressor c204 (ts1[7], ts1[8], tc2[2], tc5[9], tc5[10], ts2[8], tc5[12], tc5[13]); //4
    full_adder f202 (p[7][1], p[8][0], tc5[11], ts2[9], tc5[14]);

    compressor c205 (ts1[9], ts1[10], tc2[3], tc5[12], tc5[13], ts2[10], tc5[15], tc5[16]); //4
    full_adder E202 (p[8][1], p[9][0], tc5[14], ts2[11], tc5[17]);

    compressor  c206 (ts1[11], ts1[12], ts1[13], tc2[4], tc5[15], ts2[12], tc5[18], tc5[19]); //3
    half_adder E01 (tc5[16], tc5[17], tse[1], tce[1]);


    compressor  c207 (ts1[14], ts1[15], tc2[5], tc5[18], tc5[19], ts2[13], tc5[20], tc5[21]); //4
    full_adder E02 (p[10][1], p[11][0], tce[1], ts2[14], tc5[22]);

    compressor  c208 (ts1[16], ts1[17], ts1[18], tc2[6], tc5[20], ts2[15], tc5[23], tc5[24]); //4
    full_adder f203 (p[12][0], tc5[21], tc5[22], tse[2], tce[2]);//error adding
    half_adder EE0 (tse[2], tc2[7], ts2[16], tc5[25]); //error fixing

    compressor  c209 (ts1[19], ts1[20], ts1[21], tc2[8], tc5[23], ts2[17], tc5[26], tc5[27]); //4
    full_adder f204 (p[13][0], tc5[24], tc5[25], tse[3], tce[3]); //error adding
    half_adder HE0 (tse[3], tce[2], ts2[18], tc5[28]); //added due to error

    compressor  c210 (ts1[22], ts1[23], ts1[24], tc2[9], tc5[26], ts2[19], tc5[29], tc5[30]); //4
    full_adder E204 (p[14][0], tc5[27], tc5[28], ts2[20], tc5[31]);
    full_adder FE0 (ts2[20], tc2[10], tce[3], ts2[21], tc5[32]);


    compressor c211 (ts1[25], ts1[26], ts1[27], tc2[11], tc5[29], ts2[23], tc5[33], tc5[34]); //4
    compressor c212 (p[15][0], tc5[30], tc5[31], tc5[32], tc2[12], ts2[24], tc5[35], tc5[36]);

    compressor c213 (ts1[28], ts1[29], ts1[30], tc2[13], tc5[33], ts2[25], tc5[37], tc5[38]); //4
    compressor c214 (p[15][1], tc5[34], tc5[35], tc5[36], tc2[14], ts2[26], tc5[39], tc5[40]);

    compressor c215 (ts1[31], ts1[32], ts1[33], tc2[15], tc5[37], ts2[27], tc5[41], tc5[42]); //4
    compressor c216 (p[15][2], tc5[38], tc5[39], tc5[40], tc2[16], ts2[28], tc5[43], tc5[44]);

    compressor c217 (ts1[34], ts1[35], ts1[36], tc2[17], tc5[41], ts2[29], tc5[45], tc5[46]); //4
    compressor c218 (p[15][3], tc5[42], tc5[43], tc5[44], tc2[18], ts2[30], tc5[47], tc5[48]);

    compressor c219 (ts1[37], ts1[38], ts1[39], tc2[19], tc5[45], ts2[31], tc5[49], tc5[50]); //4
    compressor c220 (p[15][4], tc5[46], tc5[47], tc5[48], tc2[20], ts2[32], tc5[51], tc5[52]);

    compressor c221 (ts1[40], ts1[41], tc2[21], tc2[22], tc5[49], ts2[33], tc5[53], tc5[54]); //4
    compressor c222 (p[14][6], p[15][5], tc5[50], tc5[51], tc5[52], ts2[34], tc5[55], tc5[56]);

    compressor c223 (ts1[42], ts1[43], ts1[44], tc2[23], tc5[53], ts2[35], tc5[57], tc5[58]); //4
    compressor c224 (tc1[29], tc5[54], tc5[55], tc5[56], tc2[24], ts2[36], tc5[59], tc5[60]);

    compressor c225 (ts1[45], ts1[46], tc2[25], p[14][8], tc5[57], ts2[37], tc5[61], tc5[62]); //4
    compressor c226 (p[15][7], tc5[58], tc5[59], tc5[60], 1'b0, ts2[38], tc5[63], tc5[64]);

    compressor c227 (ts1[47], ts1[48], tc2[26], p[12][11], tc5[61], ts2[39], tc5[65], tc5[66]); //6
    compressor c228 (p[13][10], tc5[62], tc5[63], tc5[64], tc2[27], ts2[40], tc5[67], tc5[68]);
    full_adder f205 (p[14][9], p[15][8], ts2[40], ts2[41], tc5[69]);

    compressor c229 (ts1[49], ts1[50], tc2[28], p[14][10], tc5[65], ts2[42], tc5[70], tc5[71]); //4
    compressor c230 (p[15][9], tc5[69], tc5[66], tc5[67], tc5[68], ts2[43], tc5[72], tc5[73]);

    compressor c231 (ts1[51], tc2[29], p[13][12], p[14][11], tc5[70], ts2[44], tc5[74], tc5[75]); //4
    compressor c232 (p[15][10], tc5[71], tc5[72], tc5[73], 1'b0, ts2[45], tc5[76], tc5[77]);

    compressor c233 (ts1[52], tc2[30], p[13][13], p[14][12], tc5[74], ts2[46], tc5[78], tc5[79]); //4
    compressor c234 (p[15][11], tc5[75], tc5[76], tc5[77], 1'b0, ts2[47], tc5[80], tc5[81]);

    compressor c235 (ts1[53], p[13][14], p[14][13], p[15][12], tc5[78], ts2[48], tc5[82], tc5[83]); //4
    full_adder f206 (tc5[79], tc5[80], tc5[81], ts2[49], tc5[84]);

    compressor c236 (p[13][15], p[14][14], p[15][13], tc3[52], tc5[82], ts2[50], tc5[85], tc5[86]); //3
    full_adder f207 (tc5[83], tc5[84], 1'b0, ts2[51], tc5[87]);

    compressor c237 (p[14][15], p[15][14], tc5[85], tc5[86], tc5[87], ts2[52], tc5[88], tc5[89]);

    full_adder f208 (p[15][15], tc5[88], tc5[89], ts2[53], tc5[90]);



    wire [31:0] p1, p2;

    assign p1[0] = p[0][0];
    assign p1[1] = p[0][1];
    assign p1[2] = ts2[0];
    assign p1[3] = ts2[1];
    assign p1[4] = ts2[3];
    assign p1[5] = ts2[4];
    assign p1[6] = ts2[5];
    assign p1[7] = ts2[6];
    assign p1[8] = ts2[8];
    assign p1[9] = ts2[10];
    assign p1[10] = ts2[12];
    assign p1[11] = ts2[13];
    assign p1[12] = ts2[15];
    assign p1[13] = ts2[17];
    assign p1[14] = ts2[19];
    assign p1[15] = ts2[23];
    assign p1[16] = ts2[25];
    assign p1[17] = ts2[27];
    assign p1[18] = ts2[29];
    assign p1[19] = ts2[31];
    assign p1[20] = ts2[33];
    assign p1[21] = ts2[35];
    assign p1[22] = ts2[37];
    assign p1[23] = ts2[39];
    assign p1[24] = ts2[42];
    assign p1[25] = ts2[44];
    assign p1[26] = ts2[46];
    assign p1[27] = ts2[48];
    assign p1[28] = ts2[50];
    assign p1[29] = ts2[52];
    assign p1[30] = ts2[53];
    assign p1[31] = tc5[90];




    assign p2[0] = 0;
    assign p2[1] = p[1][0];
    assign p2[2] = p[2][0];
    assign p2[3] = ts2[2];
    assign p2[4] = p[4][0];
    assign p2[5] = p[5][0];
    assign p2[6] = p[6][0];
    assign p2[7] = ts2[7];
    assign p2[8] = ts2[9];
    assign p2[9] = ts2[11];
    assign p2[10] = tse[1];
    assign p2[11] = ts2[14];
    assign p2[12] = ts2[16];
    assign p2[13] = ts2[18];
    assign p2[14] = ts2[21];
    assign p2[15] = ts2[24];
    assign p2[16] = ts2[26];
    assign p2[17] = ts2[28];
    assign p2[18] = ts2[30];
    assign p2[19] = ts2[32];
    assign p2[20] = ts2[34];
    assign p2[21] = ts2[36];
    assign p2[22] = ts2[38];
    assign p2[23] = ts2[41];
    assign p2[24] = ts2[43];
    assign p2[25] = ts2[45];
    assign p2[26] = ts2[47];
    assign p2[27] = ts2[49];
    assign p2[28] = ts2[51];
    assign p2[29] = 0;
    assign p2[30] = 0;
    assign p2[31] = 0;

    wire [31:0] multiplication;


    Adder32 add_0(p1, p2, 1'b0, multiplication, prop, g, c);
    

    assign y = multiplication;



endmodule
