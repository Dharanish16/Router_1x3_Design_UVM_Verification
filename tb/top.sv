


module top;
    

    //import uvm_pkg.sv
	import uvm_pkg::*;

    //import router_test_pkg.sv
    import router_test_pkg::*;

    // Generate clk signal
	bit clock;  
	always 
		#5 clock=!clock; 

    // Instantiate 4 ram_if interface instances in0,in1,in2,in3 with clk as input
    router_if src_if0(clock);
	router_if dst_if0(clock);
	router_if dst_if1(clock);
	router_if dst_if2(clock);

    router_top DUV(.clock(clock),.pkt_valid(src_if0.pkt_valid),.busy(src_if0.busy),.err(src_if0.err),
                    .data_in(src_if0.data_in),.resetn(src_if0.resetn),.data_out_0(dst_if0.data_out),
                    .data_out_1(dst_if1.data_out),.data_out_2(dst_if2.data_out),.read_enb_0(dst_if0.read_enb),
                    .read_enb_1(dst_if1.read_enb),.read_enb_2(dst_if2.read_enb),.vld_out_0(dst_if0.vld_out),
                    .vld_out_1(dst_if1.vld_out),.vld_out_2(dst_if2.vld_out));
    

    initial
        begin

            `ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
            
            uvm_config_db #(virtual router_if) :: set(null,"*", "src_if0",src_if0);
            uvm_config_db #(virtual router_if) :: set(null,"*", "dst_if0",dst_if0);
            uvm_config_db #(virtual router_if) :: set(null,"*", "dst_if1",dst_if1);
            uvm_config_db #(virtual router_if) :: set(null,"*", "dst_if2",dst_if2);
            //call run_test
            run_test();

        end

    /*
    //---------------------------------Assertions--------------------------------------//
    property pkt_valid_2_busy;
        @(posedge clock) $rose(src_if0.pkt_valid) |=> $rose(src_if0.busy);
    endproperty 

    property busy_2_data_in;
        @(posedge clock) src_if0.busy |=> $stable(src_if0.data_in);
    endproperty 

    property pkt_valid_2_vld_out;
        @(posedge clock) $rose(src_if0.pkt_valid) |=> ##2 $rose(dst_if0.vld_out | dst_if1.vld_out | dst_if2.vld_out);
    endproperty 

    property read_enb0;
        @(posedge clock) (dst_if0.vld_out) |-> ##[1:29] (dst_if0.read_enb);
    endproperty 

    property read_enb1;
        @(posedge clock) (dst_if1.vld_out) |-> ##[1:29] (dst_if1.read_enb);
    endproperty 

    property read_enb2;
        @(posedge clock) (dst_if2.vld_out) |-> ##[1:29] (dst_if2.read_enb);
    endproperty 

    property read_enb0_low;
	    @(posedge clock) $fell(dst_if0.vld_out) |=> $fell(dst_if0.read_enb);
    endproperty

    property read_enb1_low;
	    @(posedge clock) $fell(dst_if1.vld_out) |=> $fell(dst_if1.read_enb);
    endproperty

    property read_enb2_low;
	    @(posedge clock) $fell(dst_if2.vld_out) |=> $fell(dst_if2.read_enb);
    endproperty

    A1 : assert property(pkt_valid_2_busy);
        /*    $display("Assertion is successfull for pkt_valid_2_busy");
        else
            $display("Assertions is not successfull for pkt_valid_2_busy");
    
    A2 : assert property(busy_2_data_in);
        //    $display("Assertion is successfull for busy_2_data_in");
        //else
        //    $display("Assertions is not successfull for busy_2_data_in");
        
    A3 : assert property(pkt_valid_2_vld_out);
        //    $display("Assertion is successfull for pkt_valid_2_vld_out");
        //else
        //    $display("Assertions is not successfull for pkt_valid_2_vld_out");
    
    A4 : assert property(read_enb0);
        //    $display("Assertion is successfull for read_enb0");
        //else
        //    $display("Assertions is not successfull for read_enb0");

    A5 : assert property(read_enb1);
        //    $display("Assertion is successfull for read_enb1");
        //else
        //    $display("Assertions is not successfull for read_enb1");

    A6 : assert property(read_enb2);
        //    $display("Assertion is successfull for read_enb2");
        //else
        //    $display("Assertions is not successfull for read_enb2");
    
    A7 : assert property(read_enb0_low);
        //    $display("Assertion is successfull for read_enb0_low");
        //else
        //    $display("Assertions is not successfull for read_enb0_low");
        
    A8 : assert property(read_enb1_low);
        //    $display("Assertion is successfull for read_enb1_low");
        //else
        //    $display("Assertions is not successfull for read_enb1_low");

    A9 : assert property(read_enb2_low);
        //    $display("Assertion is successfull for read_enb2_low");
        //else
        //    $display("Assertions is not successfull for read_enb2_low");

    C1 : cover property(pkt_valid_2_busy);
    C2 : cover property(busy_2_data_in);
    C3 : cover property(pkt_valid_2_vld_out);
    C4 : cover property(read_enb0);
    C5 : cover property(read_enb1);
    C6 : cover property(read_enb2);
    C7 : cover property(read_enb0_low);
    C8 : cover property(read_enb1_low);
    C9 : cover property(read_enb2_low);*/



endmodule