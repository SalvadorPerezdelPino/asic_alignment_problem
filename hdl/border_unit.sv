module border_unit (
	input wire clk,
	input wire reset,
	output reg signed [31:0] next,
	output reg done
);
	
	always @(posedge clk) begin
		if (reset) begin
			next <= 0;
			done <= 1'b0;
		end
		else begin
			next <= 0;
			done <= 1'b1;
		end
	
	end

endmodule
