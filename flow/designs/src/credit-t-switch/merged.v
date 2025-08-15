module credit_counters_tx (
	i_clk,
	i_rst,
	i_vc_credit_gnt,
	i_vc_target,
	o_credits,
	o_credits_next
);
	reg _sv2v_0;
	localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
	parameter VC_W = common_pkg_DEFAULT_VC_W;
	localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
	parameter DEPTH = common_pkg_DEFAULT_VC_FIFO_DEPTH;
	input wire i_clk;
	input wire i_rst;
	input wire [VC_W - 1:0] i_vc_credit_gnt;
	input wire [VC_W - 1:0] i_vc_target;
	output reg [(VC_W * $clog2(DEPTH)) - 1:0] o_credits;
	output reg [(VC_W * $clog2(DEPTH)) - 1:0] o_credits_next;
	genvar _gv_ii_1;
	function automatic signed [$clog2(DEPTH) - 1:0] sv2v_cast_711C5_signed;
		input reg signed [$clog2(DEPTH) - 1:0] inp;
		sv2v_cast_711C5_signed = inp;
	endfunction
	generate
		for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
			localparam ii = _gv_ii_1;
			always @(*) begin
				if (_sv2v_0)
					;
				if (i_vc_target[ii] & i_vc_credit_gnt[ii])
					o_credits_next[ii * $clog2(DEPTH)+:$clog2(DEPTH)] = o_credits[ii * $clog2(DEPTH)+:$clog2(DEPTH)];
				else if (i_vc_target[ii])
					o_credits_next[ii * $clog2(DEPTH)+:$clog2(DEPTH)] = o_credits[ii * $clog2(DEPTH)+:$clog2(DEPTH)] - 1;
				else if (i_vc_credit_gnt[ii])
					o_credits_next[ii * $clog2(DEPTH)+:$clog2(DEPTH)] = o_credits[ii * $clog2(DEPTH)+:$clog2(DEPTH)] + 1;
				else
					o_credits_next[ii * $clog2(DEPTH)+:$clog2(DEPTH)] = o_credits[ii * $clog2(DEPTH)+:$clog2(DEPTH)];
			end
			always @(posedge i_clk)
				if (i_rst)
					o_credits[ii * $clog2(DEPTH)+:$clog2(DEPTH)] <= sv2v_cast_711C5_signed(DEPTH - 1);
				else
					o_credits[ii * $clog2(DEPTH)+:$clog2(DEPTH)] <= o_credits_next[ii * $clog2(DEPTH)+:$clog2(DEPTH)];
		end
	endgenerate
	initial _sv2v_0 = 0;
endmodule
module credit_t_route (
	clk,
	rst,
	l_i_v,
	r_i_v,
	u0_i_v,
	l_i_bp,
	r_i_bp,
	u0_i_bp,
	l_i_addr,
	r_i_addr,
	u0_i_addr,
	l_o_v,
	r_o_v,
	u0_o_v,
	l_o_credit_gnt,
	r_o_credit_gnt,
	u0_o_credit_gnt,
	l_sel,
	r_sel,
	u0_sel
);
	reg _sv2v_0;
	localparam signed [31:0] common_pkg_DEFAULT_N = 8;
	parameter N = common_pkg_DEFAULT_N;
	localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
	parameter A_W = common_pkg_DEFAULT_A_W;
	parameter posl = 0;
	parameter posx = 0;
	localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
	parameter VC_W = common_pkg_DEFAULT_VC_W;
	localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
	parameter VC_FIFO_DEPTH = common_pkg_DEFAULT_VC_FIFO_DEPTH;
	parameter FAIR_VC_ARB = 0;
	input wire clk;
	input wire rst;
	input wire [VC_W - 1:0] l_i_v;
	input wire [VC_W - 1:0] r_i_v;
	input wire [VC_W - 1:0] u0_i_v;
	output wire [VC_W - 1:0] l_i_bp;
	output wire [VC_W - 1:0] r_i_bp;
	output wire [VC_W - 1:0] u0_i_bp;
	input wire [(VC_W * A_W) - 1:0] l_i_addr;
	input wire [(VC_W * A_W) - 1:0] r_i_addr;
	input wire [(VC_W * A_W) - 1:0] u0_i_addr;
	output wire [VC_W - 1:0] l_o_v;
	output wire [VC_W - 1:0] r_o_v;
	output wire [VC_W - 1:0] u0_o_v;
	input wire [VC_W - 1:0] l_o_credit_gnt;
	input wire [VC_W - 1:0] r_o_credit_gnt;
	input wire [VC_W - 1:0] u0_o_credit_gnt;
	output reg [$clog2(VC_W * 2) - 1:0] l_sel;
	output reg [$clog2(VC_W * 2) - 1:0] r_sel;
	output reg [$clog2(VC_W * 2) - 1:0] u0_sel;
	reg [VC_W - 1:0] l_o_bp;
	reg [VC_W - 1:0] r_o_bp;
	reg [VC_W - 1:0] u0_o_bp;
	reg [VC_W - 1:0] l_has_credit;
	reg [VC_W - 1:0] r_has_credit;
	reg [VC_W - 1:0] u0_has_credit;
	wire [(VC_W * $clog2(VC_FIFO_DEPTH)) - 1:0] l_credits;
	wire [(VC_W * $clog2(VC_FIFO_DEPTH)) - 1:0] r_credits;
	wire [(VC_W * $clog2(VC_FIFO_DEPTH)) - 1:0] u0_credits;
	credit_counters_tx #(
		.VC_W(VC_W),
		.DEPTH(VC_FIFO_DEPTH)
	) l_counters_inst(
		.i_clk(clk),
		.i_rst(rst),
		.i_vc_credit_gnt(l_o_credit_gnt),
		.i_vc_target(l_o_v),
		.o_credits(l_credits),
		.o_credits_next()
	);
	credit_counters_tx #(
		.VC_W(VC_W),
		.DEPTH(VC_FIFO_DEPTH)
	) r_counters_inst(
		.i_clk(clk),
		.i_rst(rst),
		.i_vc_credit_gnt(r_o_credit_gnt),
		.i_vc_target(r_o_v),
		.o_credits(r_credits),
		.o_credits_next()
	);
	credit_counters_tx #(
		.VC_W(VC_W),
		.DEPTH(VC_FIFO_DEPTH)
	) u0_counters_inst(
		.i_clk(clk),
		.i_rst(rst),
		.i_vc_credit_gnt(u0_o_credit_gnt),
		.i_vc_target(u0_o_v),
		.o_credits(u0_credits),
		.o_credits_next()
	);
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			reg signed [31:0] ii;
			for (ii = 0; ii < VC_W; ii = ii + 1)
				begin
					l_has_credit[ii] = |l_credits[ii * $clog2(VC_FIFO_DEPTH)+:$clog2(VC_FIFO_DEPTH)];
					r_has_credit[ii] = |r_credits[ii * $clog2(VC_FIFO_DEPTH)+:$clog2(VC_FIFO_DEPTH)];
					u0_has_credit[ii] = |u0_credits[ii * $clog2(VC_FIFO_DEPTH)+:$clog2(VC_FIFO_DEPTH)];
					l_o_bp[ii] = !l_has_credit[ii];
					r_o_bp[ii] = !r_has_credit[ii];
					u0_o_bp[ii] = !u0_has_credit[ii];
				end
		end
	end
	wire [VC_W - 1:0] l_wants_r;
	wire [VC_W - 1:0] l_wants_u0;
	wire [VC_W - 1:0] r_wants_l;
	wire [VC_W - 1:0] r_wants_u0;
	wire [VC_W - 1:0] u0_wants_l;
	wire [VC_W - 1:0] u0_wants_r;
	genvar _gv_ii_2;
	generate
		for (_gv_ii_2 = 0; _gv_ii_2 < VC_W; _gv_ii_2 = _gv_ii_2 + 1) begin : gen_vc_addr_dec
			localparam ii = _gv_ii_2;
			assign l_wants_r[ii] = (l_i_v[ii] & l_i_addr[(ii * A_W) + posl]) & (l_i_addr[(ii * A_W) + ((A_W - 1) >= (posl + 1) ? A_W - 1 : ((A_W - 1) + ((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)) - 1)-:((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)] == posx[(A_W - posl) - 2:0]);
			assign l_wants_u0[ii] = l_i_v[ii] & (l_i_addr[(ii * A_W) + ((A_W - 1) >= (posl + 1) ? A_W - 1 : ((A_W - 1) + ((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)) - 1)-:((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)] != posx[(A_W - posl) - 2:0]);
			assign r_wants_l[ii] = (r_i_v[ii] & ~r_i_addr[(ii * A_W) + posl]) & (r_i_addr[(ii * A_W) + ((A_W - 1) >= (posl + 1) ? A_W - 1 : ((A_W - 1) + ((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)) - 1)-:((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)] == posx[(A_W - posl) - 2:0]);
			assign r_wants_u0[ii] = r_i_v[ii] & (r_i_addr[(ii * A_W) + ((A_W - 1) >= (posl + 1) ? A_W - 1 : ((A_W - 1) + ((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)) - 1)-:((A_W - 1) >= (posl + 1) ? ((A_W - 1) - (posl + 1)) + 1 : ((posl + 1) - (A_W - 1)) + 1)] != posx[(A_W - posl) - 2:0]);
			assign u0_wants_l[ii] = u0_i_v[ii] & ~u0_i_addr[(ii * A_W) + posl];
			assign u0_wants_r[ii] = u0_i_v[ii] & u0_i_addr[(ii * A_W) + posl];
		end
	endgenerate
	wire l_wins_r;
	wire l_wins_u0;
	wire r_wins_l;
	wire r_wins_u0;
	wire u0_wins_l;
	wire u0_wins_r;
	reg [1:0] state;
	reg [1:0] next_state;
	always @(posedge clk)
		if (rst)
			state <= 2'd0;
		else
			state <= next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = state;
		case (state)
			2'd0:
				if (|r_i_bp)
					next_state = 2'd1;
				else if (|u0_i_bp)
					next_state = 2'd2;
			2'd1:
				if (|u0_i_bp)
					next_state = 2'd2;
				else if (|l_i_bp)
					next_state = 2'd0;
			2'd2:
				if (|l_i_bp)
					next_state = 2'd0;
				else if (|r_i_bp)
					next_state = 2'd1;
			default: next_state = 2'd0;
		endcase
	end
	assign l_wins_r = (state == 2'd0) | ~(|u0_wants_r);
	assign u0_wins_r = (state == 2'd2) | ~(|l_wants_r);
	assign r_wins_l = (state == 2'd1) | ~(|u0_wants_l);
	assign u0_wins_l = (state == 2'd2) | ~(|r_wants_l);
	assign l_wins_u0 = (state == 2'd0) | ~(|r_wants_u0);
	assign r_wins_u0 = (state == 2'd1) | ~(|l_wants_u0);
	wire [VC_W - 1:0] l_gets_r;
	wire [VC_W - 1:0] l_gets_u0;
	wire [VC_W - 1:0] r_gets_l;
	wire [VC_W - 1:0] r_gets_u0;
	wire [VC_W - 1:0] u0_gets_l;
	wire [VC_W - 1:0] u0_gets_r;
	generate
		if (FAIR_VC_ARB) begin : gen_fair_vc_arb
			wire [VC_W - 1:0] l_req_r;
			wire [VC_W - 1:0] l_req_u0;
			wire [VC_W - 1:0] r_req_l;
			wire [VC_W - 1:0] r_req_u0;
			wire [VC_W - 1:0] u0_req_l;
			wire [VC_W - 1:0] u0_req_r;
			genvar _gv_ii_3;
			for (_gv_ii_3 = 0; _gv_ii_3 < VC_W; _gv_ii_3 = _gv_ii_3 + 1) begin : gen_vc_grant
				localparam ii = _gv_ii_3;
				assign l_req_r[ii] = (l_wants_r[ii] & ~r_o_bp[ii]) & l_wins_r;
				assign u0_req_r[ii] = (u0_wants_r[ii] & ~r_o_bp[ii]) & u0_wins_r;
				assign r_req_l[ii] = (r_wants_l[ii] & ~l_o_bp[ii]) & r_wins_l;
				assign u0_req_l[ii] = (u0_wants_l[ii] & ~l_o_bp[ii]) & u0_wins_l;
				assign l_req_u0[ii] = (l_wants_u0[ii] & ~u0_o_bp[ii]) & l_wins_u0;
				assign r_req_u0[ii] = (r_wants_u0[ii] & ~u0_o_bp[ii]) & r_wins_u0;
			end
			matrix_arbiter #(.NUM(VC_W)) l_to_r_arbiter(
				.clk(clk),
				.rst(rst),
				.i_req(l_req_r),
				.o_gnt(l_gets_r)
			);
			matrix_arbiter #(.NUM(VC_W)) l_to_u0_arbiter(
				.clk(clk),
				.rst(rst),
				.i_req(l_req_u0),
				.o_gnt(l_gets_u0)
			);
			matrix_arbiter #(.NUM(VC_W)) r_to_l_arbiter(
				.clk(clk),
				.rst(rst),
				.i_req(r_req_l),
				.o_gnt(r_gets_l)
			);
			matrix_arbiter #(.NUM(VC_W)) r_to_u0_arbiter(
				.clk(clk),
				.rst(rst),
				.i_req(r_req_u0),
				.o_gnt(r_gets_u0)
			);
			matrix_arbiter #(.NUM(VC_W)) u0_to_l_arbiter(
				.clk(clk),
				.rst(rst),
				.i_req(u0_req_l),
				.o_gnt(u0_gets_l)
			);
			matrix_arbiter #(.NUM(VC_W)) u0_to_r_arbiter(
				.clk(clk),
				.rst(rst),
				.i_req(u0_req_r),
				.o_gnt(u0_gets_r)
			);
		end
		else begin : gen_static_vc_arb
			assign l_gets_r[0] = (l_wants_r[0] & ~r_o_bp[0]) & l_wins_r;
			assign u0_gets_r[0] = (u0_wants_r[0] & ~r_o_bp[0]) & u0_wins_r;
			assign r_gets_l[0] = (r_wants_l[0] & ~l_o_bp[0]) & r_wins_l;
			assign u0_gets_l[0] = (u0_wants_l[0] & ~l_o_bp[0]) & u0_wins_l;
			assign l_gets_u0[0] = (l_wants_u0[0] & ~u0_o_bp[0]) & l_wins_u0;
			assign r_gets_u0[0] = (r_wants_u0[0] & ~u0_o_bp[0]) & r_wins_u0;
			genvar _gv_ii_4;
			for (_gv_ii_4 = 1; _gv_ii_4 < VC_W; _gv_ii_4 = _gv_ii_4 + 1) begin : gen_vc_grant
				localparam ii = _gv_ii_4;
				assign l_gets_r[ii] = ((l_wants_r[ii] & ~r_o_bp[ii]) & l_wins_r) & ~(|l_gets_r[ii - 1:0]);
				assign u0_gets_r[ii] = ((u0_wants_r[ii] & ~r_o_bp[ii]) & u0_wins_r) & ~(|u0_gets_r[ii - 1:0]);
				assign r_gets_l[ii] = ((r_wants_l[ii] & ~l_o_bp[ii]) & r_wins_l) & ~(|r_gets_l[ii - 1:0]);
				assign u0_gets_l[ii] = ((u0_wants_l[ii] & ~l_o_bp[ii]) & u0_wins_l) & ~(|u0_gets_l[ii - 1:0]);
				assign l_gets_u0[ii] = ((l_wants_u0[ii] & ~u0_o_bp[ii]) & l_wins_u0) & ~(|l_gets_u0[ii - 1:0]);
				assign r_gets_u0[ii] = ((r_wants_u0[ii] & ~u0_o_bp[ii]) & r_wins_u0) & ~(|r_gets_u0[ii - 1:0]);
			end
		end
	endgenerate
	assign l_o_v = r_gets_l | u0_gets_l;
	assign r_o_v = l_gets_r | u0_gets_r;
	assign u0_o_v = l_gets_u0 | r_gets_u0;
	genvar _gv_ii_5;
	generate
		for (_gv_ii_5 = 0; _gv_ii_5 < VC_W; _gv_ii_5 = _gv_ii_5 + 1) begin : gen_vc_bp
			localparam ii = _gv_ii_5;
			assign l_i_bp[ii] = (l_wants_r[ii] & ~l_gets_r[ii]) | (l_wants_u0[ii] & ~l_gets_u0[ii]);
			assign r_i_bp[ii] = (r_wants_l[ii] & ~r_gets_l[ii]) | (r_wants_u0[ii] & ~r_gets_u0[ii]);
			assign u0_i_bp[ii] = (u0_wants_l[ii] & ~u0_gets_l[ii]) | (u0_wants_r[ii] & ~u0_gets_r[ii]);
		end
	endgenerate
	wire [(VC_W * 2) - 1:0] l_sel_onehot;
	assign l_sel_onehot = {r_gets_l, u0_gets_l};
	function automatic signed [$clog2(VC_W * 2) - 1:0] sv2v_cast_C0E30_signed;
		input reg signed [$clog2(VC_W * 2) - 1:0] inp;
		sv2v_cast_C0E30_signed = inp;
	endfunction
	always @(*) begin
		if (_sv2v_0)
			;
		l_sel = 1'sb0;
		begin : sv2v_autoblock_2
			reg signed [31:0] ii;
			for (ii = 0; ii < (VC_W * 2); ii = ii + 1)
				if (l_sel_onehot[ii])
					l_sel = sv2v_cast_C0E30_signed(ii);
		end
	end
	wire [(VC_W * 2) - 1:0] r_sel_onehot;
	assign r_sel_onehot = {l_gets_r, u0_gets_r};
	always @(*) begin
		if (_sv2v_0)
			;
		r_sel = 1'sb0;
		begin : sv2v_autoblock_3
			reg signed [31:0] ii;
			for (ii = 0; ii < (VC_W * 2); ii = ii + 1)
				if (r_sel_onehot[ii])
					r_sel = sv2v_cast_C0E30_signed(ii);
		end
	end
	wire [(VC_W * 2) - 1:0] u0_sel_onehot;
	assign u0_sel_onehot = {l_gets_u0, r_gets_u0};
	always @(*) begin
		if (_sv2v_0)
			;
		u0_sel = 1'sb0;
		begin : sv2v_autoblock_4
			reg signed [31:0] ii;
			for (ii = 0; ii < (VC_W * 2); ii = ii + 1)
				if (u0_sel_onehot[ii])
					u0_sel = sv2v_cast_C0E30_signed(ii);
		end
	end
	initial _sv2v_0 = 0;
endmodule
module credit_t_switch (
	clk,
	rst,
	l_i,
	l_i_bp,
	l_i_v,
	r_i,
	r_i_bp,
	r_i_v,
	u0_i,
	u0_i_bp,
	u0_i_v,
	l_o,
	l_o_credit_gnt,
	l_o_v,
	r_o,
	r_o_credit_gnt,
	r_o_v,
	u0_o,
	u0_o_credit_gnt,
	u0_o_v
);
	localparam signed [31:0] common_pkg_DEFAULT_N = 8;
	parameter N = common_pkg_DEFAULT_N;
	localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
	parameter A_W = common_pkg_DEFAULT_A_W;
	localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
	parameter D_W = common_pkg_DEFAULT_D_W;
	parameter posl = 0;
	parameter posx = 0;
	localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
	parameter VC_W = common_pkg_DEFAULT_VC_W;
	localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
	parameter VC_FIFO_DEPTH = common_pkg_DEFAULT_VC_FIFO_DEPTH;
	parameter FAIR_VC_ARB = 0;
	input wire clk;
	input wire rst;
	input wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] l_i;
	output wire [VC_W - 1:0] l_i_bp;
	input wire [VC_W - 1:0] l_i_v;
	input wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] r_i;
	output wire [VC_W - 1:0] r_i_bp;
	input wire [VC_W - 1:0] r_i_v;
	input wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] u0_i;
	output wire [VC_W - 1:0] u0_i_bp;
	input wire [VC_W - 1:0] u0_i_v;
	output wire [A_W + D_W:0] l_o;
	input wire [VC_W - 1:0] l_o_credit_gnt;
	output wire [VC_W - 1:0] l_o_v;
	output wire [A_W + D_W:0] r_o;
	input wire [VC_W - 1:0] r_o_credit_gnt;
	output wire [VC_W - 1:0] r_o_v;
	output wire [A_W + D_W:0] u0_o;
	input wire [VC_W - 1:0] u0_o_credit_gnt;
	output wire [VC_W - 1:0] u0_o_v;
	wire [(VC_W * A_W) - 1:0] l_i_addr;
	wire [(VC_W * A_W) - 1:0] r_i_addr;
	wire [(VC_W * A_W) - 1:0] u0_i_addr;
	wire [$clog2(VC_W * 2) - 1:0] l_sel;
	wire [$clog2(VC_W * 2) - 1:0] r_sel;
	wire [$clog2(VC_W * 2) - 1:0] u0_sel;
	genvar _gv_ii_6;
	generate
		for (_gv_ii_6 = 0; _gv_ii_6 < VC_W; _gv_ii_6 = _gv_ii_6 + 1) begin : gen_addr_breakout
			localparam ii = _gv_ii_6;
			assign l_i_addr[ii * A_W+:A_W] = l_i[((A_W + D_W) >= 0 ? (ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : (((ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
			assign r_i_addr[ii * A_W+:A_W] = r_i[((A_W + D_W) >= 0 ? (ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : (((ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
			assign u0_i_addr[ii * A_W+:A_W] = u0_i[((A_W + D_W) >= 0 ? (ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : (((ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
		end
	endgenerate
	credit_t_route #(
		.N(N),
		.A_W(A_W),
		.posx(posx),
		.posl(posl),
		.VC_W(VC_W),
		.VC_FIFO_DEPTH(VC_FIFO_DEPTH),
		.FAIR_VC_ARB(FAIR_VC_ARB)
	) credit_t_route_inst(
		.clk(clk),
		.rst(rst),
		.l_i_v(l_i_v),
		.l_i_bp(l_i_bp),
		.l_i_addr(l_i_addr),
		.r_i_v(r_i_v),
		.r_i_bp(r_i_bp),
		.r_i_addr(r_i_addr),
		.u0_i_v(u0_i_v),
		.u0_i_bp(u0_i_bp),
		.u0_i_addr(u0_i_addr),
		.l_o_v(l_o_v),
		.r_o_v(r_o_v),
		.u0_o_v(u0_o_v),
		.l_o_credit_gnt(l_o_credit_gnt),
		.r_o_credit_gnt(r_o_credit_gnt),
		.u0_o_credit_gnt(u0_o_credit_gnt),
		.l_sel(l_sel),
		.r_sel(r_sel),
		.u0_sel(u0_sel)
	);
	mux #(
		.N(VC_W * 2),
		.W((A_W + D_W) + 1)
	) l_mux(
		.s(l_sel),
		.i({r_i, u0_i}),
		.o(l_o)
	);
	mux #(
		.N(VC_W * 2),
		.W((A_W + D_W) + 1)
	) r_mux(
		.s(r_sel),
		.i({l_i, u0_i}),
		.o(r_o)
	);
	mux #(
		.N(VC_W * 2),
		.W((A_W + D_W) + 1)
	) u0_mux(
		.s(u0_sel),
		.i({l_i, r_i}),
		.o(u0_o)
	);
endmodule
module matrix_arbiter (
	clk,
	rst,
	i_req,
	o_gnt
);
	reg _sv2v_0;
	parameter NUM = 4;
	input wire clk;
	input wire rst;
	input wire [NUM - 1:0] i_req;
	output reg [NUM - 1:0] o_gnt;
	reg [(NUM * NUM) - 1:0] state_matrix;
	reg [(NUM * NUM) - 1:0] matrix;
	reg [NUM - 1:0] dis;
	always @(posedge clk)
		if (rst) begin : sv2v_autoblock_1
			reg signed [31:0] ii;
			for (ii = 0; ii < NUM; ii = ii + 1)
				begin : sv2v_autoblock_2
					reg signed [31:0] jj;
					for (jj = 0; jj < NUM; jj = jj + 1)
						state_matrix[(ii * NUM) + jj] <= 1'b0;
				end
		end
		else begin : sv2v_autoblock_3
			reg signed [31:0] ii;
			for (ii = 0; ii < (NUM - 1); ii = ii + 1)
				begin : sv2v_autoblock_4
					reg signed [31:0] jj;
					for (jj = ii + 1; jj < NUM; jj = jj + 1)
						state_matrix[(ii * NUM) + jj] <= (state_matrix[(ii * NUM) + jj] | o_gnt[jj]) & ~o_gnt[ii];
				end
		end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_5
			reg signed [31:0] ii;
			for (ii = 0; ii < (NUM - 1); ii = ii + 1)
				begin : sv2v_autoblock_6
					reg signed [31:0] jj;
					for (jj = ii + 1; jj < NUM; jj = jj + 1)
						matrix[(ii * NUM) + jj] = state_matrix[(ii * NUM) + jj];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_7
			reg signed [31:0] ii;
			for (ii = 0; ii < NUM; ii = ii + 1)
				matrix[(ii * NUM) + ii] = 1'b0;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_8
			reg signed [31:0] ii;
			for (ii = 1; ii < NUM; ii = ii + 1)
				begin : sv2v_autoblock_9
					reg signed [31:0] jj;
					for (jj = 0; jj < ii; jj = jj + 1)
						matrix[(ii * NUM) + jj] = ~state_matrix[(jj * NUM) + ii];
				end
		end
	end
	reg [(NUM * NUM) - 1:0] anded_transposed_matrix;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_10
			reg signed [31:0] ii;
			for (ii = 0; ii < NUM; ii = ii + 1)
				begin : sv2v_autoblock_11
					reg signed [31:0] jj;
					for (jj = 0; jj < NUM; jj = jj + 1)
						anded_transposed_matrix[(jj * NUM) + ii] = matrix[(ii * NUM) + jj] & i_req[ii];
				end
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_12
			reg signed [31:0] jj;
			for (jj = 0; jj < NUM; jj = jj + 1)
				dis[jj] = |anded_transposed_matrix[jj * NUM+:NUM];
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_13
			reg signed [31:0] ii;
			for (ii = 0; ii < NUM; ii = ii + 1)
				o_gnt[ii] = i_req[ii] & ~dis[ii];
		end
	end
	initial _sv2v_0 = 0;
endmodule
module mux (
	s,
	i,
	o
);
	parameter N = 2;
	parameter W = 32;
	localparam L = $clog2(N);
	input wire [L - 1:0] s;
	input wire [(N * W) - 1:0] i;
	output wire [W - 1:0] o;
	assign o = (s < N ? i[s * W+:W] : {W {1'sb0}});
endmodule
