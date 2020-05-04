//taken from https://stackoverflow.com/questions/14497877/how-to-implement-a-pseudo-hardware-random-number-generator
module random20BitNumber(clock, resetn, data);
	input clock;
	input resetn;
	output reg [19:0] data;
	
	reg[19:0]data_next;
	
	always@(*)
		begin		
			data_next[19] = data[19]^data[1];
			data_next[18] = data[18]^data[0];
			data_next[17] = data[17]^data_next[19];
			data_next[16] = data[16]^data_next[18];
			data_next[15] = data[15]^data_next[17];
			data_next[14] = data[14]^data[16];
			data_next[13] = data[13]^data_next[15];
			data_next[12] = data[12]^data_next[14];
			data_next[11] = data[11]^data_next[13];
			data_next[10] = data[10]^data_next[12];
			data_next[9] = data[9]^data[11];
			data_next[8] = data[8]^data_next[10];
			data_next[7] = data[7]^data_next[9];
			data_next[6] = data[6]^data_next[8];
			data_next[5] = data[5]^data[7];
			data_next[4] = data[4]^data_next[6];
			data_next[3] = data[3]^data_next[5];
			data_next[2] = data[2]^data_next[4];
			data_next[1] = data[1]^data_next[3];
			data_next[0] = data[0]^data_next[2];
		end
		
	always@(posedge clock or negedge resetn)
		begin
			if(!resetn)
				data <= 20'h1f;
			else
				data <= data_next;
		end
endmodule

module sequenceConverter(inSequence, outSequence);
	input [19:0]inSequence;
	output reg [39:0]outSequence;
	
	always@(*)
		begin
		//first
			if(inSequence[1:0] == 2'd0)
				outSequence[3:0] = 4'b0001;
			else if(inSequence[1:0] == 2'd1)
				outSequence[3:0] = 4'b0010;
			else if(inSequence[1:0] == 2'd2)
				outSequence[3:0] = 4'b0100;
			else if(inSequence[1:0] == 2'd3)
				outSequence[3:0] = 4'b1000;
		//second
			if(inSequence[3:2] == 2'd0)
				outSequence[7:4] = 4'b0001;
			else if(inSequence[3:2] == 2'd1)
				outSequence[7:4] = 4'b0010;
			else if(inSequence[3:2] == 2'd2)
				outSequence[7:4] = 4'b0100;
			else if(inSequence[3:2] == 2'd3)
				outSequence[7:4] = 4'b1000;
		//third
			if(inSequence[5:4] == 2'd0)
				outSequence[11:8] = 4'b0001;
			else if(inSequence[5:4] == 2'd1)
				outSequence[11:8] = 4'b0010;
			else if(inSequence[5:4] == 2'd2)
				outSequence[11:8] = 4'b0100;
			else if(inSequence[5:4] == 2'd3)
				outSequence[11:8] = 4'b1000;
		//fourth
			if(inSequence[7:6] == 2'd0)
				outSequence[15:12] = 4'b0001;
			else if(inSequence[7:6] == 2'd1)
				outSequence[15:12] = 4'b0010;
			else if(inSequence[7:6] == 2'd2)
				outSequence[15:12] = 4'b0100;
			else if(inSequence[7:6] == 2'd3)
				outSequence[15:12] = 4'b1000;
		//fifth
			if(inSequence[9:8] == 2'd0)
				outSequence[19:16] = 4'b0001;
			else if(inSequence[9:8] == 2'd1)
				outSequence[19:16] = 4'b0010;
			else if(inSequence[9:8] == 2'd2)
				outSequence[19:16] = 4'b0100;
			else if(inSequence[9:8] == 2'd3)
				outSequence[19:16] = 4'b1000;
		//sixth
			if(inSequence[11:10] == 2'd0)
				outSequence[23:20] = 4'b0001;
			else if(inSequence[11:10] == 2'd1)
				outSequence[23:20] = 4'b0010;
			else if(inSequence[11:10] == 2'd2)
				outSequence[23:20] = 4'b0100;
			else if(inSequence[11:10] == 2'd3)
				outSequence[23:20] = 4'b1000;
		//seventh
			if(inSequence[13:12] == 2'd0)
				outSequence[27:24] = 4'b0001;
			else if(inSequence[13:12] == 2'd1)
				outSequence[27:24] = 4'b0010;
			else if(inSequence[13:12] == 2'd2)
				outSequence[27:24] = 4'b0100;
			else if(inSequence[13:12] == 2'd3)
				outSequence[27:24] = 4'b1000;
		//eigth
			if(inSequence[15:14] == 2'd0)
				outSequence[31:28] = 4'b0001;
			else if(inSequence[15:14] == 2'd1)
				outSequence[31:28] = 4'b0010;
			else if(inSequence[15:14] == 2'd2)
				outSequence[31:28] = 4'b0100;
			else if(inSequence[15:14] == 2'd3)
				outSequence[31:28] = 4'b1000;
		//ninth
			if(inSequence[17:16] == 2'd0)
				outSequence[35:32] = 4'b0001;
			else if(inSequence[17:16] == 2'd1)
				outSequence[35:32] = 4'b0010;
			else if(inSequence[17:16] == 2'd2)
				outSequence[35:32] = 4'b0100;
			else if(inSequence[17:16] == 2'd3)
				outSequence[35:32] = 4'b1000;
		//tenth
			if(inSequence[19:18] == 2'd0)
				outSequence[39:36] = 4'b0001;
			else if(inSequence[19:18] == 2'd1)
				outSequence[39:36] = 4'b0010;
			else if(inSequence[19:18] == 2'd2)
				outSequence[39:36] = 4'b0100;
			else if(inSequence[19:18] == 2'd3)
				outSequence[39:36] = 4'b1000;
		end
	 
endmodule	



module rateDivider(enable, CLOCK_50);
	output enable;
	input CLOCK_50;
	reg [25:0] q;
	
	always @(posedge CLOCK_50) 
	begin
		if (q == 26'd833333) 
			q <= 0;
		else
			q <= q + 1; 
	end
	assign enable = (q == 26'b0)?1:0;

endmodule

module count64(enable, CLOCK_50);
	output enable;
	input CLOCK_50;
	reg [5:0] q;
	
	always @(posedge CLOCK_50) 
	begin
		if (q == 6'd63) 
			q <= 0;
		else
			q <= q + 1; 
	end
	assign enable = (q == 6'b0)?1:0;

endmodule

module count19200(enable, CLOCK_50);
	output enable;
	input CLOCK_50;
	reg [14:0] q;
	
	always @(posedge CLOCK_50) 
	begin
		if (q == 15'd19) 
			q <= 0;
		else
			q <= q + 1; 
	end
	assign enable = (q == 15'b0)?1:0;

endmodule

module rate05hzDivider(enable, CLOCK_50);
	output enable;
	input CLOCK_50;
	reg [26:0] q;
	
	always @(posedge CLOCK_50) 
	begin
		if (q == 2*50000000-1) 
			q <= 0;
		else
			q <= q + 1; 
	end
	assign enable = (q == 27'b0)?1:0;

endmodule

module frameCounter(enable, CLOCK_50);
	output enable;
	input CLOCK_50;
	reg [3:0] q;
	
	always @(posedge CLOCK_50) 
	begin
		if (q == 4'b1111) 
			q <= 0;
		else
			q <= q + 1; 
	end
	assign enable = (q == 0)?1:0;

endmodule

module rate1hzDivider(enable, CLOCK_50);
	output enable;
	input CLOCK_50;
	reg [25:0] q;
	
	always @(posedge CLOCK_50) 
	begin
		if (q == 50000000-1) 
			q <= 0;
		else
			q <= q + 1; 
	end
	assign enable = (q == 26'b0)?1:0;

endmodule

module hexconverter(in, out);
	input [3:0]in;
	output [6:0]out;
	
	reg [6:0]out;
	always @(*)
	
	begin
		case(in[3:0])
		4'b0000: out = 7'b1000000;
		4'b0001: out = 7'b1111001;
		4'b0010: out = 7'b0100100;
		4'b0011: out = 7'b0110000;
		4'b0100: out = 7'b0011001;
		4'b0101: out = 7'b0010010;
		4'b0110: out = 7'b0000010;
		4'b0111: out = 7'b1111000;
		4'b1000: out = 7'b0000000;
		4'b1001: out = 7'b0010000;
		4'b1010: out = 7'b0001000;
		4'b1011: out = 7'b0000011;
		4'b1100: out = 7'b1000110;
		4'b1101: out = 7'b0100001;
		4'b1110: out = 7'b0000110;
		4'b1111: out = 7'b0001110;
		default: out = 7'b0000000;
		endcase
	end
	
endmodule


module cursorQuarterEncoder(cursorX, cursorY, CLOCK_50, quarterSelected);
	input [7:0]cursorX;
	input [6:0]cursorY;
	input CLOCK_50;
	output reg [3:0]quarterSelected;
	
	always@(*)
		begin
			if(cursorX < 8'd80 && cursorY < 7'd60)
				begin
					quarterSelected = 4'b0001;
				end
			else if(cursorX > 8'd80 && cursorY < 7'd60)
				begin
					quarterSelected = 4'b0010;
				end
			else if(cursorX < 8'd80 && cursorY > 7'd60)
				begin
					quarterSelected = 4'b0100;
				end
			else if(cursorX > 8'd80 && cursorY > 7'd60)
				begin
					quarterSelected = 4'b1000;
				end
		end
	
endmodule
