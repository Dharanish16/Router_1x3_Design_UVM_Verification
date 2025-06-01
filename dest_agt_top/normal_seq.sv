class dst_base_seq extends uvm_sequence #(dest_xtn);

    `uvm_object_utils(dst_base_seq)

    extern function new(string name = "dst_seq");
endclass

//constructor new method
function dst_base_seq::new(string name = "dst_seq");
    super.new(name);
endfunction


class normal_seq extends dst_base_seq;

    `uvm_object_utils(normal_seq)

    extern function new(string name = "normal_seq");
    extern task body();
endclass

//constructor new method
function normal_seq::new(string name = "normal_seq");
    super.new(name);
endfunction

//task body
task normal_seq::body();

    //create a memory object 
    req = dest_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {no_of_cycles < 28;});
    finish_item(req);

endtask

class soft_reset_seq extends dst_base_seq;

    `uvm_object_utils(soft_reset_seq)

    extern function new(string name = "soft_reset_seq");
    extern task body();
endclass

//constructor new method
function soft_reset_seq::new(string name = "soft_reset_seq");
    super.new(name);
endfunction

//task body
task soft_reset_seq::body();

    //create a memory object 
    req = dest_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {no_of_cycles inside {[30:40]};});
    finish_item(req);

endtask