
class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

    //factory registration
    `uvm_component_utils(virtual_sequencer)

    //dynamic handles for source and destination agent sequencers
    source_agt_seqr src_agt_seqrh[];
    dest_agt_seqr dest_agt_seqrh[];

    //handle for environment config
    env_cfg cfg;

    //standard methods
    extern function new(string name="virtual_sequencer",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
endclass

//constructor new method
function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of virtual sequencer
function void virtual_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);

    //get the environment config
    if(!uvm_config_db #(env_cfg)::get(this,"","cfg",cfg))
        `uvm_fatal(get_type_name(),"Cannot get the env_cfg from uvm_config_db. Have you set it properly?")

    src_agt_seqrh = new[cfg.no_of_src_agents];
    dest_agt_seqrh = new[cfg.no_of_dst_agents];
    
endfunction