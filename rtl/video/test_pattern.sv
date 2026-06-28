module test_pattern_generator
    (input  logic [9:0] row, col,
     output logic [7:0] red, green, blue);

    logic btw_400_799, btw_200_399, btw_600_799,
          btw_100_199, btw_300_399, btw_500_599, btw_700_799;
    logic is_upper;

    RangeCheck #(10) 
      r1(.low(10'd000), .high(10'd299), .val(row), .is_between(is_upper)),
      r2(.low(10'd400), .high(10'd799), .val(col), .is_between(btw_400_799)),
      r3(.low(10'd200), .high(10'd399), .val(col), .is_between(btw_200_399)),
      r4(.low(10'd600), .high(10'd799), .val(col), .is_between(btw_600_799)),
      r5(.low(10'd100), .high(10'd199), .val(col), .is_between(btw_100_199)),
      r6(.low(10'd300), .high(10'd399), .val(col), .is_between(btw_300_399)),
      r7(.low(10'd500), .high(10'd599), .val(col), .is_between(btw_500_599)),
      r8(.low(10'd700), .high(10'd799), .val(col), .is_between(btw_700_799));

    assign red   = is_upper & btw_400_799 ? 8'hff : 8'h00;
    assign green = is_upper & (btw_200_399 | btw_600_799) ? 8'hff : 8'h00;
    assign blue  = is_upper & 
                   (btw_100_199 | btw_300_399 | btw_500_599 | btw_700_799) ? 
                      8'hff : 8'h00;

endmodule: test_pattern_generator;