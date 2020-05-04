module gameLogicFSM(resetn, CLOCK_50, go, doneSequence, gameOver, correct, level, sequenceSize, displaySequence, drawCursor, startReading, drawControlReset, loadLevel, drawTitle, drawWin, drawLose);
	input resetn; //resetn is key0
	input CLOCK_50;
	input go; //go is key1
	input doneSequence; //from sequenceDisplay, high means the sequence is finished displaying
	input gameOver; //from sequenceDetector, high means the sequence was incorrect
	input correct; //from sequenceDetector, high means the sequence was correct, low means incorrect
	input [3:0] level;

	output reg [3:0] sequenceSize; //tells sequenceDisplay and sequenceDetector the size of the sequence
	output reg displaySequence; //tells sequenceDisplay to start
	output reg drawCursor; //tells drawControl to draw the quarters when high, draw the cursor when low
	output reg startReading; //tells sequenceDetector to start at the first state again
	output reg drawControlReset; //tells drawControl to go to the reset state
	output reg loadLevel;
	output reg drawTitle; //high means drawTitle, low means draw anything else
	output reg drawWin; //high means draw youWin
	output reg drawLose;
	
	
	reg [3:0] currentState, nextState;
	localparam START = 4'd0,
					STARTWAIT = 4'd1,
					LOAD = 4'd2,
					DISPLAYSEQUENCE = 4'd3,
					MOVECURSOR = 4'd4,
					WAIT = 4'd5,
					YOULOSE = 4'd6,
					YOULOSEWAIT = 4'd7,
					YOUWINWAIT = 4'd8,
					YOUWIN = 4'd9;
					
					
	wire after2Seconds;
	rate05hzDivider r1(after2Seconds, CLOCK_50);
					
	always@(*)
		begin
			case(currentState)
				START: nextState = go ? STARTWAIT : START; //go to start wait when key1 is up
				STARTWAIT: nextState = go ?  LOAD: STARTWAIT; // start the game when key1 is released
				LOAD: nextState = after2Seconds ? DISPLAYSEQUENCE : LOAD;
				DISPLAYSEQUENCE: nextState = doneSequence ?  MOVECURSOR : DISPLAYSEQUENCE; //go to MOVECURSOR once finished displaying sequence
				MOVECURSOR: begin
									if(gameOver == 1'b1) //if the input is wrong, go to YOULOSE
										nextState = YOULOSE;
									else if(correct == 1'b1)
										begin
											if(sequenceSize == 4'd10) //if the input is right and its the last size, YOUWIN
												nextState = YOUWIN;
											else
												nextState = WAIT;	//else, go to WAIT
										end
									else
										nextState = MOVECURSOR; //if the sequence input isnt finished, stay in MOVECURSOR
								end
				WAIT: nextState = DISPLAYSEQUENCE;
				YOULOSE: nextState = go ? YOULOSEWAIT : YOULOSE;
				YOUWIN: nextState = go ?  YOUWINWAIT : YOUWIN;
				YOULOSEWAIT: nextState = go ? YOULOSEWAIT : START;
				YOUWINWAIT: nextState = go ? YOUWINWAIT : START;
			endcase
		end
		
	
	always@(*)
		begin
			startReading = 1'b1;
			sequenceSize = 4'd0;
			displaySequence = 1'b0;
			loadLevel = 1'b0;
			drawControlReset = 1'b1;
			drawCursor = 1'b1;
			drawTitle = 1'b0;
			drawLose = 1'b0;
			drawWin = 1'b0;
			case(currentState)
				START: begin
						drawTitle = 1'b1;
						loadLevel = 1'b1;
						drawControlReset = 1'b0;
					end
				STARTWAIT: begin
					drawTitle = 1'b1;
					end
				DISPLAYSEQUENCE: begin
					sequenceSize = level + 1;
					displaySequence = 1'b1;
					end
				MOVECURSOR: begin
					startReading = 1'b0;
					sequenceSize = level + 1;
					drawCursor = 1'b0;
					end
				WAIT:begin 
						drawControlReset = 1'b0;
					end
				YOULOSE:begin
							drawLose = 1'b1;
						end
				YOUWIN: begin
							drawWin = 1'b1;
						end
				YOULOSEWAIT:begin
							drawLose = 1'b1;
						end
				YOUWINWAIT: begin
							drawWin = 1'b1;
						end
			endcase
		end
	
	always@(posedge CLOCK_50)
		begin
        if(!resetn)
            currentState <= START;
        else
            currentState <= nextState;
		end
	
endmodule


