
module PS2_Demo (
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	last_data_received
	
	// Outputs
//	HEX0,
//	HEX1,
//	HEX2,
//	HEX3,
//	HEX4,
//	HEX5,
//	HEX6,
//	HEX7
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

output reg			[7:0]	last_data_received;

// Outputs
//output		[6:0]	HEX0;
//output		[6:0]	HEX1;
//output		[6:0]	HEX2;
//output		[6:0]	HEX3;
//output		[6:0]	HEX4;
//output		[6:0]	HEX5;
//output		[6:0]	HEX6;
//output		[6:0]	HEX7;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire 		[7:0]	ps2_key_data;
wire 				ps2_key_pressed;

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
	reg [4:0] current_state, next_state;
	reg pressingSig, resettingSig;
	
	localparam S_WAIT = 5'd0,
				  S_PRESSING = 5'd1,
				  S_RELEASE = 5'd2,
				  S_RESET = 5'd3;

	
	always @(*) begin 
	
		case (current_state)
			S_WAIT : next_state =  ps2_key_pressed ? S_PRESSING : S_WAIT;
			S_PRESSING : next_state = (ps2_key_data == 8'hf0) ? S_RELEASE : S_PRESSING;
			S_RELEASE : next_state = (ps2_key_data != 8'hf0) ? S_RESET: S_RELEASE;
			S_RESET : next_state = ps2_key_pressed ? S_WAIT: S_RESET  ;
		endcase
	 
	end
	 
	always @(*) begin 
	 
		
		pressingSig = 1'b0;
		resettingSig = 1'b0;
		
		case(current_state)
			S_PRESSING: pressingSig = 1'b1; 
			S_RESET: resettingSig = 1'b1;
		endcase
	
	end
	  
	always @(posedge CLOCK_50) begin 
			current_state <= next_state;
	end



	always @(posedge CLOCK_50)  

	begin
	if (KEY[0] == 1'b0 || resettingSig )
		last_data_received <= 8'h00;
	else if (pressingSig == 1'b1)
		last_data_received <= ps2_key_data;
	end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

//assign HEX2 = 7'h7F;
//assign HEX3 = 7'h7F;
//assign HEX4 = 7'h7F;
//assign HEX5 = 7'h7F;
//assign HEX6 = 7'h7F;
//assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

//Hexadecimal_To_Seven_Segment Segment0 (
//	// Inputs
//	.hex_number			(last_data_received[3:0]),
//
//	// Bidirectional
//
//	// Outputs
//	.seven_seg_display	(HEX0)
//);
//
//Hexadecimal_To_Seven_Segment Segment1 (
//	// Inputs
//	.hex_number			(last_data_received[7:4]),
//
//	// Bidirectional
//
//	// Outputs
//	.seven_seg_display	(HEX1)
//);


endmodule
