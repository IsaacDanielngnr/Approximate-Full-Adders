`timescale 1ns / 1ps
///////////////////////////////////////////////////////////PRECISE ADDER
module precise_adder(input1,input2,cin,answer,carry_out);
	parameter UPL=10;
	input [UPL-1:0] input1,input2;
  	input cin;
	output [UPL-1:0] answer;
	output  carry_out;
	wire [UPL-1:0] carry;
	
	genvar i;
	generate 
		for(i=0;i<UPL;i=i+1) begin: generate_N_bit_Adder
			if(i==0) 
             			full_adder f0(input1[0],input2[0],cin,answer[0],carry[0]);
			else
				full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
		end
  
		assign carry_out = carry[UPL-1];
	endgenerate
	
endmodule

module full_adder(x,y,c_in,s,c_out);
   input x,y,c_in;
   output s,c_out;
	assign s = (x^y) ^ c_in;
	assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule // full_adder

///////////////////////////////////////////////////////////////////IMPRECISE ADDER
module imprecise_adder(A,B,result,carry);
	parameter LPL=6;
	input [LPL - 1:0] A,B;
	output [LPL - 1:0] result;
	output wire carry;
 	wire mux;
  
    assign carry = A[LPL-1] & B[LPL-1];
    assign mux = (carry)? 1'b0: A[LPL-1] | B[LPL-1];
    assign result[LPL-1] = mux | (A[LPL-2] & B[LPL-2]);
    or (result[LPL-2],A[LPL-2],B[LPL-2]);
    assign result[LPL-3:0] = 1'b1;
endmodule : imprecise_adder

///////////////////////////////////////////////////////////////////HOAANED
module HOAANED(A,B,result);
	parameter N=16;
	parameter LPL=6;
	parameter UPL=10;
	input [N - 1:0] A,B;
	output [N:0] result;
	
	wire [LPL-1:0] A_lsb;
	wire [LPL-1:0] B_lsb;
	wire [LPL-1:0] sum_lsb;
	wire [UPL-1:0] A_msb;
	wire [UPL-1:0] B_msb;
	wire [UPL-1:0] sum_msb;
	wire carry_msb,cin;
	
  imprecise_adder lsb(.A(A_lsb),.B(B_lsb),.result(sum_lsb),.carry(cin));
  precise_adder msb(.input1(A_msb),.input2(B_msb),.cin(cin),.answer(sum_msb),.carry_out(carry_msb));
	
	assign A_lsb = A[LPL-1:0];
	assign B_lsb = B[LPL-1:0];
	assign result[LPL-1:0] = sum_lsb;
	assign A_msb = A[N-1:LPL];
	assign B_msb = B[N-1:LPL];
	assign result[N-1:LPL] = sum_msb;
	assign result[N] = carry_msb;
	
	
endmodule : HOAANED
