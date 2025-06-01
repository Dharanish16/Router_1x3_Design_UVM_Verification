
class dest_agt_drv extends uvm_driver #(dest_xtn);

    //factory registration
    `uvm_component_utils(dest_agt_drv)
    
    //interface 
    virtual router_if.DST_DRV vif;

    //destination configuration handle
    dest_agt_config dst_cfg; 

    dest_xtn xtn;

    extern function new(string name = "dest_agt_drv", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(dest_xtn xtn);

endclass

//constructor new method
function dest_agt_drv::new(string name = "dest_agt_drv", uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of destination agent driver
function void dest_agt_drv::build_phase(uvm_phase phase);
    //`uvm_info("INFO","This is the build phase of destination agent driver",UVM_LOW)
    super.build_phase(phase);

    //getting the dest_agt_config
    if(!uvm_config_db #(dest_agt_config)::get(this,"","dst_cfg",dst_cfg))
        `uvm_fatal("DEST CONFIG","cannot get the dest_agt_config, Have you set it properly")
endfunction

//connect phase of dest agent driver
function void dest_agt_drv::connect_phase(uvm_phase phase);
    vif = dst_cfg.vif;
endfunction

//run phase of dest agent driver
task dest_agt_drv::run_phase(uvm_phase phase);

    forever 
        begin
            seq_item_port.get_next_item(req); //sending the request
            send_to_dut(req);
            seq_item_port.item_done(); 
        end
endtask

//send to dut task
task dest_agt_drv::send_to_dut(dest_xtn xtn);

    vif.dst_drv_cb.read_enb <= 1'b0;
    //`uvm_info("DST_DRV","destination driver",UVM_LOW);
    //xtn.print();
    //first vld_out signal should be high so we need to wait till it becomes high
    //wait(vif.dst_drv_cb.vld_out == 1'b1)
    $display("no_of_cycles_1 is %0d",xtn.no_of_cycles);
    while(vif.dst_drv_cb.vld_out !== 1'b1)
        begin
            @(vif.dst_drv_cb);
        end
    //in the next cycle we need to make the read enable signal high 
    //one delay
    repeat(xtn.no_of_cycles)
        @(vif.dst_drv_cb);
    $display("no_of_cycles is %0d",xtn.no_of_cycles);
    //making read enable high
    vif.dst_drv_cb.read_enb <= 1'b1;
    @(vif.dst_drv_cb);
    
    //once the data is transfered wait for vld_out goes low
    //wait(vif.dst_drv_cb.vld_out == 1'b0)
    while(vif.dst_drv_cb.vld_out !== 1'b0)
        begin
            @(vif.dst_drv_cb);
        end
    //in the next cycle we need to make the read enable signal low
    @(vif.dst_drv_cb);
    //making read enable low
    vif.dst_drv_cb.read_enb <= 1'b0;

    //repeat(2)
        //@(vif.dst_drv_cb);
endtask