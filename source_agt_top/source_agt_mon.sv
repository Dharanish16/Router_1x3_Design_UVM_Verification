
class source_agt_mon extends uvm_monitor;

    //factory registration
    `uvm_component_utils(source_agt_mon)

    //declare virtual interface handle with SRC_MON modport
    virtual router_if.SRC_MON vif;

    //source agent config
    src_agt_config src_cfg;

    // Analysis TLM port to connect the monitor to the scoreboard
  	uvm_analysis_port #(source_xtn) monitor_port;

    source_xtn src_xtn;


    extern function new(string name = "source_agt_mon",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();
endclass

//constructor new method
function source_agt_mon::new(string name = "source_agt_mon",uvm_component parent);
    super.new(name,parent);
    monitor_port = new("monitor_port",this);
endfunction

//build phase of source agent monitor
function void source_agt_mon::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //`uvm_info("INFO","This is the build phase of source agent monitor",UVM_LOW)
    //get the source agent config using uvm_config_db
    if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",src_cfg))
        `uvm_fatal("SRC CONFIG","cannot get the uvm_config_db. Have you set it?")
endfunction

//connect phase of source agent monitor
function void source_agt_mon::connect_phase(uvm_phase phase);
    vif = src_cfg.vif;
endfunction

//run task of source agent monitor
task source_agt_mon::run_phase(uvm_phase phase);

    //as we dont know how many values to sample, we will use forever block here
    forever
        begin
            collect_data();
        end

endtask

//collect data task of source agent monitor
task source_agt_mon::collect_data();

    src_xtn = source_xtn::type_id::create("src_xtn");
    //for sampling the data, first the pkt_valid needs to be high
    //wait(vif.src_mon_cb.pkt_valid == 1'b1)
    while(vif.src_mon_cb.pkt_valid !== 1'b1)
        begin
        @(vif.src_mon_cb);
        end
    //check for busy signal also
    //wait(vif.src_mon_cb.busy == 1'b0)
    while(vif.src_mon_cb.busy !== 1'b0)
        begin
        @(vif.src_mon_cb);
        end
    //getting the header information in the same cycle
    src_xtn.header = vif.src_mon_cb.data_in;

    //assigning size for the payload
    src_xtn.payload_data = new[src_xtn.header[7:2]];
    //sampling the payload will happen in the next cyle
    @(vif.src_mon_cb);

    foreach(src_xtn.payload_data[i])
        begin
            //check the busy signal first
            //wait(vif.src_mon_cb.busy == 1'b0)
            while(vif.src_mon_cb.busy != 1'b0)
                begin
                @(vif.src_mon_cb);
                end
            //then sample the payload data
            src_xtn.payload_data[i] = vif.src_mon_cb.data_in;
            //next payload information has to recieve in the next cycle
            @(vif.src_mon_cb);
        end
    
    //parity 
    src_xtn.parity = vif.src_mon_cb.data_in;

    //for error we need 2 clock cycle delay after the payload data is over
    //1 clock cycle for parity checking and in the next cycle we will check the error signal
    repeat(2)
        @(vif.src_mon_cb);
    src_xtn.err = vif.src_mon_cb.err;

    //`uvm_info("SRC_MON","source monitor",UVM_LOW);
    //printing the data
    //src_xtn.print();
    //`uvm_info("SRC_MON",$sformatf("SRC_MON packet is",src_xtn.sprint()),UVM_LOW)
    //broadcasting the data through analysis port
    monitor_port.write(src_xtn);
endtask

