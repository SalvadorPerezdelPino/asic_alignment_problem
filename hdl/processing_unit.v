module processing_unit #(
	parameter N,
	parameter M,
	parameter I,
	parameter J,
	parameter FILE
	) (
	input wire clk,
	input wire reset, 
	input wire start,
	input wire [0:N+M] prev_diagonal,
	input wire [0:N+M] prev_horizontal,
	input wire [0:N+M] prev_vertical,
	output reg [0:N+M] next_diagonal,
	output reg [0:N+M] next_horizontal,
	output reg [0:N+M] next_vertical,
	output reg done
);

	localparam MATCH = 1'b1;
	localparam MISMATCH = 1'b0;
	localparam GAP_PENALTY = 1'b0;
	
	reg [0:N] string_1;
	reg [0:M] string_2;
	
	reg a;
	reg b;
	
	reg score_vertical;
	reg score_horizontal;
	reg score_diagonal;
	reg match;
	
	initial begin
		readmemb(FILE, string_1, 0, 0);
		readmemb(FILE, string_2, 1, 1);
		a = string_1[I];
		b = string_2[J]; // RETOCAR LA CODIFICACIÓN
	end
	
	always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			next_vertical <= 0;
			next_horizontal <= 0;
			next_diagonal <= 0;
		end
		else if (start) begin
			match = (a == b) ? MATCH : MISMATCH;
			score_vertical = prev_vertical + GAP_PENALTY;
			score_horizontal = prev_horizontal + GAP_PENALTY;
			score_diagonal = prev_diagonal + match;
		
			if (score_diagonal >= score_vertical && score_diagonal >= score_horizontal) begin
				next_diagonal <= score_diagonal;
			end
			else if (score_vertical >= score_horizontal) begin
				next_diagonal <= score_vertical;
			end 
			else begin
				next_diagonal <= score_horizontal;
			end
			
			done <= 1'b1;
			
		end
	end
	

endmodule