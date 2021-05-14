module kpg(x,ai,bi);

input ai,bi;
output reg[7:0] x;

always @(ai or bi)
if(ai==bi)
begin
if(ai==0)
    x="k";
else
    x="g";
end
else
    x="p";

endmodule
