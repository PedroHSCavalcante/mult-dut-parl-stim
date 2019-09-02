module my_sqrt_ctrl(
  input  logic         clk_i,
  input  logic         rstn_i,

  input  logic         enb_i,

  input  logic [8:0]   d,
  input  logic [8:0]   s,
  input  logic [7:0]   x,

  output State         state
);
  
  State state_nxt;

  always_comb begin
    state_nxt = my_idle;
    

    case(state)
      my_idle: begin
        state_nxt = getX;
      end
      my_getX: begin
        state_nxt = compara;
      end

      my_sumD_loadR1: begin
        state_nxt = sumD_loadR2;
      end
      my_sumD_loadR2: begin
        state_nxt = sumD_drive;
      end
      my_sumD_drive: begin
        state_nxt = sumS_loadR1;
      end

      my_sumS_loadR1: begin
        state_nxt = sumS_loadR2_1;
      end
      my_sumS_loadR2_1: begin
        state_nxt = sumS_driveR1;
      end
      my_sumS_driveR1: begin
        state_nxt = sumS_loadR2_2;
      end
      my_sumS_loadR2_2: begin
        state_nxt = sumS_drive;
      end
      my_sumS_drive: begin
        state_nxt = compara;
      end
	zero:  state_nxt = idle;

      my_compara: begin
	if(x==0)
	  state_nxt = zero;
        else begin 
          if(s<=x)
            state_nxt = sumD_loadR1;
          else
            state_nxt = finaliza;
        end
      end
      my_finaliza: begin
        state_nxt = my_idle;
      end
    endcase
  end

  always_ff @(posedge clk_i, negedge rstn_i) begin
    if(~rstn_i)
      state <= my_idle;
    else
      if(enb_i)
        state <= state_nxt;
  end


endmodule
