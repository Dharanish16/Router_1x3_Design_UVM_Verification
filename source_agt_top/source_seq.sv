
class source_seq extends uvm_sequence #(source_xtn);

    //factory registration
    `uvm_object_utils(source_seq)

    extern function new(string name="source_seq");

endclass

//constructor new method
function source_seq::new(string name="source_seq");
    super.new(name);
endfunction
//-----------------------------small packet---------------------------//
//extend small_pkt from source_seq
class small_pkt extends source_seq;

    //factory registration
    `uvm_object_utils(small_pkt)

    bit [1:0] addr;
    //standard methods
    extern function new(string name="small_pkt");
    extern task body();

endclass
//constructor new method
function small_pkt::new(string name="small_pkt");
    super.new(name);
endfunction

//task body for small pkt
task small_pkt::body();

    //get the address using uvm_config_db
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal("CONFIG","cannot get the uvm_config_db. Have you set it?")
    
    req = source_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0] == addr;});
    finish_item(req);
    
endtask

//-----------------------------Medium packet---------------------------//
//extend medium_pkt from source_seq
class medium_pkt extends source_seq;

    //factory registration
    `uvm_object_utils(medium_pkt)

    bit [1:0] addr;
    //standard methods
    extern function new(string name="medium_pkt");
    extern task body();

endclass
//constructor new method
function medium_pkt::new(string name="medium_pkt");
    super.new(name);
endfunction

//task body for medium pkt
task medium_pkt::body();

    //get the address using uvm_config_db
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal("CONFIG","cannot get the uvm_config_db. Have you set it?")
    
    req = source_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0] == addr;});
    finish_item(req);
    
endtask

//-----------------------------Big packet---------------------------//
//extend big_pkt from source_seq
class big_pkt extends source_seq;

    //factory registration
    `uvm_object_utils(big_pkt)

    bit [1:0] addr;
    //standard methods
    extern function new(string name="big_pkt");
    extern task body();

endclass
//constructor new method
function big_pkt::new(string name="big_pkt");
    super.new(name);
endfunction

//task body for big pkt
task big_pkt::body();

    //get the address using uvm_config_db
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal("CONFIG","cannot get the uvm_config_db. Have you set it?")
    
    req = source_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {header[7:2] inside {[31:63]} && header[1:0] == addr;});
    finish_item(req);
    
endtask

//--------------------------error packet for small-------------------------------------//
class error_pkt extends source_seq;

    //factory registration
    `uvm_object_utils(error_pkt)

    bit[1:0] addr;

    //standard methods
    extern function new(string name="error_pkt");
    extern task body();

endclass

//constructor new method
function error_pkt::new(string name="error_pkt");
    super.new(name);
endfunction

//task body for error_pkt
task error_pkt::body();
   // super.body();

    //get the address using uvm_config_db
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
       `uvm_fatal("CONFIG","cannot get the uvm_config_db. Have you set it?")

    req = source_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {header[7:2] inside {[1:14]} && header[1:0] == addr;});
    req.parity = $urandom;
    finish_item(req);

endtask