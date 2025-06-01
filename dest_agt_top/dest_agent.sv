
class dest_agent extends uvm_agent;

    //Factory registration
    `uvm_component_utils(dest_agent)

    //destination driver handle
    dest_agt_drv dst_drv;

    //destination seqr handle
    dest_agt_seqr dst_seqr;

    //destination monitor handle
    dest_agt_mon dst_mon;

    //destination agent config
    dest_agt_config dst_cfg;

    extern function new(string name = "dest_agent",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

//constructor new method
function dest_agent::new(string name = "dest_agent",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of destination agent
function void dest_agent::build_phase(uvm_phase phase);

    //`uvm_info("INFO","This is the build phase of destination agent",UVM_LOW)
    //get the destination agent config using uvm_config_db
    if(!uvm_config_db #(dest_agt_config)::get(this,"","dst_cfg",dst_cfg))
        `uvm_fatal("CONFIG","Cannot ge the destination agent config. Have you set it?")
    //creating memory for monitor
    dst_mon = dest_agt_mon::type_id::create("dst_mon",this);
    if(dst_cfg.is_active == UVM_ACTIVE)
        begin
            dst_drv = dest_agt_drv::type_id::create("dst_drv",this);
            dst_seqr = dest_agt_seqr::type_id::create("dst_seqr",this);
        end
    super.build_phase(phase);

endfunction

//connect phase of dest agent
function void dest_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(dst_cfg.is_active==UVM_ACTIVE)
		begin
			dst_drv.seq_item_port.connect(dst_seqr.seq_item_export);
  		end
endfunction