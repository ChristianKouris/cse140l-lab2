// CSE140L  Fall 2019
// What does this do? 
// When does "z" go high? Should it have gone high earlier,
//   since it "kicks" the next higher counter? How would we 
//   do this? 
module ct_mod24(
  input clk, rst, en,
  output logic[6:0] ct_out,
  output logic      z);
  logic[6:0] ctq;

  always_ff @(posedge clk)
    if(rst)
	  ct_out <= 0;
	else if(en)
	  ct_out <= (ct_out+1)%(7'd24);	  // modulo operator
  always_ff @(posedge clk)
    if(rst) 
	  ctq <= 0;
	else
	  ctq    <= ct_out;
  assign z = ctq && !ct_out;
//  assign   z = !ct_out;
  //always_comb z = !ct_out;	  // always @(*)   // always @(ct_out)

endmodule



