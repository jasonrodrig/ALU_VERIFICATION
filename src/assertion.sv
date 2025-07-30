//`include "defines.sv"
module alu_assertion(clk,rst,ce,opa,opb,mode,inp_valid,cmd,cin,res);
  input clk;
  input rst;
  input ce;
  input [`DATA_WIDTH - 1 : 0] opa;
  input [`DATA_WIDTH - 1 : 0]opb;
  input mode;
  input [1:0] inp_valid;
  input [`CMD_WIDTH - 1 : 0]cmd;
  input cin;
  input [ ( 2 * `DATA_WIDTH ) - 1 : 0]res;
	ALU_reset: assert property (@(posedge clk) !rst) else $info("RESET IS TRIGGERED");

	property ALU_unknown;
    @(posedge clk) !($isunknown({rst,ce,opa,opb,mode,inp_valid,cmd,cin}));
  endproperty

	ALU_UNKNOWN: assert property(ALU_unknown) begin
							 $info("INPUTS ARE KNOWN");
	             end
	             else $error("INPUTS ARE UNKNOWN");
  
  property ALU_state;
		@(posedge clk) ce |=> ##3res; //== $past(res);
  endproperty
	ALU_SAME_STATE: assert property(ALU_state) begin
		              $error("OUTPUTS NOT CHANGED");
									end
	                else $info("OUTPUT CHANGED");

endmodule
