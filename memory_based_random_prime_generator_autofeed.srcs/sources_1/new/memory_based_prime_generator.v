`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2024 07:03:22
// Design Name: 
// Module Name: memory_based_random_prime_generator_automated_feeding
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.10.2024 10:06:22
// Design Name:
// Module Name: hundred_mhz_clock_divider
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module hundred_mhz_clock_divider(hundred_mhz_clk,one_hz_clock);
    input hundred_mhz_clk;
    output reg one_hz_clock=0;
    reg[26:0] counter=27'd0;
    always @(posedge hundred_mhz_clk)
    begin
        counter=counter+27'd1;
        if(counter==27'd100000000)
        begin
            one_hz_clock=~one_hz_clock;
            counter=27'd0;
        end
   end
endmodule




module prbs_16bit(clk,sel,out);
        input clk;
        input[2:0] sel;
        output reg[15:0] out=0;
        always @(clk)
        case (sel)
            2'b000:
                begin
                out<=out>>1;
                out[15]<=(out[1])~^(out[0]);
                end
            2'b001:
                begin
                out<=out<<1;
                out[0]<=(out[15])~^(out[14]);
                end
            2'b010:
                begin
                out<=out<<1;
                out[0]<=~((out[15])&(out[14]));
                end
            2'b011:
                begin
                out<=out>>1;
                out[15]<=~((out[0])&(out[1]));
                end
            2'b100:
                
                out<={out[14:9],~out[15],out[8:0]};
  
            2'b101:
            
                out<={out[14:10],~out[15],out[9:0]};
            2'b110:
            
               out<={out[14:8],~out[15],out[7:0]};
               
            2'b111:
            
                out<={out[14:6],~out[15],out[5:0]};
                
            default:
            
                out<={out[14:5],~out[15],out[4:0]};
            
        endcase
endmodule


module prime_number_checker(clk,number1,prime);
input clk;
input[15:0] number1;
output reg[15:0] prime=0;

reg[15:0] counter=0;
reg[15:0] factor=0;
reg start_checking=1;
reg[15:0] num1;


begin

always @(posedge clk)
        if(start_checking)
            num1=number1;
        
 always @(posedge clk)
        begin
            start_checking=1'b0;
            counter=counter+1;
            if(num1%counter==1'b0)
                factor=factor+1;   
        end
            
 always @(posedge clk)
            if (counter==num1 & factor==16'd2)
                    begin
                    prime=num1;
                    factor=1'b0;
                    counter=1'b0;
                    start_checking=1'b1;  
                    end  
            else
               if(counter==num1 & factor>16'd2)
                       begin
                       start_checking=1'b1;
                       factor=1'b0;
                       counter=1'b0;
                       end       
                
                
                      
end
                
  
endmodule




module prbs_8bit(clk,sel,start,out);
        input clk,start;
        input[1:0] sel;
        output reg[7:0] out=0;
        wire one_hz_clk;
        hundred_mhz_clock_divider hmc(clk,one_hz_clk);
        always @(posedge one_hz_clk)
        if(start==1'b1)
        case (sel)
            2'b00:
                begin
                out<=out>>1;
                out[7]<=(out[1])~^(out[0]);
                end
            2'b01:
                begin
                out<=out<<1;
                out[0]<=(out[7])~^(out[6]);
            end
            2'b10:
            begin
                out<=out<<1;
                out[0]<=~((out[7])&(out[6]));
                end
            2'b11:
            begin
                out<=out>>1;
                out[7]<=~((out[0])&(out[1]));
            end
        endcase
endmodule



module memory_based_prime_generator(clk,start,sel_8,sel_16,prime,memory_feeded);
    input clk,start;
    input[1:0] sel_8;
    input[2:0] sel_16;
    
    output[15:0] prime;
    output reg memory_feeded=0;
    
    wire[15:0] prime_feed;
    wire [7:0] location;
    wire [15:0] random_number;
    reg[15:0] mem[255:0];
    integer i=0;
    
    
    prbs_16bit prbs_16(clk,sel_16,random_number);
    prime_number_checker(clk,random_number,prime_feed);
    

    prbs_8bit prbs_init(clk,sel_8,start,location);
    assign prime=mem[location];
    
    
    always @(prime_feed)
        if(i<256)
            begin
            mem[i]=prime_feed;
            i=i+1;
            end
            
            
   always @(prime_feed)
        if(i==256)
            memory_feeded=1;
   
            
               
endmodule



module seg7decimal(clk,x,seg,an,dp);
        input clk;
        output reg [6:0] seg;
        output reg [7:0] an;
        output wire dp;
        wire [2:0] s;
        input [31:0] x;
        reg [3:0] digit;
        wire [7:0] aen;
        reg [19:0] clkdiv;
        assign dp = 1;
        assign s = clkdiv[19:18];
        assign aen = 8'b11111111;
        always @(posedge clk)
        case(s)
            0:digit = x[3:0];
            1:digit = x[7:4];
            2:digit = x[11:8];
            3:digit = x[15:12];
            default:digit = x[3:0];
        endcase
        always @(*)
        case(digit)
            0:seg = 7'b1000000;
            1:seg = 7'b1111001;
            2:seg = 7'b0100100;
            3:seg = 7'b0110000;
            4:seg = 7'b0011001;
            5:seg = 7'b0010010;
            6:seg = 7'b0000010;
            7:seg = 7'b1111000;
            8:seg = 7'b0000000;
            9:seg = 7'b0010000;
            'hA:seg = 7'b0001000;
            'hB:seg = 7'b0000011;
            'hC:seg = 7'b1000110;
            'hD:seg = 7'b0100001;
            'hE:seg = 7'b0000110;
            'hF:seg = 7'b0001110;
            default: seg = 7'b0111111;
        endcase
        always @(*)
        begin
            an=8'b11111111;
            if(aen[s] == 1)
            an[s] = 0;
        end
        always @(posedge clk) begin
            clkdiv <= clkdiv+1;
        end
endmodule



module seven_seg_random_prime_generator(clk,start,sel_8,sel_16,seg,an,dp,memory_feeded);
        input clk;
        input start;
        
        input[1:0] sel_8;
        input[2:0] sel_16;
        
        output[7:0] an;
        output[6:0] seg;
        output dp;
        output memory_feeded;
        wire[15:0] prime;
        
        memory_based_prime_generator(clk,start,sel_8,sel_16,prime,memory_feeded);
        seg7decimal display(clk,prime,seg,an,dp);
endmodule
