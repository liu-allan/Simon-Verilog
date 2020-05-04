module sequenceFSM(sequenceSize, resetn, CLOCK_50, sequence, flashingQuarter, doneSequence);
	input [3:0]sequenceSize;
	input resetn;
	input [39:0] sequence;
	input CLOCK_50;
	output reg [3:0] flashingQuarter;
	output reg doneSequence;

	
	reg [4:0] currentState, nextState;
	
	localparam 	WAIT0 = 5'd0,
					FLASH1 = 5'd1,
					WAIT1 = 5'd2,
					FLASH2 = 5'd3,
					WAIT2 = 5'd4,
					FLASH3 = 5'd5,
					WAIT3 = 5'd6,
					FLASH4 = 5'd7,
					WAIT4 = 5'd8,
					FLASH5 = 5'd9,
					WAIT5 = 5'd10,
					FLASH6 = 5'd11,
					WAIT6 = 5'd12,
					FLASH7 = 5'd13,
					WAIT7 = 5'd14,
					FLASH8 = 5'd15,
					WAIT8 = 5'd16,
					FLASH9 = 5'd17,
					WAIT9 = 5'd18,
					FLASH10 = 5'd19,
					WAIT10 = 5'd20,
					FINISH = 5'd21;
	
	wire done;
	
	rate1hzDivider r1(done, CLOCK_50); //makes the quarter flash for 1 second
	
	always@(*)
			begin
				case(currentState)
					WAIT0: begin
								if(sequenceSize == 4'd0)
									nextState = done ? FINISH : WAIT0;
								else
									nextState = done ? FLASH1 : WAIT0;
							end
					FLASH1: nextState = done ? WAIT1 : FLASH1;
					WAIT1: begin
								if(sequenceSize == 4'd1)
									nextState = done ? FINISH : WAIT1;
								else
									nextState = done ? FLASH2 : WAIT1;
							end
					FLASH2: nextState = done ? WAIT2 : FLASH2;
					WAIT2: begin
								if(sequenceSize == 4'd2)
									nextState = done ? FINISH : WAIT2;
								else
									nextState = done ? FLASH3 : WAIT2;
							end
					FLASH3: nextState = done ? WAIT3 : FLASH3;
					WAIT3: begin
								if(sequenceSize == 4'd3)
									nextState = done ? FINISH : WAIT3;
								else
									nextState = done ? FLASH4 : WAIT3;
							end
					FLASH4: nextState = done ? WAIT4 : FLASH4;
					WAIT4: begin
								if(sequenceSize == 4'd4)
									nextState = done ? FINISH : WAIT4;
								else
									nextState = done ? FLASH5 : WAIT4;
							end
					FLASH5: nextState = done ? WAIT5 : FLASH5;
					WAIT5: begin
								if(sequenceSize == 4'd5)
									nextState = done ? FINISH : WAIT5;
								else
									nextState = done ? FLASH6 : WAIT5;
							end
					FLASH6: nextState = done ? WAIT6 : FLASH6;
					WAIT6: begin
								if(sequenceSize == 4'd6)
									nextState = done ? FINISH : WAIT6;
								else
									nextState = done ? FLASH7 : WAIT6;
							end
					FLASH7: nextState = done ? WAIT7 : FLASH7;
					WAIT7: begin
								if(sequenceSize == 4'd7)
									nextState = done ? FINISH : WAIT7;
								else
									nextState = done ? FLASH8 : WAIT7;
							end
					FLASH8: nextState = done ? WAIT8 : FLASH8;
					WAIT8: begin
								if(sequenceSize == 4'd8)
									nextState = done ? FINISH : WAIT8;
								else
									nextState = done ? FLASH9 : WAIT8;
							end
					FLASH9: nextState = done ? WAIT9 : FLASH9;
					WAIT9: begin
								if(sequenceSize == 4'd9)
									nextState = done ? FINISH : WAIT9;
								else
									nextState = done ? FLASH10 : WAIT9;
							end
					FLASH10: nextState = done ? WAIT10 : FLASH10;
					WAIT10: begin
								if(sequenceSize == 4'd10)
									nextState = done ? FINISH : WAIT10;
								else
									nextState = done ? FINISH : WAIT10;
							end
				endcase
			end
		
	always@(*)
		begin
			flashingQuarter = 4'd0;
			doneSequence = 1'b0;
				begin
					case(currentState)
						WAIT0: begin
									flashingQuarter = 4'b0000;
								end
						FLASH1: begin
									flashingQuarter = sequence[3:0];
								end
						WAIT1: begin
									flashingQuarter = 4'b0000;
								end
						FLASH2: begin
									flashingQuarter = sequence[7:4];
								end
						WAIT2: begin
									flashingQuarter = 4'b0000;
								end
						FLASH3: begin
									flashingQuarter = sequence[11:8];
								end
						WAIT3: begin
									flashingQuarter = 4'b0000;
								end
						FLASH4: begin
									flashingQuarter = sequence[15:12];
								end
						WAIT4: begin
									flashingQuarter = 4'b0000;
								end
						FLASH5: begin
									flashingQuarter = sequence[19:16];
								end
						WAIT5: begin
									flashingQuarter = 4'b0000;
								end
						FLASH6: begin
									flashingQuarter = sequence[23:20];
								end
						WAIT6: begin
									flashingQuarter = 4'b0000;
								end
						FLASH7: begin
									flashingQuarter = sequence[27:24];
								end
						WAIT7: begin
									flashingQuarter = 4'b0000;
								end
						FLASH8: begin
									flashingQuarter = sequence[31:28];
								end
						WAIT8: begin
									flashingQuarter = 4'b0000;
								end
						FLASH9: begin
									flashingQuarter = sequence[35:32];
								end
						WAIT9: begin
									flashingQuarter = 4'b0000;
								end
						FLASH10: begin
									flashingQuarter = sequence[39:36];
								end
						WAIT10: begin
									flashingQuarter = 4'b0000;
								end
						FINISH: begin
									flashingQuarter = 4'b0000;
									doneSequence = 1'b1;
								end		
					endcase
				end
				
		end
	
	always@(posedge CLOCK_50)
		begin
        if(!resetn)
            currentState <= WAIT0;
        else
            currentState <= nextState;
		end
				

endmodule

