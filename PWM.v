module main(
	input i_Clk, i_Switch_1, i_Switch_2, i_Switch_3, i_Switch_4,
	output o_LED_1, o_LED_2, o_LED_3, o_LED_4, io_PMOD_4, io_PMOD_1
);
	reg [31:0] ctr = 32'b0;
	reg [5:0] blocker = 6'b0;
	reg [4:0] slower = 5'b0;
	reg [1:0] debouncerA = 1'b00;
	reg [1:0] debouncerB = 1'b00;
	
	always @(posedge i_Clk) begin
		ctr = ctr+1;
	end
	
	always @(posedge ctr[3]) begin
		if(i_Switch_1||i_Switch_2) begin
			debouncerA = (debouncerA==2'b11)?(2'b11):(debouncerA+1'b1);
		end else begin
			debouncerA = 0;
		end
		if(debouncerA == 2'b10) begin
			blocker = blocker+i_Switch_1-i_Switch_2;
		end

		if(i_Switch_3||i_Switch_4) begin
			debouncerB = (debouncerB==2'b11)?(2'b11):(debouncerB+1'b1);
		end else begin
			debouncerB = 0;
		end
		if(debouncerB == 2'b10) begin
			slower = slower+i_Switch_4-i_Switch_3;
		end
	end
	
	
	assign {o_LED_1, o_LED_2, o_LED_3, o_LED_4} = ((ctr>>slower)&24'b000000000000000000001111);
	assign io_PMOD_4 = ((ctr>>slower)&24'b000000000000000000111111)<blocker[5:0];
endmodule