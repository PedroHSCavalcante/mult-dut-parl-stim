typedef enum logic [3:0] {
  my_idle,
  my_getX,
  my_zero,

  my_sumD_loadR1,
  my_sumD_loadR2,
  my_sumD_drive,

  my_sumS_loadR1,
  my_sumS_loadR2_1,
  my_sumS_driveR1,
  my_sumS_loadR2_2,
  my_sumS_drive,

  my_compara,
  my_finaliza
} my_State;

module my_sqrt(
  input  logic         clk_i,
  input  logic         rstn_i,

  input  logic         enb_i,
  input  logic [7:0]   dt_i,

  output logic         busy_o,
  output logic [7:0]   dt_o
);

  my_State state;

  logic [8:0]   d;
  logic [8:0]   s;
  logic [7:0]   x;


  my_sqrt_proc data_path (
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    .enb_i(enb_i),
    .dt_i(dt_i),

    .state(state),

    .d(d),
    .s(s),
    .x(x),

    .busy_o(busy_o),
    .dt_o(dt_o)
  );

  my_sqrt_ctrl FSM (
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    .enb_i(enb_i),

    .d(d),
    .s(s),
    .x(x),

    .state(state)
  );

endmodule
