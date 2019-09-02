class monitor extends uvm_monitor;

    interface_vif  vif;
    interface_vif  vif2;
    event begin_record, end_record;
    transaction_out tr_out;
    transaction_out tr_out_2;
    uvm_analysis_port #(transaction_out) resp_port_01;
    uvm_analysis_port #(transaction_out) resp_port_02;
    `uvm_component_utils(monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        resp_port_01 = new ("resp_port_01", this);
        resp_port_02 = new ("resp_port_02", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end

        if(!uvm_config_db#(interface_vif)::get(this, "", "vif2", vif2)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end

        tr_out = transaction_out::type_id::create("tr_out", this);
        tr_out_2 = transaction_out::type_id::create("tr_out_2", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions_01(phase);
            collect_transactions_02(phase);
        join
    endtask

    virtual task collect_transactions_01(uvm_phase phase);
        forever begin

            @(posedge vif.clk) begin
                
                if(vif.busy_o)begin
                    @(negedge vif.busy_o);
                    begin_tr(tr_out, "resp");
                    tr_out.result = vif.dt_o;
                    resp_port_01.write(tr_out);
                    end_tr(tr_out);
                end
            end
        end
    endtask

     virtual task collect_transactions_02(uvm_phase phase);
        forever begin

            @(posedge vif2.clk) begin
                
              if(vif2.busy_o)begin
                    @(negedge vif2.busy_o);
                    begin_tr(tr_out_2, "resp");
                    tr_out_2.result = vif2.dt_o;
                    resp_port_02.write(tr_out_2);
                    end_tr(tr_out_2);
                end
            end
        end
    endtask
endclass
