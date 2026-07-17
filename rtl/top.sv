/**
 * @brief The top module.
 * 
 * vcs command: 
 */

// `default_nettype none

module top 
   (input  logic        CLK100MHZ,      // input clock
    input  logic        CPU_RESETN,     // reset button
    input  logic [15:0] SW,             // 16x input switches

    output logic [15:0] LED,            // LED outputs
    output logic        CA, CB, CC, CD, // 7-segment segment enables
                        CE, CF, CG, DP,
    output logic [7:0]  AN,             // 7-segment digit enables
    
    // outputs to vga
    output logic        VGA_HS, VGA_VS,      // pixel location signals
    output logic [3:0]  VGA_R, VGA_G, VGA_B // RGB color signals

    // // inputs & controls from microphone 
    // input  logic        M_CLK, M_DATA, M_LRSEL
    );

    SevenSegmentTestHarness(.*);

	logic clk_40MHz;
	logic clk_locked;

	// generate the vga clock with a clock wizard
	clk_wiz_0 clk_wiz (.clk_in1(CLK100MHZ),
                       .clk_out1(clk_40MHz),
                       .reset(~CPU_RESETN),
                       .locked(clk_locked));
    
    // generate the input mic clock by dividing the vga clock
    // logic [3:0] mic_clk_div;
    logic [15:0] mic_clk_div; // 1 hz
    logic       clk_2MHz;

    always_ff @(posedge clk_40MHz)
        if (reset) begin
            mic_clk_div <= '0;
            clk_2MHz    <= '0;
        end else
            // if (mic_clk_div ==  4'd9) begin
                // mic_clk_div <=  4'd0;
            if (mic_clk_div ==  16'd20_000) begin
                mic_clk_div <=  '0;
                clk_2MHz    <= ~clk_2MHz;
            end else
                mic_clk_div <= mic_clk_div + '1;

    // assign M_CLK   = clk_2MHz;
    // assign M_LRSEL = 1'b0;


    // instantiate vga timing
    logic [9:0] col,     row;
    logic       isblank, reset;

    assign reset = ~CPU_RESETN | ~clk_locked;
    
    vga_timing vt (
        .clk(clk_40MHz),
        .reset,
        .HS(VGA_HS),
        .VS(VGA_VS),
        .isblank,
        .row,
        .col);

    

    // logic [7:0] mic_level;
    // logic       mic_level_valid;

    // pdm_level #(
    //     .ACCUM_BITS(8)
    // ) pdm_level_inst (
    //     .clk(mic_clk),
    //     .reset(reset),
    //     .pdm_data(M_DATA),
    //     .level(mic_level),
    //     .level_valid(mic_level_valid)
    // );
    
    // instantiate moving bars
    logic [7:0] count;
    Counter #(8) counter(.D('0),
                         .Q(count),
                         .clock(clk_2MHz),
                         .en('1),
                         .clear('0),
                         .load('0),
                         .up('1));

    logic [7:0] bar_vals[16];
    always_comb begin
        bar_vals[0] = SW[7:0];

        for (logic [7:0] i = 8'd1; i < 8'd16; i++)
            bar_vals[i] = count;
    end

    dynamic_bars #(.NUM_BARS(5'd16),
                   .GRAPH_X(10'd100),
                   .GRAPH_Y(10'd80),
                   .GRAPH_WIDTH(10'd560),
                   .GRAPH_HEIGHT(10'd320),
                   .BAR_GAP(10'd4))
                   db (.isblank,
                       .col,
                       .row,
                       .bar_vals,
                       .vga_r(VGA_R),
                       .vga_g(VGA_G),
                       .vga_b(VGA_B));

endmodule: top
