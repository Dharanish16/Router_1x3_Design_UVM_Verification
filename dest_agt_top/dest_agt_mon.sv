
class dest_agt_mon extends uvm_monitor;

    //factory resgistration
    `uvm_component_utils(dest_agt_mon)

    //interface handle
    virtual router_if.DST_MON vif;

    //configuration class
    dest_agt_config dst_cfg;

    //analysis port declaration
    uvm_analysis_port #(dest_xtn) dest_monitor_port;

    dest_xtn dst_xtn;

    extern function new(string name="dest_agt_mon",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task collect_data();

endclass

//constructor new method
function dest_agt_mon::new(string name="dest_agt_mon",uvm_component parent);
    super.new(name,parent);
    dest_monitor_port = new("dest_monitor_port",this);
endfunction

//build phase of destination agent monitor
function void dest_agt_mon::build_phase(uvm_phase phase);
    //`uvm_info("INFO","This is the build phase of destination agent monitor",UVM_LOW)
    super.build_phase(phase);
    //get the source agent config using uvm_config_db
    if(!uvm_config_db #(dest_agt_config)::get(this,"","dst_cfg",dst_cfg))
        `uvm_fatal("DST CONFIG","cannot get the uvm_config_db. Have you set it?")
endfunction

//connect phase of dest agent monitor
function void dest_agt_mon::connect_phase(uvm_phase phase);
    vif = dst_cfg.vif;
endfunction

//run phase of dest agent monitor
task dest_agt_mon::run_phase(uvm_phase phase);
    forever
        begin
            collect_data();
        end
endtask

//task collect data
task dest_agt_mon::collect_data();

    dst_xtn = dest_xtn::type_id::create("dst_xtn");

    //wait for read enable high and next cycle we will get the data
    //wait(vif.dst_mon_cb.read_enb == 1'b1)
    while(vif.dst_mon_cb.read_enb !== 1'b1)
        begin
            @(vif.dst_mon_cb);
        end
    //next cycle
    @(vif.dst_mon_cb);
    //assigning the data_out present in interface to header in destination transaction
    dst_xtn.header = vif.dst_mon_cb.data_out; //sampling the header
    
    //assigning size for the payload
    dst_xtn.payload_data = new[dst_xtn.header[7:2]];
    //sampling the payload will happen in the next cycle
    @(vif.dst_mon_cb);

    foreach(dst_xtn.payload_data[i])
        begin
            //then sample the payload data
            dst_xtn.payload_data[i] = vif.dst_mon_cb.data_out;
            //next payload information has to recieve in the next cycle
            @(vif.dst_mon_cb);
        end
    
    //parity 
    dst_xtn.parity = vif.dst_mon_cb.data_out;
    @(vif.dst_mon_cb);

    //`uvm_info("DST_MON","destination monitor",UVM_LOW);
    //print
    //dst_xtn.print();

    //broadcasting this data to scoreboard
    if(dst_xtn.header)
    dest_monitor_port.write(dst_xtn);

endtask