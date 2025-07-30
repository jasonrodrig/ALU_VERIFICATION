//`include "defines.sv"
`include "alu_transaction.sv"
`include "alu_generator.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_scoreboard.sv"
`include "reference_model.sv"
//`include "alu_transaction.sv"

class alu_environment;

	virtual alu_interface driver;
	virtual alu_interface monitor;
	virtual alu_interface reference;

	mailbox #(alu_transaction) gen2driv;
	mailbox #(alu_transaction) mon2scb;
	mailbox #(alu_transaction) ref2scb;
	mailbox #(alu_transaction) driv2ref;

	alu_generator       gen;
	alu_driver          driv; 
	alu_monitor         mon;
	alu_scoreboard      scb;
	alu_reference_model ref_model;
	
	function new(
              virtual alu_interface driver,
              virtual alu_interface monitor,
              virtual alu_interface reference
            );

             this.driver    = driver;
             this.monitor   = monitor;
             this.reference = reference;
 
  endfunction

	task build();
		begin
		
			gen2driv = new();
			mon2scb  = new();
			ref2scb  = new();
			driv2ref = new();

			gen       = new( gen2driv                        );
			driv      = new( gen2driv , driv2ref , driver    );
			mon       = new( mon2scb  ,            monitor   );
			scb       = new( mon2scb  , ref2scb              );
			ref_model = new( driv2ref , ref2scb  , reference );
			
		end
	endtask

	task start();
		fork
		
		 gen.start();
		 driv.start();
		 mon.start();
		 scb.start();
		 ref_model.start();
		
		join
	endtask

endclass



