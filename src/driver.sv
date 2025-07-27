class alu_driver;

  alu_transaction driver_trans;
  mailbox #(alu_transaction) gen2driv;
  mailbox #(alu_transaction) driv2ref;

        virtual alu_interface.driv vif;

  covergroup input_coverage;
                RESET:                          coverpoint driver_trans.rst       { bins rst[]       = { 0 , 1 }; }
                CE:                             coverpoint driver_trans.ce        { bins ce[]        = { 0 , 1 }; }
                MODE:                           coverpoint driver_trans.mode      { bins mode[]      = { 0 , 1 }; }
                INP_VALID:                      coverpoint driver_trans.inp_valid { bins inp_valid[] = { [ 0 : 3 ] }; }
                OPERAND_A:                      coverpoint driver_trans.opa       { bins opa[]       = { [ 0 : 2**(`DATA_WIDTH) - 1 ] }; }
                OPERAND_B:                      coverpoint driver_trans.opb       { bins opb[]       = { [ 0 : 2**(`DATA_WIDTH) - 1 ] }; }
                CARRY_IN:                       coverpoint driver_trans.cin       { bins cin[]       = { 0 , 1 }; }
                COMMAND:                        coverpoint driver_trans.cmd       { bins cmd[]       = { [ 0 : 2**( `CMD_WIDTH) - 1 ] }; }
                RESETXCE:                       cross RESET , CE ;
                CEXMODE:                        cross CE , MODE;
    MODEXCOMMAND:       cross MODE , COMMAND;
    INP_VALIDXCMD:  cross INP_VALID , COMMAND ;
                INP_VALIDXMODE: cross INP_VALID , MODE;
        endgroup

        function new(
                 mailbox #(alu_transaction) gen2driv,
                 mailbox #(alu_transaction) driv2ref,
                 virtual alu_interface.driv vif
               );
                this.gen2driv = gen2driv;
                this.driv2ref = driv2ref;
                this.vif = vif;
                input_coverage = new();
  endfunction

        int count;
        //semaphore sema;

  task start();

                repeat(3)@(vif.driv_cb);
                for(int i = 0 ; i < `no_of_transaction; i++)begin
                        driver_trans = new();

                        gen2driv.get(driver_trans);
                        //driv2ref.put(driver_trans);
      // driver_trans.display("DRIVER STARTED");
                        if( vif.driv_cb.rst == 1 ) begin
                        //      repeat(1)@(vif.driv_cb)
                                begin
                                        $display("RESET = 1 Driving Signals");
                                        vif.driv_cb.opa       <= {`DATA_WIDTH{1'b0}};
                                        vif.driv_cb.opb       <= {`DATA_WIDTH{1'b0}};
                                        vif.driv_cb.cin       <= 1'b0;
                                        vif.driv_cb.mode      <= 1'b0;
                                        vif.driv_cb.cmd       <= { `CMD_WIDTH{1'b0}};
                                        vif.driv_cb.inp_valid <= 2'b0;

                                        driv2ref.put(driver_trans);
                                        driver_trans.display("Reset = 1 Driving Signal");
                                end
                        end //rst end statement
                        else begin
        //repeat(1)@(vif.driv_cb)
                                //begin

                                        if(vif.driv_cb.ce == 0) $display("Enable = 0 Driving Signal");
                                        else                    $display("Enable = 1 Driving Signal");

        //  sema.put(1);

                                        if(vif.driv_cb.rst == 0 && vif.driv_cb.ce == 1)
                                        begin
                                                        if( ( ( driver_trans.mode == 1 ) && (!( ( driver_trans.cmd == 0 ) || ( driver_trans.cmd == 1 ) || ( driver_trans.cmd  == 2 ) || (     driver_trans.cmd == 3 ) || ( driver_trans.cmd == 8 ) ||                      ( driver_trans.cmd  == 9 ) || (     driver_trans.cmd == 10) ) ) ) ||
                                                          ( ( driver_trans.mode == 0 ) && (!( ( driver_trans.cmd == 0 ) || ( driver_trans.cmd == 1 ) ||
                                                                        ( driver_trans.cmd  == 2 ) || (                 driver_trans.cmd == 3 ) || ( driver_trans.cmd == 4 ) ||
                                                                        ( driver_trans.cmd  == 5 ) || (           driver_trans.cmd == 12) || ( driver_trans.cmd == 13) ||
                                                                        ( driver_trans.cmd  == 0 ) ) ) ) )
                                                          begin
                                                                         vif.driv_cb.opa       <= driver_trans.opa;
                                                                         vif.driv_cb.opb       <= driver_trans.opb;
                                                                         vif.driv_cb.cin       <= driver_trans.cin;
                                                                         vif.driv_cb.mode      <= driver_trans.mode;
                                                                         vif.driv_cb.cmd       <= driver_trans.cmd;
                                                                         vif.driv_cb.inp_valid <= driver_trans.inp_valid;
                                                                         //repeat(1)@(vif.driv_cb);
                                                                         driv2ref.put(driver_trans);
                                                                         driver_trans.display("Driving signals For Single Operand");
                                                                         input_coverage.sample();
                                                                         $display("INPUT FUNCTIONAL COVERAGE = %0d\n", input_coverage.get_coverage());
                                                                end //single opernad endstatement

                                          if( ( ( driver_trans.mode == 1 ) && ( ( driver_trans.cmd == 0 ) || ( driver_trans.cmd == 1 ) ||                        ( driver_trans.cmd  == 2 ) || ( driver_trans.cmd == 3   ) || ( driver_trans.cmd == 8 ) ||                        ( driver_trans.cmd  == 9 ) || ( driver_trans.cmd == 10  ) ) ) ||
                                                          ( ( driver_trans.mode == 0 ) && ( ( driver_trans.cmd == 0 ) || ( driver_trans.cmd == 1 ) ||
                                                                        ( driver_trans.cmd  == 2 ) || ( driver_trans.cmd == 3   ) || ( driver_trans.cmd == 4 ) ||
                                                                        ( driver_trans.cmd  == 5 ) || ( driver_trans.cmd == 12  ) || ( driver_trans.cmd == 13) ||
                                                                        ( driver_trans.cmd  == 0 ) ) ) )
                                                        begin

                                                                 if( driver_trans.inp_valid == 1 || driver_trans.inp_valid == 2 )
                                                                         begin

                                                                                 for( int count = 1 ; count < 17 ; count ++ )
                                                                                    begin
                                                                                                        @(vif.driv_cb);
                                                                                                        if( count == 16 )
                                                                                            begin
                                                                                                        driver_trans.mode.rand_mode(1);
                                                                                                        driver_trans.cmd.rand_mode(1);
                                                                                                        if( driver_trans.inp_valid == 3 ) break;
                                                                                      end

                                                                                                else
                                                                                                begin
                                                                                                        driver_trans.mode.rand_mode(0);
                                                                                                        driver_trans.cmd.rand_mode(0);
                                                                                                        void'(driver_trans.randomize());
                                                                                                        if( driver_trans.inp_valid == 3 ) break;
                                                                                      end

                                                                                                end //for loop end statement

                                                                        vif.driv_cb.opa       <= driver_trans.opa;
                                                                        vif.driv_cb.opb       <= driver_trans.opb;
                                                                        vif.driv_cb.cin       <= driver_trans.cin;
                                                                        vif.driv_cb.mode      <= driver_trans.mode;
                                                                        vif.driv_cb.cmd       <= driver_trans.cmd;
                                                                        vif.driv_cb.inp_valid <= driver_trans.inp_valid;

                                                                 // repeat(1)@(vif.driv_cb);
                                                                  driv2ref.put(driver_trans);
                                                                  input_coverage.sample();
                                                                  driver_trans.display(" Driving Signals For Two Operands");
                                                                  $display("INPUT FUNCTIONAL COVERAGE = %0d\n", input_coverage.get_coverage());
                                                                  end //input_valid_end_statemnet

                                                                  else begin // for two operand
                                                                                if( driver_trans.mode == 1 && driver_trans.inp_valid == 3 && ( ( driver_trans.cmd == 9 ) ||                        ( driver_trans.cmd  == 10 ) ) )  repeat(0)@(vif.driv_cb);
                                                                                vif.driv_cb.opa       <= driver_trans.opa;
                                                                                vif.driv_cb.opb       <= driver_trans.opb;
                                                                                vif.driv_cb.cin       <= driver_trans.cin;
                                                                                vif.driv_cb.mode      <= driver_trans.mode;
                                                                                vif.driv_cb.cmd       <= driver_trans.cmd;
                                                                                vif.driv_cb.inp_valid <= driver_trans.inp_valid;

                                                                          // repeat(1)@(vif.driv_cb);
                                                                                driv2ref.put(driver_trans);
                                                                                input_coverage.sample();
                                                                                driver_trans.display(" Driving Signals For Two Operands");      
                                                                                $display("INPUT FUNCTIONAL COVERAGE = %0d\n", input_coverage.get_coverage());

                                                                        end// two operand_end statment
                                                        end // two_operand_end_statement
                                        end //end statement for rst = 0 and ce=1
                                        if( driver_trans.mode == 1 && driver_trans.inp_valid == 3 && ( ( driver_trans.cmd == 9 ) ||                        ( driver_trans.cmd  == 10 ) ) )  repeat(5)@(vif.driv_cb);
                                        else repeat(4)@(vif.driv_cb);
                                        $display("AT %t, driver ended",$time);
                                //end//repeat(1)@(vif.driv_cb);
                        end //else end statement
                end // for loop for n_transaction_end_statement
        endtask //end satement for task

endclass
