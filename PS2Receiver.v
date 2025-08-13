`timescale 1ns / 1ps

module PS2Receiver(
    input clk,
    input kclk,
    input kdata,
    output [31:0] keycodeout
    );
    
    // Removed debouncer wires - using direct signals
    reg [7:0]datacur;
    reg [7:0]dataprev;
    reg [3:0]cnt;
    reg [31:0]keycode;
    reg flag;
    
    // Sửa lỗi INITIALDLY - sử dụng blocking assignment trong initial block
    initial begin
        keycode[31:0] = 32'h00000000;
        cnt = 4'b0000;
        flag = 1'b0;
    end
    
    // Removed debouncer instantiation - using kclk and kdata directly
    
always@(negedge(kclk))begin  // Using kclk directly instead of kclkf
    case(cnt)
    0:;//Start bit
    1:datacur[0]<=kdata;     // Using kdata directly instead of kdataf
    2:datacur[1]<=kdata;
    3:datacur[2]<=kdata;
    4:datacur[3]<=kdata;
    5:datacur[4]<=kdata;
    6:datacur[5]<=kdata;
    7:datacur[6]<=kdata;
    8:datacur[7]<=kdata;
    9:flag<=1'b1;
    10:flag<=1'b0;
    
    endcase
        if(cnt<=9) cnt<=cnt+1;
        else if(cnt==10) cnt<=0;
        
end

always @(posedge flag)begin
    if (dataprev!=datacur)begin
        keycode[31:24]<=keycode[23:16];
        keycode[23:16]<=keycode[15:8];
        keycode[15:8]<=dataprev;
        keycode[7:0]<=datacur;
        dataprev<=datacur;
    end
end
    
assign keycodeout=keycode;
    
endmodule