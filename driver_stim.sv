class driver_stim extends uvm_driver #(transaction_in);
    `uvm_component_utils(driver_stim)    

    event begin_record, end_record;
    transaction_in tr;
    bit item_done;

    uvm_put_port #(transaction_in) out_1;
    // uvm_put_port #(transaction_in) out_2;
    // uvm_put_port #(transaction_in) out_3;

    function new(string name = "driver_stim", uvm_component parent = null);
        super.new(name, parent);
        out_1 = new("out_1", this);
        // out_2 = new("out_2", this);
        // out_3 = new("out_3", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase (uvm_phase phase);
        // forever begin
            // seq_item_port.try_next_item(tr);
            
            // out_1.put(tr);
            // out_2.put(tr);
            // out_3.put(tr);
        // end
    endtask

endclass