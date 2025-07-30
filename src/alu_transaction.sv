//`include "defines.sv"
class alu_transaction;
	
	bit rst, ce;
	//rand bit ce ;
	rand bit mode , cin ;
 	rand bit [1:0] inp_valid ;
	rand bit [ `CMD_WIDTH - 1 : 0 ] cmd ;
	rand bit [ `DATA_WIDTH - 1 : 0 ] opa , opb ;
  
	bit [RESULT_WIDTH - 1 : 0] res ;
	bit oflow , cout , g , l , e , err ;

	//constraint ce_enable {ce == 1;}
	
	constraint inp_valid_range{
	 inp_valid inside {[1:3]};
	}

  constraint cmd_range{ 
    if(mode) cmd inside {[0:10]};
		else     cmd inside {[0:13]};
	}
  
	constraint input_data_range{
	 opa inside {[ 0 : ( ( 2 ** `DATA_WIDTH) - 1 ) ]};
	 opb inside {[ 0 : ( ( 2 ** `DATA_WIDTH) - 1 ) ]};
	}

 constraint input_valid_selection{
      if     ( ( mode == 1 && cmd == 4 ) || ( mode == 1 && cmd == 5 ) )   inp_valid == 2'b01;
			else if( ( mode == 1 && cmd == 6 ) || ( mode == 1 && cmd == 7 ) )   inp_valid == 2'b10;
			else if( ( mode == 1 && cmd == 0 ) || ( mode == 1 && cmd == 1 ) ||
				       ( mode == 1 && cmd == 2 ) || ( mode == 1 && cmd == 3 ) ||
               ( mode == 1 && cmd == 8 ) || ( mode == 1 && cmd == 9 ) ||
			         ( mode == 1 && cmd == 10 ) )                               inp_valid == 2'b11;

      else if( ( mode == 0 && cmd == 6 ) || ( mode == 0 && cmd == 8 ) || 
				       ( mode == 0 && cmd == 9 ) )                                inp_valid == 2'b01;
		  else if( ( mode == 0 && cmd == 7 ) || ( mode == 0 && cmd == 10 )|| 
				       ( mode == 0 && cmd == 11 ) )                               inp_valid == 2'b01;
		 	else                                                            		inp_valid == 2'b11;
	}

//	constraint cycle16{ mode == 1; cmd == 0;}

  function alu_transaction copy();
		copy = new();
    copy.mode = this.mode;
		copy.cin  = this.cin;
		copy.inp_valid = this.inp_valid;
		copy.cmd  = this.cmd;
		copy.opa  = this.opa;
		copy.opb  = this.opb;
    return copy;
  endfunction

	function void display(string name);
		$display("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
		$display("\t%s", name);
		$display(" Time: %0t , rst = %0b , ce = %0b , mode = %0b , cmd = %0d , inp_valid = %0d, cin = %0b , opa = %0d , opb = %0d", $time , rst , ce , mode , cmd , inp_valid , cin , opa , opb );
    $display(" Time: %0t , res = %0d , oflow = %0b , cout = %0b , g = %0b , l = %0b , e = %0b , err = %0b\n", $time , res , oflow , cout , g , l , e , err );
    $display("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||");
	endfunction


endclass



