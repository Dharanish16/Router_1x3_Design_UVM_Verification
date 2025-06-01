
class source_agt_seqr extends uvm_sequencer #(source_xtn);

    //factory registration
    `uvm_component_utils(source_agt_seqr)


    extern function new(string name="source_agt_seqr",uvm_component parent);

endclass

//constructor new method
function source_agt_seqr::new(string name="source_agt_seqr",uvm_component parent);
    super.new(name,parent);
endfunction