/**
 * @brief A parameterized multi-bar component used to display dynamic values.
 *
 * The dynamic bars is useful for visualizing data, especially for debugging.
 *
 */

module dynamic_bars
  #(parameter logic [4:0] NUM_BARS = 5'd1,

    parameter logic [9:0] GRAPH_X      =  10'd40,
    parameter logic [9:0] GRAPH_Y      =  10'd80,
    parameter logic [9:0] GRAPH_WIDTH  = 10'd560,
    parameter logic [9:0] GRAPH_HEIGHT = 10'd320,

    parameter logic [9:0] BAR_GAP = 10'd4
  )(// inputs from vga
    input  logic       isblank,
    input  logic [9:0] row, col,

    // byte values to be displayed on the bars
    input  logic [7:0] bar_vals [NUM_BARS],

    // outputs to vga
    output logic [3:0] vga_r, vga_g, vga_b );

    localparam logic [9:0] BAR_SLOT_WIDTH = GRAPH_WIDTH / NUM_BARS;
    localparam logic [9:0] BAR_WIDTH      = BAR_SLOT_WIDTH - BAR_GAP;

    logic [9:0] fill_height, fill_brim;
    logic [7:0] bar_val;

    logic [17:0] temp;

    always_comb begin
        // default values
        {vga_r, vga_g, vga_b} = 12'h000;
        fill_height    = 10'd0;
        fill_brim      = 10'd0;
        bar_val        =  8'd0;

        if (!isblank) begin
            // fill in the graph's buckets
            if ((col >= GRAPH_X && col < GRAPH_X + GRAPH_WIDTH &&
                 row >= GRAPH_Y && row < GRAPH_Y + GRAPH_HEIGHT))
                
                // we are inside the graph, and now iterate through the bars to fill
                for (logic [9:0] i = '0; i < NUM_BARS; i++)
                    // check if we are between a column
                    if (col >= GRAPH_X + i * BAR_SLOT_WIDTH &&
                        col <  GRAPH_X + i * BAR_SLOT_WIDTH + BAR_WIDTH) begin

                        bar_val = bar_vals[i];

                        // the bar fills upward
                        if (bar_val == 8'hFF)
                            fill_height = GRAPH_HEIGHT;
                        else begin
                            temp        = bar_val * GRAPH_HEIGHT;
                            fill_height = temp >> 8;
                        end

                        fill_brim = GRAPH_Y + GRAPH_HEIGHT - fill_height;

                        if (row >= fill_brim && row < GRAPH_Y + GRAPH_HEIGHT)
                            {vga_r, vga_g, vga_b} = 12'hFFF;
                    end

            // draw the bar border
            if ((col >= GRAPH_X && col  < GRAPH_X + GRAPH_WIDTH  &&
                (row == GRAPH_Y || row == GRAPH_Y + GRAPH_HEIGHT - 1)) ||
                (row >= GRAPH_Y && row  < GRAPH_Y + GRAPH_HEIGHT &&
                (col == GRAPH_X || col == GRAPH_X + GRAPH_WIDTH - 1))) 
                {vga_r, vga_g, vga_b} = 12'hFFF;
        end
    end
endmodule: dynamic_bars
