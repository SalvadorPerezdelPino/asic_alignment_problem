module processing_unit #(
	parameter I,
	parameter J,
	parameter N,
	parameter M
	) (
	input wire clk,
	input wire reset, 
	input wire start,
	input wire signed [31:0] prev_diagonal,
	input wire signed [31:0] prev_horizontal,
	input wire signed [31:0] prev_vertical,
	output reg signed [31:0] next,
	output reg done
);

	reg signed [31:0] match_score;
	reg signed [31:0] mismatch_penalty;
	reg signed [31:0] gap_penalty;
	reg signed [31:0] score_vertical;
	reg signed [31:0] score_horizontal;
	reg signed [31:0] score_diagonal;
	reg signed [31:0] match;
	
	
	localparam FILE = "C:/Users/Usuario/Documents/clase/inf/TFG/Automation/data/monocycle/experiments/alignment/single/sequence_1_size29_sequence_2_size29_20251110-121713/instance_1/input_1.mem";
	
	
	reg signed [31:0] tmp [0:(5+M+N)];
	
	wire [31:0] a = tmp[4+I];
	wire [31:0] b = tmp[4+N+J];
	
	initial begin
		$readmemb(FILE, tmp);
		match_score = tmp[0];
		mismatch_penalty = tmp[1];
		gap_penalty = tmp[2];
	end
	
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