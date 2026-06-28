/**
 * @brief The top module.
 * 
 */


module top 
   (input  logic        CLK100MHZ,      // input clock
    input  logic        CPU_RESETN,     // reset button
    input  logic [15:0] SW,             // 16x input switches

    output logic [15:0] LED,            // LED outputs
    output logic        CA, CB, CC, CD, // 7-segment segment enables
                        CE, CF, CG, DP,
    output logic [7:0]  AN              // 7-segment digit enables
    
    // // vga outputs
    // output logic [3:0]  VGA_R, VGA_G, VGA_B,
    // output logic        VGA_HS, VGA_VS

    // // microphone inputs & controls
    // input  logic        M_CLK, M_DATA, M_LRSEL
    );


    logic [3:0] hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0;
    logic [7:0] digit_en, digit_dp_en;
    
    logic [6:0] seg_bus;
    logic       dp_bus;
    logic [7:0] an_bus;

    logic [15:0] temp;
    logic [3:0]  dec0, dec1, dec2, dec3, dec4;

    always_comb begin
        temp = SW;

        dec4 = temp / 16'd10000;
        temp = temp % 16'd10000;

        dec3 = temp / 16'd1000;
        temp = temp % 16'd1000;

        dec2 = temp / 16'd100;
        temp = temp % 16'd100;

        dec1 = temp / 16'd10;
        dec0 = temp % 16'd10;

        hex0 = dec0;
        hex1 = dec1;
        hex2 = dec2;
        hex3 = dec3;
        hex4 = dec4;
        hex5 = 4'h0;
        hex6 = 4'h0;
        hex7 = 4'h0;
    end

    assign digit_en    = 8'h1F;
    assign digit_dp_en = 8'h00;
    assign LED         = SW;

    EightSevenSegmentDisplays disp (
        .CLOCK_100MHZ(CLK100MHZ),
        .reset(~CPU_RESETN),
        .digit_en(digit_en),
        .HEX7(hex7),
        .HEX6(hex6),
        .HEX5(hex5),
        .HEX4(hex4),
        .HEX3(hex3),
        .HEX2(hex2),
        .HEX1(hex1),
        .HEX0(hex0),
        .digit_dp_en(digit_dp_en),
        .seg_ctrl_enL(seg_bus),
        .dp_ctrl_enL(dp_bus),
        .an_ctrl_enL(an_bus)
    );

    assign {CA, CB, CC, CD, CE, CF, CG} = seg_bus;
    assign DP = dp_bus;
    assign AN = an_bus;

endmodule: top