
`timescale 1ns / 1ps

module game_play (
    input logic clk_pix, sim_rst,
    input wire cell_click, right_click,
    input logic [3:0] clicked_cell_x,
    input logic [3:0] clicked_cell_y,
    input logic [3:0] data_minesweeper [0:224],
    input logic restart_game,

    output logic cell_revealed_out [0:14][0:14],
    output logic flag_revealed_out [0:14][0:14]
);

    //===========================================
    //              Bản đồ đáp án
    //===========================================

    logic [7:0] correct_cells, correct_flags;

    //===========================================
    //      Xử lý tín hiệu reveal của mỗi ô
    //===========================================

    logic cell_revealed [0:14][0:14];
    logic flag_revealed [0:14][0:14];
    
    assign cell_revealed_out = cell_revealed;
    assign flag_revealed_out = flag_revealed;

    //===========================================
    //      Xử lý các trạng thái game play
    //===========================================

    localparam [2:0]
    IDLE          = 3'b000,
    PROCESSING_CELL = 3'b001,
    FLAG          = 3'b010,
    BLANK_CELL    = 3'b011,
    GAME_OVER     = 3'b100,
    GAME_WIN      = 3'b101,
    FLOOD_FILL    = 3'b110;

	reg [2:0] state_reg, state_next;
    logic game_over, game_win, game_processing_cell, game_flag;
    logic clicked_blank_cell;

    logic [3:0] stack_x_blank [0:224];
    logic [3:0] stack_y_blank [0:224];
    logic [3:0] current_flood_fill_x;
    logic [3:0] current_flood_fill_y;
    logic [3:0] current_clicked_cell_x, current_clicked_cell_y;
    logic [3:0] neighbor_i, neighbor_j;
    int top_index, local_top_index;
    logic flood_fill_done;
    logic processing_neighbors;

    always_ff @( posedge clk_pix or posedge sim_rst ) begin
        if (sim_rst || restart_game) begin
            state_reg <= IDLE;
        end
        else begin
            state_reg <= state_next;
        end
    end

    always_ff @( posedge clk_pix or posedge sim_rst ) begin
        if (sim_rst || restart_game) begin
            top_index <= -1;
            neighbor_i <= 0;
            neighbor_j <= 0;
            correct_cells = 0;
            correct_flags = 0;
            clicked_blank_cell <= 0;
            game_over <= 0;
            game_flag <= 0;
            game_processing_cell <= 0;
            flood_fill_done <= 1'b1;
            processing_neighbors <= 1'b0;
            for (int i = 0; i < 15; i++) begin
                for (int j = 0; j < 15; j++) begin
                    cell_revealed[j][i] <= 0;
                    flag_revealed[j][i] <= 0;
                end
            end
            for (int i = 0; i < 15; i++) begin
                for (int j = 0; j < 15; j++) begin
                    if (data_minesweeper[i * 15 + j] == 4'd10) begin
                        correct_flags = correct_flags + 1;
                    end
                    else if (data_minesweeper[i * 15 + j] != 4'd10) begin
                        correct_cells = correct_cells + 1;
                    end
                end
            end
        end

        else begin
            local_top_index = top_index;
            if (state_reg == IDLE) begin
                if (cell_click && clicked_cell_x < 15 && clicked_cell_y < 15 && cell_revealed[clicked_cell_y][clicked_cell_x] == 1'b0) begin
                    if (flag_revealed[clicked_cell_y][clicked_cell_x] == 1'b0) begin
                        cell_revealed[clicked_cell_y][clicked_cell_x] <= 1'b1;
                        correct_cells = correct_cells - 1;
                        if (data_minesweeper[clicked_cell_y * 15 + clicked_cell_x] == 4'd0) begin
                            clicked_blank_cell <= 1'b1;
                        end
                        else if (data_minesweeper[clicked_cell_y * 15 + clicked_cell_x] == 4'd10) begin
                            game_over <= 1'b1;
                        end
                    end
                    game_processing_cell <= 1'b1;
                end
                else if (right_click && clicked_cell_x < 15 && clicked_cell_y < 15 && cell_revealed[clicked_cell_y][clicked_cell_x] == 1'b0) begin
                    if (flag_revealed[clicked_cell_y][clicked_cell_x] == 1'b1) begin
                        flag_revealed[clicked_cell_y][clicked_cell_x] <= 1'b0;
                        correct_flags = correct_flags + 1;
                    end
                    else if (flag_revealed[clicked_cell_y][clicked_cell_x] == 1'b0) begin
                        flag_revealed[clicked_cell_y][clicked_cell_x] <= 1'b1;
                        correct_flags = correct_flags - 1;
                    end
                    game_flag <= 1'b1;
                end
            end

            else begin
                game_processing_cell <= 1'b0;
                game_flag <= 1'b0;
                clicked_blank_cell <= 1'b0;

                if (state_reg == PROCESSING_CELL) begin
                    if (state_next == BLANK_CELL) begin
                        processing_neighbors <= 1'b1;
                        neighbor_i <= 0;
                        neighbor_j <= 0;
                        flood_fill_done <= 1'b0;
                    end
                end

                else if (state_reg == BLANK_CELL) begin
                    if (processing_neighbors) begin
                        current_clicked_cell_x = (clicked_cell_x > 0 ? clicked_cell_x - 1 : 0) + neighbor_i;
                        current_clicked_cell_y = (clicked_cell_y > 0 ? clicked_cell_y - 1 : 0) + neighbor_j;
                        
                        if (current_clicked_cell_x <= 4'd14 && current_clicked_cell_y <= 4'd14) begin
                            if (!(current_clicked_cell_x == clicked_cell_x && current_clicked_cell_y == clicked_cell_y)) begin
                                if (data_minesweeper[current_clicked_cell_y * 15 + current_clicked_cell_x] == 4'd0 && cell_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b0) begin // blank cell
                                    if (flag_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b1) begin
                                        flag_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b0;
                                        correct_flags = correct_flags + 1;
                                    end
                                    cell_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b1;
                                    correct_cells = correct_cells - 1;
                                    local_top_index = local_top_index + 1;
                                    stack_x_blank[local_top_index] = current_clicked_cell_x;
                                    stack_y_blank[local_top_index] = current_clicked_cell_y;
                                end else if (data_minesweeper[current_clicked_cell_y * 15 + current_clicked_cell_x] != 4'd10) begin // number
                                    if(cell_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b0) begin
                                        if (flag_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b1) begin
                                            flag_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b0;
                                            correct_flags = correct_flags + 1;
                                        end
                                        cell_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b1;
                                        correct_cells = correct_cells - 1;
                                    end
                                end 
                            end
                        end
                        
                        top_index <= local_top_index;
                        if (neighbor_j == 4'd2) begin
                            if (neighbor_i == 4'd2) begin
                                processing_neighbors <= 1'b0;
                                flood_fill_done <= 1'b1;
                                neighbor_i <= 0;
                                neighbor_j <= 0;
                            end
                            else begin
                                neighbor_i <= neighbor_i + 1;
                                neighbor_j <= 0;
                            end
                        end
                        else begin
                            neighbor_j <= neighbor_j + 1;
                        end
                    end
                end

                else if (state_reg == FLOOD_FILL) begin
                    if (top_index >= 0 && !processing_neighbors) begin
                        current_flood_fill_x = stack_x_blank[top_index];
                        current_flood_fill_y = stack_y_blank[top_index];
                        top_index <= top_index - 1;
                        local_top_index = top_index - 1;
                        
                        processing_neighbors <= 1'b1;
                        neighbor_i <= 0;
                        neighbor_j <= 0;
                        flood_fill_done <= 1'b0;
                    end
                    else if (processing_neighbors) begin
                        current_clicked_cell_x = (current_flood_fill_x > 0 ? current_flood_fill_x - 1 : 0) + neighbor_i;
                        current_clicked_cell_y = (current_flood_fill_y > 0 ? current_flood_fill_y - 1 : 0) + neighbor_j;
                        
                        if (current_clicked_cell_x <= 4'd14 && current_clicked_cell_y <= 4'd14) begin
                            if (!(current_clicked_cell_x == current_flood_fill_x && current_clicked_cell_y == current_flood_fill_y)) begin
                                if (data_minesweeper[current_clicked_cell_y * 15 + current_clicked_cell_x] == 4'd0 && cell_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b0) begin // blank cell
                                    if (flag_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b1) begin
                                        flag_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b0;
                                        correct_flags = correct_flags + 1;
                                    end
                                    cell_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b1;
                                    correct_cells = correct_cells - 1;
                                    local_top_index = local_top_index + 1;
                                    stack_x_blank[local_top_index] = current_clicked_cell_x;
                                    stack_y_blank[local_top_index] = current_clicked_cell_y;
                                end else if (data_minesweeper[current_clicked_cell_y * 15 + current_clicked_cell_x] != 4'd10) begin // number
                                    if(cell_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b0) begin
                                        if (flag_revealed[current_clicked_cell_y][current_clicked_cell_x] == 1'b1) begin
                                            flag_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b0;
                                            correct_flags = correct_flags + 1;
                                        end
                                        cell_revealed[current_clicked_cell_y][current_clicked_cell_x] <= 1'b1;
                                        correct_cells = correct_cells - 1;
                                    end
                                end 
                            end
                        end
                        
                        top_index <= local_top_index;
                        if (neighbor_j == 4'd2) begin
                            if (neighbor_i == 4'd2) begin
                                processing_neighbors <= 1'b0;
                                flood_fill_done <= 1'b1;
                                neighbor_i <= 0;
                                neighbor_j <= 0;
                            end
                            else begin
                                neighbor_i <= neighbor_i + 1;
                                neighbor_j <= 0;
                            end
                        end
                        else begin
                            neighbor_j <= neighbor_j + 1;
                        end
                    end
                    else begin
                        flood_fill_done <= 1'b1;
                    end
                end
            end
        end
    end

    assign game_win = (correct_cells == 0) && (correct_flags == 0);

    always_comb begin
        state_next = state_reg;

        case (state_reg)
            IDLE: begin
                if (game_win) begin
                    state_next = GAME_WIN;
                end
                else begin
                    if (game_processing_cell) begin
                        state_next = PROCESSING_CELL;
                    end
                    else if (game_flag) begin
                        state_next = FLAG;
                    end
                    else begin
                        state_next = IDLE;
                    end
                end
            end

            PROCESSING_CELL: begin
                if (game_over) begin
                    state_next = GAME_OVER;
                end
                else begin
                    if (clicked_blank_cell) begin
                        state_next = BLANK_CELL;
                    end
                    else begin
                        state_next = IDLE;
                    end
                end
            end

            FLAG: begin
                state_next = IDLE;
            end

            BLANK_CELL: begin
                if (!processing_neighbors && flood_fill_done) begin
                    if (top_index >= 0) begin
                        state_next = FLOOD_FILL;
                    end
                    else begin
                        state_next = IDLE;
                    end
                end
                else begin
                    state_next = BLANK_CELL;
                end
            end

            FLOOD_FILL: begin
                if (!processing_neighbors && flood_fill_done && top_index < 0) begin
                    state_next = IDLE;
                end
                else begin
                    state_next = FLOOD_FILL;
                end
            end

            GAME_OVER: begin
                if (game_over) begin
                    state_next = GAME_OVER;
                end

                if (restart_game) begin
                    state_next = IDLE;
                end
            end

            GAME_WIN: begin
                if (game_win) begin
                    state_next = GAME_WIN;
                end

                if (restart_game) begin
                    state_next = IDLE;
                end
            end
            default: state_next = IDLE;
        endcase
    end

endmodule