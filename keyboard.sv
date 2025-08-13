
`timescale 1ns / 1ps

module keyboard (
    input wire clk_pix, sim_rst,
    input wire ps2_clk, ps2_data,
    
    output logic cell_click, right_click,
    output logic [3:0] clicked_cell_x,
    output logic [3:0] clicked_cell_y,
    output logic [3:0] current_x, current_y,  // Vị trí hiện tại để highlight
    output logic restart_game
);

//===========================================
//              PS2 Receiver
//===========================================

wire [31:0] keycode;

PS2Receiver ps2_receiver_unit (
    .clk(clk_pix),
    .kclk(ps2_clk),
    .kdata(ps2_data),
    .keycodeout(keycode)
);

//===========================================
//              Key Codes
//===========================================

localparam [7:0] 
    KEY_A = 8'h1C,      // A - di chuyển trái
    KEY_W = 8'h1D,      // W - di chuyển lên
    KEY_S = 8'h1B,      // S - di chuyển xuống
    KEY_D = 8'h23,      // D - di chuyển phải
    KEY_L = 8'h4B,      // L - click trái
    KEY_R = 8'h2D,      // R - click phải
    KEY_RELEASE = 8'hF0; // Key release prefix

//===========================================
//              Current Position
//===========================================

logic [3:0] pos_x, pos_y;
logic [3:0] pos_x_next, pos_y_next;

always_ff @(posedge clk_pix or posedge sim_rst) begin
    if (sim_rst) begin
        pos_x <= 4'd0;  // Vị trí ban đầu (0,0)
        pos_y <= 4'd0;
    end else begin
        pos_x <= pos_x_next;
        pos_y <= pos_y_next;
    end
end

assign current_x = pos_x;
assign current_y = pos_y;

//===========================================
//              Key Processing
//===========================================

logic [7:0] released_code, pressed_code;
logic negedge_key_pressed_signal;
logic key_pressed_signal, prev_key_pressed_signal;
logic key_released_signal;
logic restart_game_current, restart_game_prev;

always_ff @(posedge clk_pix or posedge sim_rst) begin
    if (sim_rst) begin
        released_code <= 8'b0;
        pressed_code <= 8'b0;
        key_pressed_signal <= 1'b0;
        prev_key_pressed_signal <= 1'b0;
        key_released_signal <= 1'b0;
        restart_game_current <= 1'b0;
        restart_game_prev <= 1'b0;
    end else begin
        released_code <= keycode[7:0];
        
        // Detect key press/release
        if (released_code == KEY_RELEASE) begin
            key_released_signal <= 1'b1;
            prev_key_pressed_signal <= key_pressed_signal;
            key_pressed_signal <= 1'b0;
            pressed_code <= keycode[15:8];
            if (keycode [15:8] == 8'h5A) begin
                restart_game_current <= 1'b0;
                restart_game_prev <= restart_game_current;
            end
        end 
        else begin
            key_pressed_signal <= 1'b1;
            prev_key_pressed_signal <= key_pressed_signal;
            key_released_signal <= 1'b0;
            if (keycode[7:0] == 8'h5A) begin
                restart_game_current <= 1'b1;
            end
        end
    end
end

assign negedge_key_pressed_signal = prev_key_pressed_signal & ~key_pressed_signal;
assign restart_game = restart_game_prev & ~restart_game_current;

//===========================================
//              Movement Logic
//===========================================

always_comb begin
    pos_x_next = pos_x;
    pos_y_next = pos_y;
    
    if (negedge_key_pressed_signal) begin
        case (pressed_code)
            KEY_A: begin // Di chuyển trái
                if (pos_x > 4'd0) begin
                    pos_x_next = pos_x - 1;
                end
                else begin
                    pos_x_next = 4'd0;
                end
            end
            
            KEY_D: begin // Di chuyển phải
                if (pos_x < 4'd14) begin
                    pos_x_next = pos_x + 1;
                end
                else begin
                    pos_x_next = 4'd14;
                end
            end
            
            KEY_W: begin // Di chuyển lên
                if (pos_y > 4'd0) begin
                    pos_y_next = pos_y - 1;
                end
                else begin
                    pos_y_next = 4'd0;
                end
            end
            
            KEY_S: begin // Di chuyển xuống
                if (pos_y < 4'd14) begin
                    pos_y_next = pos_y + 1;
                end
                else begin
                    pos_y_next = 4'd14;
                end
            end
            
            default: begin
                pos_x_next = pos_x;
                pos_y_next = pos_y;
            end
        endcase
    end
end

//===========================================
//              Click Logic - Đã sửa lỗi case incomplete
//===========================================

always_ff @(posedge clk_pix or posedge sim_rst) begin
    if (sim_rst) begin
        cell_click <= 1'b0;
        right_click <= 1'b0;
        clicked_cell_x <= 4'd0;
        clicked_cell_y <= 4'd0;
    end else begin
        cell_click <= 1'b0;
        right_click <= 1'b0;
        
        if (negedge_key_pressed_signal) begin
            case (pressed_code)
                KEY_L: begin // Click trái
                    cell_click <= 1'b1;
                    clicked_cell_x <= pos_x;
                    clicked_cell_y <= pos_y;
                end
                
                KEY_R: begin // Click phải
                    right_click <= 1'b1;
                    clicked_cell_x <= pos_x;
                    clicked_cell_y <= pos_y;
                end
                
                // Thêm các key khác để tránh incomplete case
                KEY_A, KEY_W, KEY_S, KEY_D: begin
                    clicked_cell_x <= pos_x;
                    clicked_cell_y <= pos_y;
                end
                
                default: begin
                    clicked_cell_x <= pos_x;
                    clicked_cell_y <= pos_y;
                end
            endcase
        end
    end
end

//===========================================
//              Debug Display
//===========================================

always @(posedge clk_pix) begin
    if (negedge_key_pressed_signal) begin
        case (pressed_code)
            KEY_A: $display("=== Move Left === Position: (%0d, %0d)", pos_x_next, pos_y_next);
            KEY_D: $display("=== Move Right === Position: (%0d, %0d)", pos_x_next, pos_y_next);
            KEY_W: $display("=== Move Up === Position: (%0d, %0d)", pos_x_next, pos_y_next);
            KEY_S: $display("=== Move Down === Position: (%0d, %0d)", pos_x_next, pos_y_next);
            KEY_L: $display("=== Left Click === Cell: (%0d, %0d)", pos_x, pos_y);
            KEY_R: $display("=== Right Click === Cell: (%0d, %0d)", pos_x, pos_y);
            default: ; // Không làm gì cả
        endcase
    end
end

endmodule