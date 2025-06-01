
class dest_xtn extends uvm_sequence_item;

    `uvm_object_utils(dest_xtn)

    //declaring the variables
    bit [7:0] header,payload_data[],parity; 

    //declare the variable for cycles (delay injection)
    rand bit [5:0] no_of_cycles;

    extern function new(string name = "dest_xtn");
    extern function void do_print(uvm_printer printer);

endclass

//constructor new method
function dest_xtn::new(string name = "dest_xtn");
    super.new(name);
endfunction

//function do_print
function void dest_xtn::do_print(uvm_printer printer);
    printer.print_field("header",this.header,8,UVM_BIN);
    foreach(payload_data[i])
        printer.print_field($sformatf("payload_data[%0d]",i),this.payload_data[i],8,UVM_DEC);
    printer.print_field("parity",this.parity,8,UVM_DEC);
    printer.print_field("no_of_cycles",this.no_of_cycles,6,UVM_DEC);
endfunction