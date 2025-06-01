
class source_agt_drv extends uvm_driver #(source_xtn);

    //factory registration
    `uvm_component_utils(source_agt_drv)

    //declare virtual interface handle with SRC_DRV modport
    virtual router_if.SRC_DRV vif;

    //source agent config
    src_agt_config src_cfg;

    source_xtn xtn;

    //standard methods
    extern function new(string name="source_agt_drv", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(source_xtn xtn);

endclass

//constructor new method
function source_agt_drv::new(string name="source_agt_drv", uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of source agent driver
function void source_agt_drv::build_phase(uvm_phase phase);
    super.build_phase(phase);
    //get the source agent config using uvm_config_db
    if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",src_cfg))
        `uvm_fatal("SRC CONFIG","cannot get the uvm_config_db. Have you set it?")
    //`uvm_info("INFO","This is the build phase of source agent driver",UVM_LOW)
endfunction

//connect phase of source agent driver
function void source_agt_drv::connect_phase(uvm_phase phase);
    vif = src_cfg.vif;
endfunction

//run_phase of soure agent driver
task source_agt_drv::run_phase(uvm_phase phase);

    //as we are driving the information at output skew of the posedge edge of clock, because of that we are using NBA
    //as resetn signal is active low signal, resetn will take place when it is 0
    @(vif.src_drv_cb); //clocking event 1st cycle 
    vif.src_drv_cb.resetn <= 1'b0;
    //and in the next clock cycle we are making resetn to 1
    @(vif.src_drv_cb); //clocking event 2nd cycle
    vif.src_drv_cb.resetn <= 1'b1;

    forever 
        begin
            seq_item_port.get_next_item(req); //sending the request
            send_to_dut(req);
            seq_item_port.item_done(); 
        end
endtask

//send to dut task
task source_agt_drv::send_to_dut(source_xtn xtn);

    `uvm_info("SRC_DRV","source driver",UVM_LOW);
    //`uvm_info("SRC_DRV",$sformatf("SRC_DRV packet is",xtn.sprint()),UVM_LOW)
    xtn.print();
    @(vif.src_drv_cb);
         //wait for busy signal to be low so that header can pass
    //wait(vif.src_drv_cb.busy == 0) 
    //$display("Source driver");
    while(vif.src_drv_cb.busy) //we dont know when the busy cycle is low
       begin
       @(vif.src_drv_cb);
       end
    //if we want to drive the data we need to set the pkt_valid to high
    vif.src_drv_cb.pkt_valid <= 1'b1;
    //now we are driving the header present in xtn to data_in present in src driver interface
    vif.src_drv_cb.data_in <= xtn.header;
    //in the next clock event we have to pass the payload data
    @(vif.src_drv_cb); //clocking event 3rd cycle

    //based on the payload length we have to drive the data
    foreach(xtn.payload_data[i])
        begin
            //on checking the busy signal we have to drive the data
            //wait(vif.src_drv_cb.busy == 0)
            while(vif.src_drv_cb.busy)
                begin
                @(vif.src_drv_cb);
                end
            vif.src_drv_cb.data_in <= xtn.payload_data[i];
            //also one clock event is required so that the data will drive in the next cycle
            @(vif.src_drv_cb);
        end
    //for parity also we are checking with the busy signal
    //problem arises when payload load length is 1 

    //wait(vif.src_drv_cb.busy == 0)
    while(vif.src_drv_cb.busy)
        begin
        @(vif.src_drv_cb);
        end
    //for driving the parity value, pkt_valid should be low
    vif.src_drv_cb.pkt_valid <= 1'b0;
    //in the same cycle, we need to drive the parity
    vif.src_drv_cb.data_in <= xtn.parity;
    //repeat(2)
    @(vif.src_drv_cb);


endtask
