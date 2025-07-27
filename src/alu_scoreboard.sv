class alu_scoreboard;

        alu_transaction monitor_trans ;
        alu_transaction reference_trans;

        mailbox #(alu_transaction) mon2scb;
        mailbox #(alu_transaction) ref2scb;

        function new( mailbox #(alu_transaction) mon2scb ,
                            mailbox #(alu_transaction) ref2scb
                    );
  this.mon2scb = mon2scb;
  this.ref2scb = ref2scb;
  endfunction

        reg [ ( RESULT_WIDTH - 1  ) + 6 : 0 ] pkt_ref[ `no_of_transaction - 1 : 0 ];
        reg [ ( RESULT_WIDTH - 1  ) + 6 : 0 ] pkt_mon[ `no_of_transaction - 1 : 0 ];

  int pass = 0 ;
        int fail = 0 ;

        task start();

                for(int i = 0 ; i < `no_of_transaction ; i++) begin

                        monitor_trans = new();
                        reference_trans = new();

                        fork
                          /*begin
                                  ref2scb.get(reference_trans);
                                        pkt_ref[i] = {
                                                             reference_trans.res  , reference_trans.oflow ,
                                                             reference_trans.cout , reference_trans.g ,
                                                             reference_trans.l    , reference_trans.e,
                                                             reference_trans.err
                                                  };
          reference_trans.display("scorebord: reference_signals");
                                end
        */
                                begin
                                                             mon2scb.get(monitor_trans);
                                    pkt_mon[i] = {
                                                             monitor_trans.res  , monitor_trans.oflow ,
                                                             monitor_trans.cout , monitor_trans.g ,
                                                             monitor_trans.l    , monitor_trans.e,
                                                             monitor_trans.err
                                                  };
                                monitor_trans.display("scoreboard: monitor_signals");
                    end
                                begin
                                  ref2scb.get(reference_trans);
                                        pkt_ref[i] = {
                                                             reference_trans.res  , reference_trans.oflow ,
                                                             reference_trans.cout , reference_trans.g ,
                                                             reference_trans.l    , reference_trans.e,
                                                             reference_trans.err
                                                  };
                                        reference_trans.display("scorebord: reference_signals");
                                end
                        join

                        $display(" \t COMPARISION ON MON & SCB REPORT ");
//              for(int j = 0; j < `no_of_transaction; j++)begin

                        if( pkt_ref[i] === pkt_mon[i] )
                          begin
                                         pass = pass + 1;
                            $display("NUMBER OF PACKET PASSED = %0d",pass);
                          end

                        else
              begin
                                  fail = fail + 1;
                            $display("NUMBER OF PACKET FAILED = %0d",fail);
                          end
                end

        endtask

endclass
