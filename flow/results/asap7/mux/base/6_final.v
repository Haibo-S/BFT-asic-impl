module mux (a,
    b,
    clk,
    rst,
    sel,
    y);
 input a;
 input b;
 input clk;
 input rst;
 input sel;
 output y;

 wire _00_;
 wire _01_;
 wire _02_;
 wire _03_;
 wire _04_;
 wire _05_;
 wire _06_;
 wire _07_;
 wire _08_;
 wire _09_;
 wire _10_;
 wire net5;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;

 INVx1_ASAP7_75t_R _11_ (.A(_00_),
    .Y(net5));
 INVx1_ASAP7_75t_R _12_ (.A(net3),
    .Y(_08_));
 AND2x2_ASAP7_75t_R _13_ (.A(net1),
    .B(_08_),
    .Y(_04_));
 AND2x2_ASAP7_75t_R _14_ (.A(_08_),
    .B(net2),
    .Y(_05_));
 AND2x2_ASAP7_75t_R _15_ (.A(_08_),
    .B(net4),
    .Y(_06_));
 INVx1_ASAP7_75t_R _16_ (.A(_03_),
    .Y(_09_));
 NAND2x1_ASAP7_75t_R _17_ (.A(_01_),
    .B(_02_),
    .Y(_10_));
 OA211x2_ASAP7_75t_R _18_ (.A1(_01_),
    .A2(_09_),
    .B(_08_),
    .C(_10_),
    .Y(_07_));
 DFFHQNx1_ASAP7_75t_R \a_r$_SDFF_PP0_  (.CLK(clknet_1_0__leaf_clk),
    .D(_04_),
    .QN(_03_));
 DFFHQNx1_ASAP7_75t_R \b_r$_SDFF_PP0_  (.CLK(clknet_1_0__leaf_clk),
    .D(_05_),
    .QN(_02_));
 DFFHQNx1_ASAP7_75t_R \sel_r$_SDFF_PP0_  (.CLK(clknet_1_1__leaf_clk),
    .D(_06_),
    .QN(_01_));
 DFFHQNx1_ASAP7_75t_R \y$_SDFF_PP0_  (.CLK(clknet_1_1__leaf_clk),
    .D(_07_),
    .QN(_00_));
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_0_Right_0 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_1_Right_1 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_2_Right_2 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_3_Right_3 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_4_Right_4 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_5_Right_5 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_6_Right_6 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_0_Left_7 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_1_Left_8 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_2_Left_9 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_3_Left_10 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_4_Left_11 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_5_Left_12 ();
 TAPCELL_ASAP7_75t_R PHY_EDGE_ROW_6_Left_13 ();
 BUFx3_ASAP7_75t_R input1 (.A(a),
    .Y(net1));
 BUFx3_ASAP7_75t_R input2 (.A(b),
    .Y(net2));
 BUFx3_ASAP7_75t_R input3 (.A(rst),
    .Y(net3));
 BUFx3_ASAP7_75t_R input4 (.A(sel),
    .Y(net4));
 BUFx3_ASAP7_75t_R output5 (.A(net5),
    .Y(y));
 BUFx2_ASAP7_75t_R clkbuf_0_clk (.A(clk),
    .Y(clknet_0_clk));
 BUFx2_ASAP7_75t_R clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .Y(clknet_1_0__leaf_clk));
 BUFx2_ASAP7_75t_R clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .Y(clknet_1_1__leaf_clk));
 DECAPx6_ASAP7_75t_R FILLER_0_2 ();
 DECAPx6_ASAP7_75t_R FILLER_0_21 ();
 FILLERxp5_ASAP7_75t_R FILLER_0_35 ();
 FILLER_ASAP7_75t_R FILLER_1_14 ();
 DECAPx1_ASAP7_75t_R FILLER_2_2 ();
 FILLERxp5_ASAP7_75t_R FILLER_2_6 ();
 DECAPx2_ASAP7_75t_R FILLER_2_27 ();
 FILLER_ASAP7_75t_R FILLER_3_2 ();
 DECAPx2_ASAP7_75t_R FILLER_3_18 ();
 FILLER_ASAP7_75t_R FILLER_4_2 ();
 DECAPx1_ASAP7_75t_R FILLER_4_32 ();
 FILLER_ASAP7_75t_R FILLER_5_14 ();
 DECAPx4_ASAP7_75t_R FILLER_6_19 ();
 FILLERxp5_ASAP7_75t_R FILLER_6_29 ();
 FILLER_ASAP7_75t_R FILLER_6_33 ();
 FILLERxp5_ASAP7_75t_R FILLER_6_35 ();
endmodule
