//`include "defines.sv"
interface alu_interface(input bit clk, rst ,ce);
	
	logic [ `DATA_WIDTH - 1 : 0 ] opa , opb ;
	logic cin, mode ;//, ce;
	logic [1:0] inp_valid;
	logic [ `CMD_WIDTH - 1 : 0 ] cmd;
	wire [ RESULT_WIDTH - 1 : 0 ] res;
	wire oflow , cout , g , l , e , err;

	clocking driv_cb@(posedge clk);
		default input #0 output #0;
		input rst, ce;
		output opa , opb , cin , mode , cmd , inp_valid;
	endclocking

  clocking mon_cb@(posedge clk);
		default input #0 output #0;
		input rst, ce;
		input opa , opb , cin , mode , cmd , inp_valid;
		input res , oflow , cout , g , l , e , err;
	endclocking

  clocking reference_cb@(posedge clk);
		default input #0 output #0;
		input rst, ce;
		input opa , opb , cin , mode , cmd , inp_valid;
		output res , oflow , cout , g , l , e , err;
	endclocking

	modport driv(clocking driv_cb);
	modport mon(clocking mon_cb);
	modport reference(clocking reference_cb);

endinterface
