module processing_unit #(
	parameter I,
	parameter J
	) (
	input wire clk,
	input wire reset, 
	input wire start,
	input wire [31:0] a,
	input wire [31:0] b,
	input wire signed [31:0] match_score,
	input wire signed [31:0] mismatch_penalty,
	input wire signed [31:0] gap_penalty,
	input wire signed [31:0] prev_diagonal,
	input wire signed [31:0] prev_horizontal,
	input wire signed [31:0] prev_vertical,
	output reg signed [31:0] next,
	output reg done
);

	reg signed [31:0] score_vertical;
	reg signed [31:0] score_horizontal;
	reg signed [31:0] score_diagonal;
	reg signed [31:0] match;
	
	always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			next <= 0;
		end
		else if (start) begin
			match = (a == b) ? match_score : mismatch_penalty;
			score_vertical = prev_vertical + gap_penalty;
			score_horizontal = prev_horizontal + gap_penalty;
			score_diagonal = prev_diagonal + match;
		
			if (score_diagonal >= score_vertical && score_diagonal >= score_horizontal) begin
				next <= score_diagonal;
			end
			else if (score_vertical >= score_horizontal) begin
				next <= score_vertical;
			end 
			else begin
				next <= score_horizontal;
			end
			
			done <= 1'b1;
		end
	end
	

endmodule