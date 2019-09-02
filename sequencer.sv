`uvm_get_imp_decl(_DUT)
`uvm_get_imp_decl(_DUT2)
class sequencer extends uvm_sequencer #(transaction_in);
    `uvm_component_utils(sequencer)

    transaction_in tr;
    transaction_in tr2;
    uvm_tlm_analysis_fifo #(transaction_in) fifo_to_DUT;
    uvm_tlm_analysis_fifo #(transaction_in) fifo_to_DUT2;

    uvm_get_imp_DUT#(transaction_in, sequencer)  seq_export_DUT;
    uvm_get_imp_DUT2#(transaction_in, sequencer)  seq_export_DUT2;

    function new (string name = "sequencer", uvm_component parent = null);
        super.new(name, parent);
        fifo_to_DUT = new("fifo_to_DUT",this);
        fifo_to_DUT2 = new("fifo_to_DUT2",this);
        seq_export_DUT = new("seq_export_DUT",this);
        seq_export_DUT2 = new("seq_export_DUT2",this);
    endfunction

    virtual task get_DUT(output transaction_in tr);
        if(fifo_to_DUT.is_empty())begin
          get_next_item(tr);
          fifo_to_DUT.write(tr);
          fifo_to_DUT2.write(tr);
          item_done();
          fifo_to_DUT.get(tr);
        end
    endtask : get_DUT

  virtual function bit try_get_DUT(transaction_in t);
  endfunction

  virtual function bit can_get_DUT();
  endfunction

    virtual task get_DUT2(output transaction_in tr2);
          fifo_to_DUT2.get(tr2);
    endtask : get_DUT2

  virtual function bit try_get_DUT2(transaction_in t);
  endfunction

  virtual function bit can_get_DUT2();
  endfunction

endclass: sequencer