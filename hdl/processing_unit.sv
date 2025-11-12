module processing_unit #(
	parameter N,
	parameter M,
	parameter J
	) (
	input wire clk,
	input wire reset, 
	input wire start,
	input wire signed [31:0] left,
	input wire signed [31:0] prev_diagonal,
	output reg signed [31:0] right,
	output reg signed [31:0] next_diagonal,
	output reg done,
	output reg finish
);

	reg signed [31:0] match_score;
	reg signed [31:0] mismatch_penalty;
	reg signed [31:0] gap_penalty;
	wire signed [31:0] match_value;
	reg [31:0] row;
	
	localparam FILE = "";
	reg signed [31:0] tmp [0:(5+M+N)];
	
	wire [31:0] a = tmp[4+row];
	wire [31:0] b = tmp[4+N+J];
	
	reg signed [31:0] buffer [0:1];
	
	initial begin
		$readmemb(FILE, tmp);
		match_score = tmp[0];
		mismatch_penalty = tmp[1];
		gap_penalty = tmp[2];
		row = 0;
		buffer[0] = 0;
		buffer[1] = 0;
		done <= 0;
		finish <= 0;
	end
	
	assign match_value = (a == b) ? match_score : mismatch_penalty;
	
	wire signed [31:0] score_diagonal = prev_diagonal + match_value;
	wire signed [31:0] score_up   = buffer[0] + gap_penalty;
	wire signed [31:0] score_left = left + gap_penalty;

	wire signed [31:0] next_score = (score_diagonal >= score_up && score_diagonal >= score_left) ? score_diagonal :
		(score_up >= score_left) ? score_up : score_left;

	always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			finish <= 0;
			buffer[0] <= 0;
			buffer[1] <= 0;
		end
		else if (start && !finish) begin
			buffer[1] <= buffer[0];
			buffer[0] <= next_score;
			right <= next_score;
			next_diagonal <= buffer[0];
			done <= 1'b1;
			row <= row + 1;

			if (row > N ) begin
				finish <= 1'b1;
			end
		end
		else begin
			done <= 1'b0;
		end
	end
	

endmodule