class alu_monitor;

        alu_transaction monitor_trans;
  mailbox #(alu_transaction) mon2scb;
  virtual alu_interface.mon_cb vif;

        function new(
                       mailbox #(alu_transaction) mon2scb,
                       virtual alu_interface.mon_cb vif
                    );
                this.mon2scb = mon2scb;
                this.vif     = vif;
        endfunction

        task start();

                repeat(3) @(vif.mon_cb);

                for( int i = 0; i < `no_of_transaction; i++)
                 begin

                         monitor_trans = new();
                         monitor_trans.display("MONITOR STARTED");
                         repeat(2) @(vif.mon_cb);
                                begin
                                        if( vif.mon_cb.mode == 1 && vif.mon_cb.inp_valid == 3 && ( ( vif.mon_cb.cmd == 9 ) ||
                                                ( vif.mon_cb.cmd == 10 ) ) )
                                        begin
                                                $display("result extracting");
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
                                                 //repeat(1)@(vif.mon_cb);
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
                                  end
        //repeat(2) @(vif.mon_cb);
                                mon2scb.put(monitor_trans);
                                monitor_trans.display("MONITOR SIGNALS ENDED");
                          repeat(2) @(vif.mon_cb);
                          monitor_trans.display("Monitor delay");
                    end
                 end

        endtask

endclass
