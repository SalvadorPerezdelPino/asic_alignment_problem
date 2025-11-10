module DE10 (
	input CLOCK_50,
	input [3:0] KEY,
	output [9:0] LEDR
);

	wire [31:0] solution;
	assign LEDR = solution;
	generator gen (
		.clk (CLOCK_50),
		.start (KEY[0]),
		.reset (KEY[3]),
		.finish (),
		.solution (solution)
	);
	
endmodule