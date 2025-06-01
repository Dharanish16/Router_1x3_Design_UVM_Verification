
class env_cfg extends uvm_object;

    //factory registration
    `uvm_object_utils(env_cfg)

    //handles for source and destination configs
    src_agt_config src_cfg[];
    dest_agt_config dst_cfg[];

    //declaring no of source and destination agents
    int no_of_src_agents = 1;
    int no_of_dst_agents = 3;

    bit has_src_agt_top = 1;
    bit has_dst_agt_top = 1;
    bit has_scoreboard = 1;
    bit has_virtual_sequencer = 1;
    
    extern function new(string name="env_cfg");

endclass

//constructor new method
function env_cfg::new(string name="env_cfg");
    super.new(name);
endfunction
