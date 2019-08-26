class stimulator extends uvm_component;
    
    typedef uvm_sequencer#(transaction_in) sequencer;
    sequencer  sqr;
    driver_stim   drv;
    
    uvm_put_export #(transaction_in) out_1;

    `uvm_component_utils(stimulator)

    function new(string name = "stimulator", uvm_component parent = null);
        super.new(name, parent);
        out_1 = new("out_1", this);
        // out_2 = new("out_2", this);
        // out_3 = new("out_3", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = sequencer::type_id::create("sqr", this);
        drv = driver_stim::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        drv.out_1.connect(out_1);
        //drv.out_2.connect(to_dut_2.put_export);
        //drv.out_3.connect(to_dut_3.put_export);

        //out_1.connect(to_dut_1.get_export);
        //to_dut_2.get_peek_export.connect(out_2);
        //to_dut_3.get_peek_export.connect(out_3);

        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: stimulator