/**
 * @brief The top module.
 * 
 */

// `default_nettype none

module top 
   (input  logic        CLK100MHZ,      // input clock
    input  logic        CPU_RESETN,     // reset button
    // input  logic [15:0] SW,             // 16x input switches

    // output logic [15:0] LED,            // LED outputs
    // output logic        CA, CB, CC, CD, // 7-segment segment enables
    //                     CE, CF, CG, DP,
    // output logic [7:0]  AN,             // 7-segment digit enables
    
    // outputs to vga
    output logic        VGA_HS, VGA_VS,      // pixel location signals
    output logic [3:0]  VGA_R, VGA_G, VGA_B  // RGB color signals

    // // inputs & controls from microphone 
    // input  logic        M_CLK, M_DATA, M_LRSEL
    );

    // SevenSegmentTestHarness(.*);

    // assume you have a 40 MHz clock source named 'clock_40MHz'.
    // For hardware, replace the clock source with your Clocking Wizard/MMCM output.

	logic clk_40MHz;
	logic clk_locked;

	//clock wizard configured with a 1x and 5x clock
	clk_wiz_0 clk_wiz (
        .clk_in1(CLK100MHZ),
        .clk_out1(clk_40MHz),
        .reset(~CPU_RESETN),
        .locked(clk_locked));

    // instantiate timing
    logic pixel_isblank;
    logic [9:0] pixel_x, pixel_y;
    logic reset;

    assign reset = ~CPU_RESETN | ~clk_locked;
    
    vga_timing vt (
        .clk(clk_40MHz),
        .reset,
        .HS(VGA_HS),
        .VS(VGA_VS),
        .isblank(pixel_isblank),
        .row(pixel_x),
        .col(pixel_y));

    // pattern generator (existing)
    logic [7:0] pix_r8, pix_g8, pix_b8;
    test_pattern_generator tpg (
        .row(pixel_y),
        .col(pixel_x),
        .red(pix_r8),
        .green(pix_g8),
        .blue(pix_b8));

    // map 8-bit color -> 4-bit VGA outputs and gate by video_active

    assign VGA_R = ~pixel_isblank ? pix_r8[7:4] : 4'h0;
    assign VGA_G = ~pixel_isblank ? pix_g8[7:4] : 4'h0;
    assign VGA_B = ~pixel_isblank ? pix_b8[7:4] : 4'h0;

endmodule: top