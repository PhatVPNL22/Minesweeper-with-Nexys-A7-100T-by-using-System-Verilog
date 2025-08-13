
`timescale 1ns / 1ps

module bit_map_data (
    input logic sq_flag_on,
    input logic [3:0] current_cell_data,
    input logic [4:0] rom_number_row,
    output logic [24:0] bit_map
);


logic [24:0] rom_number_data;
assign bit_map = rom_number_data;

    always_comb begin
        if (sq_flag_on) begin
            case (rom_number_row)
                5'h00: rom_number_data = 25'b0000000000000000000000000;
                5'h01: rom_number_data = 25'b0000000000000000000000000;
                5'h02: rom_number_data = 25'b0000000000000000000000000;
                5'h03: rom_number_data = 25'b0000000000001000000000000;
                5'h04: rom_number_data = 25'b0000000000011000000000000;
                5'h05: rom_number_data = 25'b0000000000111000000000000;
                5'h06: rom_number_data = 25'b0000000001111000000000000; // Cột cờ + đỉnh cờ
                5'h07: rom_number_data = 25'b0000000011111000000000000; // Cột cờ + 2 pixel cờ
                5'h08: rom_number_data = 25'b0000000111111000000000000; // Cột cờ + 3 pixel cờ
                5'h09: rom_number_data = 25'b0000001111111000000000000; // Cột cờ + 4 pixel cờ
                5'h0A: rom_number_data = 25'b0000011111111000000000000; // Cột cờ + 5 pixel cờ
                5'h0B: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h0C: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h0D: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h0E: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h0F: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h10: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h11: rom_number_data = 25'b0000000000011000000000000; // Cột cờ
                5'h12: rom_number_data = 25'b0000000111111111100000000;
                5'h13: rom_number_data = 25'b0000011111111111111000000;
                5'h14: rom_number_data = 25'b0001111111111111111110000;
                5'h15: rom_number_data = 25'b0001111111111111111110000;
                5'h16: rom_number_data = 25'b0111111111111111111111110;
                5'h17: rom_number_data = 25'b0111111111111111111111110;
                5'h18: rom_number_data = 25'b0111111111111111111111110;
                default: rom_number_data = 25'b0000000000000000000000000;
            endcase
        end
        else begin
             case (current_cell_data)
                4'd0: begin // Trống
                    case (rom_number_row) 
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000; 
                        5'h04: rom_number_data = 25'b0000000000000000000000000; 
                        5'h05: rom_number_data = 25'b0000000000000000000000000; 
                        5'h06: rom_number_data = 25'b0000000000000000000000000; 
                        5'h07: rom_number_data = 25'b0000000000000000000000000;
                        5'h08: rom_number_data = 25'b0000000000000000000000000; 
                        5'h09: rom_number_data = 25'b0000000000000000000000000; 
                        5'h0A: rom_number_data = 25'b0000000000000000000000000;
                        5'h0B: rom_number_data = 25'b0000000000000000000000000; 
                        5'h0C: rom_number_data = 25'b0000000000000000000000000; 
                        5'h0D: rom_number_data = 25'b0000000000000000000000000; 
                        5'h0E: rom_number_data = 25'b0000000000000000000000000; 
                        5'h0F: rom_number_data = 25'b0000000000000000000000000; 
                        5'h10: rom_number_data = 25'b0000000000000000000000000;
                        5'h11: rom_number_data = 25'b0000000000000000000000000; 
                        5'h12: rom_number_data = 25'b0000000000000000000000000; 
                        5'h13: rom_number_data = 25'b0000000000000000000000000; 
                        5'h14: rom_number_data = 25'b0000000000000000000000000; 
                        5'h15: rom_number_data = 25'b0000000000000000000000000; 
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end
                
                4'd1: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000011000000000000;
                        5'h05: rom_number_data = 25'b0000000000011100000000000;
                        5'h06: rom_number_data = 25'b0000000000011110000000000;
                        5'h07: rom_number_data = 25'b0000000000011111000000000;
                        5'h08: rom_number_data = 25'b0000000000011111100000000;
                        5'h09: rom_number_data = 25'b0000000000011111110000000;
                        5'h0A: rom_number_data = 25'b0000000000011111111000000;
                        5'h0B: rom_number_data = 25'b0000000000011110000000000;
                        5'h0C: rom_number_data = 25'b0000000000011110000000000;
                        5'h0D: rom_number_data = 25'b0000000000011110000000000;
                        5'h0E: rom_number_data = 25'b0000000000011110000000000;
                        5'h0F: rom_number_data = 25'b0000000000011110000000000;
                        5'h10: rom_number_data = 25'b0000000000011110000000000;
                        5'h11: rom_number_data = 25'b0000000000011110000000000;
                        5'h12: rom_number_data = 25'b0000000000011110000000000;
                        5'h13: rom_number_data = 25'b0000000000011110000000000;
                        5'h14: rom_number_data = 25'b0000000000011110000000000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end

                4'd2: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000000000000000000000000;
                        5'h06: rom_number_data = 25'b0000111111111111111000000;
                        5'h07: rom_number_data = 25'b0000111111111111111000000;
                        5'h08: rom_number_data = 25'b0000111100000000000000000;
                        5'h09: rom_number_data = 25'b0000111100000000000000000;
                        5'h0A: rom_number_data = 25'b0000111100000000000000000;
                        5'h0B: rom_number_data = 25'b0000111100000000000000000;
                        5'h0C: rom_number_data = 25'b0000111111111111111000000;
                        5'h0D: rom_number_data = 25'b0000111111111111111000000;
                        5'h0E: rom_number_data = 25'b0000111111111111111000000;
                        5'h0F: rom_number_data = 25'b0000000000000001111000000;
                        5'h10: rom_number_data = 25'b0000000000000001111000000;
                        5'h11: rom_number_data = 25'b0000000000000001111000000;
                        5'h12: rom_number_data = 25'b0000000000000001111000000;
                        5'h13: rom_number_data = 25'b0000000000000001111000000;
                        5'h14: rom_number_data = 25'b0000111111111111111000000;
                        5'h15: rom_number_data = 25'b0000111111111111111000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end

                4'd3: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000000000000000000000000;
                        5'h06: rom_number_data = 25'b0000000111111111110000000;
                        5'h07: rom_number_data = 25'b0000001111111111111000000;
                        5'h08: rom_number_data = 25'b0000011100000000011000000;
                        5'h09: rom_number_data = 25'b0000111000000000001100000;
                        5'h0A: rom_number_data = 25'b0000111000000000000000000;
                        5'h0B: rom_number_data = 25'b0000011100000000000000000;
                        5'h0C: rom_number_data = 25'b0000001111111111100000000;
                        5'h0D: rom_number_data = 25'b0000001111111111100000000;
                        5'h0E: rom_number_data = 25'b0000011100000000000000000;
                        5'h0F: rom_number_data = 25'b0000111000000000000000000;
                        5'h10: rom_number_data = 25'b0000111000000000000000000;
                        5'h11: rom_number_data = 25'b0000111000000000001100000;
                        5'h12: rom_number_data = 25'b0000011100000000011000000;
                        5'h13: rom_number_data = 25'b0000001111111111111000000;
                        5'h14: rom_number_data = 25'b0000000111111111110000000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end

                4'd4: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000011111000000000000000;
                        5'h06: rom_number_data = 25'b0000011111100000000000000;
                        5'h07: rom_number_data = 25'b0000011111110000000000000;
                        5'h08: rom_number_data = 25'b0000011111111000000000000;
                        5'h09: rom_number_data = 25'b0000011110111100000000000;
                        5'h0A: rom_number_data = 25'b0000011110011110000000000;
                        5'h0B: rom_number_data = 25'b0000011110001111000000000;
                        5'h0C: rom_number_data = 25'b0000011110000111100000000;
                        5'h0D: rom_number_data = 25'b0000011110000011110000000;
                        5'h0E: rom_number_data = 25'b0001111111111111111000000;
                        5'h0F: rom_number_data = 25'b0001111111111111111100000;
                        5'h10: rom_number_data = 25'b0000011110000000000000000;
                        5'h11: rom_number_data = 25'b0000011110000000000000000;
                        5'h12: rom_number_data = 25'b0000011110000000000000000;
                        5'h13: rom_number_data = 25'b0000011110000000000000000;
                        5'h14: rom_number_data = 25'b0000011110000000000000000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end



                4'd5: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000000000000000000000000;
                        5'h06: rom_number_data = 25'b0000111111111111111000000;
                        5'h07: rom_number_data = 25'b0000111111111111111000000;
                        5'h08: rom_number_data = 25'b0000000000000001111000000;
                        5'h09: rom_number_data = 25'b0000000000000001111000000;
                        5'h0A: rom_number_data = 25'b0000000000000001111000000;
                        5'h0B: rom_number_data = 25'b0000000011111111110000000;
                        5'h0C: rom_number_data = 25'b0000000111111111110000000;
                        5'h0D: rom_number_data = 25'b0000011100000000000000000;
                        5'h0E: rom_number_data = 25'b0000111000000000000000000;
                        5'h0F: rom_number_data = 25'b0000111000000000000000000;
                        5'h10: rom_number_data = 25'b0000111000000000000000000;
                        5'h11: rom_number_data = 25'b0000111000000000000111000;
                        5'h12: rom_number_data = 25'b0000011100000000001110000;
                        5'h13: rom_number_data = 25'b0000001111111111111100000;
                        5'h14: rom_number_data = 25'b0000000111111111110000000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end

                4'd6: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000000000000000000000000;
                        5'h06: rom_number_data = 25'b0000011111111111110000000;
                        5'h07: rom_number_data = 25'b0000111111111111111000000;
                        5'h08: rom_number_data = 25'b0001111000000000111100000;
                        5'h09: rom_number_data = 25'b0001111000000000111100000;
                        5'h0A: rom_number_data = 25'b0000000000000000111100000;
                        5'h0B: rom_number_data = 25'b0000000000000000111100000;
                        5'h0C: rom_number_data = 25'b0000111111111111111100000;
                        5'h0D: rom_number_data = 25'b0001111111111111111100000;
                        5'h0E: rom_number_data = 25'b0001111000000000111100000;
                        5'h0F: rom_number_data = 25'b0001111000000000111100000;
                        5'h10: rom_number_data = 25'b0001111000000000111100000;
                        5'h11: rom_number_data = 25'b0001111000000000111100000;
                        5'h12: rom_number_data = 25'b0001111000000000111100000;
                        5'h13: rom_number_data = 25'b0001111111111111111100000;
                        5'h14: rom_number_data = 25'b0000111111111111111000000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end

                4'd7: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000000000000000000000000;
                        5'h06: rom_number_data = 25'b0000111111111111111100000;
                        5'h07: rom_number_data = 25'b0000111111111111111100000;
                        5'h08: rom_number_data = 25'b0000011100000000000000000;
                        5'h09: rom_number_data = 25'b0000001110000000000000000;
                        5'h0A: rom_number_data = 25'b0000000111000000000000000;
                        5'h0B: rom_number_data = 25'b0000000011100000000000000;
                        5'h0C: rom_number_data = 25'b0000000001110000000000000;
                        5'h0D: rom_number_data = 25'b0000000000111000000000000;
                        5'h0E: rom_number_data = 25'b0000000000011100000000000;
                        5'h0F: rom_number_data = 25'b0000000000001110000000000;
                        5'h10: rom_number_data = 25'b0000000000000111000000000;
                        5'h11: rom_number_data = 25'b0000000000000011100000000;
                        5'h12: rom_number_data = 25'b0000000000000001110000000;
                        5'h13: rom_number_data = 25'b0000000000000000111000000;
                        5'h14: rom_number_data = 25'b0000000000000000011100000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end


                4'd8: begin
                    case (rom_number_row)
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000000000000000000000;
                        5'h03: rom_number_data = 25'b0000000000000000000000000;
                        5'h04: rom_number_data = 25'b0000000000000000000000000;
                        5'h05: rom_number_data = 25'b0000000000000000000000000;
                        5'h06: rom_number_data = 25'b0000000111111111110000000;
                        5'h07: rom_number_data = 25'b0000001111111111111000000;
                        5'h08: rom_number_data = 25'b0000011100000000011100000;
                        5'h09: rom_number_data = 25'b0000111000000000001110000;
                        5'h0A: rom_number_data = 25'b0000111000000000001110000;
                        5'h0B: rom_number_data = 25'b0000011100000000011100000;
                        5'h0C: rom_number_data = 25'b0000001111111111111000000;
                        5'h0D: rom_number_data = 25'b0000001111111111111000000;
                        5'h0E: rom_number_data = 25'b0000011100000000011100000;
                        5'h0F: rom_number_data = 25'b0000111000000000001110000;
                        5'h10: rom_number_data = 25'b0000111000000000001110000;
                        5'h11: rom_number_data = 25'b0000111000000000001110000;
                        5'h12: rom_number_data = 25'b0000011100000000011100000;
                        5'h13: rom_number_data = 25'b0000001111111111111000000;
                        5'h14: rom_number_data = 25'b0000000111111111110000000;
                        5'h15: rom_number_data = 25'b0000000000000000000000000;
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end

                default: begin
                    case (rom_number_row) 
                        5'h00: rom_number_data = 25'b0000000000000000000000000;
                        5'h01: rom_number_data = 25'b0000000000000000000000000;
                        5'h02: rom_number_data = 25'b0000000111111111110000000;
                        5'h03: rom_number_data = 25'b0000001111111111111000000;
                        5'h04: rom_number_data = 25'b0000011111111111111100000;
                        5'h05: rom_number_data = 25'b0000111111111111111110000;
                        5'h06: rom_number_data = 25'b0001111111111111111111000;
                        5'h07: rom_number_data = 25'b0011111111111111111111100; 
                        5'h08: rom_number_data = 25'b0011111111111111111111100; 
                        5'h09: rom_number_data = 25'b0011111111111111111111100; 
                        5'h0A: rom_number_data = 25'b0011111111111111111111100; 
                        5'h0B: rom_number_data = 25'b0011111111111111111111100; 
                        5'h0C: rom_number_data = 25'b0011111111111111111111100; 
                        5'h0D: rom_number_data = 25'b0011111111111111111111100; 
                        5'h0E: rom_number_data = 25'b0011111111111111111111100;
                        5'h0F: rom_number_data = 25'b0011111111111111111111100; 
                        5'h10: rom_number_data = 25'b0011111111111111111111100;
                        5'h11: rom_number_data = 25'b0001111111111111111111000; 
                        5'h12: rom_number_data = 25'b0000111111111111111110000; 
                        5'h13: rom_number_data = 25'b0000011111111111111100000; 
                        5'h14: rom_number_data = 25'b0000001111111111111000000; 
                        5'h15: rom_number_data = 25'b0000000111111111110000000; 
                        5'h16: rom_number_data = 25'b0000000000000000000000000;
                        5'h17: rom_number_data = 25'b0000000000000000000000000;
                        5'h18: rom_number_data = 25'b0000000000000000000000000;
                        
                        default: rom_number_data = 25'b0000000000000000000000000;
                    endcase
                end
            endcase
        end
end 
endmodule