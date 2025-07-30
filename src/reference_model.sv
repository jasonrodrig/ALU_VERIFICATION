//`include "defines.sv"
//`include "alu_transaction.sv"
class alu_reference_model;
 
  alu_transaction ref_t;

  mailbox#(alu_transaction) driv2ref;
	mailbox#(alu_transaction) ref2scb;
	virtual alu_interface.reference_cb vif;

	function new(
	               mailbox#(alu_transaction) driv2ref,
	               mailbox#(alu_transaction) ref2scb,
                 virtual alu_interface.reference_cb vif
	             );
 
      this.driv2ref = driv2ref;
	    this.ref2scb  = ref2scb;
      this.vif      = vif;

	endfunction
  
	static int flag;
  reg [ RESULT_WIDTH - 1 : 0 ] t_mul;
	static int count;

	task start();
		
		for(int i = 0; i < `no_of_transaction; i++)
		begin
       driv2ref.get(ref_t);
	//		 check_16_cycle_single_operand();
		//	 ref_t.display("REFERENCE_STARTED");
      // dummy_alu();
      // ref2scb.put(ref_t);
		//end
	//endtask  
	//task check_16_cycle_single_operand();
  if( ( ref_t.mode == 1 ) && ( ref_t.cmd inside { 0 , 1 , 2 , 3 , 8 , 9 , 10 } ||
		  ( ref_t.mode == 0 ) && ( ref_t.cmd inside { 0 , 1 , 2 , 3 , 4 , 5 , 12 , 13 } )))
		begin
			if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) flag = 1;
			else 																							 flag = 0; 
		end
	//endtask
    $display("reference_flag = %b",flag);
	//task dummy_alu();
  	repeat(1) @(vif.reference_cb)
		begin

      if(vif.reference_cb.rst) begin   
       ref_t.opa       = 'b0;
			 ref_t.opb 			 = 'b0;
			 ref_t.cmd 			 = 'b0;
       ref_t.cin 			 = 'b0;
			 ref_t.mode 		 = 'b0;
			 ref_t.inp_valid = 'b0;	
			 
			 ref_t.res   		 = 'b0;
       ref_t.cout  		 = 'b0;
			 ref_t.oflow 		 = 'b0;
			 ref_t.err   		 = 'b0;	
       ref_t.e    		 = 'b0;
			 ref_t.g     		 = 'b0;
			 ref_t.l     		 = 'b0;	
			 
			 t_mul 					 = 'b0;
			 count           = 'b0;
			end //: rst_end_statement

			else if(vif.reference_cb.ce) begin
				$display("CE is activated");
			 if(ref_t.mode) begin
				 $display("MODE1 ACRIVATED");
			 	   ref_t.res   = 'b0;
           ref_t.cout  = 'b0;
			     ref_t.oflow = 'b0;
			     ref_t.err   = 'b0;	
           ref_t.e     = 'b0;
			     ref_t.g     = 'b0;
			     ref_t.l     = 'b0;
					 t_mul       = 'b0;
				 case(ref_t.cmd)
					 0: begin
						     if( ref_t.inp_valid == 3) begin
                 ref_t.res  = ref_t.opa + ref_t.opb;
						     ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
								 repeat(1) @(vif.reference_cb); 
								 end
						     /*else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res  = ref_t.opa + ref_t.opb;
						     						ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res  = ref_t.opa + ref_t.opb;
						     				 	 ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
						   */else ref_t.err = 1;
						  end
					 1:begin
						     if( ref_t.inp_valid == 3) begin
	               ref_t.res   = {{(`DATA_WIDTH - 1){1'b0}},ref_t.opa - ref_t.opb};
						     ref_t.oflow = ref_t.opa < ref_t.opb ? 1 : 0;  
							   repeat(1) @(vif.reference_cb); 
								 end
						     else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res   = ref_t.opa - ref_t.opb;
						     						ref_t.oflow = ref_t.opa < ref_t.opb ? 1 : 0;
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 	count = 0;
                         		ref_t.res   = ref_t.opa - ref_t.opb;
						     				 		ref_t.oflow = ref_t.opa < ref_t.opb ? 1 : 0;
												 		break;
												 end
										 	 end
									 	 end            
									 end
								 end
						     else ref_t.err = 1;
						 end
					 2:begin
						     if( ref_t.inp_valid == 3) begin
					 		   ref_t.res  = ref_t.opa + ref_t.opb + ref_t.cin;
						     ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
								 repeat(1)@(vif.reference_cb);
					  		 end
								 else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res  = ref_t.opa + ref_t.opb + ref_t.cin;
						     						ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
                         	 ref_t.res  = ref_t.opa + ref_t.opb + ref_t.cin;
						     				 	 ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
						     else ref_t.err = 1;
						 end
					 3:begin
						     if( ref_t.inp_valid == 3) begin
					       ref_t.res   = {{(`DATA_WIDTH - 1){1'b0}},{ref_t.opa - ref_t.opb - ref_t.cin} };
						     ref_t.oflow = ( ( ref_t.opa < ref_t.opb ) || ( ( ref_t.opa == ref_t.opb ) && ( ref_t.cin < 0 )))
												 			 ? 1 : 0;
					       repeat(1) @(vif.reference_cb); 
								 end
						     else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res   = ref_t.opa - ref_t.opb - ref_t.cin;
						     						ref_t.oflow = ( ( ref_t.opa < ref_t.opb ) || ( ( ref_t.opa == ref_t.opb ) && 
															               ( ref_t.cin < 0 ) ) ) ? 1 : 0;

												 	//	break;
												 end
												 else begin 
													 count = 0 ;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
                         	 ref_t.res   = ref_t.opa - ref_t.opb - ref_t.cin;
						     				 	 ref_t.oflow = ( ( ref_t.opa < ref_t.opb ) || ( ( ref_t.opa == ref_t.opb ) && 
																           ( ref_t.cin < 0 ) ) ) ? 1 : 0;
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								 else ref_t.err = 1;
						 end
					 4:begin
						     if( ref_t.inp_valid == 1) begin
					       ref_t.res  = ref_t.opa + 1;
						     ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
					       repeat(1) @(vif.reference_cb); 
								 end
						     else ref_t.err = 1;
					   end
					 5:begin
                 if( ref_t.inp_valid == 1) begin
					       ref_t.res  = ref_t.opa - 1;
						     ref_t.oflow = ( ref_t.opa == 0 ) ? 1 : 0;
					       repeat(1) @(vif.reference_cb); 
								 end
						     else ref_t.err = 1;
					 	 end
					 6:begin
					 		   if( ref_t.inp_valid == 2) begin
					       ref_t.res  = ref_t.opb + 1;
						     ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
					       repeat(1) @(vif.reference_cb); 
								 end
						     else ref_t.err = 1;
					   end
					 7:begin
						       $display("DEC OPB ACTIVATED");
						     if( ref_t.inp_valid == 2) begin
									 $display("INP_VALID2 SELECTED");
					       ref_t.res  = ref_t.opb - 1;
						     ref_t.oflow = ( ref_t.opb == 0 ) ? 1 : 0;
								 $display("res = %d , oflow = %d", ref_t.res, ref_t.oflow);
								 repeat(1) @(vif.reference_cb); 
					       end
						     else ref_t.err = 1;
					 	 end
					 8:begin
                 if( ref_t.inp_valid == 3 )begin
							   		ref_t.res = 0;
			           		if (ref_t.opa == ref_t.opb )begin
											 ref_t.e = 'b1;
									  	 ref_t.g = 'b0;
											 ref_t.l = 'b0;
								 		end
						     		else if( ref_t.opa > ref_t.opb )begin
											 ref_t.e = 'b0;
										   ref_t.g = 'b1;
											 ref_t.l = 'b0;
								 		end		          
								 		else begin
								   		 ref_t.e = 'b0;
											 ref_t.g = 'b0;
											 ref_t.l = 'b1;
								 		end
                 	 repeat(1) @(vif.reference_cb); 
								 end
						     else if( flag == 1 ) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         			ref_t.res = 0;
			          					 		if( ref_t.opa == ref_t.opb )begin
														  	ref_t.e = 'b1;
									  	 					ref_t.g = 'b0;
														  	ref_t.l = 'b0;
								 							end
						     							else if( ref_t.opa > ref_t.opb )begin
															 	ref_t.e = 'b0;
										   					ref_t.g = 'b1;
											 					ref_t.l = 'b0;
								 							end		          
								 							else begin
								   		 					ref_t.e = 'b0;
											 					ref_t.g = 'b0;
															  ref_t.l = 'b1;
								 							end
												 	//	break;
												 end
												 else begin 
													 count = 0 ;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
												 	 ref_t.res = 0;
			          					 	if( ref_t.opa == ref_t.opb ) begin
														  ref_t.e = 'b1;
									  	 				ref_t.g = 'b0;
														  ref_t.l = 'b0;
								 						end
						     						else if( ref_t.opa > ref_t.opb ) begin
															ref_t.e = 'b0;
										   				ref_t.g = 'b1;
											 				ref_t.l = 'b0;
								 						end		          
								 						else begin
								   	 					ref_t.e = 'b0;
										 					ref_t.g = 'b0;
														  ref_t.l = 'b1;
							 							end	 	
													 break;
												 end
										 	 end
									 	 end            
									 end
								 end
						     else ref_t.err = 1;
					 	 end
					 9:begin
						    if(ref_t.inp_valid == 3) begin
					 			t_mul  = ( ref_t.opa + 1 ) * ( ref_t.opb + 1 );
					      ref_t.res =  t_mul;
								repeat(2)@(vif.reference_cb);	
								end
						 	  else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
													  t_mul = ( ref_t.opa + 1 ) * ( ref_t.opb + 1 );
                         		ref_t.res = t_mul;
												 	//	break;
												 end
												 else begin 
													 count = 0 ;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
                         	 t_mul = ( ref_t.opa + 1 ) * ( ref_t.opb + 1 );
													 ref_t.res = t_mul;
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
						    else ref_t.err = 1;
					 	 end
					 10:begin
						    if(ref_t.inp_valid == 3) begin
									bit [7:0] temp = ( ref_t.opa << 1 ); 
               	t_mul  = ( temp) * ( ref_t.opb );
									$display("%d", temp );
							  ref_t.res =  t_mul;
								repeat(2)@(vif.reference_cb);	
								end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
													  t_mul = ( ref_t.opa << 1 ) * ( ref_t.opb );
                         		ref_t.res = t_mul;
												 	//	break;
												 end
												 else begin 
													 count = 0 ;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
                         	 t_mul = ( ref_t.opa << 1 ) * ( ref_t.opb );
													 ref_t.res = t_mul;
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
						  end
					 default:begin
						         ref_t.res   = 'b0;
          					 ref_t.cout  = 'b0;
			     					 ref_t.oflow = 'b0;
			     					 ref_t.err   = 'b1;
							       ref_t.e     = 'b0;
                     ref_t.g     = 'b0;
						  		   ref_t.l     = 'b0;
					         end
				 endcase
			 end //:mode1_end_statement
			 else begin
           ref_t.res   = 'b0;
           ref_t.cout  = 'b0;
			     ref_t.oflow = 'b0;
			     ref_t.err   = 'b0;	
           ref_t.e     = 'b0;
			     ref_t.g     = 'b0;
			     ref_t.l     = 'b0;
					 t_mul       = 'b0;
				   case(ref_t.cmd)
           0:begin 
								if(ref_t.inp_valid == 3) begin
									ref_t.res = ( ref_t.opa & ref_t.opb ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res = ( ref_t.opa & ref_t.opb );
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res = ( ref_t.opa & ref_t.opb );
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
						    else ref_t.err = 1;
					   end
					 1:begin 
								if(ref_t.inp_valid == 3) begin
									ref_t.res = (~( ref_t.opa & ref_t.opb )) & ( { { `DATA_WIDTH{1'b0} },{ `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res = ~( ref_t.opa & ref_t.opb );
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res = ~( ref_t.opa & ref_t.opb );
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					   end
           2:begin 
								if(ref_t.inp_valid == 3) begin
									ref_t.res = ( ref_t.opa | ref_t.opb ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res = ( ref_t.opa | ref_t.opb );
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res = ( ref_t.opa | ref_t.opb );
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					   end
					 3:begin 
								if(ref_t.inp_valid == 3) begin
									ref_t.res = (~( ref_t.opa | ref_t.opb )) & ( { { `DATA_WIDTH{1'b0} },{ `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res = ~( ref_t.opa | ref_t.opb );
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res = ~( ref_t.opa | ref_t.opb );
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					   end
           4:begin 
								if(ref_t.inp_valid == 3) begin
									ref_t.res = ( ref_t.opa ^ ref_t.opb )  & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );

									repeat(1) @(vif.reference_cb); 
						 		end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if(ref_t.inp_valid == 3 ) begin
                         		ref_t.res = ( ref_t.opa ^ ref_t.opb );
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res = ( ref_t.opa ^ ref_t.opb );
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					   end
           5:begin 
								if(ref_t.inp_valid == 3) begin
									ref_t.res = (~( ref_t.opa ^ ref_t.opb )) & ( { { `DATA_WIDTH{1'b0} },{ `DATA_WIDTH{1'b1} } } );

                  repeat(1) @(vif.reference_cb); 
						 		end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
                         		ref_t.res = ~( ref_t.opa ^ ref_t.opb );
												 	//	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res = ~( ref_t.opa ^ ref_t.opb );
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					   end
					 6:begin 
								if(ref_t.inp_valid == 1) begin
									ref_t.res = ( ~( ref_t.opa ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else ref_t.err = 1;
					   end
 					 7:begin 
								if(ref_t.inp_valid == 2) begin
									ref_t.res = ( ~( ref_t.opb ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else ref_t.err = 1;
					   end
 					 8:begin 
					  		if(ref_t.inp_valid == 1) begin
									ref_t.res = ( ( ref_t.opa >> 1 ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else ref_t.err = 1;
					   end
					 9:begin 
								if(ref_t.inp_valid == 1) begin
									ref_t.res = ( ( ref_t.opa << 1 ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else ref_t.err = 1;
					    end
					 10:begin 
								if(ref_t.inp_valid == 2) begin
									ref_t.res = ( ( ref_t.opb >> 1 ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else ref_t.err = 1;
					    end
 					 11:begin 
								if(ref_t.inp_valid == 2) begin
									ref_t.res = ( ( ref_t.opb << 1 ) ) & ( { { `DATA_WIDTH{1'b0} } , { `DATA_WIDTH{1'b1} } } );
									repeat(1) @(vif.reference_cb); 
						 		end
						    else ref_t.err = 1;
					    end
 					 12:begin 
								if(ref_t.inp_valid == 3) begin
                  ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
							    ( ref_t.opa << ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
								  ( ref_t.opa >> (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );
						      if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))	ref_t.err = 1; 
									else                                        								  ref_t.err = 0;  
									repeat(1) @(vif.reference_cb); 	
								end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
												   ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
							    				 ( ref_t.opa << ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
								  				 ( ref_t.opa >> (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );
						     					 if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))	ref_t.err = 1; 
													 else	                                        								  ref_t.err = 0;  
													 //	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;
													 ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
							    				 ( ref_t.opa << ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
								  				 ( ref_t.opa >> (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );
						      				 if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))	ref_t.err = 1; 
													 else                                        								  	ref_t.err = 0; 
												 	 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					    end
 					 13:begin 
								if(ref_t.inp_valid == 3) begin
                  ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
							    ( ref_t.opa >> ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
								  ( ref_t.opa << (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );
						      if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))	ref_t.err = 1; 
								  else                                        								  ref_t.err = 0;  
									repeat(1) @(vif.reference_cb); 
								end
						    else if( flag == 1) begin
									 if( ref_t.inp_valid == 1 || ref_t.inp_valid == 2 ) begin
										 count = 0; flag = 0;									
										 for(int i = 0 ; i < 16 ; i++) begin				 
											 @(vif.reference_cb);								 
											 if( count == 15 ) begin
												 count = 0;
												 if( ref_t.inp_valid == 3 ) begin
												  	 ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
							   						 ( ref_t.opa >> ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
								  					 ( ref_t.opa << (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );
						     						 if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))	ref_t.err = 1; 
								 						 else   	                                     								  ref_t.err = 0;  
													 //	break;
												 end
												 else begin
													 count = 0;
													 ref_t.err = 1;
													// break;
												 end
											 end
											 else begin
												 count = count + 1;
												 if( ref_t.inp_valid == 3 ) begin
													 count = 0;												 	 
												   ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
							   					 ( ref_t.opa >> ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
								  				 ( ref_t.opa << (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );
						     					 if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))	ref_t.err = 1; 
								 					 else   	                                     								  ref_t.err = 0;  
													 break;
												 end
										 	 end
									 	 end            
									 end
								 end
								else ref_t.err = 1;
					    end 
					 default:begin
						         ref_t.res   = 'b0;
          					 ref_t.cout  = 'b0;
			     					 ref_t.oflow = 'b0;
			     					 ref_t.err   = 'b1;
							       ref_t.e     = 'b0;
                     ref_t.g     = 'b0;
						  		   ref_t.l     = 'b0;
					         end
					 endcase	 
			 end //:mode0_end_statement
			end //:ce1_end_statement
			else begin
				$display("CE = 0 AND DEACTIVATED");
				ref_t.opa 		 = ref_t.opa;
				ref_t.opb 		 = ref_t.opb;
			 ref_t.cmd 			 = ref_t.cmd;
       ref_t.cin 			 = ref_t.cin;
			 ref_t.mode 		 = ref_t.mode;
			 ref_t.inp_valid = ref_t.inp_valid;	
				ref_t.res   		 = ref_t.res;
				ref_t.cout  		 = ref_t.cout;
				ref_t.oflow 		 = ref_t.oflow;
				ref_t.err   		 = ref_t.err;	
				ref_t.e    		   = ref_t.e;
				ref_t.g     		 = ref_t.g;
				ref_t.l    		   = ref_t.l;			 
			end //:ce0_end_statement
			ref_t.display("REFERENCE SIGNALS ");
			ref2scb.put(ref_t);
		 end //:repeat_end_statement
		end//for loop end statement
	endtask
endclass


