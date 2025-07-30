//`include"defines.sv"
//`include "alu_transaction.sv"
class alu_monitor;

	alu_transaction monitor_trans;
	mailbox #(alu_transaction) mon2scb;
	virtual alu_interface.mon_cb vif;

	covergroup output_coverage;
		OFLOW:        coverpoint monitor_trans.oflow     { bins oflow[] = { 0 , 1 }; }
		COUT:         coverpoint monitor_trans.cout      { bins cout[]  = { 0 , 1 }; }
		GREATER:      coverpoint monitor_trans.g         { bins g[]     = { 0 , 1 }; }
		LESSER:       coverpoint monitor_trans.l         { bins l[]     = { 0 , 1 }; }
		EQUAL:        coverpoint monitor_trans.e         { bins e[]     = { 0 , 1 }; }
		ERROR:        coverpoint monitor_trans.err       { bins err[]   = { 0 , 1 }; }
	endgroup

	function new(
		mailbox #(alu_transaction) mon2scb,
		virtual alu_interface.mon_cb vif
	);
		this.mon2scb = mon2scb;
		this.vif     = vif;
		output_coverage = new();
	endfunction

	
	task start();

		repeat(3) @(vif.mon_cb);

		for( int i = 0; i < `no_of_transaction; i++)
		begin

			monitor_trans = new();
			monitor_trans.display("MONITOR STARTED");
			repeat(2) @(vif.mon_cb);
			begin
			
			if(vif.mon_cb.inp_valid == 3 || vif.mon_cb.inp_valid == 0 ) 
			begin
				if( vif.mon_cb.mode == 1 && vif.mon_cb.inp_valid == 3 && ( ( vif.mon_cb.cmd == 9 ) ||
					( vif.mon_cb.cmd == 10 ) ) )
				begin
					$display("multiplication operation");
					repeat(1)@(vif.mon_cb);
					monitor_trans.opa       = vif.mon_cb.opa;
					monitor_trans.opb       = vif.mon_cb.opb;
					monitor_trans.cin       = vif.mon_cb.cin;
					monitor_trans.mode      = vif.mon_cb.mode;
					monitor_trans.cmd       = vif.mon_cb.cmd;
					monitor_trans.inp_valid = vif.mon_cb.inp_valid;
					//@(vif.mon_cb);
					monitor_trans.res       = vif.mon_cb.res;
					monitor_trans.oflow     = vif.mon_cb.oflow;
					monitor_trans.cout      = vif.mon_cb.cout;
					monitor_trans.g         = vif.mon_cb.g;
					monitor_trans.l         = vif.mon_cb.l;
					monitor_trans.e         = vif.mon_cb.e;
					monitor_trans.err       = vif.mon_cb.err;
					mon2scb.put(monitor_trans);
					output_coverage.sample();
					monitor_trans.display("MONITOR SIGNALS ENDED");
					repeat(2) @(vif.mon_cb);
					monitor_trans.display("Monitor delay");
				end //for normal cmd 9or 10
				else begin
					monitor_trans.opa       = vif.mon_cb.opa;
					monitor_trans.opb       = vif.mon_cb.opb;
					monitor_trans.cin       = vif.mon_cb.cin;
					monitor_trans.mode      = vif.mon_cb.mode;
					monitor_trans.cmd       = vif.mon_cb.cmd;
					monitor_trans.inp_valid = vif.mon_cb.inp_valid;
					//@(vif.mon_cb);
					monitor_trans.res       = vif.mon_cb.res;
					monitor_trans.oflow     = vif.mon_cb.oflow;
					monitor_trans.cout      = vif.mon_cb.cout;
					monitor_trans.g         = vif.mon_cb.g;
					monitor_trans.l         = vif.mon_cb.l;
					monitor_trans.e         = vif.mon_cb.e;
					monitor_trans.err       = vif.mon_cb.err;
					mon2scb.put(monitor_trans);
					output_coverage.sample();
          monitor_trans.display("MONITOR SIGNALS ENDED");
					repeat(2) @(vif.mon_cb);
					monitor_trans.display("Monitor delay");
				end // for normal without 9 or 10
			end //main_if
			else begin
				if( ( vif.mon_cb.mode == 0 ) && ( ( vif.mon_cb.cmd == 6 ) || ( vif.mon_cb.cmd == 7 ) ||                            	 ( vif.mon_cb.cmd == 8 ) 	||   ( vif.mon_cb.cmd == 9 ) || ( vif.mon_cb.cmd == 10) ||                            	( vif.mon_cb.cmd == 11) ) )
				begin
         	monitor_trans.opa       = vif.mon_cb.opa;
					monitor_trans.opb       = vif.mon_cb.opb;
					monitor_trans.cin       = vif.mon_cb.cin;
					monitor_trans.mode      = vif.mon_cb.mode;
					monitor_trans.cmd       = vif.mon_cb.cmd;
					monitor_trans.inp_valid = vif.mon_cb.inp_valid;
					//@(vif.mon_cb);
					monitor_trans.res       = vif.mon_cb.res;
					monitor_trans.oflow     = vif.mon_cb.oflow;
					monitor_trans.cout      = vif.mon_cb.cout;
					monitor_trans.g         = vif.mon_cb.g;
					monitor_trans.l         = vif.mon_cb.l;
					monitor_trans.e         = vif.mon_cb.e;
					monitor_trans.err       = vif.mon_cb.err;
					mon2scb.put(monitor_trans);
					output_coverage.sample();
					monitor_trans.display("MONITOR SIGNALS ENDED");
					repeat(2) @(vif.mon_cb);
					monitor_trans.display("Monitor delay");
        end // single operand mode0
				else if( ( vif.mon_cb.mode == 1 ) && ( ( vif.mon_cb.cmd == 4 ) || ( vif.mon_cb.cmd == 5 ) ||                            	 ( vif.mon_cb.cmd == 6 ) ||   ( vif.mon_cb.cmd == 7 ) ) )
				begin
        	monitor_trans.opa       = vif.mon_cb.opa;
					monitor_trans.opb       = vif.mon_cb.opb;
					monitor_trans.cin       = vif.mon_cb.cin;
					monitor_trans.mode      = vif.mon_cb.mode;
					monitor_trans.cmd       = vif.mon_cb.cmd;
					monitor_trans.inp_valid = vif.mon_cb.inp_valid;
					//@(vif.mon_cb);
					monitor_trans.res       = vif.mon_cb.res;
					monitor_trans.oflow     = vif.mon_cb.oflow;
					monitor_trans.cout      = vif.mon_cb.cout;
					monitor_trans.g         = vif.mon_cb.g;
					monitor_trans.l         = vif.mon_cb.l;
					monitor_trans.e         = vif.mon_cb.e;
					monitor_trans.err       = vif.mon_cb.err;
					output_coverage.sample();
					mon2scb.put(monitor_trans);
					monitor_trans.display("MONITOR SIGNALS ENDED");
					repeat(2) @(vif.mon_cb);
					monitor_trans.display("Monitor delay");
				end// single operand mode1
				else begin
					for(int count = 0; count < 16; count++ )
					begin
						//@(vif.mon_cb);
						$display("monitor count = %d",count + 1);
						if(count == 15)
						begin
							if( vif.mon_cb.inp_valid == 3 )
							begin
								repeat(1)@(vif.mon_cb);
								count = 0;
								if( ( vif.mon_cb.mode == 1 ) && ( vif.mon_cb.cmd == 9 || vif.mon_cb.cmd == 10 ) )
									begin
									$display("multiplication operation");
									repeat(1)@(vif.mon_cb);
									monitor_trans.opa       = vif.mon_cb.opa;
									monitor_trans.opb       = vif.mon_cb.opb;
									monitor_trans.cin       = vif.mon_cb.cin;
									monitor_trans.mode      = vif.mon_cb.mode;
									monitor_trans.cmd       = vif.mon_cb.cmd;
									monitor_trans.inp_valid = vif.mon_cb.inp_valid;
									//@(vif.mon_cb);
									monitor_trans.res       = vif.mon_cb.res;
									monitor_trans.oflow     = vif.mon_cb.oflow;
									monitor_trans.cout      = vif.mon_cb.cout;
									monitor_trans.g         = vif.mon_cb.g;
									monitor_trans.l         = vif.mon_cb.l;
									monitor_trans.e         = vif.mon_cb.e;
									monitor_trans.err       = vif.mon_cb.err;
									mon2scb.put(monitor_trans);
									output_coverage.sample();
									monitor_trans.display("MONITOR SIGNALS ENDED");
									repeat(2) @(vif.mon_cb);
									monitor_trans.display("Monitor delay");
									end
								else begin
									monitor_trans.opa       = vif.mon_cb.opa;
									monitor_trans.opb       = vif.mon_cb.opb;
									monitor_trans.cin       = vif.mon_cb.cin;
									monitor_trans.mode      = vif.mon_cb.mode;
									monitor_trans.cmd       = vif.mon_cb.cmd;
									monitor_trans.inp_valid = vif.mon_cb.inp_valid;
									//@(vif.mon_cb);
									monitor_trans.res       = vif.mon_cb.res;
									monitor_trans.oflow     = vif.mon_cb.oflow;
									monitor_trans.cout      = vif.mon_cb.cout;
									monitor_trans.g         = vif.mon_cb.g;
									monitor_trans.l         = vif.mon_cb.l;
									monitor_trans.e         = vif.mon_cb.e;
									monitor_trans.err       = vif.mon_cb.err;
									mon2scb.put(monitor_trans);
                 	output_coverage.sample();
									monitor_trans.display("MONITOR SIGNALS ENDED");
									repeat(2) @(vif.mon_cb);
									monitor_trans.display("Monitor delay");						
								end
							 end
						  end//count==15
						else begin
						if( vif.mon_cb.inp_valid == 3 )
						begin
							//count = 0;
							repeat(1)@(vif.mon_cb);
							if( ( vif.mon_cb.mode == 1 ) && ( vif.mon_cb.cmd == 9 || vif.mon_cb.cmd == 10 ) )
							  begin
								$display("multiplication operation");
								repeat(1)@(vif.mon_cb);
								monitor_trans.opa       = vif.mon_cb.opa;
								monitor_trans.opb       = vif.mon_cb.opb;
								monitor_trans.cin       = vif.mon_cb.cin;
								monitor_trans.mode      = vif.mon_cb.mode;
								monitor_trans.cmd       = vif.mon_cb.cmd;
								monitor_trans.inp_valid = vif.mon_cb.inp_valid;
							  //@(vif.mon_cb);
								monitor_trans.res       = vif.mon_cb.res;
								monitor_trans.oflow     = vif.mon_cb.oflow;
								monitor_trans.cout      = vif.mon_cb.cout;
								monitor_trans.g         = vif.mon_cb.g;
								monitor_trans.l         = vif.mon_cb.l;
								monitor_trans.e         = vif.mon_cb.e;
								monitor_trans.err       = vif.mon_cb.err;
								mon2scb.put(monitor_trans);
	              output_coverage.sample();
								monitor_trans.display("MONITOR SIGNALS ENDED");
								repeat(2) @(vif.mon_cb);
								monitor_trans.display("Monitor delay");
								end
							else begin
								monitor_trans.opa       = vif.mon_cb.opa;
								monitor_trans.opb       = vif.mon_cb.opb;
								monitor_trans.cin       = vif.mon_cb.cin;
								monitor_trans.mode      = vif.mon_cb.mode;
								monitor_trans.cmd       = vif.mon_cb.cmd;
								monitor_trans.inp_valid = vif.mon_cb.inp_valid;
								//@(vif.mon_cb);
								monitor_trans.res       = vif.mon_cb.res;
								monitor_trans.oflow     = vif.mon_cb.oflow;
								monitor_trans.cout      = vif.mon_cb.cout;
								monitor_trans.g         = vif.mon_cb.g;
								monitor_trans.l         = vif.mon_cb.l;
								monitor_trans.e         = vif.mon_cb.e;
								monitor_trans.err       = vif.mon_cb.err;
								mon2scb.put(monitor_trans);
	              output_coverage.sample();
								monitor_trans.display("MONITOR SIGNALS ENDED");
								repeat(2 + count + 1) @(vif.mon_cb);
								monitor_trans.display("Monitor delay");						
							end
							break;
						end//inp_valid =3
					  end//count!=15
						@(vif.mon_cb);
          end// for loop end statement
		
				end// 16 clock cycle check
			end// main_else
			end//repeat end statement
		end//for loop end statement
	endtask
endclass
