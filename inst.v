module DUT(
	input wire clk,rst,en,kin_enc,
	input wire [7:0] din_enc,
	output wire kin_err,disp_enc,disp_dec,kout,code_err,disp_err,
	output wire [7:0] dout_dec
);
wire [9:0] dout_enc;
wire [9:0] din_dec;
  encoder_8b10  enc(clk,rst,en,kin_enc,din_enc,din_dec,disp_enc,kin_err);
decoder_8b10b  dec(clk,rst,en,din_dec,dout_dec,kout,code_err,disp_dec,disp_err);
assign din_dec=dout_enc;
endmodule