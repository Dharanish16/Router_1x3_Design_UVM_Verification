
//Extend source_xtn from uvm_sequence_item
class source_xtn extends uvm_sequence_item;

    //factory registration
    `uvm_object_utils(source_xtn)

    //declaration of required variables
    rand bit [7:0] header;
    rand bit [7:0] payload_data[];
    bit [7:0] parity;
    bit err;

    //constraints for declared variables
    constraint C1{header[1:0] != 3;}
    constraint C2{payload_data.size == header[7:2];}
    constraint C3{header[7:2] != 0;}

    //standard methods
    extern function new(string name="source_xtn");
    extern function void post_randomize();
    extern function void do_print(uvm_printer printer);


endclass

//constructor new method
function source_xtn::new(string name="source_xtn");
    super.new(name);
endfunction

//do_print function
function void source_xtn::do_print(uvm_printer printer);
    //super.do_print(printer);
    printer.print_field("header",this.header,8,UVM_BIN);
    foreach(payload_data[i])
        printer.print_field($sformatf("payload_data[%0d]",i),this.payload_data[i],8,UVM_DEC);
    printer.print_field("parity",this.parity,8,UVM_DEC);
    printer.print_field("err",this.err,1,UVM_BIN);
endfunction

//post randomize method
function void source_xtn::post_randomize();
    //initial parity calculation
    parity = 0 ^ header;
    //parity calculation
    foreach(payload_data[i])
        begin
            parity = payload_data[i] ^ parity;
        end
endfunction
