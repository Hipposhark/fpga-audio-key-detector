/**
 * @brief The VGA timing driver for a 800x600 monitor 
 */

module vga_timing
   (input  logic       clk, reset,
    output logic       HS,  VS, isblank,
    output logic [9:0] row, col);

    logic clear;
    Synchronizer resetSync(.async(reset), .clock(clk), .sync(clear));


    // handle horizontal timing
    logic [10:0] hsTime;
    logic        HS_disp, newRow;
 
    Counter #(11)   hsCounter(.en('1), .up('1), .clear, .clock(clk),
        /* increments the    */ .D('0),  .load(newRow),
        /* HS clock          */ .Q(hsTime));

    Counter #(10)   colCounter(.en(HS_disp), .up('1), .clear, .clock(clk),
        /* counts the screen  */ .D('0),       .load(~HS_disp),
        /* column position    */ .Q(col));

    RangeCheck #(11)
        // outputs HS by checking if 128 <= hsTime <= 1056
        hsChecker(.low(11'd128), .val(hsTime), .high(11'd1056), 
                  .is_between(HS)),
        // outputs HS_disp by checking if 216 <= hsTime < 1016
        hsdispChecker(.low(11'd216), .val(hsTime), .high(11'd1015), 
                      .is_between(HS_disp));


    // handle vertical timing
    logic [9:0] vsLine;
    logic       VS_disp, isFrameDone;
 
    Counter #(10)     vsCounter(.en(newRow),   .load(isFrameDone), .up('1),
        /* increments the    */ .clear, .Q(vsLine),       .clock(clk),
        /* VS clock by lines */ .D('0));

    Counter #(10)     rowCounter(.en(newRow & VS_disp), .load(~VS_disp), .up('1),
        /* counts the screen  */ .clear, .Q(row), .clock(clk),
        /* column position    */ .D('0));

    RangeCheck #(10)
        // outputs VS by checking if 4 <= hsTime <= 628
        vsChecker(.low(10'd4), .val(vsLine), .high(10'd628), 
                  .is_between(VS)),
        // outputs VS_disp by checking if 27 <= hsTime < 627
        vsdispChecker(.low(10'd27), .val(vsLine), .high(10'd626), 
                      .is_between(VS_disp));

    Comparator #(10) isNewFrameComp(.A(10'd628), .B(vsLine), .AeqB(isFrameDone));


    // handle new row logic
    Comparator #(11) isNewRowComp(.A(11'd1056), .B(hsTime), .AeqB(newRow));

    // calculate the blank periods
    assign isblank = ~HS_disp | ~VS_disp;

    //
endmodule: vga_timing