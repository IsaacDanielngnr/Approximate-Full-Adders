`timescale 1ns / 1ps
module test;
  
  parameter N=16;
  reg [N-1:0] A,B;
  wire [N:0] result;
  wire [N:0] Esum;
  bit signed [7:0] ED;
  
  top dut(A,B,result);
  
  	assign Esum = A + B;
 	assign ED = Esum - result;
  
  initial begin

        A = 'd2; B = 'd1;
    
    $dumpvars(0);
    $dumpfile("dump.vcd");
		
    $display("..A..\t\t..B..\t\t..Esum..\t\t..Asum..\t\t..ED..");
    $monitor("%d \t\t %d \t\t %d \t\t\t %d \t\t\t %d",A,B,Esum,result,ED,);
		
    #50
    $finish;
    
    

  end
  
  initial begin
    forever #1 begin
		
      A = $urandom_range('d0,'d65535);
      B = $urandom_range('d0,'d65535);
     
	end
  end

endmodule
