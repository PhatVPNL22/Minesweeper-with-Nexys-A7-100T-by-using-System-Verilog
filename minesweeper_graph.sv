
`timescale 1ns / 1ps

module minesweeper_graph (
    input wire clk_pix, sim_rst,
    input wire video_on,
    input wire [9:0] pixel_x, pixel_y,
    input logic cell_revealed_out [0:14][0:14],
    input logic flag_revealed_out [0:14][0:14],
    input logic [3:0] current_x, current_y,  // Vị trí cursor hiện tại
    input logic restart_game,
    output logic [2:0] graph_rgb,
    output logic [3:0] data_minesweeper [0:224]
);

    //===========================================
    //              Create Grid
    //===========================================

    localparam TOP_BORDER = 50;
    localparam L_BORDER = 50;
    localparam R_BORDER = 455;
    localparam BOTTOM_BORDER = 455;
    localparam GRID_SIZE = 27;

    // Grid area bounds
    wire in_grid_area = (pixel_x >= L_BORDER && pixel_x <= R_BORDER) &&
                        (pixel_y >= TOP_BORDER && pixel_y <= BOTTOM_BORDER);

    // Outside game area
    wire outside_area = (pixel_x < L_BORDER - 5) || (pixel_x > R_BORDER + 5) ||
                        (pixel_y < TOP_BORDER - 5) || (pixel_y > BOTTOM_BORDER + 5);

    // Simplified grid lines - same approach as working graph.sv
    wire [9:0] x_offset = pixel_x - L_BORDER;
    wire [9:0] y_offset = pixel_y - TOP_BORDER;
    
    // Draw grid lines every 27 pixels (simplified comparison)
    wire h_grid_line = in_grid_area && 
                      ((y_offset == 0) || (y_offset == 27) || (y_offset == 54) || 
                       (y_offset == 81) || (y_offset == 108) || (y_offset == 135) ||
                       (y_offset == 162) || (y_offset == 189) || (y_offset == 216) ||
                       (y_offset == 243) || (y_offset == 270) || (y_offset == 297) ||
                       (y_offset == 324) || (y_offset == 351) || (y_offset == 378) ||
                       (y_offset == 405));
                       
    wire v_grid_line = in_grid_area && 
                      ((x_offset == 0) || (x_offset == 27) || (x_offset == 54) || 
                       (x_offset == 81) || (x_offset == 108) || (x_offset == 135) ||
                       (x_offset == 162) || (x_offset == 189) || (x_offset == 216) ||
                       (x_offset == 243) || (x_offset == 270) || (x_offset == 297) ||
                       (x_offset == 324) || (x_offset == 351) || (x_offset == 378) ||
                       (x_offset == 405));

    //===========================================
    //              Data map
    //===========================================

    logic [3:0] internal_data_minesweeper [0:14][0:14] = '{
        '{  1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 2,10},
        '{  1,10, 2, 1, 0, 1, 2,10, 2, 1, 0, 1, 2,10, 2},
        '{  1, 2,10, 2, 2, 2,10, 3,10, 2, 2, 2,10, 2, 1},
        '{  0, 1, 2,10, 3,10, 3, 4, 3,10, 3,10, 2, 1, 0},
        '{  0, 0, 1, 2,10, 4,10, 3,10, 4,10, 2, 1, 0, 0},
        '{  1, 1, 1, 1, 3,10, 4,10, 4,10, 3, 1, 1, 1, 1},
        '{  1,10, 1, 0, 2,10, 4, 3, 4,10, 2, 0, 1,10, 1},
        '{  2, 2, 2, 0, 2, 3,10, 2,10, 3, 2, 0, 2, 2, 2},
        '{  1,10, 1, 0, 2,10, 4, 3, 4,10, 2, 0, 1,10, 1},
        '{  1, 1, 1, 1, 3,10, 4,10, 4,10, 3, 1, 1, 1, 1},
        '{  0, 0, 1, 2,10, 4,10, 3,10, 4,10, 2, 1, 0, 0},
        '{  0, 1, 2,10, 3,10, 3, 4, 3,10, 3,10, 2, 1, 0},
        '{  1, 2,10, 2, 2, 2,10, 3,10, 2, 2, 2,10, 2, 1},
        '{  2,10, 2, 1, 0, 1, 2,10, 2, 1, 0, 1, 2,10, 1},
        '{ 10, 2, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1}
    };

    task automatic convert_2d_to_1d(input logic [3:0] internal_data_minesweeper [0:14][0:14], output logic [3:0] data_minesweeper[0:224]);
        int index = 0;
        for(int i = 0; i < 15; i++) begin
            for(int j = 0; j < 15; j++) begin
                data_minesweeper[index] = internal_data_minesweeper[i][j];
                index = index + 1;
            end
        end
    endtask

    always_ff @( posedge clk_pix or posedge sim_rst ) begin
        if (sim_rst || restart_game) begin
            convert_2d_to_1d(internal_data_minesweeper, data_minesweeper);
        end
    end

    //===========================================
    //              Tính toán cell hiện tại
    //===========================================

    // Tính toán cell hiện tại dựa trên pixel position
    logic [4:0] rom_number_row, rom_number_col;
    logic [24:0] rom_number_data;
    logic rom_number_bit;
    logic number_on, sq_number_on;

    // Xác định cell hiện tại (từ 0 đến 14)
    // Phần khai báo biến trung gian
    logic [3:0] cell_x, cell_y;
    logic [9:0] temp_cell_x, temp_cell_y;
    logic [9:0] temp_row, temp_col;
    logic [3:0] current_cell_data;
    logic current_cell_revealed;

    // Tính toán cell hiện tại
    assign temp_cell_x = (pixel_x - L_BORDER) / GRID_SIZE;
    assign temp_cell_y = (pixel_y - TOP_BORDER) / GRID_SIZE;

    assign cell_x = in_grid_area ? temp_cell_x[3:0] : 4'hF;
    assign cell_y = in_grid_area ? temp_cell_y[3:0] : 4'hF;
 
    // Tính toán position trong cell
    assign temp_row = (pixel_y - TOP_BORDER) % GRID_SIZE;
    assign temp_col = (pixel_x - L_BORDER) % GRID_SIZE;

    assign rom_number_row = temp_row[4:0];
    assign rom_number_col = temp_col[4:0];

    // Lấy dữ liệu của cell hiện tại
    assign current_cell_data = (cell_x < 15 && cell_y < 15) ? data_minesweeper[cell_y * 15 + cell_x] : 4'h9;
    assign current_cell_revealed = (cell_x < 15 && cell_y < 15) ? cell_revealed_out[cell_y][cell_x] : 1'b0;

    // Kiểm tra pixel có nằm trong cell hợp lệ và cell đã được revealed
    assign sq_number_on = in_grid_area && current_cell_revealed;
    assign rom_number_bit = rom_number_data[rom_number_col];
    assign number_on = sq_number_on && (rom_number_bit || current_cell_data == 4'd0);

    //===========================================
    //              Flag processing
    //===========================================

    logic sq_flag_on, flag_on;
    logic rom_flag_bit;
    
    assign sq_flag_on = in_grid_area && (!cell_revealed_out[cell_y][cell_x]) && flag_revealed_out[cell_y][cell_x];
    assign rom_flag_bit = rom_number_data[rom_number_col];
    assign flag_on = sq_flag_on && rom_flag_bit;

    //===========================================
    //              Cursor Highlight - Đã sửa lỗi width
    //===========================================
    
    logic cursor_highlight;
    logic [9:0] cursor_cell_left, cursor_cell_right, cursor_cell_top, cursor_cell_bottom;
    
    // Tính toán vùng của cell được chọn - Sửa lỗi width expansion
    assign cursor_cell_left = L_BORDER + ({6'b0, current_x} * GRID_SIZE);
    assign cursor_cell_right = L_BORDER + ({6'b0, current_x} + 10'd1) * GRID_SIZE - 10'd1;
    assign cursor_cell_top = TOP_BORDER + ({6'b0, current_y} * GRID_SIZE);
    assign cursor_cell_bottom = TOP_BORDER + ({6'b0, current_y} + 10'd1) * GRID_SIZE - 10'd1;
    
    // Kiểm tra pixel có nằm ở viền của cell được chọn không
    logic cursor_border;
    assign cursor_border = in_grid_area && (cell_x == current_x && cell_y == current_y) &&
                          ((temp_row <= 2) || (temp_row >= GRID_SIZE - 3) || 
                           (temp_col <= 2) || (temp_col >= GRID_SIZE - 3));

    //===========================================
    //              ROM cho các số
    //===========================================

    bit_map_data bit_map_data_unit
    (
        .current_cell_data(current_cell_data),
        .rom_number_row(rom_number_row),
        .bit_map(rom_number_data),
        .sq_flag_on(sq_flag_on)
    );

    //===========================================
    //              Display all objects
    //===========================================

    always_comb begin
        if (!video_on) begin
            graph_rgb = 3'b000;  // Black when video off
        end
        else if (h_grid_line || v_grid_line) begin
            graph_rgb = 3'b000;  // Black grid lines
        end
        else if (outside_area) begin
            graph_rgb = 3'b000;  // Black outside area
        end
        else if (cursor_border) begin
            graph_rgb = 3'b010;  // Green border for cursor
        end
        else if (restart_game) begin
            graph_rgb = 3'b110;
        end
        else if (flag_on) begin
            graph_rgb = 3'b001;  // ĐỎ cho cờ (sửa từ 3'b100 thành 3'b001)
        end
        else if (number_on) begin
            if(current_cell_data == 4'd10) begin
                graph_rgb = 3'b001;  // ĐỎ cho mine (sửa từ 3'b100 thành 3'b001)
            end
            else if (current_cell_data == 4'd0) begin
                graph_rgb = 3'b111;  // White for empty cell
            end
            else begin
                graph_rgb = 3'b100;  // XANH DƯƠNG cho số (sửa từ 3'b001 thành 3'b100)
            end
        end
        else begin
            graph_rgb = 3'b110;  // Yellow for unrevealed cells
        end
    end
endmodule