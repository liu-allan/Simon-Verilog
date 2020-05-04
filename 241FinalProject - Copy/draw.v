module draw(Enable, inX, inY, inColour, erase, draw, move, load, Left, Right, Up, Down, drawTitle, drawWin, drawLose, CLOCK_50, outX, outY, outColour, X, Y, done);
	input Enable;
	input Left, Right, Up, Down;
	input erase;
	input move;
	input load;
	input draw;
	input CLOCK_50;
	input [7:0]inX;
	input [6:0]inY;
	input [2:0]inColour;
	input drawTitle;
	input drawWin;
	input drawLose;
	output reg [7:0]outX;
	output reg [6:0]outY;
	output reg [2:0]outColour;
	output reg done;
	
	reg [12:0] q; //counter for individual quarters
	reg [5:0] q2;	//counter for the cursor
	reg [14:0] q3;	//counter for the entire display
	reg [2:0]cursorColour;
	output reg [7:0]X; //cursor X position
	output reg [6:0]Y;	//cursor Y position
	reg [1:0]quarter;
	
	always @(posedge CLOCK_50)
		begin
			if(Enable && ~drawTitle && ~drawWin && ~drawLose)//this means draw just the background
				begin
					if (q[12:7] < 6'b111100)
						begin
							q <= q + 1;
							done <= 1'b0;
						end
					else
						begin
							q <= 0;
							done <= 1'b1;
						end
				end
			else if(drawTitle || drawWin || drawLose)
				begin
					if(q3[14:8] < 7'b1111000)
						begin
							q3 <= q3 + 1;
						end
					else
						begin
							q3 <= 0;
						end
				end
			else if(erase == 1'b1 && ~Enable)
						begin
							if (q[12:7] < 6'b111100)
								begin
									q <= q + 1;
								end
							else
								begin
									q <= 0;
									quarter <= quarter + 1;
								end
							if(q3 < 15'b100101100000000)
								begin
									q3 <= q3 + 1;
									if(erase == 1'b1)
										done <= 0;
								end
							else
								begin
									q3 <= 0;
									if(erase == 1'b1)
										done <= 1;
								end
						end
			else if(erase == 1'b0 && ~Enable)
						if(q2 < 6'd63)
							begin
								q2 <= q2 + 1;
								done <= 0;
							end
						else
							begin
								q2 <= 0;
								done <= 1;
							end
						
		end
		
	wire [2:0] blueColour;
	wire [2:0] greenColour;
	wire [2:0] redColour;
	wire [2:0] yellowColour;
	wire [2:0] titleScreenColour;
	wire [2:0] youWinColour;
	wire [2:0] youLoseColour;
	
	//these 4 modules create the coloured cursors
	
	BlueCursor b1(8*q2[5:3] + q2[2:0] + 3, CLOCK_50, blueColour);
	GreenCursor g1(8*q2[5:3] + q2[2:0] + 3, CLOCK_50, greenColour);
	RedCursor r1(8*q2[5:3] + q2[2:0] + 3, CLOCK_50, redColour);
	YellowCursor y1(8*q2[5:3] + q2[2:0] + 3, CLOCK_50, yellowColour);
	
	//these 3 modules are for the corresponding screens
	titleScreen t1(160*q3[14:8] + q3[7:0], CLOCK_50, titleScreenColour);
	youWin y2(160*q3[14:8] + q3[7:0], CLOCK_50, youWinColour);
	youLose y3(160*q3[14:8] + q3[7:0], CLOCK_50, youLoseColour);
	

		
	always@(posedge CLOCK_50)
		begin
			if(load)
				begin
					X <= inX;
					Y <= inY;
				end
			if(erase == 1'b0) //else, select the correct cursor colour
				begin
					if(X < 8'd80 && Y < 7'd60)
						begin
							cursorColour <= blueColour;
						end
					else if(X > 8'd80 && Y < 7'd60)
						begin
							cursorColour <= greenColour;
						end
					else if(X < 8'd80 && Y > 7'd60)
						begin
							cursorColour <= redColour;
						end
					else if(X > 8'd80 && Y > 7'd60)
						begin
							cursorColour <= yellowColour;
						end
				end
			//Move the cursor in the selected direction
			if(move && Right)
				X <= X + 1;
			if(move && Left)
				X <= X - 1;
			if(move && Down)
				Y <= Y + 1;
			if(move && Up)
				Y <= Y - 1;
		end
		
	always @(CLOCK_50)
		begin
			if(Enable && ~drawTitle && ~drawWin && ~drawLose) // draw the normal game without cursor
				begin
					outColour <= inColour;
					outY <= inY + q[12:7];
					if(q[6:0] < 7'b1010000)
						outX <= inX + q[6:0];
				end
			else if(drawTitle)
				begin
					outColour <= titleScreenColour;
					outY <= 0 + q3[14:8];
					if(q3[7:0] < 8'b10100000)
						outX <= 0 -1'b1 + q3[7:0];
				end
			else if(drawWin)
				begin
					outColour <= youWinColour;
					outY <= 0 + q3[14:8];
					if(q3[7:0] < 8'b10100000)
						outX <= 0 -1'b1 + q3[7:0];
				end
			else if(drawLose)
				begin
					outColour <= youLoseColour;
					outY <= 0 + q3[14:8];
					if(q3[7:0] < 8'b10100000)
						outX <= 0-1'b1  + q3[7:0];
				end
			else if(erase == 1'b0 && ~Enable) //if its not time to erase, draw the cursor in its position
						begin
							outColour <= cursorColour;
							outY <= Y + q2[5:3];
							outX <= X + q2[2:0];
						end
			else if(erase == 1'b1 && ~Enable)
						begin
							if(quarter == 3'd0)
								begin
									outColour <= 3'd1;
									outY <= 0 + q[12:7];
									if(q[6:0] < 7'b1010000)
										outX <= 0 + q[6:0];
								end
							else if(quarter == 3'd1)
								begin
									outColour <= 3'd2;
									outY <= 0 + q[12:7];
									if(q[6:0] < 7'b1010000)
										outX <= 80 + q[6:0];
								end
							else if(quarter == 3'd2)
								begin
									outColour <= 3'd4;
									outY <= 60 + q[12:7];
									if(q[6:0] < 7'b1010000)
										outX <= 0 + q[6:0];
								end
							else if(quarter == 3'd3)
								begin
									outColour <= 3'd6;
									outY <= 60 + q[12:7];
									if(q[6:0] < 7'b1010000)
										outX <= 80 + q[6:0];
								end
						end
				end
		
endmodule






