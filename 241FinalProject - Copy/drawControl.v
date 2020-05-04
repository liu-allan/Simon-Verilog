module drawControl(resetn, flashingQuarter, drawCursor, CLOCK_50, done, outX, outY, outColour, erase, draw, move, load);
	input resetn;
	input CLOCK_50;
	input drawCursor;
	input done;
	input [3:0] flashingQuarter;
	output reg [7:0]outX;
	output reg [6:0]outY;
	output reg [2:0]outColour;
	output reg erase;
	output reg load;
	output reg move;
	output reg draw;
	
	wire go, done2;
	reg [3:0]counter;

	reg [3:0] currentState, nextState;
	localparam RESET = 4'd0,
					q0 = 4'd1, //BLUE 001
					q1 = 4'd2, //GREEN 010
					q2 = 4'd3, //RED 100
					q3 = 4'd4, //YELLOW 110
					FINISH = 4'd5,	
					DRAW = 4'd6,
					WAIT = 4'd7,
					ERASE = 4'd8,
					MOVE = 4'd9,
					RESET_POSITION = 4'd10;
	
	rateDivider r2(go, CLOCK_50); 
	count64(done2, CLOCK_50);

	always@(*)
		begin
			case(currentState)
				RESET: begin
					if(drawCursor)
						nextState = resetn ? q0 : RESET;
					else
						nextState = RESET_POSITION;
				end
				q0: nextState = done ? q1 : q0;
				q1: nextState = done ? q2 : q1;
				q2: nextState = done ? q3 : q2;
				q3: nextState = done ? FINISH : q3;
				RESET_POSITION: nextState = DRAW;
				DRAW: nextState = done2 ? WAIT : DRAW;
				WAIT: nextState = go ? ERASE : WAIT;
				ERASE: nextState = done ? MOVE : ERASE;
				MOVE: nextState = DRAW;
				default: nextState = RESET;
			endcase
		end

		
	always@(*)
		begin
			outColour = 3'b0;
			outX = 8'b0;
			outY = 7'b0;
			
			move = 1'b0;
			load = 1'b0;
			draw = 1'b0;
			case(currentState)
				q0: begin
						if (flashingQuarter[0] == 1'b1) 
							begin
								outColour = 3'd7;
								outX = 8'b0;
								outY = 7'b0;
							end
						else
							begin
								outColour = 3'd1;
								outX = 8'b0;
								outY = 7'b0;
							end
					end
				q1: begin
						if (flashingQuarter[1] == 1'b1)
							begin
								outColour = 3'd7;
								outX = 8'd80;
								outY = 7'd0;
							end
						else
							begin
								outColour = 3'd2;
								outX = 8'd80;
								outY = 7'd0;
							end
					end
				q2: begin
						if (flashingQuarter[2] == 1'b1)
							begin
								outColour = 3'd7;
								outX = 8'b0;
								outY = 7'd60;
							end
						else
							begin
								outColour = 3'd4;
								outX = 8'b0;
								outY = 7'd60;
							end
					end
				q3: begin
						if (flashingQuarter[3] == 1'b1)
							begin
								outColour = 3'd7;
								outX = 8'd80;
								outY = 7'd60;
							end
						else
							begin
								outColour = 3'd6;
								outX = 8'd80;
								outY = 7'd60;
							end
					end
				RESET_POSITION: begin
								load = 1'b1;
								outX = 8'd72;
								outY = 7'd52;
							end
				DRAW: begin
							draw = 1'b1;
							erase = 1'b0;
						end
				ERASE: erase = 1'b1;
				MOVE: move = 1'b1;
			endcase
		end
		
	always@(posedge CLOCK_50)
		begin
        if(!resetn)
				currentState <= RESET;
        else
            currentState <= nextState;
		end
	
endmodule