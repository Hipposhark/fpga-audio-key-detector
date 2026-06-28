/**
 * @brief The driver for the 8x seven-segment display on the Nexys A7. Hex
 *        digits are translated to their seven-segment format and displayed
 *        for the right amount of time at the correct time via clock division
 *        and multiplexing.
 */

module EightSevenSegmentDisplays
   (input logic       CLOCK_100MHZ, reset,    // control signals

    // inputs
    input logic [7:0] digit_en,               // enable lines for the digits
    input logic [3:0] HEX7, HEX6, HEX5, HEX4, // input digits to display
                      HEX3, HEX2, HEX1, HEX0,
    input logic [7:0] digit_dp_en,            // enable lines for the digits' 
                                              // decimal points

    // outputs to the nexys a7
    output logic [6:0] seg_ctrl_enL, // the active-low digit segments
                                    // (i.e. {CA, CB, CC, CD, CE, CF, CG})
    output logic       dp_ctrl_enL,  // the active-low decimal point
    output logic [7:0] an_ctrl_enL   // the active-low digits 
    );


    // 1) multiplexes the target display digit around every 0.5 to 1 ms
    logic [16:0] refresh_counter; // tracks the digit   display duration
    logic [2:0]  active_digit;    // tracks the current active digit

    always_ff @(posedge CLOCK_100MHZ) begin
        if (reset) begin
            // zero out the refresh counter & active digit tracker
            refresh_counter <= 17'd0;
            active_digit    <=  3'd0;
        end else begin
            if (refresh_counter == 17'd99999) begin
                // divides clock by 100k cycles
                refresh_counter <= 17'd0;
                active_digit    <= active_digit + 3'd1;
            end else begin
                refresh_counter <= refresh_counter + 17'd1;
            end
        end
    end


    // 2) correctly determines the current target digit's contents and 
    //    correctly populates its decimal point
    logic [3:0] active_hex;
    logic       active_dp;
    logic       active_en;

    always_comb begin
        unique case (active_digit)
            3'd0: begin active_hex = HEX0; active_dp = digit_dp_en[0]; active_en = digit_en[0]; end
            3'd1: begin active_hex = HEX1; active_dp = digit_dp_en[1]; active_en = digit_en[1]; end
            3'd2: begin active_hex = HEX2; active_dp = digit_dp_en[2]; active_en = digit_en[2]; end
            3'd3: begin active_hex = HEX3; active_dp = digit_dp_en[3]; active_en = digit_en[3]; end
            3'd4: begin active_hex = HEX4; active_dp = digit_dp_en[4]; active_en = digit_en[4]; end
            3'd5: begin active_hex = HEX5; active_dp = digit_dp_en[5]; active_en = digit_en[5]; end
            3'd6: begin active_hex = HEX6; active_dp = digit_dp_en[6]; active_en = digit_en[6]; end
            3'd7: begin active_hex = HEX7; active_dp = digit_dp_en[7]; active_en = digit_en[7]; end
        endcase
    end

    // 3) correctly populates the target digit's seven segment contents
    //    - segment is active high and the order is {a,b,c,d,e,f,g}
    logic [6:0] seg_pattern;

    always_comb begin
        unique case (active_hex)
            4'h0: seg_pattern = 7'b1111110;
            4'h1: seg_pattern = 7'b0110000;
            4'h2: seg_pattern = 7'b1101101;
            4'h3: seg_pattern = 7'b1111001;
            4'h4: seg_pattern = 7'b0110011;
            4'h5: seg_pattern = 7'b1011011;
            4'h6: seg_pattern = 7'b1011111;
            4'h7: seg_pattern = 7'b1110000;
            4'h8: seg_pattern = 7'b1111111;
            4'h9: seg_pattern = 7'b1111011;
            4'hA: seg_pattern = 7'b1110111;
            4'hB: seg_pattern = 7'b0011111;
            4'hC: seg_pattern = 7'b1001110;
            4'hD: seg_pattern = 7'b0111101;
            4'hE: seg_pattern = 7'b1001111;
            4'hF: seg_pattern = 7'b1000111;
        endcase
    end

    // 4) drive the board pins
    always_comb begin
        an_ctrl_enL  = 8'b11111111; // all digits off
        seg_ctrl_enL = 7'b1111111;  // all segments off
        dp_ctrl_enL  = 1'b1;        // dp off

        if (active_en) begin
            an_ctrl_enL[active_digit] = 1'b0; // enable one digit
            seg_ctrl_enL = ~seg_pattern;      // invert to active-low
            if (active_dp) dp_ctrl_enL = 1'b0;
        end
    end

    //
endmodule : EightSevenSegmentDisplays