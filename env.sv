class env extends uvm_env;

    agent       mst;
    scoreboard  sb;
    coverage    cov;
    stimulator stim;

    uvm_tlm_analysis_fifo #(transaction_in) to_dut_1;    

    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        to_dut_1 = new("to_dut_1", this); 
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mst = agent::type_id::create("mst", this);
        sb = scoreboard::type_id::create("sb", this);
        cov = coverage::type_id::create("cov",this);

        stim = stimulator::type_id::create("stim",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mst.agt_req_port.connect(cov.req_port);
        mst.agt_resp_port.connect(sb.ap_comp);
        mst.agt_req_port.connect(sb.ap_rfm);
        mst.agt_req_port.connect(sb.ap_rfm);
        mst.in.connect(to_dut_1.get_export);
        stim.out_1.connect(to_dut_1.put_export);
    endfunction
endclass