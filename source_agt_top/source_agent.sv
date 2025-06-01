
class source_agent extends uvm_agent;

    //Factory registration
    `uvm_component_utils(source_agent)

    //source driver handle
    source_agt_drv src_drv;
    //source sequencer handle
    source_agt_seqr src_seqr;
    //source monitor Handle
    source_agt_mon src_mon;

    //source agent config handle
    src_agt_config src_cfg;

    extern function new(string name="source_agent",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

//constructor new method
function source_agent::new(string name="source_agent",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of source agent
function void source_agent::build_phase(uvm_phase phase);

    //`uvm_info("INFO","This is the build phase of source agent",UVM_LOW)
    //get the source agent config using uvm_config_db
    if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",src_cfg))
        `uvm_fatal("CONFIG","Cannot ge the source agent config. Have you set it?")
    //creating memory for monitor
    src_mon = source_agt_mon::type_id::create("src_mon",this);
    if(src_cfg.is_active == UVM_ACTIVE)
        begin
            src_drv = source_agt_drv::type_id::create("src_drv",this);
            src_seqr = source_agt_seqr::type_id::create("src_seqr",this);
        end
    super.build_phase(phase);
endfunction

//connect phase of source agent
function void source_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(src_cfg.is_active==UVM_ACTIVE)
		begin
			src_drv.seq_item_port.connect(src_seqr.seq_item_export);
  		end
endfunction