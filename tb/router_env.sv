

class router_env extends uvm_env;

    //Factory registration
    `uvm_component_utils(router_env)

    //handle for router source agent top and router destination agent top
    source_agt_top src_agt_toph;
    dest_agt_top dst_agt_toph;

    //handle for router scoreboard
    router_scoreboard s_brd;

    //virtual sequencer handle
    virtual_sequencer v_seqrh;

    //environment config handle
    env_cfg cfg;

    extern function new(string name="router_env",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass

//constructor new method
function router_env::new(string name="router_env",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of router_env
function void router_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(env_cfg)::get(this,"", "cfg", cfg))
        `uvm_fatal("ENV","Unable to get the env_cfg. Have you set it?")

    if(cfg.has_src_agt_top)
        src_agt_toph = source_agt_top::type_id::create("src_agt_toph",this);

    if(cfg.has_dst_agt_top)
        dst_agt_toph = dest_agt_top::type_id::create("dst_agt_toph",this);

    if(cfg.has_scoreboard)
        s_brd = router_scoreboard::type_id::create("s_brd",this);

    if(cfg.has_virtual_sequencer)
        v_seqrh = virtual_sequencer::type_id::create("v_seqrh",this);
    //`uvm_info("Router Env","This is build phase in Router Env",UVM_LOW)
endfunction

//connect phase of environment
function void router_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(cfg.has_src_agt_top)
		begin
			for(int i = 0; i < cfg.no_of_src_agents; i++)
				v_seqrh.src_agt_seqrh[i] = src_agt_toph.src_agt[i].src_seqr;
		end
			
	if(cfg.has_dst_agt_top)
		begin
			for(int i = 0; i < cfg.no_of_dst_agents; i++)
				v_seqrh.dest_agt_seqrh[i] = dst_agt_toph.dst_agt[i].dst_seqr; 
		end

    //connecting the scoreboard
    for(int i = 0; i < cfg.no_of_src_agents; i++)
    //foreach(cfg.src_cfg[i])
		src_agt_toph.src_agt[i].src_mon.monitor_port.connect(s_brd.fifo_srch[i].analysis_export);
				
			
	for(int i = 0; i < cfg.no_of_dst_agents; i++)
		dst_agt_toph.dst_agt[i].dst_mon.dest_monitor_port.connect(s_brd.fifo_dsth[i].analysis_export);

endfunction