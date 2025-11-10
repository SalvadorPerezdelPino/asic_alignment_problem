module generator (
	input wire clk,
	input wire start,
	input wire reset,
	output wire finish,
	output wire [31:0] solution
);


	localparam N = 5;
	localparam M = 5;
	localparam MATCH = 1;
	localparam MISMATCH = 0;
	localparam GAP = 0;
	
	reg [31:0] mem [0:(5+M+N)-1];
	
	wire [31:0] values [0:N][0:M];
	wire done [0:N][0:M];

	localparam FILE = "";
	
	initial begin
		$readmemb(FILE, mem);
	end
	
	assign solution = values[N][M];
	assign finish = done[N][M];
	
	genvar i, j;
	
	generate
		for (i = 0; i <= N; i = i + 1) begin : init_col
			border_unit bu (
				.clk (clk),
				.reset (reset),
				.next (values[i][0]),
				.done (done[i][0])
			);
		end
	endgenerate
	
	generate
		for (j = 1; j <= M; j = j + 1) begin : init_row
			border_unit bu (
				.clk (clk),
				.reset (reset),
				.next (values[0][j]),
				.done (done[0][j])
			);
		end
	endgenerate
	
	generate
		for (i = 1; i <= N; i = i + 1) begin : generate_rows
			for (j = 1; j <= M; j = j + 1) begin : generate_cols
			
				processing_unit #(
					.I(i),
					.J(j)
					) pu (
					.clk (clk),
					.reset (reset), 
					.start (done[i][j-1] & done[i-1][j-1] & done[i-1][j]),
					.match_score(MATCH),
					.mismatch_penalty(MISMATCH),
					.gap_penalty(GAP),
					.a (mem[4+i]),
					.b	(mem[4+N+j]),
					.prev_diagonal (values[i-1][j-1]),
					.prev_horizontal (values[i][j-1]),
					.prev_vertical (values[i-1][j]),
					.next (values[i][j]),
					.done (done[i][j])
				);
				
				
			end
		end
	endgenerate


endmodule