// CSE140L  Fall 2019
// see Structural Diagram in Lab2.pdf
module struct_diag(
  input Reset,
        Timeset, 	  // manual buttons
        Alarmset,	  //	(five total)
		Minadv,
		Hrsadv,
		Alarmon,
		Pulse,		  // assume 1/sec.
// 6 decimal digit display (7 segment)
  output [6:0] S1disp, S0disp, 
    M1disp, M0disp, H1disp, H0disp,
  output logic Buzz);	  // alarm sounds
  logic[6:0] TSec, TMin, THrs, AMin, AHrs;
  logic[6:0] Min, Hrs;
  logic Szero, Mzero, Hzero, TMen, THen, AMen, AHen, tmp; 

// free-running seconds counter
  ct_mod60 Sct(
    .clk(Pulse), .rst(Reset), .en(1'b1), .ct_out(TSec), .z(Szero)
    );
// minutes counter -- runs at either 1/sec or 1/60sec
  assign TMen = (Timeset && Minadv) ? Pulse : Szero;
  ct_mod60 Mct(
    .clk(Pulse), .rst(Reset), .en(TMen), .ct_out(TMin), .z(Mzero)
    );
// hours counter -- runs at either 1/sec or 1/60min
  assign THen = (Timeset && Hrsadv) ? Pulse : Mzero;
  ct_mod24 Hct(
	.clk(Pulse), .rst(Reset), .en(THen), .ct_out(THrs), .z(Hzero)
    );
// alarm set registers -- either hold or advance 1/sec
  assign AMen = Alarmset && Minadv;
  ct_mod60 Mreg(
    .clk(Pulse), .rst(Reset), .en(AMen), .ct_out(AMin), .z()
    ); 

  assign AHen = Alarmset && Hrsadv;
  ct_mod24 Hreg(
    .clk(Pulse), .rst(Reset), .en(AHen), .ct_out(AHrs), .z()
    ); 

// display drivers (2 digits each, 6 digits total)
  lcd_int Sdisp(
    .bin_in (TSec)  ,
	.Segment1  (S1disp),
	.Segment0  (S0disp)
	);

  assign Min = Alarmset ? AMin : TMin;
  lcd_int Mdisp(
    .bin_in (Min) ,
	.Segment1  (M1disp),
	.Segment0  (M0disp)
	);

  assign Hrs = Alarmset ? AHrs : THrs;
  lcd_int Hdisp(
    .bin_in (Hrs),
	.Segment1  (H1disp),
	.Segment0  (H0disp)
	);

// buzz off :)
  alarm a1(
    .tmin(TMin), .amin(AMin), .thrs(THrs), .ahrs(AHrs), .buzz(tmp)
	);
	
  assign Buzz = Alarmon && tmp;

endmodule