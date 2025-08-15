module mux(
    input wire clk,
    input wire rst,
    input wire a,
    input wire b,
    input wire sel,
    output reg y
  );

  reg a_r;
  reg b_r;
  reg sel_r;

  always @(posedge clk) begin
    if(rst) begin
      y <= 1'b0;
      a_r <= 1'b0;
      b_r <= 1'b0;
      sel_r <= 1'b0;
    end else begin
      a_r <= a;
      b_r <= b;
      sel_r <= sel;
      y <= sel_r?a_r:b_r;
    end
  end

endmodule
