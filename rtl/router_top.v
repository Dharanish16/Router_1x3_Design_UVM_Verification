
module router_top(clock,resetn,data_in,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_out_0,
                  data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);
          
       input clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2;
		 input [7:0] data_in;
		 output [7:0] data_out_0,data_out_1,data_out_2;
		 output vld_out_0,vld_out_1,vld_out_2,err,busy;
				
		 wire [2:0] write_enb;
		 wire [7:0] dout;
				
		 router_fifo F1(clock,resetn,dout,read_enb_0,write_enb[0],data_out_0,full_0,empty_0,
                  lfd_state,soft_reset_0);
		 router_fifo F2(clock,resetn,dout,read_enb_1,write_enb[1],data_out_1,full_1,empty_1,
                  lfd_state,soft_reset_1);
		 router_fifo F3(clock,resetn,dout,read_enb_2,write_enb[2],data_out_2,full_2,empty_2,
                  lfd_state,soft_reset_2);
		 
		 
		 router_sync S1(clock,resetn,data_in[1:0],detect_add,full_0,full_1,full_2,empty_0,
                   empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,
						 read_enb_2,vld_out_0,vld_out_1,vld_out_2,fifo_full,
						 soft_reset_0,soft_reset_1,soft_reset_2,write_enb);
		 
		 router_fsm FSM1(clock,resetn,pkt_valid,data_in[1:0],fifo_full,empty_0,empty_1,
                  empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,
						low_packet_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,
						full_state,rst_int_reg,busy);
						
		 router_reg R1(clock,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,
                  full_state,laf_state,lfd_state,rst_int_reg,err,parity_done,
						low_packet_valid,dout);
endmodule

						