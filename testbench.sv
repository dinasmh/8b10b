class data;
  rand bit [7:0] data_in;
  rand bit kin;
  constraint cnst{
    (kin==1'b1)->(data_in inside{28,60,92,124,156,188,220,247,251,252,253,254});
    solve kin before data_in;
  };
  function void print;
    $display("K_in=%b",kin);
    $display("Data in=%b",data_in);
  endfunction
endclass

`include "inst.sv"
    
module top;
  
  reg clk,rst,en,kin_enc;
  reg[7:0]din_enc;
  wire kin_err,disp_err,disp_dec,kout,code_err;
  wire[7:0]dout_dec;
  
  DUT  dut(clk,rst,en,kin_enc,din_enc,kin_err,disp_enc,disp_dec,kout,code_err,disp_err,dout_dec);
 
  data dt; //creating dt handle from data class
  
  initial begin
    clk=0;
    forever
      #1 clk=~clk;
  end
  
  initial begin
    
    rst=0;
	en=0;
    repeat(2)@(posedge clk); //wait for 2 clk cycles
	rst=1;
	en=0;
    repeat(2)@(posedge clk);
    rst=0;
	din_enc=8'b00000000;
	kin_enc=1'b0;
    repeat(2)@(posedge clk);
    en=1;
    repeat(2)@(posedge clk);
    
    dt=new(); 
    
    forever begin
      
      assert(dt.randomize()); //to ensure the randomisation success before getting to the rest of the code 
      
      /* To test for K-symbol error, comment on the forever begin/end lines and the randomize() function call*/
      /* The assigned values that result in a K-symbol error */
      /*dt.data_in=20;
      dt.kin=1;*/
      
      
      din_enc=dt.data_in;
  	  kin_enc=dt.kin;
      dt.print();
      
      repeat(4)@(posedge clk); //delay for enc (2 clk cycles) and dec (2 clk cycles)
      
      $display("Dout_dec==%b",dout_dec); 
      
      if((dout_dec!==din_enc))begin
        $display("Data error");
        $display("din_enc=%b, dout_dec=%b",din_enc,dout_dec);
        $display("K_in=%b",dt.kin);
        $display("K_out=%b",kout);
        //$stop;
      end
      if(disp_err===1)begin
        $display("Disparity error");
        $display("din_enc=%b, dout_dec=%b",din_enc,dout_dec);
        $display("disp_enc=%b",disp_enc);
        $display("disp_dec=%b",disp_dec);
        //$stop;
      end
    if(kin_err===1)begin
        $display("K error");
        $display("din_enc=%b, dout_dec=%b",din_enc,dout_dec);
        $display("K_in=%b",dt.kin);
        $display("K_out=%b",kout);
        $stop;
    	end
    end
  end
endmodule