module performence_counter(
	input clk,
	input i_cache_stb,
	input d_cache_stb,
	input L2_cache_stb,
	input opcode,
	//input branch prediction output?
	input if_ready,
	input id_ready,
	input ex_ready,
	input mem_ready,
	input wb_ready,
	
	output i_stall_count,
	output d_stall_count,
	output L2_stall_count
	output branch_count,
	output misprediction_count,
	output stall_count
);

initial begin
	i_stall_count = 0;
	d_stall_count = 0;
	L2_stall_count = 0;
	branch_count = 0;
	misprediction_count = 0;
	stall_count = 0;
end

logic [2:0] internal_count;