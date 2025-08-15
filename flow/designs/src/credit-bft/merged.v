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
	genvar _gv_ii_2;
	function automatic signed [$clog2(DEPTH) - 1:0] sv2v_cast_711C5_signed;
		input reg signed [$clog2(DEPTH) - 1:0] inp;
		sv2v_cast_711C5_signed = inp;
	endfunction
	generate
		for (_gv_ii_2 = 0; _gv_ii_2 < VC_W; _gv_ii_2 = _gv_ii_2 + 1) begin : gen_vc_logic
			localparam ii = _gv_ii_2;
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
module fifo32 (
	clk,
	rst,
	i_push,
	o_full,
	i_wdata,
	i_pop,
	o_empty,
	o_rdata
);
	reg _sv2v_0;
	parameter signed [31:0] DEPTH32 = 4;
	parameter signed [31:0] WIDTH = 32;
	parameter TECH = "RTL";
	parameter signed [31:0] RLATENCY = 0;
	input wire clk;
	input wire rst;
	input wire i_push;
	output reg o_full;
	input wire [WIDTH - 1:0] i_wdata;
	input wire i_pop;
	output reg o_empty;
	output reg [WIDTH - 1:0] o_rdata;
	localparam signed [31:0] DEPTH = DEPTH32 * 32;
	function automatic signed [$clog2(DEPTH) - 1:0] sv2v_cast_711C5_signed;
		input reg signed [$clog2(DEPTH) - 1:0] inp;
		sv2v_cast_711C5_signed = inp;
	endfunction
	generate
		if (TECH == "FIFO18E1") begin : gen_fifo18e1
			wire [31:0] DO;
			wire [3:0] DOP;
			wire EMPTY;
			wire FULL;
			reg RDCLK;
			reg RDEN;
			reg RST;
			reg WRCLK;
			reg WREN;
			reg [31:0] DI;
			wire [3:0] DIP;
			always @(*) begin
				if (_sv2v_0)
					;
				o_rdata = DO;
				o_empty = EMPTY;
				o_full = FULL;
				RDCLK = clk;
				RDEN = i_pop;
				RST = rst;
				WRCLK = clk;
				WREN = i_push;
				DI = i_wdata;
			end
			FIFO18E1 #(
				.DATA_WIDTH(36),
				.FIFO_MODE("FIFO18"),
				.FIRST_WORD_FALL_THROUGH(RLATENCY == 0)
			) fifo(
				.DO(DO),
				.DOP(DOP),
				.ALMOSTEMPTY(),
				.ALMOSTFULL(),
				.EMPTY(EMPTY),
				.FULL(FULL),
				.RDCOUNT(),
				.RDERR(),
				.WRCOUNT(),
				.WRERR(),
				.RDCLK(RDCLK),
				.RDEN(RDEN),
				.REGCE(1'b1),
				.RST(RST),
				.RSTREG(1'b0),
				.WRCLK(WRCLK),
				.WREN(WREN),
				.DI(DI),
				.DIP(DIP)
			);
		end
		else if (TECH == "RTL") begin : gen_rtl
			reg [WIDTH - 1:0] fifo_data [DEPTH - 1:0];
			reg [$clog2(DEPTH) - 1:0] fifo_head;
			reg [$clog2(DEPTH) - 1:0] fifo_tail;
			reg [$clog2(DEPTH) - 1:0] next_fifo_head;
			reg [$clog2(DEPTH) - 1:0] next_fifo_tail;
			always @(*) begin
				if (_sv2v_0)
					;
				next_fifo_head = fifo_head + sv2v_cast_711C5_signed(1);
				next_fifo_tail = fifo_tail + sv2v_cast_711C5_signed(1);
			end
			always @(posedge clk)
				if (rst) begin
					o_full <= 1'b0;
					o_empty <= 1'b1;
				end
				else if (i_push && i_pop) begin
					o_full <= (next_fifo_head + sv2v_cast_711C5_signed(1)) == next_fifo_tail;
					o_empty <= next_fifo_head == next_fifo_tail;
				end
				else if (i_push) begin
					o_full <= (next_fifo_head + sv2v_cast_711C5_signed(1)) == fifo_tail;
					o_empty <= next_fifo_head == fifo_tail;
				end
				else if (i_pop) begin
					o_full <= next_fifo_head == next_fifo_tail;
					o_empty <= fifo_head == next_fifo_tail;
				end
			always @(posedge clk)
				if (rst) begin
					fifo_head <= 1'sb0;
					fifo_tail <= 1'sb0;
				end
				else begin
					if (i_push)
						fifo_head <= next_fifo_head;
					if (i_pop)
						fifo_tail <= next_fifo_tail;
				end
			always @(posedge clk)
				if (i_push)
					fifo_data[fifo_head] <= i_wdata;
			if (RLATENCY == 0) begin : gen_rlatency0
				wire [WIDTH:1] sv2v_tmp_2A762;
				assign sv2v_tmp_2A762 = fifo_data[fifo_tail];
				always @(*) o_rdata = sv2v_tmp_2A762;
			end
			else begin : gen_rlatency1
				always @(posedge clk)
					if (i_pop)
						o_rdata <= fifo_data[fifo_tail];
			end
		end
	endgenerate
	initial _sv2v_0 = 0;
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
module topology_t_binary_tree_wrap (
	clk,
	rst,
	root_credit_vc_target,
	root_credit_packet,
	root_credit_vc_credit_gnt,
	leaf_credit_vc_target,
	leaf_credit_packet,
	leaf_credit_vc_credit_gnt
);
	parameter signed [31:0] N = 2;
	localparam signed [31:0] common_pkg_DEFAULT_N = 8;
	localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
	parameter signed [31:0] A_W = common_pkg_DEFAULT_A_W;
	localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
	parameter signed [31:0] D_W = common_pkg_DEFAULT_D_W;
	parameter signed [31:0] INTERFACE_FLOPS = 1;
	localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
	parameter signed [31:0] VC_W = common_pkg_DEFAULT_VC_W;
	localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
	parameter signed [31:0] VC_FIFO_DEPTH = common_pkg_DEFAULT_VC_FIFO_DEPTH;
	parameter signed [31:0] FAIR_VC_ARB = 0;
	input wire clk;
	input wire rst;
	input wire [VC_W - 1:0] root_credit_vc_target;
	input wire [(((D_W + 0) >= 0 ? D_W + 1 : 1 - (D_W + 0)) + A_W) - 1:0] root_credit_packet;
	input wire [VC_W - 1:0] root_credit_vc_credit_gnt;
	input wire [(N * VC_W) - 1:0] leaf_credit_vc_target;
	input wire [(N * (((D_W + 0) >= 0 ? D_W + 1 : 1 - (D_W + 0)) + A_W)) - 1:0] leaf_credit_packet;
	input wire [(N * VC_W) - 1:0] leaf_credit_vc_credit_gnt;
	generate
		if (1) begin : if_root
			localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
			localparam signed [31:0] VC_W = common_pkg_DEFAULT_VC_W;
			localparam signed [31:0] common_pkg_DEFAULT_N = 8;
			localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
			localparam signed [31:0] A_W = common_pkg_DEFAULT_A_W;
			localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
			localparam signed [31:0] D_W = common_pkg_DEFAULT_D_W;
			wire clk;
			wire rst;
			wire [1:0] vc_target;
			wire [36:0] packet;
			wire [1:0] vc_credit_gnt;
		end
	endgenerate
	assign if_root.clk = clk;
	assign if_root.rst = rst;
	genvar _arr_1F79A;
	generate
		for (_arr_1F79A = N - 1; _arr_1F79A >= 0; _arr_1F79A = _arr_1F79A - 1) begin : if_leaf
			localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
			localparam signed [31:0] VC_W = common_pkg_DEFAULT_VC_W;
			localparam signed [31:0] common_pkg_DEFAULT_N = 8;
			localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
			localparam signed [31:0] A_W = common_pkg_DEFAULT_A_W;
			localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
			localparam signed [31:0] D_W = common_pkg_DEFAULT_D_W;
			wire clk;
			wire rst;
			reg [1:0] vc_target;
			reg [36:0] packet;
			reg [1:0] vc_credit_gnt;
		end
		for (_arr_1F79A = N - 1; _arr_1F79A >= 0; _arr_1F79A = _arr_1F79A - 1) begin : if_leaf_port_bindings
			assign if_leaf[_arr_1F79A].clk = clk;
			assign if_leaf[_arr_1F79A].rst = rst;
		end
	endgenerate
	assign if_root.credit_vc_target = root_credit_vc_target;
	assign if_root.credit_packet = root_credit_packet;
	assign if_root.credit_vc_credit_gnt = root_credit_vc_credit_gnt;
	assign if_leaf[0].credit_vc_target = leaf_credit_vc_target[0+:VC_W];
	assign if_leaf[0].credit_packet = leaf_credit_packet[0+:((D_W + 0) >= 0 ? D_W + 1 : 1 - (D_W + 0)) + A_W];
	assign if_leaf[0].credit_vc_credit_gnt = leaf_credit_vc_credit_gnt[0+:VC_W];
	assign if_leaf[1].credit_vc_target = leaf_credit_vc_target[VC_W+:VC_W];
	assign if_leaf[1].credit_packet = leaf_credit_packet[((D_W + 0) >= 0 ? D_W + 1 : 1 - (D_W + 0)) + A_W+:((D_W + 0) >= 0 ? D_W + 1 : 1 - (D_W + 0)) + A_W];
	assign if_leaf[1].credit_vc_credit_gnt = leaf_credit_vc_credit_gnt[VC_W+:VC_W];
	localparam _bbase_19CF4_leaf_rx = 0;
	localparam _bbase_19CF4_leaf_tx = 0;
	localparam _param_19CF4_N = N;
	localparam _param_19CF4_INTERFACE_FLOPS = INTERFACE_FLOPS;
	localparam _param_19CF4_VC_W = VC_W;
	localparam _param_19CF4_D_W = D_W;
	localparam _param_19CF4_VC_FIFO_DEPTH = VC_FIFO_DEPTH;
	localparam _param_19CF4_FAIR_VC_ARB = FAIR_VC_ARB;
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	generate
		if (1) begin : dut
			localparam N = _param_19CF4_N;
			localparam INTERFACE_FLOPS = _param_19CF4_INTERFACE_FLOPS;
			localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
			localparam VC_W = _param_19CF4_VC_W;
			localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
			localparam D_W = _param_19CF4_D_W;
			localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
			localparam VC_FIFO_DEPTH = _param_19CF4_VC_FIFO_DEPTH;
			localparam FAIR_VC_ARB = _param_19CF4_FAIR_VC_ARB;
			wire clk;
			wire rst;
			localparam _mbase_leaf_rx = 0;
			localparam _mbase_leaf_tx = 0;
			localparam A_W = $clog2(N) + 1;
			localparam LEVELS = $clog2(N);
			localparam _param_ECFDD_VC_W = VC_W;
			localparam _param_ECFDD_A_W = A_W;
			localparam _param_ECFDD_D_W = D_W;
			genvar _arr_ECFDD;
			for (_arr_ECFDD = N - 1; _arr_ECFDD >= 0; _arr_ECFDD = _arr_ECFDD - 1) begin : leaf_rx_above_flops
				localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
				localparam signed [31:0] VC_W = _param_ECFDD_VC_W;
				localparam signed [31:0] common_pkg_DEFAULT_N = 8;
				localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
				localparam signed [31:0] A_W = _param_ECFDD_A_W;
				localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
				localparam signed [31:0] D_W = _param_ECFDD_D_W;
				wire clk;
				wire rst;
				reg [VC_W - 1:0] vc_target;
				reg [(((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + sv2v_cast_32_signed(_param_ECFDD_A_W)) - 1:0] packet;
				reg [VC_W - 1:0] vc_credit_gnt;
			end
			for (_arr_ECFDD = N - 1; _arr_ECFDD >= 0; _arr_ECFDD = _arr_ECFDD - 1) begin : leaf_rx_above_flops_port_bindings
				assign leaf_rx_above_flops[_arr_ECFDD].clk = clk;
				assign leaf_rx_above_flops[_arr_ECFDD].rst = rst;
			end
			localparam _param_442DB_VC_W = VC_W;
			localparam _param_442DB_A_W = A_W;
			localparam _param_442DB_D_W = D_W;
			genvar _arr_442DB;
			for (_arr_442DB = N - 1; _arr_442DB >= 0; _arr_442DB = _arr_442DB - 1) begin : leaf_tx_above_flops
				localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
				localparam signed [31:0] VC_W = _param_442DB_VC_W;
				localparam signed [31:0] common_pkg_DEFAULT_N = 8;
				localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
				localparam signed [31:0] A_W = _param_442DB_A_W;
				localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
				localparam signed [31:0] D_W = _param_442DB_D_W;
				wire clk;
				wire rst;
				wire [VC_W - 1:0] vc_target;
				wire [(((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + sv2v_cast_32_signed(_param_442DB_A_W)) - 1:0] packet;
				reg [VC_W - 1:0] vc_credit_gnt;
			end
			for (_arr_442DB = N - 1; _arr_442DB >= 0; _arr_442DB = _arr_442DB - 1) begin : leaf_tx_above_flops_port_bindings
				assign leaf_tx_above_flops[_arr_442DB].clk = clk;
				assign leaf_tx_above_flops[_arr_442DB].rst = rst;
			end
			genvar _gv_ii_3;
			for (_gv_ii_3 = 0; _gv_ii_3 < LEVELS; _gv_ii_3 = _gv_ii_3 + 1) begin : gen_levels
				localparam ii = _gv_ii_3;
				localparam _param_34D87_VC_W = VC_W;
				localparam _param_34D87_A_W = A_W;
				localparam _param_34D87_D_W = D_W;
				genvar _arr_34D87;
				for (_arr_34D87 = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_34D87 >= 0; _arr_34D87 = _arr_34D87 - 1) begin : upwards_if_below_flops
					localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
					localparam signed [31:0] VC_W = _param_34D87_VC_W;
					localparam signed [31:0] common_pkg_DEFAULT_N = 8;
					localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
					localparam signed [31:0] A_W = _param_34D87_A_W;
					localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
					localparam signed [31:0] D_W = _param_34D87_D_W;
					wire clk;
					wire rst;
					wire [VC_W - 1:0] vc_target;
					wire [(((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + sv2v_cast_32_signed($clog2(N) + 1)) - 1:0] packet;
					reg [VC_W - 1:0] vc_credit_gnt;
				end
				for (_arr_34D87 = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_34D87 >= 0; _arr_34D87 = _arr_34D87 - 1) begin : upwards_if_below_flops_port_bindings
					assign upwards_if_below_flops[_arr_34D87].clk = clk;
					assign upwards_if_below_flops[_arr_34D87].rst = rst;
				end
				localparam _param_4402B_VC_W = VC_W;
				localparam _param_4402B_A_W = A_W;
				localparam _param_4402B_D_W = D_W;
				genvar _arr_4402B;
				for (_arr_4402B = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_4402B >= 0; _arr_4402B = _arr_4402B - 1) begin : upwards_if_above_flops
					localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
					localparam signed [31:0] VC_W = _param_4402B_VC_W;
					localparam signed [31:0] common_pkg_DEFAULT_N = 8;
					localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
					localparam signed [31:0] A_W = _param_4402B_A_W;
					localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
					localparam signed [31:0] D_W = _param_4402B_D_W;
					wire clk;
					wire rst;
					reg [VC_W - 1:0] vc_target;
					reg [(((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + sv2v_cast_32_signed($clog2(N) + 1)) - 1:0] packet;
					reg [VC_W - 1:0] vc_credit_gnt;
				end
				for (_arr_4402B = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_4402B >= 0; _arr_4402B = _arr_4402B - 1) begin : upwards_if_above_flops_port_bindings
					assign upwards_if_above_flops[_arr_4402B].clk = clk;
					assign upwards_if_above_flops[_arr_4402B].rst = rst;
				end
				localparam _param_86B3A_VC_W = VC_W;
				localparam _param_86B3A_A_W = A_W;
				localparam _param_86B3A_D_W = D_W;
				genvar _arr_86B3A;
				for (_arr_86B3A = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_86B3A >= 0; _arr_86B3A = _arr_86B3A - 1) begin : downwards_if_above_flops
					localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
					localparam signed [31:0] VC_W = _param_86B3A_VC_W;
					localparam signed [31:0] common_pkg_DEFAULT_N = 8;
					localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
					localparam signed [31:0] A_W = _param_86B3A_A_W;
					localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
					localparam signed [31:0] D_W = _param_86B3A_D_W;
					wire clk;
					wire rst;
					wire [VC_W - 1:0] vc_target;
					wire [(((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + sv2v_cast_32_signed($clog2(N) + 1)) - 1:0] packet;
					reg [VC_W - 1:0] vc_credit_gnt;
				end
				for (_arr_86B3A = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_86B3A >= 0; _arr_86B3A = _arr_86B3A - 1) begin : downwards_if_above_flops_port_bindings
					assign downwards_if_above_flops[_arr_86B3A].clk = clk;
					assign downwards_if_above_flops[_arr_86B3A].rst = rst;
				end
				localparam _param_BB136_VC_W = VC_W;
				localparam _param_BB136_A_W = A_W;
				localparam _param_BB136_D_W = D_W;
				genvar _arr_BB136;
				for (_arr_BB136 = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_BB136 >= 0; _arr_BB136 = _arr_BB136 - 1) begin : downwards_if_below_flops
					localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
					localparam signed [31:0] VC_W = _param_BB136_VC_W;
					localparam signed [31:0] common_pkg_DEFAULT_N = 8;
					localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
					localparam signed [31:0] A_W = _param_BB136_A_W;
					localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
					localparam signed [31:0] D_W = _param_BB136_D_W;
					wire clk;
					wire rst;
					reg [VC_W - 1:0] vc_target;
					reg [(((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + sv2v_cast_32_signed($clog2(N) + 1)) - 1:0] packet;
					reg [VC_W - 1:0] vc_credit_gnt;
				end
				for (_arr_BB136 = (2 ** ((LEVELS - ii) - 1)) - 1; _arr_BB136 >= 0; _arr_BB136 = _arr_BB136 - 1) begin : downwards_if_below_flops_port_bindings
					assign downwards_if_below_flops[_arr_BB136].clk = clk;
					assign downwards_if_below_flops[_arr_BB136].rst = rst;
				end
				genvar _gv_jj_1;
				for (_gv_jj_1 = 0; _gv_jj_1 < (2 ** ((LEVELS - ii) - 1)); _gv_jj_1 = _gv_jj_1 + 1) begin : gen_flops
					localparam jj = _gv_jj_1;
					localparam _bbase_B3B1C_from_tx = _gv_jj_1;
					localparam _bbase_B3B1C_to_rx = _gv_jj_1;
					localparam _param_B3B1C_VC_W = VC_W;
					localparam _param_B3B1C_A_W = A_W;
					localparam _param_B3B1C_D_W = D_W;
					localparam _param_B3B1C_LATENCY = INTERFACE_FLOPS;
					if (1) begin : upwards_pipe
						reg _sv2v_0;
						localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
						localparam signed [31:0] VC_W = _param_B3B1C_VC_W;
						localparam signed [31:0] common_pkg_DEFAULT_N = 8;
						localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
						localparam signed [31:0] A_W = _param_B3B1C_A_W;
						localparam signed [31:0] D_W = _param_B3B1C_D_W;
						localparam signed [31:0] LATENCY = _param_B3B1C_LATENCY;
						wire clk;
						wire rst;
						localparam _mbase_from_tx = _bbase_B3B1C_from_tx;
						localparam _mbase_to_rx = _bbase_B3B1C_to_rx;
						if (LATENCY == 0) begin : gen_comb_pipe
							always @(*) begin
								if (_sv2v_0)
									;
								topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_target = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_target;
								topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].packet = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].packet;
								topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_credit_gnt = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_credit_gnt;
							end
						end
						else if (LATENCY == 1) begin : gen_single_ff_pipe
							always @(posedge clk)
								if (rst) begin
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_target <= 1'sb0;
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_credit_gnt <= 1'sb0;
								end
								else begin
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_target <= topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_target;
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_credit_gnt <= topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_credit_gnt;
								end
							always @(posedge clk) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].packet <= topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].packet;
						end
						else begin : gen_multi_ff_pipe
							reg [(LATENCY * VC_W) - 1:0] vc_target_ffs;
							reg [(LATENCY * VC_W) - 1:0] vc_credit_gnt_ffs;
							reg [((A_W + D_W) >= 0 ? (LATENCY * ((A_W + D_W) + 1)) - 1 : (LATENCY * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] packet_ffs;
							always @(posedge clk)
								if (rst) begin
									vc_target_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
									vc_credit_gnt_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
								end
								else begin
									vc_target_ffs <= {vc_target_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_target};
									vc_credit_gnt_ffs <= {vc_credit_gnt_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_credit_gnt};
								end
							always @(posedge clk) packet_ffs <= {packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + (((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1)))+:((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(N) + 1) + 0)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed($clog2(N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(N) + 1) - 1) - (sv2v_cast_32_signed($clog2(N) + 1) - 1))-:sv2v_cast_32_signed($clog2(N) + 1)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))]};
							wire [_param_19CF4_VC_W:1] sv2v_tmp_134F0;
							assign sv2v_tmp_134F0 = vc_target_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].vc_target = sv2v_tmp_134F0;
							wire [1:1] sv2v_tmp_D4771;
							assign sv2v_tmp_D4771 = packet_ffs[((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? A_W + D_W : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (A_W + D_W))];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(N) + 1) + 0)] = sv2v_tmp_D4771;
							wire [sv2v_cast_32_signed($clog2(N) + 1) * 1:1] sv2v_tmp_7D8D0;
							assign sv2v_tmp_7D8D0 = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].packet[(sv2v_cast_32_signed($clog2(N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(N) + 1) - 1) - (sv2v_cast_32_signed($clog2(N) + 1) - 1))-:sv2v_cast_32_signed($clog2(N) + 1)] = sv2v_tmp_7D8D0;
							wire [((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0)) * 1:1] sv2v_tmp_12604;
							assign sv2v_tmp_12604 = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1))) + D_W) - 1)-:D_W];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_above_flops[_mbase_to_rx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))] = sv2v_tmp_12604;
							wire [_param_19CF4_VC_W:1] sv2v_tmp_79639;
							assign sv2v_tmp_79639 = vc_credit_gnt_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_from_tx].vc_credit_gnt = sv2v_tmp_79639;
						end
						initial _sv2v_0 = 0;
					end
					assign upwards_pipe.clk = clk;
					assign upwards_pipe.rst = rst;
					localparam _bbase_7C965_from_tx = _gv_jj_1;
					localparam _bbase_7C965_to_rx = _gv_jj_1;
					localparam _param_7C965_VC_W = VC_W;
					localparam _param_7C965_A_W = A_W;
					localparam _param_7C965_D_W = D_W;
					localparam _param_7C965_LATENCY = INTERFACE_FLOPS;
					if (1) begin : downwards_pipe
						reg _sv2v_0;
						localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
						localparam signed [31:0] VC_W = _param_7C965_VC_W;
						localparam signed [31:0] common_pkg_DEFAULT_N = 8;
						localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
						localparam signed [31:0] A_W = _param_7C965_A_W;
						localparam signed [31:0] D_W = _param_7C965_D_W;
						localparam signed [31:0] LATENCY = _param_7C965_LATENCY;
						wire clk;
						wire rst;
						localparam _mbase_from_tx = _bbase_7C965_from_tx;
						localparam _mbase_to_rx = _bbase_7C965_to_rx;
						if (LATENCY == 0) begin : gen_comb_pipe
							always @(*) begin
								if (_sv2v_0)
									;
								topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_target = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_target;
								topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].packet = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].packet;
								topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_credit_gnt = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_credit_gnt;
							end
						end
						else if (LATENCY == 1) begin : gen_single_ff_pipe
							always @(posedge clk)
								if (rst) begin
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_target <= 1'sb0;
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_credit_gnt <= 1'sb0;
								end
								else begin
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_target <= topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_target;
									topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_credit_gnt <= topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_credit_gnt;
								end
							always @(posedge clk) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].packet <= topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].packet;
						end
						else begin : gen_multi_ff_pipe
							reg [(LATENCY * VC_W) - 1:0] vc_target_ffs;
							reg [(LATENCY * VC_W) - 1:0] vc_credit_gnt_ffs;
							reg [((A_W + D_W) >= 0 ? (LATENCY * ((A_W + D_W) + 1)) - 1 : (LATENCY * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] packet_ffs;
							always @(posedge clk)
								if (rst) begin
									vc_target_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
									vc_credit_gnt_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
								end
								else begin
									vc_target_ffs <= {vc_target_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_target};
									vc_credit_gnt_ffs <= {vc_credit_gnt_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_credit_gnt};
								end
							always @(posedge clk) packet_ffs <= {packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + (((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1)))+:((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(N) + 1) + 0)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed($clog2(N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(N) + 1) - 1) - (sv2v_cast_32_signed($clog2(N) + 1) - 1))-:sv2v_cast_32_signed($clog2(N) + 1)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))]};
							wire [_param_19CF4_VC_W:1] sv2v_tmp_CA491;
							assign sv2v_tmp_CA491 = vc_target_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].vc_target = sv2v_tmp_CA491;
							wire [1:1] sv2v_tmp_6D964;
							assign sv2v_tmp_6D964 = packet_ffs[((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? A_W + D_W : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (A_W + D_W))];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(N) + 1) + 0)] = sv2v_tmp_6D964;
							wire [sv2v_cast_32_signed($clog2(N) + 1) * 1:1] sv2v_tmp_DDCB9;
							assign sv2v_tmp_DDCB9 = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].packet[(sv2v_cast_32_signed($clog2(N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(N) + 1) - 1) - (sv2v_cast_32_signed($clog2(N) + 1) - 1))-:sv2v_cast_32_signed($clog2(N) + 1)] = sv2v_tmp_DDCB9;
							wire [((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0)) * 1:1] sv2v_tmp_14619;
							assign sv2v_tmp_14619 = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1))) + D_W) - 1)-:D_W];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_to_rx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))] = sv2v_tmp_14619;
							wire [_param_19CF4_VC_W:1] sv2v_tmp_D6A8C;
							assign sv2v_tmp_D6A8C = vc_credit_gnt_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
							always @(*) topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_above_flops[_mbase_from_tx].vc_credit_gnt = sv2v_tmp_D6A8C;
						end
						initial _sv2v_0 = 0;
					end
					assign downwards_pipe.clk = clk;
					assign downwards_pipe.rst = rst;
				end
				if (ii == 0) begin : gen_almost_leaves
					genvar _gv_jj_2;
					for (_gv_jj_2 = 0; _gv_jj_2 < (2 ** ((LEVELS - ii) - 1)); _gv_jj_2 = _gv_jj_2 + 1) begin : gen_almost_leaves_loop
						localparam jj = _gv_jj_2;
						localparam _bbase_EA2DE_l_rx = _gv_jj_2 * 2;
						localparam _bbase_EA2DE_l_tx = _gv_jj_2 * 2;
						localparam _bbase_EA2DE_r_rx = (_gv_jj_2 * 2) + 1;
						localparam _bbase_EA2DE_r_tx = (_gv_jj_2 * 2) + 1;
						localparam _bbase_EA2DE_u0_rx = _gv_jj_2;
						localparam _bbase_EA2DE_u0_tx = _gv_jj_2;
						localparam _param_EA2DE_N = N;
						localparam _param_EA2DE_A_W = A_W;
						localparam _param_EA2DE_D_W = D_W;
						localparam _param_EA2DE_posl = ii;
						localparam _param_EA2DE_posx = jj;
						localparam _param_EA2DE_VC_W = VC_W;
						localparam _param_EA2DE_VC_FIFO_DEPTH = VC_FIFO_DEPTH;
						localparam _param_EA2DE_FAIR_VC_ARB = FAIR_VC_ARB;
						if (1) begin : almost_leaf_t_switch_inst
							localparam signed [31:0] common_pkg_DEFAULT_N = 8;
							localparam N = _param_EA2DE_N;
							localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
							localparam A_W = _param_EA2DE_A_W;
							localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
							localparam D_W = _param_EA2DE_D_W;
							localparam posl = _param_EA2DE_posl;
							localparam posx = _param_EA2DE_posx;
							localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
							localparam VC_W = _param_EA2DE_VC_W;
							localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
							localparam VC_FIFO_DEPTH = _param_EA2DE_VC_FIFO_DEPTH;
							localparam FAIR_VC_ARB = _param_EA2DE_FAIR_VC_ARB;
							wire clk;
							wire rst;
							localparam _mbase_l_rx = _bbase_EA2DE_l_rx;
							localparam _mbase_r_rx = _bbase_EA2DE_r_rx;
							localparam _mbase_u0_rx = _bbase_EA2DE_u0_rx;
							localparam _mbase_l_tx = _bbase_EA2DE_l_tx;
							localparam _mbase_r_tx = _bbase_EA2DE_r_tx;
							localparam _mbase_u0_tx = _bbase_EA2DE_u0_tx;
							wire [VC_W - 1:0] l_i_v;
							wire [VC_W - 1:0] r_i_v;
							wire [VC_W - 1:0] u0_i_v;
							wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] l_i_d;
							wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] r_i_d;
							wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] u0_i_d;
							wire [VC_W - 1:0] l_i_b;
							wire [VC_W - 1:0] r_i_b;
							wire [VC_W - 1:0] u0_i_b;
							localparam _bbase_5713C_from_tx = _gv_jj_2 * 2;
							localparam _param_5713C_VC_W = VC_W;
							localparam _param_5713C_D_W = D_W;
							localparam _param_5713C_A_W = A_W;
							localparam _param_5713C_DEPTH = VC_FIFO_DEPTH;
							if (1) begin : l_rx_fifos
								reg _sv2v_0;
								localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
								localparam VC_W = _param_5713C_VC_W;
								localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
								localparam D_W = _param_5713C_D_W;
								localparam signed [31:0] common_pkg_DEFAULT_N = 8;
								localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
								localparam A_W = _param_5713C_A_W;
								localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
								localparam DEPTH = _param_5713C_DEPTH;
								wire clk;
								wire rst;
								localparam _mbase_from_tx = _bbase_5713C_from_tx;
								reg [VC_W - 1:0] o_v;
								reg [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] o_d;
								wire [VC_W - 1:0] i_b;
								genvar _gv_ii_1;
								for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
									localparam ii = _gv_ii_1;
									reg push;
									reg [A_W + D_W:0] wdata;
									reg pop;
									wire empty;
									wire [A_W + D_W:0] rdata;
									fifo32 #(
										.DEPTH32(DEPTH / 32),
										.WIDTH((A_W + D_W) + 1),
										.RLATENCY(0)
									) vc_fifo(
										.clk(clk),
										.rst(rst),
										.i_push(push),
										.o_full(),
										.i_wdata(wdata),
										.i_pop(pop),
										.o_empty(empty),
										.o_rdata(rdata)
									);
									always @(*) begin
										if (_sv2v_0)
											;
										push = topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].vc_target[ii];
										wdata = {topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].packet[((_param_ECFDD_D_W + 0) >= 0 ? (((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1)) - (_param_ECFDD_D_W + 0) : sv2v_cast_32_signed(_param_ECFDD_A_W) + 0)], topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed(_param_ECFDD_A_W) - 1) - ((sv2v_cast_32_signed(_param_ECFDD_A_W) - 1) - (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1))-:sv2v_cast_32_signed(_param_ECFDD_A_W)], topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].packet[((_param_ECFDD_D_W + 0) >= 0 ? (((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1)) - ((_param_ECFDD_D_W + 0) - (_param_ECFDD_D_W + 0)) : (((sv2v_cast_32_signed(_param_ECFDD_A_W) + 0) - (_param_ECFDD_D_W + 0)) + ((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0))) - 1)-:((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0))]};
										topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].vc_credit_gnt[ii] = pop;
									end
									always @(*) begin
										if (_sv2v_0)
											;
										pop = !i_b[ii] & !empty;
										o_v[ii] = !empty;
										o_d[((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : ($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + (ii * ((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W)))+:((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W))] = rdata;
									end
								end
								initial _sv2v_0 = 0;
							end
							assign l_rx_fifos.clk = clk;
							assign l_rx_fifos.rst = rst;
							assign l_i_v = l_rx_fifos.o_v;
							assign l_i_d = l_rx_fifos.o_d;
							assign l_rx_fifos.i_b = l_i_b;
							localparam _bbase_60DC2_from_tx = (_gv_jj_2 * 2) + 1;
							localparam _param_60DC2_VC_W = VC_W;
							localparam _param_60DC2_D_W = D_W;
							localparam _param_60DC2_A_W = A_W;
							localparam _param_60DC2_DEPTH = VC_FIFO_DEPTH;
							if (1) begin : r_rx_fifos
								reg _sv2v_0;
								localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
								localparam VC_W = _param_60DC2_VC_W;
								localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
								localparam D_W = _param_60DC2_D_W;
								localparam signed [31:0] common_pkg_DEFAULT_N = 8;
								localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
								localparam A_W = _param_60DC2_A_W;
								localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
								localparam DEPTH = _param_60DC2_DEPTH;
								wire clk;
								wire rst;
								localparam _mbase_from_tx = _bbase_60DC2_from_tx;
								reg [VC_W - 1:0] o_v;
								reg [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] o_d;
								wire [VC_W - 1:0] i_b;
								genvar _gv_ii_1;
								for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
									localparam ii = _gv_ii_1;
									reg push;
									reg [A_W + D_W:0] wdata;
									reg pop;
									wire empty;
									wire [A_W + D_W:0] rdata;
									fifo32 #(
										.DEPTH32(DEPTH / 32),
										.WIDTH((A_W + D_W) + 1),
										.RLATENCY(0)
									) vc_fifo(
										.clk(clk),
										.rst(rst),
										.i_push(push),
										.o_full(),
										.i_wdata(wdata),
										.i_pop(pop),
										.o_empty(empty),
										.o_rdata(rdata)
									);
									always @(*) begin
										if (_sv2v_0)
											;
										push = topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].vc_target[ii];
										wdata = {topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].packet[((_param_ECFDD_D_W + 0) >= 0 ? (((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1)) - (_param_ECFDD_D_W + 0) : sv2v_cast_32_signed(_param_ECFDD_A_W) + 0)], topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed(_param_ECFDD_A_W) - 1) - ((sv2v_cast_32_signed(_param_ECFDD_A_W) - 1) - (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1))-:sv2v_cast_32_signed(_param_ECFDD_A_W)], topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].packet[((_param_ECFDD_D_W + 0) >= 0 ? (((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1)) - ((_param_ECFDD_D_W + 0) - (_param_ECFDD_D_W + 0)) : (((sv2v_cast_32_signed(_param_ECFDD_A_W) + 0) - (_param_ECFDD_D_W + 0)) + ((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0))) - 1)-:((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0))]};
										topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_from_tx].vc_credit_gnt[ii] = pop;
									end
									always @(*) begin
										if (_sv2v_0)
											;
										pop = !i_b[ii] & !empty;
										o_v[ii] = !empty;
										o_d[((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : ($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + (ii * ((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W)))+:((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W))] = rdata;
									end
								end
								initial _sv2v_0 = 0;
							end
							assign r_rx_fifos.clk = clk;
							assign r_rx_fifos.rst = rst;
							assign r_i_v = r_rx_fifos.o_v;
							assign r_i_d = r_rx_fifos.o_d;
							assign r_rx_fifos.i_b = r_i_b;
							localparam _bbase_01D46_from_tx = _gv_jj_2;
							localparam _param_01D46_VC_W = VC_W;
							localparam _param_01D46_D_W = D_W;
							localparam _param_01D46_A_W = A_W;
							localparam _param_01D46_DEPTH = VC_FIFO_DEPTH;
							if (1) begin : u0_rx_fifos
								reg _sv2v_0;
								localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
								localparam VC_W = _param_01D46_VC_W;
								localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
								localparam D_W = _param_01D46_D_W;
								localparam signed [31:0] common_pkg_DEFAULT_N = 8;
								localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
								localparam A_W = _param_01D46_A_W;
								localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
								localparam DEPTH = _param_01D46_DEPTH;
								wire clk;
								wire rst;
								localparam _mbase_from_tx = _bbase_01D46_from_tx;
								reg [VC_W - 1:0] o_v;
								reg [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] o_d;
								wire [VC_W - 1:0] i_b;
								genvar _gv_ii_1;
								for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
									localparam ii = _gv_ii_1;
									reg push;
									reg [A_W + D_W:0] wdata;
									reg pop;
									wire empty;
									wire [A_W + D_W:0] rdata;
									fifo32 #(
										.DEPTH32(DEPTH / 32),
										.WIDTH((A_W + D_W) + 1),
										.RLATENCY(0)
									) vc_fifo(
										.clk(clk),
										.rst(rst),
										.i_push(push),
										.o_full(),
										.i_wdata(wdata),
										.i_pop(pop),
										.o_empty(empty),
										.o_rdata(rdata)
									);
									always @(*) begin
										if (_sv2v_0)
											;
										push = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].vc_target[ii];
										wdata = {topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))]};
										topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].vc_credit_gnt[ii] = pop;
									end
									always @(*) begin
										if (_sv2v_0)
											;
										pop = !i_b[ii] & !empty;
										o_v[ii] = !empty;
										o_d[((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : ($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + (ii * ((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W)))+:((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W))] = rdata;
									end
								end
								initial _sv2v_0 = 0;
							end
							assign u0_rx_fifos.clk = clk;
							assign u0_rx_fifos.rst = rst;
							assign u0_i_v = u0_rx_fifos.o_v;
							assign u0_i_d = u0_rx_fifos.o_d;
							assign u0_rx_fifos.i_b = u0_i_b;
							wire [VC_W - 1:0] l_o_v;
							wire [VC_W - 1:0] r_o_v;
							wire [VC_W - 1:0] u0_o_v;
							wire [A_W + D_W:0] l_o_d;
							wire [A_W + D_W:0] r_o_d;
							wire [A_W + D_W:0] u0_o_d;
							t_switch #(
								.N(N),
								.A_W(A_W),
								.D_W(D_W),
								.posl(posl),
								.posx(posx),
								.VC_W(VC_W),
								.VC_FIFO_DEPTH(VC_FIFO_DEPTH),
								.FAIR_VC_ARB(FAIR_VC_ARB)
							) t_switch_inst(
								.clk(clk),
								.rst(rst),
								.l_i(l_i_d),
								.l_i_bp(l_i_b),
								.l_i_v(l_i_v),
								.r_i(r_i_d),
								.r_i_bp(r_i_b),
								.r_i_v(r_i_v),
								.u0_i(u0_i_d),
								.u0_i_bp(u0_i_b),
								.u0_i_v(u0_i_v),
								.l_o(l_o_d),
								.l_o_credit_gnt(topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_l_tx].vc_credit_gnt),
								.l_o_v(l_o_v),
								.r_o(r_o_d),
								.r_o_credit_gnt(topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_r_tx].vc_credit_gnt),
								.r_o_v(r_o_v),
								.u0_o(u0_o_d),
								.u0_o_credit_gnt(topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].vc_credit_gnt),
								.u0_o_v(u0_o_v)
							);
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_l_tx].packet[((_param_442DB_D_W + 0) >= 0 ? (((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + (sv2v_cast_32_signed(_param_442DB_A_W) - 1)) - ((_param_442DB_D_W + 0) - (_param_442DB_D_W + 0)) : (((sv2v_cast_32_signed(_param_442DB_A_W) + 0) - (_param_442DB_D_W + 0)) + ((_param_442DB_D_W + 0) >= 1 ? _param_442DB_D_W + 0 : 2 - (_param_442DB_D_W + 0))) - 1)-:((_param_442DB_D_W + 0) >= 1 ? _param_442DB_D_W + 0 : 2 - (_param_442DB_D_W + 0))] = l_o_d[D_W - 1:0];
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_l_tx].packet[(sv2v_cast_32_signed(_param_442DB_A_W) - 1) - ((sv2v_cast_32_signed(_param_442DB_A_W) - 1) - (sv2v_cast_32_signed(_param_442DB_A_W) - 1))-:sv2v_cast_32_signed(_param_442DB_A_W)] = l_o_d[(A_W + D_W) - 1:D_W];
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_l_tx].packet[((_param_442DB_D_W + 0) >= 0 ? (((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + (sv2v_cast_32_signed(_param_442DB_A_W) - 1)) - (_param_442DB_D_W + 0) : sv2v_cast_32_signed(_param_442DB_A_W) + 0)] = l_o_d[A_W + D_W];
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_r_tx].packet[((_param_442DB_D_W + 0) >= 0 ? (((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + (sv2v_cast_32_signed(_param_442DB_A_W) - 1)) - ((_param_442DB_D_W + 0) - (_param_442DB_D_W + 0)) : (((sv2v_cast_32_signed(_param_442DB_A_W) + 0) - (_param_442DB_D_W + 0)) + ((_param_442DB_D_W + 0) >= 1 ? _param_442DB_D_W + 0 : 2 - (_param_442DB_D_W + 0))) - 1)-:((_param_442DB_D_W + 0) >= 1 ? _param_442DB_D_W + 0 : 2 - (_param_442DB_D_W + 0))] = r_o_d[D_W - 1:0];
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_r_tx].packet[(sv2v_cast_32_signed(_param_442DB_A_W) - 1) - ((sv2v_cast_32_signed(_param_442DB_A_W) - 1) - (sv2v_cast_32_signed(_param_442DB_A_W) - 1))-:sv2v_cast_32_signed(_param_442DB_A_W)] = r_o_d[(A_W + D_W) - 1:D_W];
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_r_tx].packet[((_param_442DB_D_W + 0) >= 0 ? (((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + (sv2v_cast_32_signed(_param_442DB_A_W) - 1)) - (_param_442DB_D_W + 0) : sv2v_cast_32_signed(_param_442DB_A_W) + 0)] = r_o_d[A_W + D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))] = u0_o_d[D_W - 1:0];
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)] = u0_o_d[(A_W + D_W) - 1:D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)] = u0_o_d[A_W + D_W];
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_l_tx].vc_target = l_o_v;
							assign topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_r_tx].vc_target = r_o_v;
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].vc_target = u0_o_v;
						end
						assign almost_leaf_t_switch_inst.clk = clk;
						assign almost_leaf_t_switch_inst.rst = rst;
					end
				end
				else begin : gen_higher_levels
					genvar _gv_jj_3;
					for (_gv_jj_3 = 0; _gv_jj_3 < (2 ** ((LEVELS - ii) - 1)); _gv_jj_3 = _gv_jj_3 + 1) begin : gen_higher_levels_loop
						localparam jj = _gv_jj_3;
						localparam _bbase_142F7_l_rx = _gv_jj_3 * 2;
						localparam _bbase_142F7_l_tx = _gv_jj_3 * 2;
						localparam _bbase_142F7_r_rx = (_gv_jj_3 * 2) + 1;
						localparam _bbase_142F7_r_tx = (_gv_jj_3 * 2) + 1;
						localparam _bbase_142F7_u0_rx = _gv_jj_3;
						localparam _bbase_142F7_u0_tx = _gv_jj_3;
						localparam _param_142F7_N = N;
						localparam _param_142F7_A_W = A_W;
						localparam _param_142F7_D_W = D_W;
						localparam _param_142F7_posl = ii;
						localparam _param_142F7_posx = jj;
						localparam _param_142F7_VC_W = VC_W;
						localparam _param_142F7_VC_FIFO_DEPTH = VC_FIFO_DEPTH;
						localparam _param_142F7_FAIR_VC_ARB = FAIR_VC_ARB;
						if (1) begin : higher_level_t_switch_inst
							localparam signed [31:0] common_pkg_DEFAULT_N = 8;
							localparam N = _param_142F7_N;
							localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
							localparam A_W = _param_142F7_A_W;
							localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
							localparam D_W = _param_142F7_D_W;
							localparam posl = _param_142F7_posl;
							localparam posx = _param_142F7_posx;
							localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
							localparam VC_W = _param_142F7_VC_W;
							localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
							localparam VC_FIFO_DEPTH = _param_142F7_VC_FIFO_DEPTH;
							localparam FAIR_VC_ARB = _param_142F7_FAIR_VC_ARB;
							wire clk;
							wire rst;
							localparam _mbase_l_rx = _bbase_142F7_l_rx;
							localparam _mbase_r_rx = _bbase_142F7_r_rx;
							localparam _mbase_u0_rx = _bbase_142F7_u0_rx;
							localparam _mbase_l_tx = _bbase_142F7_l_tx;
							localparam _mbase_r_tx = _bbase_142F7_r_tx;
							localparam _mbase_u0_tx = _bbase_142F7_u0_tx;
							wire [VC_W - 1:0] l_i_v;
							wire [VC_W - 1:0] r_i_v;
							wire [VC_W - 1:0] u0_i_v;
							wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] l_i_d;
							wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] r_i_d;
							wire [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] u0_i_d;
							wire [VC_W - 1:0] l_i_b;
							wire [VC_W - 1:0] r_i_b;
							wire [VC_W - 1:0] u0_i_b;
							localparam _bbase_20467_from_tx = _gv_jj_3 * 2;
							localparam _param_20467_VC_W = VC_W;
							localparam _param_20467_D_W = D_W;
							localparam _param_20467_A_W = A_W;
							localparam _param_20467_DEPTH = VC_FIFO_DEPTH;
							if (1) begin : l_rx_fifos
								reg _sv2v_0;
								localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
								localparam VC_W = _param_20467_VC_W;
								localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
								localparam D_W = _param_20467_D_W;
								localparam signed [31:0] common_pkg_DEFAULT_N = 8;
								localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
								localparam A_W = _param_20467_A_W;
								localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
								localparam DEPTH = _param_20467_DEPTH;
								wire clk;
								wire rst;
								localparam _mbase_from_tx = _bbase_20467_from_tx;
								reg [VC_W - 1:0] o_v;
								reg [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] o_d;
								wire [VC_W - 1:0] i_b;
								genvar _gv_ii_1;
								for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
									localparam ii = _gv_ii_1;
									reg push;
									reg [A_W + D_W:0] wdata;
									reg pop;
									wire empty;
									wire [A_W + D_W:0] rdata;
									fifo32 #(
										.DEPTH32(DEPTH / 32),
										.WIDTH((A_W + D_W) + 1),
										.RLATENCY(0)
									) vc_fifo(
										.clk(clk),
										.rst(rst),
										.i_push(push),
										.o_full(),
										.i_wdata(wdata),
										.i_pop(pop),
										.o_empty(empty),
										.o_rdata(rdata)
									);
									always @(*) begin
										if (_sv2v_0)
											;
										push = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].vc_target[ii];
										wdata = {topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))]};
										topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].vc_credit_gnt[ii] = pop;
									end
									always @(*) begin
										if (_sv2v_0)
											;
										pop = !i_b[ii] & !empty;
										o_v[ii] = !empty;
										o_d[((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : ($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + (ii * ((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W)))+:((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W))] = rdata;
									end
								end
								initial _sv2v_0 = 0;
							end
							assign l_rx_fifos.clk = clk;
							assign l_rx_fifos.rst = rst;
							assign l_i_v = l_rx_fifos.o_v;
							assign l_i_d = l_rx_fifos.o_d;
							assign l_rx_fifos.i_b = l_i_b;
							localparam _bbase_2C859_from_tx = (_gv_jj_3 * 2) + 1;
							localparam _param_2C859_VC_W = VC_W;
							localparam _param_2C859_D_W = D_W;
							localparam _param_2C859_A_W = A_W;
							localparam _param_2C859_DEPTH = VC_FIFO_DEPTH;
							if (1) begin : r_rx_fifos
								reg _sv2v_0;
								localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
								localparam VC_W = _param_2C859_VC_W;
								localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
								localparam D_W = _param_2C859_D_W;
								localparam signed [31:0] common_pkg_DEFAULT_N = 8;
								localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
								localparam A_W = _param_2C859_A_W;
								localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
								localparam DEPTH = _param_2C859_DEPTH;
								wire clk;
								wire rst;
								localparam _mbase_from_tx = _bbase_2C859_from_tx;
								reg [VC_W - 1:0] o_v;
								reg [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] o_d;
								wire [VC_W - 1:0] i_b;
								genvar _gv_ii_1;
								for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
									localparam ii = _gv_ii_1;
									reg push;
									reg [A_W + D_W:0] wdata;
									reg pop;
									wire empty;
									wire [A_W + D_W:0] rdata;
									fifo32 #(
										.DEPTH32(DEPTH / 32),
										.WIDTH((A_W + D_W) + 1),
										.RLATENCY(0)
									) vc_fifo(
										.clk(clk),
										.rst(rst),
										.i_push(push),
										.o_full(),
										.i_wdata(wdata),
										.i_pop(pop),
										.o_empty(empty),
										.o_rdata(rdata)
									);
									always @(*) begin
										if (_sv2v_0)
											;
										push = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].vc_target[ii];
										wdata = {topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))]};
										topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3 - 1].upwards_if_above_flops[_mbase_from_tx].vc_credit_gnt[ii] = pop;
									end
									always @(*) begin
										if (_sv2v_0)
											;
										pop = !i_b[ii] & !empty;
										o_v[ii] = !empty;
										o_d[((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : ($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + (ii * ((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W)))+:((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W))] = rdata;
									end
								end
								initial _sv2v_0 = 0;
							end
							assign r_rx_fifos.clk = clk;
							assign r_rx_fifos.rst = rst;
							assign r_i_v = r_rx_fifos.o_v;
							assign r_i_d = r_rx_fifos.o_d;
							assign r_rx_fifos.i_b = r_i_b;
							localparam _bbase_26DEF_from_tx = _gv_jj_3;
							localparam _param_26DEF_VC_W = VC_W;
							localparam _param_26DEF_D_W = D_W;
							localparam _param_26DEF_A_W = A_W;
							localparam _param_26DEF_DEPTH = VC_FIFO_DEPTH;
							if (1) begin : u0_rx_fifos
								reg _sv2v_0;
								localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
								localparam VC_W = _param_26DEF_VC_W;
								localparam signed [31:0] common_pkg_DEFAULT_D_W = 32;
								localparam D_W = _param_26DEF_D_W;
								localparam signed [31:0] common_pkg_DEFAULT_N = 8;
								localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
								localparam A_W = _param_26DEF_A_W;
								localparam signed [31:0] common_pkg_DEFAULT_VC_FIFO_DEPTH = 32;
								localparam DEPTH = _param_26DEF_DEPTH;
								wire clk;
								wire rst;
								localparam _mbase_from_tx = _bbase_26DEF_from_tx;
								reg [VC_W - 1:0] o_v;
								reg [((A_W + D_W) >= 0 ? (VC_W * ((A_W + D_W) + 1)) - 1 : (VC_W * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] o_d;
								wire [VC_W - 1:0] i_b;
								genvar _gv_ii_1;
								for (_gv_ii_1 = 0; _gv_ii_1 < VC_W; _gv_ii_1 = _gv_ii_1 + 1) begin : gen_vc_logic
									localparam ii = _gv_ii_1;
									reg push;
									reg [A_W + D_W:0] wdata;
									reg pop;
									wire empty;
									wire [A_W + D_W:0] rdata;
									fifo32 #(
										.DEPTH32(DEPTH / 32),
										.WIDTH((A_W + D_W) + 1),
										.RLATENCY(0)
									) vc_fifo(
										.clk(clk),
										.rst(rst),
										.i_push(push),
										.o_full(),
										.i_wdata(wdata),
										.i_pop(pop),
										.o_empty(empty),
										.o_rdata(rdata)
									);
									always @(*) begin
										if (_sv2v_0)
											;
										push = topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].vc_target[ii];
										wdata = {topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)], topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))]};
										topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].downwards_if_below_flops[_mbase_from_tx].vc_credit_gnt[ii] = pop;
									end
									always @(*) begin
										if (_sv2v_0)
											;
										pop = !i_b[ii] & !empty;
										o_v[ii] = !empty;
										o_d[((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : ($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + (ii * ((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W)))+:((($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) >= 0 ? (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W) + 1 : 1 - (($clog2(_param_19CF4_N) + 1) + _param_19CF4_D_W))] = rdata;
									end
								end
								initial _sv2v_0 = 0;
							end
							assign u0_rx_fifos.clk = clk;
							assign u0_rx_fifos.rst = rst;
							assign u0_i_v = u0_rx_fifos.o_v;
							assign u0_i_d = u0_rx_fifos.o_d;
							assign u0_rx_fifos.i_b = u0_i_b;
							wire [VC_W - 1:0] l_o_v;
							wire [VC_W - 1:0] r_o_v;
							wire [VC_W - 1:0] u0_o_v;
							wire [A_W + D_W:0] l_o_d;
							wire [A_W + D_W:0] r_o_d;
							wire [A_W + D_W:0] u0_o_d;
							t_switch #(
								.N(N),
								.A_W(A_W),
								.D_W(D_W),
								.posl(posl),
								.posx(posx),
								.VC_W(VC_W),
								.VC_FIFO_DEPTH(VC_FIFO_DEPTH),
								.FAIR_VC_ARB(FAIR_VC_ARB)
							) t_switch_inst(
								.clk(clk),
								.rst(rst),
								.l_i(l_i_d),
								.l_i_bp(l_i_b),
								.l_i_v(l_i_v),
								.r_i(r_i_d),
								.r_i_bp(r_i_b),
								.r_i_v(r_i_v),
								.u0_i(u0_i_d),
								.u0_i_bp(u0_i_b),
								.u0_i_v(u0_i_v),
								.l_o(l_o_d),
								.l_o_credit_gnt(topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_l_tx].vc_credit_gnt),
								.l_o_v(l_o_v),
								.r_o(r_o_d),
								.r_o_credit_gnt(topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_r_tx].vc_credit_gnt),
								.r_o_v(r_o_v),
								.u0_o(u0_o_d),
								.u0_o_credit_gnt(topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].vc_credit_gnt),
								.u0_o_v(u0_o_v)
							);
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_l_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))] = l_o_d[D_W - 1:0];
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_l_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)] = l_o_d[(A_W + D_W) - 1:D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_l_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)] = l_o_d[A_W + D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_r_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))] = r_o_d[D_W - 1:0];
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_r_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)] = r_o_d[(A_W + D_W) - 1:D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_r_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)] = r_o_d[A_W + D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - ((_param_19CF4_D_W + 0) - (_param_19CF4_D_W + 0)) : (((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0) - (_param_19CF4_D_W + 0)) + ((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))) - 1)-:((_param_19CF4_D_W + 0) >= 1 ? _param_19CF4_D_W + 0 : 2 - (_param_19CF4_D_W + 0))] = u0_o_d[D_W - 1:0];
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].packet[(sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - ((sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1) - (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1))-:sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1)] = u0_o_d[(A_W + D_W) - 1:D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].packet[((_param_19CF4_D_W + 0) >= 0 ? (((_param_19CF4_D_W + 0) >= 0 ? _param_19CF4_D_W + 1 : 1 - (_param_19CF4_D_W + 0)) + (sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) - 1)) - (_param_19CF4_D_W + 0) : sv2v_cast_32_signed($clog2(_param_19CF4_N) + 1) + 0)] = u0_o_d[A_W + D_W];
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_l_tx].vc_target = l_o_v;
							assign topology_t_binary_tree_wrap.dut.gen_levels[ii - 1].downwards_if_above_flops[_mbase_r_tx].vc_target = r_o_v;
							assign topology_t_binary_tree_wrap.dut.gen_levels[_gv_ii_3].upwards_if_below_flops[_mbase_u0_tx].vc_target = u0_o_v;
						end
						assign higher_level_t_switch_inst.clk = clk;
						assign higher_level_t_switch_inst.rst = rst;
					end
				end
			end
			assign gen_levels[LEVELS - 1].downwards_if_above_flops[0].vc_target = topology_t_binary_tree_wrap.if_root.vc_target;
			assign gen_levels[LEVELS - 1].downwards_if_above_flops[0].packet = topology_t_binary_tree_wrap.if_root.packet;
			assign topology_t_binary_tree_wrap.if_root.vc_credit_gnt = gen_levels[LEVELS - 1].downwards_if_above_flops[0].vc_credit_gnt;
			assign topology_t_binary_tree_wrap.if_root.vc_target = gen_levels[LEVELS - 1].upwards_if_above_flops[0].vc_target;
			assign topology_t_binary_tree_wrap.if_root.packet = gen_levels[LEVELS - 1].upwards_if_above_flops[0].packet;
			wire [VC_W:1] sv2v_tmp_9ACEC;
			assign sv2v_tmp_9ACEC = topology_t_binary_tree_wrap.if_root.vc_credit_gnt;
			always @(*) gen_levels[LEVELS - 1].upwards_if_above_flops[0].vc_credit_gnt = sv2v_tmp_9ACEC;
			genvar _gv_ii_4;
			for (_gv_ii_4 = 0; _gv_ii_4 < N; _gv_ii_4 = _gv_ii_4 + 1) begin : gen_leaf_flops
				localparam ii = _gv_ii_4;
				localparam _bbase_AF7C6_from_tx = _gv_ii_4 + _mbase_leaf_rx;
				localparam _bbase_AF7C6_to_rx = _gv_ii_4;
				localparam _param_AF7C6_VC_W = VC_W;
				localparam _param_AF7C6_A_W = A_W;
				localparam _param_AF7C6_D_W = D_W;
				localparam _param_AF7C6_LATENCY = INTERFACE_FLOPS;
				if (1) begin : leaf_rx_pipe
					reg _sv2v_0;
					localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
					localparam signed [31:0] VC_W = _param_AF7C6_VC_W;
					localparam signed [31:0] common_pkg_DEFAULT_N = 8;
					localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
					localparam signed [31:0] A_W = _param_AF7C6_A_W;
					localparam signed [31:0] D_W = _param_AF7C6_D_W;
					localparam signed [31:0] LATENCY = _param_AF7C6_LATENCY;
					wire clk;
					wire rst;
					localparam _mbase_from_tx = _bbase_AF7C6_from_tx;
					localparam _mbase_to_rx = _bbase_AF7C6_to_rx;
					if (LATENCY == 0) begin : gen_comb_pipe
						always @(*) begin
							if (_sv2v_0)
								;
							topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_target = topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_target;
							topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].packet = topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].packet;
							topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_credit_gnt = topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_credit_gnt;
						end
					end
					else if (LATENCY == 1) begin : gen_single_ff_pipe
						always @(posedge clk)
							if (rst) begin
								topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_target <= 1'sb0;
								topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_credit_gnt <= 1'sb0;
							end
							else begin
								topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_target <= topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_target;
								topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_credit_gnt <= topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_credit_gnt;
							end
						always @(posedge clk) topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].packet <= topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].packet;
					end
					else begin : gen_multi_ff_pipe
						reg [(LATENCY * VC_W) - 1:0] vc_target_ffs;
						reg [(LATENCY * VC_W) - 1:0] vc_credit_gnt_ffs;
						reg [((A_W + D_W) >= 0 ? (LATENCY * ((A_W + D_W) + 1)) - 1 : (LATENCY * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] packet_ffs;
						always @(posedge clk)
							if (rst) begin
								vc_target_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
								vc_credit_gnt_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
							end
							else begin
								vc_target_ffs <= {vc_target_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_target};
								vc_credit_gnt_ffs <= {vc_credit_gnt_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_credit_gnt};
							end
						always @(posedge clk) packet_ffs <= {packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + (((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1)))+:((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].packet[4], topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].packet[3-:32'sd4], topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].packet[36-:32]};
						wire [_param_ECFDD_VC_W:1] sv2v_tmp_01C56;
						assign sv2v_tmp_01C56 = vc_target_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
						always @(*) topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].vc_target = sv2v_tmp_01C56;
						wire [1:1] sv2v_tmp_69A86;
						assign sv2v_tmp_69A86 = packet_ffs[((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? A_W + D_W : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (A_W + D_W))];
						always @(*) topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].packet[((_param_ECFDD_D_W + 0) >= 0 ? (((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1)) - (_param_ECFDD_D_W + 0) : sv2v_cast_32_signed(_param_ECFDD_A_W) + 0)] = sv2v_tmp_69A86;
						wire [sv2v_cast_32_signed(_param_ECFDD_A_W) * 1:1] sv2v_tmp_5A04A;
						assign sv2v_tmp_5A04A = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
						always @(*) topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].packet[(sv2v_cast_32_signed(_param_ECFDD_A_W) - 1) - ((sv2v_cast_32_signed(_param_ECFDD_A_W) - 1) - (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1))-:sv2v_cast_32_signed(_param_ECFDD_A_W)] = sv2v_tmp_5A04A;
						wire [((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0)) * 1:1] sv2v_tmp_FE7CB;
						assign sv2v_tmp_FE7CB = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1))) + D_W) - 1)-:D_W];
						always @(*) topology_t_binary_tree_wrap.dut.leaf_rx_above_flops[_mbase_to_rx].packet[((_param_ECFDD_D_W + 0) >= 0 ? (((_param_ECFDD_D_W + 0) >= 0 ? _param_ECFDD_D_W + 1 : 1 - (_param_ECFDD_D_W + 0)) + (sv2v_cast_32_signed(_param_ECFDD_A_W) - 1)) - ((_param_ECFDD_D_W + 0) - (_param_ECFDD_D_W + 0)) : (((sv2v_cast_32_signed(_param_ECFDD_A_W) + 0) - (_param_ECFDD_D_W + 0)) + ((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0))) - 1)-:((_param_ECFDD_D_W + 0) >= 1 ? _param_ECFDD_D_W + 0 : 2 - (_param_ECFDD_D_W + 0))] = sv2v_tmp_FE7CB;
						wire [2:1] sv2v_tmp_3E754;
						assign sv2v_tmp_3E754 = vc_credit_gnt_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
						always @(*) topology_t_binary_tree_wrap.if_leaf[_mbase_from_tx].vc_credit_gnt = sv2v_tmp_3E754;
					end
					initial _sv2v_0 = 0;
				end
				assign leaf_rx_pipe.clk = clk;
				assign leaf_rx_pipe.rst = rst;
				localparam _bbase_D72C0_from_tx = _gv_ii_4;
				localparam _bbase_D72C0_to_rx = _gv_ii_4 + _mbase_leaf_tx;
				localparam _param_D72C0_VC_W = VC_W;
				localparam _param_D72C0_A_W = A_W;
				localparam _param_D72C0_D_W = D_W;
				localparam _param_D72C0_LATENCY = INTERFACE_FLOPS;
				if (1) begin : leaf_tx_pipe
					reg _sv2v_0;
					localparam signed [31:0] common_pkg_DEFAULT_VC_W = 2;
					localparam signed [31:0] VC_W = _param_D72C0_VC_W;
					localparam signed [31:0] common_pkg_DEFAULT_N = 8;
					localparam signed [31:0] common_pkg_DEFAULT_A_W = 4;
					localparam signed [31:0] A_W = _param_D72C0_A_W;
					localparam signed [31:0] D_W = _param_D72C0_D_W;
					localparam signed [31:0] LATENCY = _param_D72C0_LATENCY;
					wire clk;
					wire rst;
					localparam _mbase_from_tx = _bbase_D72C0_from_tx;
					localparam _mbase_to_rx = _bbase_D72C0_to_rx;
					if (LATENCY == 0) begin : gen_comb_pipe
						always @(*) begin
							if (_sv2v_0)
								;
							topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_target = topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_target;
							topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].packet = topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].packet;
							topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_credit_gnt = topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_credit_gnt;
						end
					end
					else if (LATENCY == 1) begin : gen_single_ff_pipe
						always @(posedge clk)
							if (rst) begin
								topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_target <= 1'sb0;
								topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_credit_gnt <= 1'sb0;
							end
							else begin
								topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_target <= topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_target;
								topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_credit_gnt <= topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_credit_gnt;
							end
						always @(posedge clk) topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].packet <= topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].packet;
					end
					else begin : gen_multi_ff_pipe
						reg [(LATENCY * VC_W) - 1:0] vc_target_ffs;
						reg [(LATENCY * VC_W) - 1:0] vc_credit_gnt_ffs;
						reg [((A_W + D_W) >= 0 ? (LATENCY * ((A_W + D_W) + 1)) - 1 : (LATENCY * (1 - (A_W + D_W))) + ((A_W + D_W) - 1)):((A_W + D_W) >= 0 ? 0 : (A_W + D_W) + 0)] packet_ffs;
						always @(posedge clk)
							if (rst) begin
								vc_target_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
								vc_credit_gnt_ffs[_param_19CF4_VC_W * ((LATENCY - 1) - (LATENCY - 1))+:_param_19CF4_VC_W * LATENCY] <= 1'sb0;
							end
							else begin
								vc_target_ffs <= {vc_target_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_target};
								vc_credit_gnt_ffs <= {vc_credit_gnt_ffs[_param_19CF4_VC_W * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1))+:_param_19CF4_VC_W * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_credit_gnt};
							end
						always @(posedge clk) packet_ffs <= {packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? 0 : sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + (((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * (((LATENCY - 2) >= 0 ? LATENCY - 2 : ((LATENCY - 2) + ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)) - 1) - (((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY) - 1)))+:((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W)) * ((LATENCY - 2) >= 0 ? LATENCY - 1 : 3 - LATENCY)], topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].packet[((_param_442DB_D_W + 0) >= 0 ? (((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + (sv2v_cast_32_signed(_param_442DB_A_W) - 1)) - (_param_442DB_D_W + 0) : sv2v_cast_32_signed(_param_442DB_A_W) + 0)], topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].packet[(sv2v_cast_32_signed(_param_442DB_A_W) - 1) - ((sv2v_cast_32_signed(_param_442DB_A_W) - 1) - (sv2v_cast_32_signed(_param_442DB_A_W) - 1))-:sv2v_cast_32_signed(_param_442DB_A_W)], topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].packet[((_param_442DB_D_W + 0) >= 0 ? (((_param_442DB_D_W + 0) >= 0 ? _param_442DB_D_W + 1 : 1 - (_param_442DB_D_W + 0)) + (sv2v_cast_32_signed(_param_442DB_A_W) - 1)) - ((_param_442DB_D_W + 0) - (_param_442DB_D_W + 0)) : (((sv2v_cast_32_signed(_param_442DB_A_W) + 0) - (_param_442DB_D_W + 0)) + ((_param_442DB_D_W + 0) >= 1 ? _param_442DB_D_W + 0 : 2 - (_param_442DB_D_W + 0))) - 1)-:((_param_442DB_D_W + 0) >= 1 ? _param_442DB_D_W + 0 : 2 - (_param_442DB_D_W + 0))]};
						wire [2:1] sv2v_tmp_179C1;
						assign sv2v_tmp_179C1 = vc_target_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
						always @(*) topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].vc_target = sv2v_tmp_179C1;
						wire [1:1] sv2v_tmp_805D8;
						assign sv2v_tmp_805D8 = packet_ffs[((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? A_W + D_W : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (A_W + D_W))];
						always @(*) topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].packet[4] = sv2v_tmp_805D8;
						wire [4:1] sv2v_tmp_C2611;
						assign sv2v_tmp_C2611 = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
						always @(*) topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].packet[3-:32'sd4] = sv2v_tmp_C2611;
						wire [32:1] sv2v_tmp_468A7;
						assign sv2v_tmp_468A7 = packet_ffs[((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? ((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1)) : ((((LATENCY - 1) * ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) + 1 : 1 - (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W))) + ((sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) >= 0 ? D_W - 1 : (sv2v_cast_32_signed($clog2(N) + 1) + _param_19CF4_D_W) - (D_W - 1))) + D_W) - 1)-:D_W];
						always @(*) topology_t_binary_tree_wrap.if_leaf[_mbase_to_rx].packet[36-:32] = sv2v_tmp_468A7;
						wire [_param_442DB_VC_W:1] sv2v_tmp_500C5;
						assign sv2v_tmp_500C5 = vc_credit_gnt_ffs[(LATENCY - 1) * _param_19CF4_VC_W+:_param_19CF4_VC_W];
						always @(*) topology_t_binary_tree_wrap.dut.leaf_tx_above_flops[_mbase_from_tx].vc_credit_gnt = sv2v_tmp_500C5;
					end
					initial _sv2v_0 = 0;
				end
				assign leaf_tx_pipe.clk = clk;
				assign leaf_tx_pipe.rst = rst;
			end
		end
	endgenerate
	assign dut.clk = clk;
	assign dut.rst = rst;
endmodule
module t_route (
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
	genvar _gv_ii_5;
	generate
		for (_gv_ii_5 = 0; _gv_ii_5 < VC_W; _gv_ii_5 = _gv_ii_5 + 1) begin : gen_vc_addr_dec
			localparam ii = _gv_ii_5;
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
			genvar _gv_ii_6;
			for (_gv_ii_6 = 0; _gv_ii_6 < VC_W; _gv_ii_6 = _gv_ii_6 + 1) begin : gen_vc_grant
				localparam ii = _gv_ii_6;
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
			genvar _gv_ii_7;
			for (_gv_ii_7 = 1; _gv_ii_7 < VC_W; _gv_ii_7 = _gv_ii_7 + 1) begin : gen_vc_grant
				localparam ii = _gv_ii_7;
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
	genvar _gv_ii_8;
	generate
		for (_gv_ii_8 = 0; _gv_ii_8 < VC_W; _gv_ii_8 = _gv_ii_8 + 1) begin : gen_vc_bp
			localparam ii = _gv_ii_8;
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
module t_switch (
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
	genvar _gv_ii_9;
	generate
		for (_gv_ii_9 = 0; _gv_ii_9 < VC_W; _gv_ii_9 = _gv_ii_9 + 1) begin : gen_addr_breakout
			localparam ii = _gv_ii_9;
			assign l_i_addr[ii * A_W+:A_W] = l_i[((A_W + D_W) >= 0 ? (ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : (((ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
			assign r_i_addr[ii * A_W+:A_W] = r_i[((A_W + D_W) >= 0 ? (ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : (((ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
			assign u0_i_addr[ii * A_W+:A_W] = u0_i[((A_W + D_W) >= 0 ? (ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)) : (((ii * ((A_W + D_W) >= 0 ? (A_W + D_W) + 1 : 1 - (A_W + D_W))) + ((A_W + D_W) >= 0 ? (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1) : (A_W + D_W) - (((A_W + D_W) - 1) >= D_W ? (A_W + D_W) - 1 : (((A_W + D_W) - 1) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1))) + (((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)) - 1)-:(((A_W + D_W) - 1) >= D_W ? (((A_W + D_W) - 1) - D_W) + 1 : (D_W - ((A_W + D_W) - 1)) + 1)];
		end
	endgenerate
	t_route #(
		.N(N),
		.A_W(A_W),
		.posx(posx),
		.posl(posl),
		.VC_W(VC_W),
		.VC_FIFO_DEPTH(VC_FIFO_DEPTH),
		.FAIR_VC_ARB(FAIR_VC_ARB)
	) t_route_inst(
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
