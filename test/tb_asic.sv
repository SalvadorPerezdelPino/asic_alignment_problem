module tb_asic();
	
	reg clk, start, reset, done;
	
	wire [31:0] solution;
	generator dut (
		.clk (clk),
		.start (start),
		.reset (reset),
		.finish (done),
		.solution (solution)
	);
	
	initial begin
		start = 0;
		reset = 1;
		#10
		start = 1;
		reset = 0;
	end
	
	initial clk = 0;
	
	always #20 clk = ~clk;
	
	integer cycles;
	initial begin
		cycles = 0;
		
		while (done !== 1) begin
			@(posedge clk);
			cycles = cycles + 1;
		end

		
		$display("Cycles: %d", cycles);
		$display("Solucion: %d", solution);
		$stop();
	end

endmodule