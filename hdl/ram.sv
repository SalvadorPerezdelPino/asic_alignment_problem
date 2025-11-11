module ram # (
	parameter ADDR_WIDTH = 12,
	parameter DATA_WIDTH = 32,
	parameter DEPTH = 64
	) ( 	
	input wire clk,
	input wire [ADDR_WIDTH-1:0] addr,
	input wire[DATA_WIDTH-1:0] data_in,
	input wire we,
	output reg [DATA_WIDTH-1:0] data_out
);

	reg [DATA_WIDTH-1:0] mem [DEPTH];

	always @ (posedge clk) begin
		if (we) begin
			mem[addr] <= data_in;
		end
		data_out <= mem[addr];
	end

endmodule
