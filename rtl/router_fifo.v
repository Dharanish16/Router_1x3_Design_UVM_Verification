
module router_fifo(clock,resetn,data_in,read_enb,write_enb,data_out,full,empty,
                  lfd_state,soft_reset);
      
		input clock,resetn,read_enb,write_enb,lfd_state,soft_reset;
		input [7:0]data_in;
		reg [4:0]rd_pointer,wr_pointer;
		output reg [7:0]data_out;
		output full,empty;
		
		reg [8:0]mem[15:0];
		reg temp;
		reg [6:0]count;
		integer i,j;
		
		//logic for fifo full & empty
		assign full = ((wr_pointer[4] != rd_pointer[4]) && (wr_pointer[3:0] == rd_pointer[3:0]));
		assign empty = (wr_pointer == rd_pointer);
		
		//delaying lfd_state by 1 clock to latch the header byte
		always@(posedge clock)
		    begin
			    if (!resetn)
				      temp <= 0;
				 else 
				      temp <= lfd_state;
			 end
			 
	   //Write Logic
		always@(posedge clock)
		    begin
			    if(!resetn)
				    begin
					    for(i=0;i<16;i=i+1)
						   begin
						     mem[i] <= 0;
							  wr_pointer <= 0;
							end
					 end
				 else if(soft_reset)
				    begin
					    for(j=0;j<16;j=j+1)
						   begin
						     mem[j] <= 0;
							  wr_pointer <= 0;
							end
					 end
				 else if(write_enb && !full)
				    begin
				       {mem[wr_pointer[3:0]][8],mem[wr_pointer[3:0]][7:0]} <= {temp,data_in};
		             wr_pointer <= wr_pointer + 1'b1;
					 end
			 end
			 
	   //Read logic
		always@(posedge clock)
		    begin
			    if(!resetn)
				    begin
					    data_out <= 0;
						 rd_pointer <= 0;
					 end
				 else if(soft_reset)
				    begin
					    data_out <= 8'bz;
					 end
			    else if(read_enb && !empty)
				    begin
					    data_out <= mem[rd_pointer[3:0]][7:0];
						 rd_pointer <= rd_pointer + 1'b1;
				 	 end
				 else
				    data_out <= 8'bz;
			 end
			 
		//counter logic	 
		always@(posedge clock)
		    begin
			    if(!resetn)
				    count <= 0;
				 else if(read_enb && !empty)
				   begin
				      if (mem[rd_pointer[3:0]][8] == 1)
						   begin
					        count <= mem[rd_pointer[3:0]][7:2] + 1'b1;
					      end
						else
				         count <= count-1'b1;
					end
				 else
				    count <= count;
			 end
endmodule
				 
				
		
		