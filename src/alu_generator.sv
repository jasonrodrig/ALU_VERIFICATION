class alu_generator;

        alu_transaction generator_trans;
  mailbox #(alu_transaction) gen2driv;

        function new( mailbox #(alu_transaction) gen2driv );
                this.gen2driv = gen2driv;
    this.generator_trans = new();
        endfunction

        task start();
                for( int i = 0 ; i < `no_of_transaction ; i++ )
                begin
                        assert(generator_trans.randomize());
                        gen2driv.put(generator_trans.copy());
                        generator_trans.display("generator signals");
                        /*  $display("generator signals\n");
                        $display(" Time: %0t, rst = %0d, ce = %0d, mode = %0b, cmd = %0d, inp_valid = %0d, cin = %0b, opa = %0d,opb = %0d", $time, generator_trans.rst, generator_trans.ce, generator_trans.mode ,                                                          generator_trans.cmd , generator_trans.inp_valid , generator_trans.cin , generator_trans.opa ,                                                  generator_trans.opb );
                        $display(" Time: %0t , res = %0d , oflow = %0b , cout = %0b , g = %0b , l = %0b , e = %0b , err = %0b",$time, generator_trans.res, generator_trans.oflow, generator_trans.cout, generator_trans.g,                      generator_trans.l , generator_trans.e , generator_trans.err );
                */
                end
        endtask
endclass
