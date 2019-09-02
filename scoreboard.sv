class scoreboard extends uvm_scoreboard;

  typedef transaction_out T;
  typedef uvm_in_order_class_comparator #(T) comp_type;

  comp_type comp;

  uvm_analysis_port #(T) ap_comp;
  uvm_analysis_port #(T) ap_comp2;

  `uvm_component_utils(scoreboard)

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    ap_comp = new("ap_comp", this);
    ap_comp2 = new("ap_comp2", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    comp = comp_type::type_id::create("comp", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ap_comp.connect(comp.before_export);
    ap_comp2.connect(comp.after_export);
  endfunction
endclass : scoreboard