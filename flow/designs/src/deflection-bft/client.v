`include "commands.h"

module client #(
	parameter N 	= 2,		// total number of clients
	parameter D_W	= 32,		// data width
	parameter A_W	= $clog2(N)+1,	// address width
	parameter WRAP  = 1,            // wrapping means throttling of reinjection
	parameter PAT   = `RANDOM,      // default RANDOM pattern
	parameter RATE  = 10,           // rate of injection (in percent) 
	parameter LIMIT = 16,           // when to stop injectin packets
	parameter SIGMA = 4,            // radius for LOCAL traffic
	parameter posx 	= 2		// position
) (
	input  wire clk,		// clock
	input  wire rst,		// reset
	input  wire ce,			// clock enable
	input  wire `Cmd cmd,		// client test command	
	input  wire [A_W+D_W+1:0] o,	// output message from router
	output reg  [A_W+D_W+1:0] i,	// input message from client, registered, validated by i`v
	output wire done		// done
);

	reg done_sig;
	reg next_v;
	reg [A_W-2:0] next;
	reg [D_W-1:0] next_d;
	reg [A_W+D_W+1:0] saved0, saved1;  	// save deflected msg for reinject
	integer seed=posx;
	reg [31:0] r;

	always @(posedge clk) begin: inject
		reg [D_W-1:0] tmp;
		if (rst) begin
			i			<= 0;
			r 			<= 0;
		end else begin 
			i			<= 0;
			r 			<= r+1;
			//$display("Time%0d, PE=%0d, r=%0d, RATE=%0d",now, posx, {r}, RATE);
			if(o[A_W+D_W+1] & !o[A_W+D_W]) begin
				$display("Time%0d: Received packet at PE(%0d) with data=%0d",now,posx,o[D_W-1:0]);
			end
			
			if(({r} < RATE)) begin 
				i[A_W+D_W+1]		<= next_v;
				i[A_W+D_W]		<= 0; // does not start deflected...
				i[A_W+D_W-1:D_W]	<= {1'd0,next};
				if(next_v==1) begin
					tmp		= ((posx)*LIMIT+o[D_W-1]); // send packetid instead
					i[D_W-1:0]	<= tmp;
					$display("Time%0d: Sent packet from PE(%0d) to PE(%0d) with packetid=%0d, data=%0d saved0=%0d, saved1=%0d",now,posx,next,((posx)*LIMIT+sent),tmp,saved0[A_W+D_W+1],saved1[A_W+D_W+1]);
				end
			end

		end
	end

	always @(*) begin
		next_v = 0;
		next = 0;
		if (cmd != `Cmd_IDLE) begin				
			next_v = 1;
			next=o;
		end 

	end

	integer now=0;
	always @(posedge clk) begin
		now     <= now + 1;
		if(now==0 && posx==0) begin
			$display("RATE=%0d , N=%0d",RATE,N);
		end
		if(~o[A_W+D_W+1] & ~saved0[A_W+D_W+1] & ~saved1[A_W+D_W+1] & ~i[A_W+D_W+1]) begin
			done_sig <= 1;
		end else begin
			done_sig <= 0;
		end
	end
	
	assign done = done_sig;

	// avoid self-packets for now
	function integer get_safe_rnd(input integer tmp);
		get_safe_rnd=(tmp==posx)?((tmp+1)%N):tmp%N;
	endfunction

	function integer local_rnd(input integer i);
		local_rnd = i + {$random} % SIGMA - SIGMA/2;
	endfunction

	// avoiding SystemVerilog for
	// iverilog compatibility
	function integer local_window(input integer r, input integer max);
		local_window = (r < 0)? 0 : (r >= max) ? (max-1) : r;
	endfunction

	function [9:0] bitrev(input [9:0] i);
		bitrev = {i[0],i[1],i[2],i[3],i[4],i[5],i[6],i[7],i[8],i[9]};
	endfunction

	function integer tornado(input integer i, input integer max);
		tornado = (i + max/2-1) % max;
	endfunction


endmodule

