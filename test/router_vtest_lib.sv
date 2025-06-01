

class router_base_test extends uvm_test;

    //Factory registration
    `uvm_component_utils(router_base_test)

    //declaring no of source and destination agents
    int no_of_src_agents = 1;
    int no_of_dst_agents = 3;

    //handles for source,destination and env configs
    src_agt_config src_cfg[];
    dest_agt_config dst_cfg[];
    env_cfg cfg;

    //handle for router_env 
    router_env envh;

    virtual_sequencer v_seqrh;


    extern function new(string name="router_base_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    
endclass

//constructor new method
function router_base_test::new(string name="router_base_test",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase method of router_base_test
function void router_base_test::build_phase(uvm_phase phase);
    //`uvm_info("INFO","This is the build phase of test",UVM_LOW)
    //create a memory for env config
    cfg = env_cfg::type_id::create("cfg");
    // initialize the dynamic array of source config equal to no_of_src_agents
    src_cfg = new[no_of_src_agents];
    // for all the configuration objects, set the following parameters 
	// is_active to UVM_ACTIVE
    foreach(src_cfg[i])
        begin
            //creating an instance for src_agt_config using src_cfg
            src_cfg[i] = src_agt_config::type_id::create($sformatf("src_cfg[%0d]",i));
            
		    // Get the virtual interface from the config database
            if(!uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("src_if%0d",i),src_cfg[i].vif))
                `uvm_fatal("CONFIG","Unable to get the uvm_config_db. Have you set it?")
            src_cfg[i].is_active = UVM_ACTIVE;

        end
    // initialize the dynamic array of dest config equal to no_of_dest_agents
    dst_cfg = new[no_of_dst_agents];
    // for all the configuration objects, set the following parameters
    // is_active to UVM_ACTIVE
    foreach(dst_cfg[i])
        begin
            //creating an instance for dest_agt_config using dest_cfg
            dst_cfg[i] = dest_agt_config::type_id::create($sformatf("dst_cfg[%0d]",i));

            //get the virtual interface from the config database
            if(!uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("dst_if%0d",i),dst_cfg[i].vif))
                `uvm_fatal("CONFIG","Unable to get the router interface. Have you set it?")
            dst_cfg[i].is_active = UVM_ACTIVE;
        end
    
    //connecting the source and dest configs to env configs
    cfg.src_cfg = src_cfg;
    cfg.dst_cfg = dst_cfg;

    //properties connection with the env configs
    cfg.no_of_src_agents = no_of_src_agents;
    cfg.no_of_dst_agents = no_of_dst_agents;

    // set the env config object into UVM config DB  
	uvm_config_db #(env_cfg)::set(this,"*","cfg",cfg);

    //create a memory for env
    envh = router_env::type_id::create("envh",this);
    super.build_phase(phase);

endfunction

//start of simulation phase for router base test
function void router_base_test::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology;
endfunction

//----------------------------small_test_0-----------------------------//
class small_test_0 extends router_base_test;

    //factory registration
    `uvm_component_utils(small_test_0)

    bit [1:0] addr;
    //handle for small pkt
    //small_pkt small_pkth;

    normal_seq n_seq;

    //handles for small_seq 
    small_seq small_seqh;

    extern function new(string name="small_test_0",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function small_test_0::new(string name="small_test_0",uvm_component parent);
    super.new(name,parent);
endfunction

//small_test build phase
function void small_test_0::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//small_pkt run_phase
task small_test_0::run_phase(uvm_phase phase);

    //creating a memory for small_pkt
    small_seqh = small_seq::type_id::create("small_seqh");
    //small_pkth = small_pkt::type_id::create("small_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 0;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
        //fork
            //small_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
            //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
            small_seqh.start(envh.v_seqrh);
            //n_seq.start(envh.v_seqrh);
        //join
    //#100;
    end
    #200;
    phase.drop_objection(this);

endtask

//----------------------------Medium_test_0-----------------------------//
class medium_test_0 extends router_base_test;

    //factory registration
    `uvm_component_utils(medium_test_0)

    bit [1:0] addr;
    //handle for medium pkt
    medium_pkt medium_pkth;

    medium_seq m_seqh;

    normal_seq n_seq;
    extern function new(string name="medium_test_0",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function medium_test_0::new(string name="medium_test_0",uvm_component parent);
    super.new(name,parent);
endfunction

//medium_test build phase
function void medium_test_0::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//medium_test run_phase
task medium_test_0::run_phase(uvm_phase phase);

    //creating a memory for medium_pkt
    m_seqh = medium_seq::type_id::create("m_seqh");
    //medium_pkth = medium_pkt::type_id::create("medium_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 0;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    fork
        //medium_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
        m_seqh.start(envh.v_seqrh);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    join
    //#100;
    end
    #500;
    phase.drop_objection(this);

endtask

//----------------------------Big_test_0-----------------------------//
class big_test_0 extends router_base_test;

    //factory registration
    `uvm_component_utils(big_test_0)

    bit [1:0] addr;
    //handle for big pkt
    big_pkt big_pkth;

    normal_seq n_seq;

    big_seq b_seqh;

    extern function new(string name="big_test_0",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function big_test_0::new(string name="big_test_0",uvm_component parent);
    super.new(name,parent);
endfunction

//big_test build phase
function void big_test_0::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//big_test run_phase
task big_test_0::run_phase(uvm_phase phase);

    //creating a memory for big_pkt
    b_seqh = big_seq::type_id::create("b_seqh");
    //big_pkth = big_pkt::type_id::create("big_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 0;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    fork
        b_seqh.start(envh.v_seqrh);
        //big_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    join
    end
    #100;
    phase.drop_objection(this);

endtask

//----------------------------Medium_soft_reset_test-----------------------------//
/*class medium_soft_reset_test extends router_base_test;

    //factory registration
    `uvm_component_utils(medium_soft_reset_test)

    bit [1:0] addr;
    //handle for medium pkt
    //medium_pkt medium_pkth;

    //medium_seq m_seqh;

    medium_sft_rst_seq m_sft_rst_seqh;

    extern function new(string name="medium_soft_reset_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function medium_soft_reset_test::new(string name="medium_soft_reset_test",uvm_component parent);
    super.new(name,parent);
endfunction

//medium_test build phase
function void medium_soft_reset_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//medium_test run_phase
task medium_soft_reset_test::run_phase(uvm_phase phase);

    //creating a memory for medium_pkt
    //m_seqh = medium_sft_rst_seq::type_id::create("m_seqh");
    m_sft_rst_seqh = medium_sft_rst_seq::type_id::create("m_sft_rst_seqh");

    //setting any one address among {0,1,2}
    addr = $urandom%3;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    //fork
        m_sft_rst_seqh.start(envh.v_seqrh);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    //join
    //#100;
    end
    #500;
    phase.drop_objection(this);

endtask*/

//----------------------------error_test medium-----------------------------//
class error_test extends router_base_test;

    //factory registration
    `uvm_component_utils(error_test)

    bit [1:0] addr;
    //handle for medium pkt
    //medium_pkt medium_pkth;

    error_vseq error_vseqh;

    //normal_seq n_seq;
    extern function new(string name="error_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function error_test::new(string name="error_test",uvm_component parent);
    super.new(name,parent);
endfunction

//medium_test build phase
function void error_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//medium_test run_phase
task error_test::run_phase(uvm_phase phase);

    //creating a memory for medium_pkt
    error_vseqh = error_vseq::type_id::create("error_vseqh");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = $urandom%3;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    //fork
        error_vseqh.start(envh.v_seqrh);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    //join
    //#100;
    end
    #500;
    phase.drop_objection(this);

endtask

//----------------------------small_test_1-----------------------------//
class small_test_1 extends router_base_test;

    //factory registration
    `uvm_component_utils(small_test_1)

    bit [1:0] addr;
    //handle for small pkt
    //small_pkt small_pkth;

    normal_seq n_seq;

    //handles for small_seq 
    small_seq small_seqh;

    extern function new(string name="small_test_1",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function small_test_1::new(string name="small_test_1",uvm_component parent);
    super.new(name,parent);
endfunction

//small_test build phase
function void small_test_1::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//small_pkt run_phase
task small_test_1::run_phase(uvm_phase phase);

    //creating a memory for small_pkt
    small_seqh = small_seq::type_id::create("small_seqh");
    //small_pkth = small_pkt::type_id::create("small_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 1;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
        //fork
            //small_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
            //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
            small_seqh.start(envh.v_seqrh);
            //n_seq.start(envh.v_seqrh);
        //join
    //#100;
    end
    #200;
    phase.drop_objection(this);

endtask

//----------------------------small_test_2-----------------------------//
class small_test_2 extends router_base_test;

    //factory registration
    `uvm_component_utils(small_test_2)

    bit [1:0] addr;
    //handle for small pkt
    //small_pkt small_pkth;

    normal_seq n_seq;

    //handles for small_seq 
    small_seq small_seqh;

    extern function new(string name="small_test_2",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function small_test_2::new(string name="small_test_2",uvm_component parent);
    super.new(name,parent);
endfunction

//small_test build phase
function void small_test_2::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//small_pkt run_phase
task small_test_2::run_phase(uvm_phase phase);

    //creating a memory for small_pkt
    small_seqh = small_seq::type_id::create("small_seqh");
    //small_pkth = small_pkt::type_id::create("small_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 2;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
        //fork
            //small_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
            //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
            small_seqh.start(envh.v_seqrh);
            //n_seq.start(envh.v_seqrh);
        //join
    //#100;
    end
    #200;
    phase.drop_objection(this);

endtask

//----------------------------Medium_test_1-----------------------------//
class medium_test_1 extends router_base_test;

    //factory registration
    `uvm_component_utils(medium_test_1)

    bit [1:0] addr;
    //handle for medium pkt
    medium_pkt medium_pkth;

    medium_seq m_seqh;

    normal_seq n_seq;
    extern function new(string name="medium_test_1",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function medium_test_1::new(string name="medium_test_1",uvm_component parent);
    super.new(name,parent);
endfunction

//medium_test build phase
function void medium_test_1::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//medium_test run_phase
task medium_test_1::run_phase(uvm_phase phase);

    //creating a memory for medium_pkt
    m_seqh = medium_seq::type_id::create("m_seqh");
    //medium_pkth = medium_pkt::type_id::create("medium_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 1;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    fork
        //medium_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
        m_seqh.start(envh.v_seqrh);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    join
    //#100;
    end
    #500;
    phase.drop_objection(this);

endtask

//----------------------------Medium_test_2-----------------------------//
class medium_test_2 extends router_base_test;

    //factory registration
    `uvm_component_utils(medium_test_2)

    bit [1:0] addr;
    //handle for medium pkt
    medium_pkt medium_pkth;

    medium_seq m_seqh;

    normal_seq n_seq;
    extern function new(string name="medium_test_2",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function medium_test_2::new(string name="medium_test_2",uvm_component parent);
    super.new(name,parent);
endfunction

//medium_test build phase
function void medium_test_2::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//medium_test run_phase
task medium_test_2::run_phase(uvm_phase phase);

    //creating a memory for medium_pkt
    m_seqh = medium_seq::type_id::create("m_seqh");
    //medium_pkth = medium_pkt::type_id::create("medium_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 2;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    fork
        //medium_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
        m_seqh.start(envh.v_seqrh);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    join
    //#100;
    end
    #500;
    phase.drop_objection(this);

endtask

//----------------------------Big_test_1-----------------------------//
class big_test_1 extends router_base_test;

    //factory registration
    `uvm_component_utils(big_test_1)

    bit [1:0] addr;
    //handle for big pkt
    big_pkt big_pkth;

    normal_seq n_seq;

    big_seq b_seqh;

    extern function new(string name="big_test_1",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function big_test_1::new(string name="big_test_1",uvm_component parent);
    super.new(name,parent);
endfunction

//big_test build phase
function void big_test_1::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//big_test run_phase
task big_test_1::run_phase(uvm_phase phase);

    //creating a memory for big_pkt
    b_seqh = big_seq::type_id::create("b_seqh");
    //big_pkth = big_pkt::type_id::create("big_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 1;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    fork
        b_seqh.start(envh.v_seqrh);
        //big_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    join
    end
    #100;
    phase.drop_objection(this);

endtask

//----------------------------Big_test_2-----------------------------//
class big_test_2 extends router_base_test;

    //factory registration
    `uvm_component_utils(big_test_2)

    bit [1:0] addr;
    //handle for big pkt
    big_pkt big_pkth;

    normal_seq n_seq;

    big_seq b_seqh;

    extern function new(string name="big_test_2",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

//constructor new method
function big_test_2::new(string name="big_test_2",uvm_component parent);
    super.new(name,parent);
endfunction

//big_test build phase
function void big_test_2::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//big_test run_phase
task big_test_2::run_phase(uvm_phase phase);

    //creating a memory for big_pkt
    b_seqh = big_seq::type_id::create("b_seqh");
    //big_pkth = big_pkt::type_id::create("big_pkth");
    //n_seq = normal_seq::type_id::create("n_seq");

    //setting any one address among {0,1,2}
    addr = 2;

    //set this address value using config_db
    uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

    phase.raise_objection(this);
    repeat(1)
    begin
    fork
        b_seqh.start(envh.v_seqrh);
        //big_pkth.start(envh.src_agt_toph.src_agt[0].src_seqr);
        //n_seq.start(envh.dst_agt_toph.dst_agt[addr].dst_seqr);
    join
    end
    #100;
    phase.drop_objection(this);

endtask