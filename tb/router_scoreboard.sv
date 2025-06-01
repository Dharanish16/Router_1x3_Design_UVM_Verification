
class router_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(router_scoreboard)

    //declaration of tlm analysis ports
    uvm_tlm_analysis_fifo #(source_xtn) fifo_srch[];
    uvm_tlm_analysis_fifo #(dest_xtn) fifo_dsth[];

    //handles for transactions to store the tlm analysis data
    source_xtn s_xtnh;
    dest_xtn d_xtnh;
    
    //environment config
    env_cfg cfg;

    int data_verified_count;


    extern function new(string name = "router_scoreboard",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task pkt_compare();
    extern function void report_phase(uvm_phase phase);

    //source side covergroup
    covergroup router_fcov1;
        option.per_instance = 1;
        //address
        ADDR : coverpoint s_xtnh.header [1:0] {
                                                bins addr1 = {2'b00};
                                                bins addr2 = {2'b01};
                                                bins addr3 = {2'b10};
                                                }
        PAYLOAD : coverpoint s_xtnh.header [7:2] {
                                                bins payload1 = {[1:14]};
							                    bins payload2 = {[15:30]};
							                    bins payload3 = {[31:63]};
                                                }
        ERROR : coverpoint s_xtnh.err {
                                        bins e1 ={1'b0};
						                bins e2 ={1'b1};
                                        }
        ADDR_X_PAYLOAD : cross ADDR,PAYLOAD;
    endgroup

    //destination side covergroup
    covergroup router_fcov2;
	
		option.per_instance = 1;
		
		ADDR_D : coverpoint d_xtnh.header[1:0]{
							bins addr_d1 = {2'b00};
							bins addr_d2 = {2'b01};
							bins addr_d3 = {2'b10};
							}
		PAYLOAD_D : coverpoint d_xtnh.header[7:2]{
							bins payload_d1 = {[1:14]};
							bins payload_d2 = {[15:30]};
							bins payload_d3 = {[31:63]};
							}
	
		ADDR_DXPAYLOAD_D :cross ADDR_D,PAYLOAD_D;
	endgroup
endclass 

//constructor new method
function router_scoreboard::new(string name = "router_scoreboard",uvm_component parent);
    super.new(name,parent);
    router_fcov1 = new();
	router_fcov2 = new();
endfunction

//build phase of router scoreboard
function void router_scoreboard::build_phase(uvm_phase phase);
    //`uvm_info("INFO","This is the build phase of router scoreboard",UVM_LOW)
    super.build_phase(phase);
    
    //get the env_cfg 
    if(!uvm_config_db #(env_cfg)::get(this,"","cfg",cfg))
			`uvm_fatal(get_type_name(),"cannot get the env_cfg")

	fifo_srch = new[cfg.no_of_src_agents];
	fifo_dsth = new[cfg.no_of_dst_agents];
		
	foreach(fifo_srch[i])
		fifo_srch[i] = new($sformatf("fifo_srch[%0d]",i),this);
		
	foreach(fifo_dsth[i])
		fifo_dsth[i] = new($sformatf("fifo_dsth[%0d]",i),this);

endfunction 

//run phase of scoreboard
task router_scoreboard::run_phase(uvm_phase phase);

    forever
        fork
            //source side 
            begin
                //get the source transaction
                fifo_srch[0].get(s_xtnh);
                `uvm_info("SB","SRC_MON",UVM_LOW)
                s_xtnh.print();
                router_fcov1.sample();
            end

            //destination side
            begin
                fork
                    begin
                        fifo_dsth[0].get(d_xtnh);
                        `uvm_info("SB","DST_MON",UVM_LOW)
                        d_xtnh.print();
                        router_fcov2.sample();
                    end

                    begin
                        fifo_dsth[1].get(d_xtnh);
                        `uvm_info("SB","DST_MON",UVM_LOW)
                        d_xtnh.print();
                        router_fcov2.sample();
                    end

                    begin
                        fifo_dsth[2].get(d_xtnh);
                        `uvm_info("SB","DST_MON",UVM_LOW)
                        d_xtnh.print();
                        router_fcov2.sample();
                    end
                join_any

                disable fork;

                //task compare
                pkt_compare();
            end
        join
endtask

//task compare
task router_scoreboard::pkt_compare();
		
	if(s_xtnh.header != d_xtnh.header)
		`uvm_error(get_type_name(),"error in comparing the header")
			
	else
		begin
			if(s_xtnh.payload_data != d_xtnh.payload_data)
				`uvm_error(get_type_name(),"error in comparing the payload") 
				
			if(s_xtnh.parity != d_xtnh.parity)
				`uvm_error(get_type_name(),"error in comparing the parity")
			else
				data_verified_count++;
		end	
endtask

//report phase
function void router_scoreboard::report_phase(uvm_phase phase);

    `uvm_info(get_type_name(),$sformatf("Report: Number of data verified in scoreboard %0d",data_verified_count),UVM_LOW)
endfunction