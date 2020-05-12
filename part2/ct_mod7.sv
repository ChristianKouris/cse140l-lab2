// moduo N counter
module ct_mod7(
  input clk, 
        rst,                   // 1: reset 
        en,					       // 1: advance
  output logic[6:0] ct_out,
  output logic      z);  // "carry flag"
  logic[6:0] ctq;

  always_ff @(posedge clk)
    if(rst)
	  ct_out <= 0;
	else if(en) 
	  ct_out <= (ct_out+1)%(7'd7);
  always_ff @(posedge clk)
    if(rst) 
	  ctq <= 0;
	else
	  ctq    <= ct_out;
  assign z = ctq && !ct_out;
endmodule
