
class source_agt_top extends uvm_env;

    //Factory registration
    `uvm_component_utils(source_agt_top)

    //source agent top contains source agents which can be dynamic
    source_agent src_agt[];

    //env config contains information about how many agents
    env_cfg cfg;

    //source agent config handle
    src_agt_config src_cfg;

    extern function new(string name="source_agt_top",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
endclass

//constructor new method
function source_agt_top::new(string name="source_agt_top",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of source agent top
function void source_agt_top::build_phase(uvm_phase phase);

    //`uvm_info("INFO","This is the build phase of source agent top",UVM_LOW)
    //get the env config 
    if(!uvm_config_db #(env_cfg)::get(this,"", "cfg", cfg))
        `uvm_fatal("CONFIG","Unable to get the env_cfg. Have you set it?")
    //fixing the sources agents using no of source agents from env config
    src_agt = new[cfg.no_of_src_agents];
    //creating a memory for all the source agents
    foreach(src_agt[i])
        begin
            src_agt[i] = source_agent::type_id::create($sformatf("src_agt[%0d]",i),this);
            //connecting the respective source configs to those respective source agents
            //for that we need to set the source agent config using uvm_condig_db
            uvm_config_db #(src_agt_config)::set(this,$sformatf("src_agt[%0d]*",i),"src_agt_config",cfg.src_cfg[i]);
        end
endfunction