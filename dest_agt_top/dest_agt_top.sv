
class dest_agt_top extends uvm_agent;

    //factory registration
    `uvm_component_utils(dest_agt_top)

    //destination agent top contains destination agents which can be dynamic
    dest_agent dst_agt[];

    //env config contains information about how many agents
    env_cfg cfg;

    //destination agent config handle
    dest_agt_config dst_cfg;

    extern function new(string name="dest_agt_top",uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass

//constructor new method
function dest_agt_top::new(string name="dest_agt_top",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of destination agent
function void dest_agt_top::build_phase(uvm_phase phase);
    
    //`uvm_info("INFO","This is the build phase of destination agent top",UVM_LOW)
    //get the env config 
    if(!uvm_config_db #(env_cfg)::get(this,"","cfg",cfg))
        `uvm_fatal("CONFIG","Cannot get the env config. Have you set it?")
    
    //fixing the no of destination agents
    dst_agt = new[cfg.no_of_dst_agents];

    //creating memory for all the destination agents
    foreach(dst_agt[i])
        begin
            dst_agt[i] = dest_agent::type_id::create($sformatf("dst_agt[%0d]",i),this);
            //connecting the respective destination configs to those respective destination agents
            //for that we need to set the destination agent config using uvm_config_db
            uvm_config_db #(dest_agt_config)::set(this,$sformatf("dst_agt[%0d]*",i),"dst_cfg",cfg.dst_cfg[i]);
        end
    
endfunction
