interface router_if(input bit clock);

    logic [7:0]data_in;
    logic [7:0]data_out;
    logic resetn;
    logic err;
    logic busy;
    logic read_enb;
    logic vld_out;
    logic pkt_valid;

    //source driver clocking block
    clocking src_drv_cb @(posedge clock);
        default input #1;
        input busy;
        input err;
        output data_in;
        output pkt_valid;
        output resetn;
    endclocking

    //source monitor clocking block
    clocking src_mon_cb @(posedge clock);
        default input #1;
        input data_in;
        input pkt_valid;
        input err;
        input busy;
        input resetn;
    endclocking

    //destination driver clocking block
    clocking dst_drv_cb @(posedge clock);
        default input #1;
        input vld_out;
        output read_enb;
    endclocking

    //destination monitor clocking block
    clocking dst_mon_cb @(posedge clock);
        default input #1;
        input read_enb;
        input vld_out;
        input data_out;
    endclocking

    //source driver modport
    modport SRC_DRV(clocking src_drv_cb);

    //source monitor modport
    modport SRC_MON(clocking src_mon_cb);

    //destination driver modport
    modport DST_DRV(clocking dst_drv_cb);

    //destination monitor modport
    modport DST_MON(clocking dst_mon_cb);
    
endinterface