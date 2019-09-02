typedef virtual interface_if.mst interface_vif;

class driver extends uvm_driver #(transaction_in);
    `uvm_component_utils(driver)
    interface_vif vif;
    interface_vif vif2;
    event begin_record, end_record;
    transaction_in tr;
    transaction_in tr2;
    bit item_done;
    bit item_done2;

    uvm_get_port #(transaction_in) get_item_01;
    uvm_get_port #(transaction_in) get_item_02;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
        get_item_01 = new("get_item_01",this);
        get_item_02 = new("get_item_02",this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
        if(!uvm_config_db#(interface_vif)::get(this, "", "vif2", vif2)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    task run_phase (uvm_phase phase);
        fork
            drive2dut1(phase);
            drive2dut2(phase);
        join
    endtask

    virtual protected task drive2dut1(uvm_phase phase);
        forever begin
            @(posedge vif.clk) begin

                item_done = 1'b0;

                if(!vif.rst) begin
                    vif.enb_i   <= '0;  
                    vif.dt_i    <= '0;
                    item_done = 0;
                end
                else begin
                    if(tr)begin
                        if(!vif.busy_o) begin
                            @(posedge vif.clk);
                            @(posedge vif.clk);
                            $display("dt_i = ",tr.data);
                            vif.dt_i <= tr.data;
                            vif.enb_i   <= '1;
                            // wait(vif.busy_o === 1);
                            item_done = 1;
                        end
                    end
                end


                if ((item_done || !tr) && vif.rst) begin
                    get_item_01.get(tr);
                end
            end
        end
    endtask : drive2dut1

   virtual protected task drive2dut2(uvm_phase phase);
        forever begin
            @(posedge vif2.clk) begin

                item_done2 = 1'b0;

                if(!vif2.rst) begin
                    vif2.enb_i   <= '0;  
                    vif2.dt_i    <= '0;
                    item_done2 = 0;
                end
                else begin
                    if(tr2)begin
                        if(!vif2.busy_o) begin
                            @(posedge vif2.clk);
                            @(posedge vif2.clk);
                            $display("dt_i = ",tr2.data);
                            vif2.dt_i <= tr2.data;
                            vif2.enb_i   <= '1;
                            // wait(vif2.busy_o === 1);
                            item_done2 = 1;
                        end
                    end
                end


                if ((item_done2 || !tr2) && vif2.rst) begin
                    get_item_02.get(tr2);
                end
            end
        end
    
    endtask : drive2dut2

endclass