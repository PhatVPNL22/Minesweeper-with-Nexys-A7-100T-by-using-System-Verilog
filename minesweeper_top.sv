module minesweeper_top (
    input wire clk_100MHz, sim_rst,  // Changed to match vga_top.sv
    // PS/2 interface cho bàn phím
    input wire ps2_clk, ps2_data,
    // VGA outputs - changed to match vga_top.sv
    output logic [11:0] rgb,  // 12-bit RGB output
    output logic hsync, vsync
);

//===========================================
//              VGA signals
//===========================================

logic [9:0] pixel_x, pixel_y;
wire pixel_tick, video_on;
logic [2:0] rgb_reg;      // Keep 3-bit for minesweeper_graph
logic [2:0] rgb_next;     // Keep 3-bit for minesweeper_graph
logic [11:0] rgb_12bit;   // 12-bit for output

// VGA controller module (replaces vga_sync) - same as vga_top.sv
vga_controller vga_controller_unit (
    .clk_100MHz(clk_100MHz),
    .reset(sim_rst),
    .hsync(hsync),
    .vsync(vsync),
    .video_on(video_on),
    .p_tick(pixel_tick),
    .x(pixel_x),
    .y(pixel_y)
);

//===========================================
//              Module keyboard (thay thế mouse)
//===========================================

wire cell_click, right_click;
wire [3:0] clicked_cell_x, clicked_cell_y;
wire [3:0] current_x, current_y;
logic restart_game;

keyboard keyboard_unit (
    .clk_pix(clk_pix),
    .sim_rst(sim_rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .cell_click(cell_click),
    .right_click(right_click),
    .clicked_cell_x(clicked_cell_x),
    .clicked_cell_y(clicked_cell_y),
    .current_x(current_x),
    .current_y(current_y),
    .restart_game(restart_game)
);

//===========================================
//              Module game_play
//===========================================

logic cell_revealed_out [0:14][0:14];
logic flag_revealed_out [0:14][0:14];

game_play game_play_unit (
    .clk_pix(clk_pix),
    .sim_rst(sim_rst),
    .clicked_cell_x(clicked_cell_x),
    .clicked_cell_y(clicked_cell_y),
    .cell_revealed_out(cell_revealed_out),
    .flag_revealed_out(flag_revealed_out),
    .cell_click(cell_click),
    .right_click(right_click),
    .data_minesweeper(data_minesweeper),
    .restart_game(restart_game)
);

//===========================================
//              Background
//===========================================

logic [3:0] data_minesweeper [0:224];

minesweeper_graph minesweeper_graph_unit (
    .clk_pix(clk_pix),
    .sim_rst(sim_rst),
    .video_on(video_on),
    .pixel_x(pixel_x),
    .pixel_y(pixel_y),
    .graph_rgb(rgb_next),  // Still 3-bit output from minesweeper_graph
    .cell_revealed_out(cell_revealed_out),
    .flag_revealed_out(flag_revealed_out),
    .data_minesweeper(data_minesweeper),
    .current_x(current_x),
    .current_y(current_y),
    .restart_game(restart_game)
);

// RGB buffer register - similar to vga_top.sv implementation
always_ff @(posedge clk_100MHz or posedge sim_rst) begin
    if (sim_rst)
        rgb_reg <= 3'b0;
    else if (pixel_tick)  // Only update on pixel tick (25MHz enable)
        rgb_reg <= rgb_next;
end

// Convert 3-bit RGB to 12-bit RGB for output - same expansion as before
always_comb begin
    rgb_12bit[11:8] = (video_on && rgb_reg[2]) ? 4'hF : 4'h0;  // Red
    rgb_12bit[7:4]  = (video_on && rgb_reg[1]) ? 4'hF : 4'h0;  // Green  
    rgb_12bit[3:0]  = (video_on && rgb_reg[0]) ? 4'hF : 4'h0;  // Blue
end

// Output assignments for 12-bit RGB - using converted register
assign rgb = rgb_12bit;

endmodule