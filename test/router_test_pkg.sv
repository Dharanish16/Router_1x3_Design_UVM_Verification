
package router_test_pkg;

    //import uvm_pkg.sv
	import uvm_pkg::*;

    //include uvm_macros.sv
	`include "uvm_macros.svh"

    `include "source_xtn.sv"
    `include "source_agt_config.sv"
    `include "dest_agt_config.sv"
    `include "router_env_config.sv"

    `include "source_agt_driver.sv"
    `include "source_agt_mon.sv"
    `include "source_agt_seqr.sv"
    `include "source_agent.sv"
    `include "source_agt_top.sv"
    `include "source_seq.sv"

    `include "dest_xtn.sv"
    `include "normal_seq.sv"
    `include "dest_agt_mon.sv"
    `include "dest_agt_seqr.sv"
    `include "dest_agt_driver.sv"
    `include "dest_agent.sv"
    `include "dest_agt_top.sv"
    

    `include "virtual_sequencer.sv"
    `include "virtual_sequence.sv"
    `include "router_scoreboard.sv"

    `include "router_env.sv"


    `include "router_vtest_lib.sv"

endpackage