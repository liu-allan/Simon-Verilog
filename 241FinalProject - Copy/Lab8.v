module top
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		SW,
		LEDR,// Your inputs and outputs here
		// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,							//	VGA Blue[9:0]
		PS2_CLK,
		PS2_DAT
	);

	input	CLOCK_50;	//	50 MHz
	input [3:0]KEY;
	input [9:0]SW;
	inout PS2_CLK;
	inout PS2_DAT;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	output [9:0] LEDR;
	
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [7:0] outX;
	wire [6:0] outY;
	wire [2:0] outColour;
	wire [7:0] cursorX;
	wire [6:0] cursorY;
	wire [7:0] controlToDrawX;
	wire [6:0] controlToDrawY;
	wire [2:0] controlToDrawColour;
	wire [3:0] sequenceSize;
	wire [3:0] flashingQuarter;
	wire [3:0] quarterSelected;
	wire [19:0] sequence20bit;
	wire [39:0] sequence40bit;
	wire [3:0] Level;
	wire doneCounting, loadLevel, erase, move, load, displaySequence, gameOver, correct, startReading, drawControlReset, writeEn, done, doneSequence, drawCursor;
	wire drawTitle, drawWin, drawLose, draw;
	wire go = ~KEY[2];

	assign writeEn = 1'b1;
	wire left, right, up, down, enter, space;
	wire [7:0] output_keyboard;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(outColour),
			.x(outX),
			.y(outY),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
		
		PS2_Demo inputsfromKB(CLOCK_50, KEY[0], PS2_CLK, PS2_DAT, output_keyboard);

		kbDecoder k1(output_keyboard, left, right, up, down, enter, space);		
			
		random20BitNumber r1(loadLevel, resetn, sequence20bit);
		sequenceConverter sC1(sequence20bit, sequence40bit);
		
		cursorQuarterEncoder c1(cursorX, cursorY, CLOCK_50, quarterSelected);
		
		gameLogicFSM top(resetn, CLOCK_50, enter, doneSequence, gameOver, correct, Level, sequenceSize, displaySequence, drawCursor, startReading, drawControlReset, loadLevel, drawTitle, drawWin, drawLose);
		sequenceFSM s1(sequenceSize, displaySequence, CLOCK_50, sequence40bit, flashingQuarter, doneSequence);
		drawControl d1(drawControlReset, flashingQuarter, drawCursor, CLOCK_50, done, controlToDrawX, controlToDrawY, controlToDrawColour, erase, draw, move, load);
		draw d2(drawCursor, controlToDrawX, controlToDrawY, controlToDrawColour, erase, draw, move, load, left, right, up, down, drawTitle, drawWin, drawLose, CLOCK_50, outX, outY, outColour, cursorX, cursorY, done);
		sequenceDetector s2(startReading, resetn, CLOCK_50, sequence40bit, sequenceSize, quarterSelected, space, gameOver, correct, Level);

endmodule
