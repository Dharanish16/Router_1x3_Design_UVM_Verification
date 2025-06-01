
class dest_agt_seqr extends uvm_sequencer #(dest_xtn);

    //factory registration
    `uvm_component_utils(dest_agt_seqr)


    extern function new(string name="dest_agt_seqr",uvm_component parent);

endclass

//constructor new method
function dest_agt_seqr::new(string name="dest_agt_seqr",uvm_component parent);
    super.new(name,parent);
endfunction
