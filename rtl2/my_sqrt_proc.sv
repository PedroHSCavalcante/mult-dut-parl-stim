module my_sqrt_proc(
  input  logic         clk_i,
  input  logic         rstn_i,

  input  logic         enb_i,
  input  logic [7:0]   dt_i,

  input  State         state,

  output logic [8:0]   d,
  output logic [8:0]   s,
  output logic [7:0]   x,

  output logic         busy_o,
  output logic [7:0]   dt_o
);

  logic [8:0]  R1_reg;
  logic [8:0]  R2_reg;

  logic [8:0]  sum;

  logic [8:0]  d_nxt;
  logic [8:0]  s_nxt;

  logic [7:0]  x_nxt;

  logic [8:0]  R1_nxt;
  logic [8:0]  R2_nxt;

  logic        busy_o_nxt;
  logic [7:0]  dt_o_nxt;


  always_comb begin
    d_nxt      = d;
    s_nxt      = s;

    x_nxt      = x;

    R1_nxt     = R1_reg; 
    R2_nxt     = R2_reg; 

    busy_o_nxt = busy_o;
    dt_o_nxt   = dt_o;

    case(state)
      my_idle: begin
        d_nxt = 9'd2;
        s_nxt = 9'd4;

        busy_o_nxt = 1'b0;
      end
      my_getX: begin
        x_nxt = dt_i;

        busy_o_nxt = 1'b1;
      end

      my_sumD_loadR1: begin
        R1_nxt = d; 
      end
      my_sumD_loadR2: begin
        R2_nxt = 9'd2;
      end
      my_sumD_drive: begin
        d_nxt  = sum;
      end

      my_sumS_loadR1: begin
        R1_nxt = s;
      end
      my_sumS_loadR2_1: begin
        R2_nxt = d;
      end
      my_sumS_driveR1: begin
        R1_nxt = sum;
      end
      my_sumS_loadR2_2: begin
        R2_nxt = 9'd1;
      end
      my_sumS_drive: begin
        s_nxt  = sum;
      end

      my_zero: begin
	dt_o_nxt   = 0;
	busy_o_nxt = 0;
      end
      my_finaliza: begin
        dt_o_nxt = d >> 1;
      end
    endcase
  end

  always_ff @(posedge clk_i, negedge rstn_i) begin
    if(~rstn_i) begin
      d      <= 9'd2;
      s      <= 9'd4;

      x      <= 8'd0;

      R1_reg <= 9'd0; 
      R2_reg <= 9'd0; 

      dt_o   <= 8'd0;
      busy_o <= 1'b0;
    end
    else 
      if(enb_i) begin
        d      <= d_nxt;
        s      <= s_nxt;

        x      <= x_nxt;

        R1_reg <= R1_nxt;
        R2_reg <= R2_nxt;
	
	busy_o <= busy_o_nxt;
        dt_o   <= dt_o_nxt;
      end
  end

  assign  sum = R1_reg + R2_reg;

endmodule
