`include "dadda.v"

module top;
reg  [16:1]a,b;

wire  [32:1] c;
wire  [32:1] d;
wire  [32:1] e;


dadda_multiplier w_0(a,b,c);

initial
begin 
#4  a=23479; b=23415;
#9  a=24; b=10;
#12  a=34543; b=0;

end

initial
 begin
    $display("NOTE: Inputs works as unsigned numbers and time delay of 4 seconds are there\n");
     $monitor($time," Input bts:Multiplier=%d and Multiplicand =%d;\n\t\t\t\tOutput:\n\t\t\t\tExponential form=%e\n\t\t\t\tDecimal form=%d\n",a,b,c,c);
     $dumpfile("dadda.vcd");
     $dumpvars;
 
end
endmodule
