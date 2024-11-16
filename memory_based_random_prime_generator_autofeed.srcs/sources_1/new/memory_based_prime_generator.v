`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 30.10.2024 10:06:22
// Design Name:rohit raj,alok ranjan,shubham kumar jha (under supervision of PROF. jawar singh)
// Module Name: 
// Project Name:memory_based_random_prime_generator_autofeed_update
// Target Devices:fpga xc7a100tcsg324
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



module memory_based_prime_generator(clk,start,sel_8,sel_16,prime);
    input clk,start;
    input[1:0] sel_8;
    input[2:0] sel_16;
    output[15:0] prime;
    
    wire[15:0] prime_feed;
    wire [7:0] location;
    wire [15:0] random_number;
    reg[15:0] mem[255:0];
    integer i=0;
    
    
    prbs_16bit prbs_16(clk,sel_16,random_number);
    prime_number_checker pnc(clk,random_number,prime_feed);
    

    prbs_8bit prbs_init(clk,sel_8,start,location);
    assign prime=mem[location];
    
    
    always @(prime_feed)
            begin
            mem[i]=prime_feed;
            i=i+1;
            end
            
            
   always @(posedge clk)
        if(i==256)
            i=0;
   initial
    begin
            mem[60]=16'd2;
            mem[61]=16'd3;
            mem[62]=16'd5;
            mem[63]=16'd7;
            mem[64]=16'd11;
            mem[65]=16'd13;
            mem[66]=16'd17;
            mem[67]=16'd19;
            mem[68]=16'd23;
            mem[69]=16'd29;
            mem[10]=16'd31;
            mem[11]=16'd37;
            mem[12]=16'd41;
            mem[13]=16'd43;
            mem[14]=16'd47;
            mem[15]=16'd53;
            mem[16]=16'd59;
            mem[17]=16'd61;
            mem[18]=16'd67;
            mem[19]=16'd71;
            mem[20]=16'd73;
            mem[21]=16'd79;
            mem[22]=16'd83;
            mem[23]=16'd89;
            mem[24]=16'd97;
            mem[25]=16'd101;
            mem[26]=16'd103;
            mem[27]=16'd661;
            mem[28]=16'd673;
            mem[29]=16'd683;
            mem[30]=16'd677;
            mem[31]=16'd691;
            mem[32]=16'd701;
            mem[33]=16'd719;
            mem[34]=16'd929;
            mem[35]=16'd941;
            mem[36]=16'd947;
            mem[37]=16'd953;
            mem[38]=16'd967;
            mem[39]=16'd971;
            mem[40]=16'd977;
            mem[41]=16'd983;
            mem[42]=16'd991;
            mem[43]=16'd997;
            mem[44]=16'd10007;
            mem[45]=16'd10009;
            mem[46]=16'd10037;
            mem[47]=16'd10061;
            mem[48]=16'd10091;
            mem[49]=16'd10093;
            mem[50]=16'd10099;
            mem[51]=16'd10103;
            mem[52]=16'd10111;
            mem[53]=16'd10133;
            mem[54]=16'd10141;
            mem[55]=16'd10193;
            mem[56]=16'd10211;
            mem[57]=16'd10223;
            mem[58]=16'd10247;
            mem[59]=16'd11003;
            mem[0]=16'd11027;
            mem[1]=16'd11031;
            mem[2]=16'd11033;
            mem[3]=16'd11039;
            mem[4]=16'd11063;
            mem[5]=16'd11069;
            mem[6]=16'd11073;
            mem[7]=16'd11087;
            mem[8]=16'd11089;
            mem[9]=16'd11093;
            mem[70]=16'd11113;
            mem[71]=16'd12001;
            mem[72]=16'd12007;
            mem[73]=16'd12011;
            mem[74]=16'd12109;
            mem[75]=16'd12163;
            mem[76]=16'd12203;
            mem[77]=16'd12209;
            mem[78]=16'd12241;
            mem[79]=16'd12301;
            mem[80]=16'd12307;
            mem[81]=16'd12319;
            mem[82]=16'd12401;
            mem[83]=16'd12409;
            mem[84]=16'd12413;
            mem[85]=16'd12427;
            mem[86]=16'd20011;
            mem[87]=16'd20021;
            mem[88]=16'd20023;
            mem[89]=16'd20029;
            mem[90]=16'd20031;
            mem[91]=16'd20033;
            mem[92]=16'd20041;
            mem[93]=16'd20051;
            mem[94]=16'd20053;
            mem[95]=16'd20071;
            mem[96]=16'd20089;
            mem[97]=16'd20093;
            mem[98]=16'd20101;
            mem[99]=16'd20107;
            mem[100]=16'd20111;
            mem[101]=16'd20113;
            mem[102]=16'd20129;
            mem[103]=16'd20131;
            mem[104]=16'd20143;
            mem[105]=16'd20149;
            mem[106]=16'd20161;
            mem[107]=16'd22079;
            mem[108]=16'd22103;
            mem[109]=16'd22111;
            mem[110]=16'd22117;
            mem[111]=16'd22121;
            mem[112]=16'd22123;
            mem[113]=16'd22147;
            mem[114]=16'd22151;
            mem[115]=16'd22169;
            mem[116]=16'd22171;
            mem[117]=16'd30011;
            mem[118]=16'd30029;
            mem[119]=16'd30031;
            mem[120]=16'd30037;
            mem[121]=16'd30059;
            mem[122]=16'd30061;
            mem[123]=16'd30071;
            mem[124]=16'd30073;
            mem[125]=16'd30089;
            mem[126]=16'd30091;
            mem[127]=16'd30097;
            mem[128]=16'd30111;
            mem[129]=16'd30119;
            mem[130]=16'd30127;
            mem[131]=16'd30133;
            mem[132]=16'd30211;
            mem[133]=16'd30223;
            mem[134]=16'd30259;
            mem[135]=16'd30261;
            mem[136]=16'd30271;
            mem[137]=16'd30293;
            mem[138]=16'd30323;
            mem[139]=16'd30337;
            mem[140]=16'd30341;
            mem[141]=16'd30347;
            mem[142]=16'd30349;
            mem[143]=16'd30359;
            mem[144]=16'd30389;
            mem[145]=16'd30403;
            mem[146]=16'd30763;
            mem[147]=16'd30799;
            mem[148]=16'd30803;
            mem[149]=16'd30809;
            mem[150]=16'd31057;
            mem[151]=16'd31061;
            mem[152]=16'd31073;
            mem[153]=16'd31181;
            mem[154]=16'd31183;
            mem[155]=16'd31193;
            mem[156]=16'd31219;
            mem[157]=16'd31223;
            mem[157]=16'd31231;
            mem[158]=16'd31651;
            mem[159]=16'd31669;
            mem[160]=16'd31691;
            mem[161]=16'd31703;
            mem[162]=16'd40001;
            mem[163]=16'd40009;
            mem[164]=16'd40011;
            mem[165]=16'd40021;
            mem[166]=16'd40023;
            mem[167]=16'd40039;
            mem[168]=16'd40099;
            mem[169]=16'd40111;
            mem[170]=16'd40117;
            mem[171]=16'd40127;
            mem[172]=16'd40129;
            mem[173]=16'd40141;
            mem[174]=16'd40143;
            mem[175]=16'd40151;
            mem[176]=16'd40157;
            mem[178]=16'd40547;
            mem[179]=16'd40553;
            mem[180]=16'd40561;
            mem[181]=16'd40999;
            mem[182]=16'd41041;
            mem[183]=16'd45059;
            mem[184]=16'd45061;
            mem[185]=16'd45067;
            mem[186]=16'd45073;
            mem[187]=16'd45113;
            mem[188]=16'd45137;
            mem[189]=16'd45119;
            mem[190]=16'd45113;
            mem[191]=16'd45149;
            mem[192]=16'd47227;
            mem[193]=16'd47239;
            mem[194]=16'd47251;
            mem[195]=16'd47253;
            mem[196]=16'd47239;
            mem[197]=16'd47257;
            mem[198]=16'd47261;
            mem[199]=16'd47519;
            mem[200]=16'd47521;
            mem[201]=16'd47729;
            mem[202]=16'd47731;
            mem[203]=16'd49471;
            mem[204]=16'd49549;
            mem[205]=16'd49571;
            mem[206]=16'd49573;
            mem[207]=16'd49727;
            mem[208]=16'd49739;
            mem[209]=16'd49979;
            mem[210]=16'd49981;
            mem[211]=16'd55073;
            mem[212]=16'd55217;
            mem[213]=16'd55231;
            mem[214]=16'd55297;
            mem[215]=16'd55319;
            mem[216]=16'd55453;
            mem[217]=16'd57731;
            mem[218]=16'd58243;
            mem[219]=16'd58301;
            mem[220]=16'd58373;
            mem[221]=16'd59371;
            mem[222]=16'd59539;
            mem[223]=16'd59603;
            mem[224]=16'd59737;
            mem[225]=16'd59773;
            mem[226]=16'd59779;
            mem[227]=16'd59821;
            mem[228]=16'd59827;
            mem[229]=16'd59993;
            mem[230]=16'd60011;
            mem[231]=16'd60043;
            mem[232]=16'd60109;
            mem[233]=16'd60119;
            mem[234]=16'd60127;
            mem[235]=16'd61117;
            mem[236]=16'd61181;
            mem[237]=16'd61183;
            mem[238]=16'd61333;
            mem[239]=16'd61337;
            mem[240]=16'd61353;
            mem[241]=16'd62209;
            mem[242]=16'd62221;
            mem[243]=16'd62603;
            mem[244]=16'd63889;
            mem[245]=16'd63893;
            mem[246]=16'd63901;
            mem[247]=16'd63917;
            mem[248]=16'd63943;
            mem[249]=16'd63949;
            mem[250]=16'd63959;
            mem[251]=16'd63937;
            mem[252]=16'd63961;
            mem[253]=16'd63937;
            mem[254]=16'd63979;
            mem[255]=16'd63997;
    end
            
               
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
            default: seg = 7'b0000000;
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



module seven_seg_random_prime_generator(clk,start,sel_8,sel_16,seg,an,dp);
        input clk;
        input start;
        
        input[1:0] sel_8;
        input[2:0] sel_16;
        
        output[7:0] an;
        output[6:0] seg;
        output dp;
        wire[15:0] prime;
        
        memory_based_prime_generator msb(clk,start,sel_8,sel_16,prime);
        seg7decimal display(clk,prime,seg,an,dp);
endmodule