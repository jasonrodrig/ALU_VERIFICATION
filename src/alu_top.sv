`include "alu_test.sv"
`include "alu_interface.sv"
`include "alu_design.v"

module alu_top;

        //import alu_pkg ::*;
        bit clk , rst, ce;

  initial begin
          clk = 0;
          forever #10 clk = ~clk;
   end

        initial begin
        /*repeat(1) @(posedge clk);
                rst = 0; ce = 0;
                repeat(1) @(posedge clk);
                rst = 0; ce = 1;
                repeat(1) @(posedge clk);
                rst = 1; ce = 0;
                repeat(1) @(posedge clk);
                rst = 1; ce = 1;
                */
        //      repeat(1) @(posedge clk);
                //rst = 1 ;ce = 0;
                //#10;
                rst = 0; ce = 1;
        end

        alu_interface vif(clk,rst,ce);

        ALU_DESIGN duv ( .CLK(vif.clk), .RST(vif.rst), .CE(vif.ce), .INP_VALID(vif.inp_valid), .MODE(vif.mode),
                        .CMD(vif.cmd), .OPA(vif.opa), .OPB(vif.opb), .CIN(vif.cin), .RES(vif.res),
                        .OFLOW(vif.oflow), .COUT(vif.cout), .G(vif.g), .E(vif.e), .L(vif.l), .ERR(vif.err)
                );

        alu_test tb = new( vif.driv , vif.mon , vif.reference);

  initial begin
                tb.run();
                $finish;
        end

endmodule
