
module system (
	clk_clk,
	led_external_connection_export,
	mlp_result_digit_result_digit,
	mlp_result_valid_result_valid,
	reset_reset_n);	

	input		clk_clk;
	output	[9:0]	led_external_connection_export;
	output	[3:0]	mlp_result_digit_result_digit;
	output		mlp_result_valid_result_valid;
	input		reset_reset_n;
endmodule
