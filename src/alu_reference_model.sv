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

	task start();
		
		for(int i = 0; i < `no_of_transaction; i++)
		begin
       driv2ref.get(ref_t);
       dummy_alu();
       ref2scb.put(ref_t);
		end
	endtask

	static int flag;
  reg [ RESULT_WIDTH - 1 : 0 ] t_mul;
	static int count ;

	task finding(alu_transaction ref_t);
      if( ( ref_t.mode == 1 ) && !( ref_t.cmd inside { 0 , 1 , 2 , 3 , 8 , 9 , 10 } || 
			    ( ref_t.mode == 0 ) && !( ref_t.cmd inside { 0 , 1 , 2 , 3 , 4 , 5 , 12 , 13 })
				  begin
			      flag = 1;			   	   		
					end
      else flag = 0;
	endtask

	//reg [`CMD_WIDTH - 1 : 0 ]ref_t.cmd;
	//reg [`DATA_WIDTH - 1 : 0 ] ref_t.opa , ref_t.opb;
	//reg [ 1 : 0 ] ref_t.inp_valid;
  //reg ref_t.mode , ref_t.cin; 
	
	//reg [ RESULT_WIDTH - 1 : 0 ] t_mul;
	//static int count ;
	//reg [ RESULT_WIDTH - 1 : 0 ] res;
  //reg cout , oflow , err , e , g , l;

	task dummy_alu();
		repeat(1) @(vif.reference_cb)
		begin

      if(ref_t.rst) begin   
       ref_t.opa = 'b0;
			 ref_t.opb = 'b0;
			 ref_t.cmd = 'b0;
       ref_t.cin = 'b0;
			 ref_t.mode = 'b0;
			 ref_t.inp_valid = 'b0;	
			 
			 ref_t.res   = 'b0;
       ref_t.cout  = 'b0;
			 ref_t.oflow = 'b0;
			 ref_t.err   = 'b0;	
       ref_t.e     = 'b0;
			 ref_t.g     = 'b0;
			 ref_t.l     = 'b0;	
			 
			 t_mul = 'b0;
			 count = 'b0;
			end

			else if(ref_t.ce) begin
      // ref_t.opa       = ref_t.opa;
			// ref_t.opb       = ref_t.opb;
			// ref_t.cmd       = ref_t.cmd;
      // ref_t.cin       = ref_t.cin;
			// ref_t.mode      = ref_t.mode;
			// ref_t.inp_valid = ref_t.inp_valid;
 
			 if(ref_t.mode)
			 begin
				   ref_t.res   = 'b0;
           ref_t.cout  = 'b0;
			     ref_t.oflow = 'b0;
			     ref_t.err   = 'b0;	
           ref_t.e     = 'b0;
			     ref_t.g     = 'b0;
			     ref_t.l     = 'b0;
					 t_mul       = 'b0;

				 if(ref_t.cmd != 4'd9 && ref_t.cmd != 4'd10)
				   ref_t.res   = 'b0;

         //  ref_t.cout  = 'b0;
			   //  ref_t.oflow = 'b0;
			   //  ref_t.err   = 'b0;	
         //  ref_t.e     = 'b0;
			   //  ref_t.g     = 'b0;
			   //  ref_t.l     = 'b0;
				 //	 t_mul       = 'b0;
           
					 case(ref_t.inp_valid)
						 2'b00:begin
             				/* ref_t.res   = 'b0;
          					 ref_t.cout  = 'b0;
			     					 ref_t.oflow = 'b0;
			     					 ref_t.err   = 'b0;
							       ref_t.e     = 'b0;
                     ref_t.g     = 'b0;
			               ref_t.l     = 'b0;
							      */
							 if(flag==1)begin
							       if(count == 15)begin
												 count = 0;
												 err = 1;
											end
                     else count ++;
						       end
						 else begin
									   ref_t.res   = 'b0;
          					 ref_t.cout  = 'b0;
			     					 ref_t.oflow = 'b0;
			     					 ref_t.err   = 'b0;
							       ref_t.e     = 'b0;
                     ref_t.g     = 'b0;
			               ref_t.l     = 'b0;
						 end
						 end

						 2'b01:begin
                     case(ref_t.cmd)

											 4'b0100: begin 
												        	ref_t.res  = ref_t.opa + 1;
												        	ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
											          end

                       4'b0101: begin
												        	ref_t.res   = ref_t.opa - 1;
												        	ref_t.oflow = ( ref_t.opa == 0) ? 1 : 0;
											          end

											 default:begin
											           /*ref_t.res   = 'b0;
          					 						 ref_t.cout  = 'b0;
			     					 						 ref_t.oflow = 'b0;
			     					 						 ref_t.err   = 'b1;
							       						 ref_t.e     = 'b0;
                     						 ref_t.g     = 'b0;
						  		               ref_t.l     = 'b0;
																*/
												 if(flag==1)begin       
												 if(count == 15)begin
																	count = 0;
										   						err = 1;
																end
                                else count ++;

 															 end
												 else begin
													ref_t.res   = 'b0;
          					 		  ref_t.cout  = 'b0;
			     					 			ref_t.oflow = 'b0;
			     					 			ref_t.err   = 'b1;
							       			ref_t.e     = 'b0;
                     			ref_t.g     = 'b0;
						  		        ref_t.l     = 'b0;
												 end
												end
										 endcase
						       end

             2'b10:begin
                     case(ref_t.cmd)

											 4'b0110: begin
												        	ref_t.res  = ref_t.opb + 1;
												        	ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
											          end

                       4'b0111: begin
												        	ref_t.res   = ref_t.opb - 1;
												          ref_t.oflow = ( ref_t.opb == 0) ? 1 : 0;
											          end

											 default:begin
											 if(flag==1)begin       
												 if(count == 15)begin
																	count = 0;
										   						err = 1;
																end
                                else count ++;

 															 end
												 else begin
													ref_t.res   = 'b0;
          					 		  ref_t.cout  = 'b0;
			     					 			ref_t.oflow = 'b0;
			     					 			ref_t.err   = 'b1;
							       			ref_t.e     = 'b0;
                     			ref_t.g     = 'b0;
						  		        ref_t.l     = 'b0;
												 end
												end


											         end
										 endcase
						       end
             
						 2'b11:begin
							 			count = 0; 
							 flag=0;
							 			case(ref_t.cmd)
 
											 4'b0000: begin
												        	ref_t.res  = ref_t.opa + ref_t.opb;
												        	ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
											          end

                       4'b0001: begin
												        	ref_t.res   = ref_t.opa - ref_t.opb;
												        	ref_t.oflow = ( ref_t.opa < ref_t.opb) ? 1 : 0;
											 					end

											 4'b0010: begin
												        	ref_t.res  = ref_t.opa + ref_t.opb + ref_t.cin;
												        	ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
											          end

                       4'b0011: begin
												        	ref_t.res   = ref_t.opa - ref_t.opb - ref_t.cin;
												        	ref_t.oflow = ( ref_t.opa < ref_t.opb || ( (ref_t.opa == ref_t.opb) && 
																	 																					  ref_t.cin == 1) )  ? 1 : 0;
											          end

                       4'b0100: begin
												        	ref_t.res  = ref_t.opa + 1;
												        	ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
											          end

                       4'b0101: begin
												        	ref_t.res   = ref_t.opa - 1;
												        	ref_t.oflow = ( ref_t.opa < ref_t.opb ) ? 1 : 0;
											 					end

											 4'b0110: begin
												        	ref_t.res  = ref_t.opb + 1;
												        	ref_t.cout = ref_t.res[`DATA_WIDTH] ? 1 : 0;
											          end

                       4'b0111: begin
												          ref_t.res   = ref_t.opb - 1 ;
												        	ref_t.oflow = ( ref_t.opa < ref_t.opb) ? 1 : 0;
											          end

                       4'b1000: begin
												        	ref_t.res = 0;
												 
												          if(ref_t.opa == ref_t.opb)begin
																		ref_t.e = 'b1;
																		ref_t.g = 'b0;
																		ref_t.l = 'b0;
																	end

												          else if(ref_t.opa > ref_t.opb)begin
																		ref_t.e = 'b0;
																		ref_t.g = 'b1;
																		ref_t.l = 'b0;
																	end
													          
																	else begin
																		ref_t.e = 'b0;
																		ref_t.g = 'b0;
																		ref_t.l = 'b1;
																	end

																end

											 4'b1001: begin
												        	t_mul  = ( ref_t.opa + 1 ) * ( ref_t.opb + 1 );
											            ref_t.res =  t_mul;
											          end

                       4'b1010: begin
												          t_mul  = ( ref_t.opa << 1 ) * ( ref_t.opb ) ;
												          ref_t.res = t_mul;
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
					  	     end 

					 endcase // inp_valid end statement for mode 1
			 end// mode 1 end statement
				
			 else begin
           // mode 0 logical operation
				   ref_t.res   = 'b0;
           ref_t.cout  = 'b0;
			     ref_t.oflow = 'b0;
			     ref_t.err   = 'b0;	
           ref_t.e     = 'b0;
			     ref_t.g     = 'b0;
			     ref_t.l     = 'b0;
          
				 case(ref_t.inp_valid)
					  2'b00:begin
										 if(flag==1)begin       
												 if(count == 15)begin
																	count = 0;
										   						err = 1;
																end
                                else count ++;

 															 end
												 else begin
													ref_t.res   = 'b0;
          					 		  ref_t.cout  = 'b0;
			     					 			ref_t.oflow = 'b0;
			     					 			ref_t.err   = 'b1;
							       			ref_t.e     = 'b0;
                     			ref_t.g     = 'b0;
						  		        ref_t.l     = 'b0;
												 end
												end

	
			              
	
									end

            2'b01: begin
							       case(ref_t.cmd)
												 4'b0110: begin
													        ref_t.res = ~(ref_t.opa) ;
						                      end
						             4'b1000: begin
													        ref_t.res = (ref_t.opa) >> 1 ;
						                      end
                         4'b1001: begin
													        ref_t.res = (ref_t.opa) << 1 ;
						                      end
											   default: begin
										if(flag==1)begin       
												 if(count == 15)begin
																	count = 0;
										   						err = 1;
																end
                                else count ++;

 															 end
												 else begin
													ref_t.res   = 'b0;
          					 		  ref_t.cout  = 'b0;
			     					 			ref_t.oflow = 'b0;
			     					 			ref_t.err   = 'b1;
							       			ref_t.e     = 'b0;
                     			ref_t.g     = 'b0;
						  		        ref_t.l     = 'b0;
												 end
												end

	  
							       						 
      
												 
												 end
										 endcase
                   end

					  2'b10:begin
            		     case(ref_t.cmd)
												 4'b0111: begin
													        ref_t.res = ~(ref_t.opb) ;
						                      end
						             4'b1010: begin
													        ref_t.res = (ref_t.opb) >> 1 ;
						                      end
                         4'b1011: begin
													        ref_t.res = (ref_t.opb) << 1 ;
						                      end
											   default: begin
										     	if(flag==1)begin       
												      if(count == 15)begin
																	count = 0;
										   						err = 1;
															end
                          else count ++;

 												 end
												 else begin
													ref_t.res   = 'b0;
          					 		  ref_t.cout  = 'b0;
			     					 			ref_t.oflow = 'b0;
			     					 			ref_t.err   = 'b1;
							       			ref_t.e     = 'b0;
                     			ref_t.g     = 'b0;
						  		        ref_t.l     = 'b0;
												 end
												end       
												 
												 end
						  		               
										 endcase
                   end
              
					  2'b11:begin
							      count = 0; flag = 0;
            		      case(ref_t.cmd)
												 4'b0000: begin
													        ref_t.res = ref_t.opa & ref_t.opb;
						                      end
						             4'b0001: begin
													        ref_t.res = ~(ref_t.opa & ref_t.opb);
						                      end
                         4'b0010: begin
													        ref_t.res = ref_t.opa | ref_t.opb;
						                      end
                      	 4'b0011: begin
													        ref_t.res = ~(ref_t.opa | ref_t.opb);
						                      end
						             4'b0100: begin
													        ref_t.res = ref_t.opa ^ ref_t.opb;
						                      end
                         4'b0101: begin
													        ref_t.res = ~(ref_t.opa ^ ref_t.opb);
						                      end
	                       4'b0110: begin
													        ref_t.res = ~(ref_t.opa);
						                      end
						             4'b0111: begin
													        ref_t.res = ~(ref_t.opb);
						                      end
                         4'b1000: begin
													        ref_t.res = ref_t.opa >> 1;
						                      end
                      	 4'b1001: begin
													        ref_t.res = ref_t.opa << 1;
						                      end
						             4'b1010: begin
													        ref_t.res = ref_t.opb >> 1;
						                      end
                         4'b1011: begin
													        ref_t.res = ref_t.opb << 1;
						                      end
                      	 4'b1100: begin
													 
													        ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
																  ( ref_t.opa << ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
																	( ref_t.opa >> (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );

													        if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))																									           ref_t.err = 1; 
													        else
																	    ref_t.err = 0;       
						                      end

						             4'b1101: begin
													        
													        ref_t.res[`DATA_WIDTH - 1 : 0 ] = 
																  ( ref_t.opa >> ref_t.opb[($clog2(`DATA_WIDTH) - 1):0] ) | 
																	( ref_t.opa << (`DATA_WIDTH - ref_t.opb[($clog2(`DATA_WIDTH) - 1):0]) );

													        if(|(ref_t.opb[`DATA_WIDTH - 1 : ($clog2(`DATA_WIDTH) + 1)]))																									       ref_t.err = 1; 
													        else
																	    ref_t.err = 0;       
						                      end

											  default: begin
	                                ref_t.res   = 'b0;
          					 						  ref_t.cout  = 'b0;
			     					 						  ref_t.oflow = 'b0;
			     					 						  ref_t.err   = 'b1;
							       						  ref_t.e     = 'b0;
                     						  ref_t.g     = 'b0;
						  		                ref_t.l     = 'b0;
											         end
										 endcase
                   end
			   endcase
 
			 end //mode 0 end statement in else 

			end //else if end statement
      
			else begin 

		/*  ref_t.opa       = 'b0;
				ref_t.opb       = 'b0;
				ref_t.cmd       = 'b0;
				ref_t.mode      = 'b0;
				ref_t.inp_valid = 'b0;
				ref_t.cin       = 'b0;
				ref_t.res   = 'b0;
				ref_t.err   = 'b0;
				ref_t.oflow = 'b0;
				ref_t.g     = 'b0;
				ref_t.l     = 'b0;
				ref_t.e     = 'b0;
    */
			end //else end statement for reset and ce as logic zero

		end //repeat 1 @vif_reference_cb end statement
   	
	endtask

endclass

