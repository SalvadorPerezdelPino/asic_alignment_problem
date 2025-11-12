module generator (
	input wire clk,
	input wire start,
	input wire reset,
	output wire finish,
	output wire [31:0] solution
);


	localparam N = 100;
	localparam M = 200;
	
	wire [31:0] horizontal_scores [0:M];
	wire [31:0] diagonal_scores [0:M];
	wire done [0:M];
	wire finishes [0:M-1];
	
	assign solution = horizontal_scores[M];
	assign finish = finishes[M-1];
	
	genvar j;
	
	assign done[0] = start;
	assign horizontal_scores[0] = 0;
	assign diagonal_scores[0] = 0;
	
	generate
		for (j = 0; j < M; j = j + 1) begin : generate_cols
			processing_unit #(
				.N(N),
				.M(M),
				.J(j)
				) pu (
				.clk (clk),
				.reset (reset), 
				.start (done[j]),
				.prev_diagonal (diagonal_scores[j]),
				.left (horizontal_scores[j]),
				.right (horizontal_scores[j+1]),
				.next_diagonal (diagonal_scores[j+1]),
				.done (done[j+1]),
				.finish (finishes[j])
			);
		end
	endgenerate


endmodule