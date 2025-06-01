
module router_reg(clock,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,
                  full_state,laf_state,lfd_state,rst_int_reg,err,parity_done,
						low_packet_valid,dout);
						
			 //port declarations
			 input [7:0]data_in;
			 input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,
			       full_state,lfd_state,rst_int_reg;
			 
			 output reg [7:0]dout;
			 output reg err,parity_done,low_packet_valid;
			 
			 //internal registers 
			 reg[7:0] full_state_byte,internal_parity,header,packet_parity;
			 
			 
			 //dout logic 
			 always@(posedge clock)
			     begin
				     if(!resetn)
					      dout <= 0;
					  else if(lfd_state)
					      dout <= header;
					  else if(ld_state && !fifo_full)
					      dout <= data_in;
					  else if(laf_state)
					      dout <= full_state_byte;
					  else
					      dout <= dout;
				  end
				 
							
			//Header logic 
		   always@(posedge clock)
				begin
				    if(!resetn)
					     header <= 0;
					 else if(detect_add && pkt_valid && data_in[1:0]!=2'd3)
					     header <= data_in;
					 else 
					     header <= header;
			   end
			
			//full state byte logic 
			always@(posedge clock)
			    begin
				    if(!resetn)
					     full_state_byte <= 0;
					 else if(ld_state && fifo_full)
					     full_state_byte <= data_in;
					 else
					     full_state_byte <= full_state_byte;
				 end
		   
			//parity calculation logic 
			always@(posedge clock)
				begin
				   if(!resetn)
					    internal_parity <= 0;
					else if(detect_add)
					    internal_parity <= 0;
					else if(lfd_state)
					    internal_parity <= internal_parity ^ header;
				   else if(pkt_valid && ld_state && !full_state)
					    internal_parity <= internal_parity ^ data_in;
					else 
					    internal_parity <= internal_parity;
				end
			
		  //packet parity logic 
		  always@(posedge clock)
		       begin
				    if(!resetn)
					     packet_parity <= 0;
				    else if(detect_add)
					     packet_parity <= 0;
					 else if(ld_state && !pkt_valid)
					     packet_parity <= data_in;
					 else
					     packet_parity <= packet_parity;
				 end
		 
		 //low_packet_valid logic
		 always@(posedge clock)
		       begin
				    if(!resetn)
					     low_packet_valid <= 0;
					 else if(rst_int_reg)
					     low_packet_valid <= 0;
					 else if(ld_state && !pkt_valid)
					     low_packet_valid <= 1'b1;
					 else 
					     low_packet_valid <= low_packet_valid;
				 end
		
		 //parity done logic 
		 always@(posedge clock)
		       begin
				    if(!resetn)
					     parity_done <= 0;
					 else if(detect_add)
					     parity_done <= 0;
					 else if((ld_state && !pkt_valid && !fifo_full) ||
					         (laf_state && low_packet_valid && !parity_done))
						  parity_done <= 1'b1;
					 else
					     parity_done <= parity_done;
				 end
		 
		 //error logic 
		 always@(posedge clock)
		      begin
				   if(!resetn)
					    err <= 0;
					else 
					    begin
						    if(parity_done)
							    begin
								    if(internal_parity == packet_parity)
									     err <= 1'b0;
									 else
									     err <= 1'b1;
								 end
							 else
							    err <= 1'b0;
						 end
			  end
endmodule
					    
				 
		 
			
					      
					      