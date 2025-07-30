`include "alu_environment.sv"

class alu_test;

	virtual alu_interface driv_vif;
	virtual alu_interface mon_vif;
	virtual alu_interface ref_vif;

	alu_environment env;

  function new(	virtual alu_interface driv_vif,
	              virtual alu_interface mon_vif,
             		virtual alu_interface ref_vif);
  
	this.driv_vif = driv_vif;
	this.mon_vif  = mon_vif;
	this.ref_vif  = ref_vif;
  
  endfunction
  
	task run();
   env = new( driv_vif , mon_vif , ref_vif  );
   env.build;
	 env.start;	
	endtask

endclass
