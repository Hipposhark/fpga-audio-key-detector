/**
 * @brief The VGA rendering driver for a 800x600 monitor 
 * 
 * vga_renderer composes the desired visual components on the VGA and
 * orchestrates their timings 
 */

module vga_renderer (
    input  logic       isblank,
    input  logic [9:0] row, col,

    output logic [3:0] vga_r, vga_g, vga_b
);

    always_comb begin : pixel_rgb_comb
        {vga_r, vga_g, vga_b} = 12'h000;

        if (!isblank) begin
            // White border
            if (col < 10 || col >= 790 || row < 10 || row >= 590)
                {vga_r, vga_g, vga_b} = 12'hFFF;

            // Red vertical bar
            else if (col >= 100 && col < 200)
                {vga_r, vga_g, vga_b} = 12'hF00;

            // Green vertical bar
            else if (col >= 250 && col < 350)
                {vga_r, vga_g, vga_b} = 12'h0F0;

            // Blue vertical bar
            else if (col >= 400 && col < 500)
                {vga_r, vga_g, vga_b} = 12'h00F;
        end
        
    end : pixel_rgb_comb

endmodule: vga_renderer