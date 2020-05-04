module sequenceDetector(startreading, resetn, CLOCK_50, sequence, sequenceSize,  controls, go, gameOver, correct, level);
    input startreading;
	 input CLOCK_50;
	 input [3:0] sequenceSize;
	 input [39:0] sequence;
	 input [3:0] controls;
	 input resetn;
    input go;
	 output reg [3:0] level;
	 output reg gameOver;
	 output reg correct;
	 reg win;

    wire clock, out_light;
	 wire [3:0]w;
    
    reg [3:0] y_Q, Y_D; // y_Q represents current state, Y_D represents next state
    
    localparam A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110, H = 4'b0111, I = 4'b1000, J = 4'b1001, Correct = 4'b1010, Incorrect = 4'b1011, youWin = 4'b1111;
    
    assign w = controls;
    assign clock = ~go;
			
			
	//4'b0001 is q1, 0010 is q2, 0100 is q3, 1000 is q4
    always@(*)
    begin: state_table
        case (y_Q)
            A: begin
				
					if(sequenceSize == 4'b0001) //if sequence size is 1
						begin
							if (w == sequence[3:0]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 1
						begin
							if (w == sequence[3:0]) Y_D = B;
							else Y_D = Incorrect;
						end
					end
					
            B: begin
				
					if(sequenceSize == 4'b0010) // if sequence size is 2
						begin
							if(w == sequence[7:4]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 2
						begin
							if (w == sequence[7:4]) Y_D = C;
							else Y_D = Incorrect;
						end
					end
					
            C: begin
				
					if(sequenceSize == 4'b0011) // if sequence size is 3
						begin
							if(w == sequence[11:8]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 3
						begin
							if (w == sequence[11:8]) Y_D = D;
							else Y_D = Incorrect;
						end
					end
					
            D: begin
					
					if(sequenceSize == 4'b0100) // if sequence size is 4
						begin
							if(w == sequence[15:12]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 4
						begin
							if(w == sequence[15:12]) Y_D = E;
							else Y_D = Incorrect;
						end
					end
					
            E: begin
				
					if(sequenceSize == 4'b0101) // if sequence size is 5
						begin
							if(w == sequence[19:16]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 5
						begin
							if(w == sequence[19:16]) Y_D = F;
							else Y_D = Incorrect;
						end
					end
					
            F: begin
					
					if(sequenceSize == 4'b0110) // if sequence size is 6
						begin
							if(w == sequence[23:20]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 6
						begin
							if(w == sequence[23:20]) Y_D = G;
							else Y_D = Incorrect;
						end
					end
					
					
            G:	begin
					
					if(sequenceSize == 4'b0111) // if sequence size is 7
						begin
							if(w == sequence[27:24]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 7
						begin
							if(w == sequence[27:24]) Y_D = H;
							else Y_D = Incorrect;
						end
					end
					
				H: begin
					
					if(sequenceSize == 4'b1000) // if sequence size is 8
						begin
							if(w == sequence[31:28]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 8

						begin
							if(w == sequence[31:28]) Y_D = I;
							else Y_D = Incorrect;
						end
					end
					
				I: begin
					
					if(sequenceSize == 4'b1001) // if sequence size is 9
						begin
							if(w == sequence[35:32]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 9
						begin
							if(w == sequence[35:32]) Y_D = J;
							else Y_D = Incorrect;
						end
					end
					
				J: begin
					
					if(sequenceSize == 4'b1010) // if sequence size is 10
						begin
							if(w == sequence[39:36]) Y_D = youWin;
							else Y_D = Incorrect;
						end
					else //if sequence size is anything greater than 10
						begin
							if(w == sequence[39:36]) Y_D = Correct;
							else Y_D = Incorrect;
						end
					end
				Correct: begin
						Y_D = A;
					end
				Incorrect: begin
						Y_D = A;
					end
				youWin: Y_D = A;
//							  
            default: Y_D = A;
        endcase
    end // state_table
	 
	 always @(*)
		begin
			win= 1'b0;
			case(y_Q)
				A: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				B: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				C: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				D: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				E: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				F: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				G: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				H: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				I: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				J: begin
					correct = 1'b0;
					gameOver = 1'b0;
				end
				Correct: begin 
								correct = 1'b1;
								gameOver = 1'b0;
							end
				Incorrect: begin
									correct = 1'b0;
									gameOver = 1'b1;
								end
				youWin: begin
							correct = 1'b1;
							win = 1'b1;
							gameOver = 1'b0;
							end
			endcase
		end
    
	always @(negedge go)
			begin
				if(correct == 1'b1)//increments level
					level <= level + 1;
				if(gameOver == 1'b1)//resets level to 0 when gameover or reset
					level <= 0;
				if(!resetn)
					level <= 0;
				if(win == 1'b1)
					level <= 0;
				
			end
    // State Registers
    always @(posedge clock)
    begin: state_FFs
        if(!resetn)
				y_Q <= A;
		  if(startreading == 1'b1)
				begin
					y_Q <=  A;	// Should set reset state to state A
				end
        else
				begin
					y_Q <= Y_D;	
				end
    end

    // Output logic
    // Set out_light to 1 to turn on LED when in relevant states

endmodule

