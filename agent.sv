class agent extends uvm_agent;
    
    // typedef uvm_sequencer#(transaction_in) sequencer;
    sequencer  sqr;
    driver   drv;
    monitor  mon;

    uvm_analysis_port #(transaction_out) agt_req_port;
    uvm_analysis_port #(transaction_out) agt_resp_port;

    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
        agt_req_port  = new("agt_req_port", this);
        agt_resp_port = new("agt_resp_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor::type_id::create("mon", this);
        sqr = sequencer::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.resp_port_01.connect(agt_req_port);
        mon.resp_port_02.connect(agt_resp_port);
        drv.get_item_01.connect(sqr.seq_export_DUT);
        drv.get_item_02.connect(sqr.seq_export_DUT2);
        // drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: agent