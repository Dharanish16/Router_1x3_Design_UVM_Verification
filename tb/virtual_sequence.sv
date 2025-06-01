
class virtual_base_sequence extends uvm_sequence #(uvm_sequence_item);

    //factory registration
    `uvm_object_utils(virtual_base_sequence)

    virtual_sequencer v_seqrh;
    source_agt_seqr src_agt_seqrh[];
    dest_agt_seqr dest_agt_seqrh[];
    env_cfg cfg;

    //source side handles for sequences
    small_pkt small_pkth;
    medium_pkt medium_pkth;
    big_pkt big_pkth;
    error_pkt error_pkth;

    //destination side sequence handles
    normal_seq normal_seqh;
    soft_reset_seq soft_reset_seqh;

    bit [1:0] addr;

    extern function new(string name="virtual_base_sequence");
    extern task body();

endclass

//constructor new method
function virtual_base_sequence::new(string name="virtual_base_sequence");
    super.new(name);
endfunction

//task body
task virtual_base_sequence::body();
    
    //get the env_cfg
    if(!uvm_config_db #(env_cfg)::get(null,get_full_name(),"cfg",cfg))
        `uvm_fatal(get_type_name(), "Cannot cfg from uvm_config_db")
    
    //get the address from test class
    if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_type_name(),"cannot get addr from uvm_config_db")
                
    src_agt_seqrh = new[cfg.no_of_src_agents];
    dest_agt_seqrh = new[cfg.no_of_dst_agents];

    assert($cast(v_seqrh,m_sequencer)) 
    else 
        begin
    	    `uvm_error("BODY", "$cast error in virtual sequencer")
        end
               
    foreach (src_agt_seqrh[i])
        begin
            src_agt_seqrh[i] = v_seqrh.src_agt_seqrh[i];
        end

    foreach (dest_agt_seqrh[i])    
        begin
            dest_agt_seqrh[i] = v_seqrh.dest_agt_seqrh[i];  
        end
endtask

//--------------------------small sequence--------------------------//
class small_seq extends virtual_base_sequence;

    `uvm_object_utils(small_seq)

    //bit[1:0] addr;

    extern function new(string name="small_seq");
    extern task body();
endclass

//constructor new method
function small_seq::new(string name="small_seq");
    super.new(name);
endfunction

//task body
task small_seq::body();
    super.body();

    $display("addr is %0d",addr);
    //object creation
    small_pkth = small_pkt::type_id::create("small_pkth");
    normal_seqh = normal_seq::type_id::create("normal_seqh");

    for(int i = 0; i < cfg.no_of_src_agents; i++)
        begin
        //fork
			small_pkth.start(src_agt_seqrh[i]);
			normal_seqh.start(dest_agt_seqrh[addr]);
		//join
        end
endtask
//--------------------------------------------------------------------//

//--------------------------medium sequence--------------------------//
class medium_seq extends virtual_base_sequence;

    `uvm_object_utils(medium_seq)

    //bit[1:0] addr;

    extern function new(string name="medium_seq");
    extern task body();
endclass

//constructor new method
function medium_seq::new(string name="medium_seq");
    super.new(name);
endfunction

//task body
task medium_seq::body();
    super.body();

    
    //object creation
    medium_pkth = medium_pkt::type_id::create("medium_pkth");
    normal_seqh = normal_seq::type_id::create("normal_seqh");

    for(int i = 0; i < cfg.no_of_src_agents; i++)
        fork
			medium_pkth.start(src_agt_seqrh[i]);
			normal_seqh.start(dest_agt_seqrh[addr]);
		join
endtask
//--------------------------------------------------------------------//

//--------------------------big sequence--------------------------//
class big_seq extends virtual_base_sequence;

    `uvm_object_utils(big_seq)

    //bit[1:0] addr;

    extern function new(string name="big_seq");
    extern task body();
endclass

//constructor new method
function big_seq::new(string name="big_seq");
    super.new(name);
endfunction

//task body
task big_seq::body();
    super.body();

    //object creation
    big_pkth = big_pkt::type_id::create("big_pkth");
    normal_seqh = normal_seq::type_id::create("normal_seqh");

    for(int i = 0; i < cfg.no_of_src_agents; i++)
        fork
			big_pkth.start(src_agt_seqrh[i]);
			normal_seqh.start(dest_agt_seqrh[addr]);
		join
endtask
//--------------------------------------------------------------------//

//--------------------------medium soft reset sequence--------------------------//
class medium_sft_rst_seq extends virtual_base_sequence;

    `uvm_object_utils(medium_sft_rst_seq)

    //bit[1:0] addr;

    extern function new(string name="medium_sft_rst_seq");
    extern task body();
endclass

//constructor new method
function medium_sft_rst_seq::new(string name="medium_sft_rst_seq");
    super.new(name);
endfunction

//task body
task medium_sft_rst_seq::body();
    super.body();

    //object creation
    medium_pkth = medium_pkt::type_id::create("medium_pkth");
    soft_reset_seqh = soft_reset_seq::type_id::create("soft_reset_seqh");

    for(int i = 0; i < cfg.no_of_src_agents; i++)
        fork
			medium_pkth.start(src_agt_seqrh[i]);
			soft_reset_seqh.start(dest_agt_seqrh[addr]);
		join
endtask
//--------------------------------------------------------------------//

//---------------------------------------error sequence-------------------------//
class error_vseq extends virtual_base_sequence;

    //factory registration
    `uvm_object_utils(error_vseq)

    extern function new(string name="error_vseq");
    extern task body();
endclass

//constructor new method
function error_vseq::new(string name="error_vseq");
    super.new(name);
endfunction

//task body
task error_vseq::body();
    super.body();

    //object creation
    error_pkth = error_pkt::type_id::create("error_pkth");
    normal_seqh = normal_seq::type_id::create("normal_seqh");

    for(int i = 0; i < cfg.no_of_src_agents; i++)
        fork
			error_pkth.start(src_agt_seqrh[i]);
			normal_seqh.start(dest_agt_seqrh[addr]);
		join
endtask
    