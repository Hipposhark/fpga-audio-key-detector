`default_nettype none

module Comparator_test;
    logic [7:0] A, B;
    logic AeqB;

    Comparator comp(.A, .B, .AeqB);

    initial begin
        $monitor($time,,
            "A=%b B=%b -> A==B=%b",
            A, B, AeqB);

        $display("Comparator Test");

        #1 A = 8'b0000_0000;
        #0 B = 8'b0000_0000;

        #1 A = 8'b1111_1111;
        #0 B = 8'b0000_0000;

        #1 A = 8'b0000_0000;
        #0 B = 8'b1111_1111;

        #1 A = 8'b1111_1111;
        #0 B = 8'b1111_1111;

        #1 $finish;
    end
endmodule: Comparator_test

module MagComp_test;
    logic [7:0] A, B;
    logic AltB, AeqB, AgtB;

    MagComp magComp(.A, .B, .AltB, .AeqB, .AgtB);

    initial begin
        $monitor($time,,
            "A=%b B=%b -> A<B=%b A==B=%b A>B=%b",
            A, B, AltB, AeqB, AgtB);

        $display("Magnitude Comparator Test");

        #1 A = 8'b0000_0000;
        #0 B = 8'b0000_0000;

        #1 A = 8'b1111_1111;
        #0 B = 8'b0000_0000;

        #1 A = 8'b0000_0000;
        #0 B = 8'b1111_1111;

        #1 A = 8'b1111_1111;
        #0 B = 8'b1111_1111;

        #1 $finish;
    end
endmodule: MagComp_test

module Adder_test;
    logic [7:0] A, B, sum;
    logic cin, cout;

    Adder adder(.A, .B, .cin, .sum, .cout);

    initial begin
        $monitor($time,,
            "A=%b B=%b cin=%b -> sum=%b cout=%b",
            A, B, cin, sum, cout);

        $display("Adder Test");

        #1 A   = 8'b0000_0000;
           B   = 8'b0000_0000;
           cin = 1;

        #1 A   = 8'b1111_1111;
           B   = 8'b0000_0000;
           cin = 1;

        #1 A   = 8'b0000_0000;
           B   = 8'b1111_1111;
           cin = 0;

        #1 A   = 8'b1111_1111;
           B   = 8'b1111_1111;
           cin = 1;

        #1 $finish;
    end
endmodule: Adder_test

module Subtracter_test;
    logic [7:0] A, B, diff;
    logic bin, bout;

    Subtracter subtracter(.A, .B, .bin, .diff, .bout);

    initial begin
        $monitor($time,,
            "A=%b B=%b bin=%b -> diff=%b bout=%b",
            A, B, bin, diff, bout);
        $display("Subtracter Test");

        #1 A   = 8'b0000_0000;
           B   = 8'b0000_0000;
           bin = 1;

        #1 A   = 8'b1111_1111;
           B   = 8'b0000_0000;
           bin = 1;

        #1 A   = 8'b0000_0000;
           B   = 8'b1111_1111;
           bin = 0;

        #1 A   = 8'b1111_1111;
           B   = 8'b1111_1111;
           bin = 1;

        #1 $finish;
    end
endmodule: Subtracter_test

module Multiplexer_test;
    logic [7:0] I;
    logic [3:0] S;
    logic       Y;

    Multiplexer multiplexer(.I, .S, .Y);

    initial begin
        $monitor($time,,
            "I=%b S=%b -> Y=%b",
            I, S, Y);
        $display("Multiplexer Test");

        #1 I = 8'b1010_1010;
        for (S=3'b000; S<3'b111; S++) 
            #1;

        #1 I = 8'b1100_1100;
        for (S=3'b000; S<3'b111; S++) 
            #1;

        #1 I = 8'b1111_0000;
        for (S=3'b000; S<3'b111; S++) 
            #1;

        #1 $finish;
    end
endmodule: Multiplexer_test

module Mux2to1_test;
    logic [7:0] I0, I1, Y;
    logic S;

    Mux2to1 mux2to1(.I0, .I1, .S, .Y);

    initial begin
        $monitor($time,,
            "I0=%b I1=%b S=%b -> Y=%b",
            I0, I1, S, Y);
        $display("Mux2to1 Test");

        #1 I0 = 8'b0000_0000;
           I1 = 8'b1111_1111;
           S  = 0;

        #1 I0 = 8'b0000_0000;
           I1 = 8'b1111_1111;
           S  = 1;

        #1 I0 = 8'b0101_0101;
           I1 = 8'b1010_1010;
           S  = 0;

        #1 I0 = 8'b0101_0101;
           I1 = 8'b1010_1010;
           S  = 1;

        #1 $finish;
    end
endmodule: Mux2to1_test

module Decoder_test;
    logic [3:0] I;
    logic       en;
    logic [7:0] D;

    Decoder decoder(.I, .en, .D);

    initial begin
        $monitor($time,,
            "I=%b en=%b -> D=%b",
            I, en, D);
        $display("Decoder Test");

        #1 en = 0;
        for (I=3'b000; I<3'b111; I++) 
            #1;

        #1 en = 1;
        for (I=3'b000; I<3'b111; I++) 
            #1;

        #1 $finish;
    end
endmodule: Decoder_test

module DFlipFlop_test;
    logic D, clock, preset_L, reset_L, Q;

    DFlipFlop dFlipFlop(.D, .clock, .preset_L, .reset_L, .Q);

    initial begin
        clock    = 0;
        reset_L  = 0;
        reset_L <= 1;

        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time,,
            "clock=%b D=%b preset_L=%b reset_L=%b-> Q=%b",
            clock, D, preset_L, reset_L, Q);
        $display("DFlipFlop Test");

        #1 D = 0;
           reset_L  = 1;
           preset_L = 1;

        #1 D = 1;

        #2 D = 0;

        #1 reset_L  = 0;
           preset_L = 1;

        #1 reset_L  = 1;
           preset_L = 0;

        #1 $finish;
    end
endmodule: DFlipFlop_test

module Register_test;
    logic [7:0] D, Q;
    logic en, clear, clock;

    Register register(.D, .Q, .en, .clear, .clock);

    initial begin
        clock  = 0;
        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time,,
            "clock=%b en=%b D=%b clear=%b -> Q=%b",
            clock, en, D, clear, Q);
        $display("Register Test");

        #0 D     = 8'b1111_0000;
           en    = 1;
           clear = 0;
        
        #1 D     = 8'b1111_0000;
           en    = 1;
           clear = 0;
        
        #1 en    = 0;

        #1 clear = 1;

        #1 $finish;
    end
endmodule: Register_test;

module Counter_test;
    logic [3:0] D, Q;
    logic       en, clear, load, up, clock;
    
    Counter #(4) counter(.D, .Q, .en, .clear, .load, .up, .clock);

    initial begin
        clock  = 0;
        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time,,
            "clock=%b clear=%b load=%b en=%b up=%b D=%b -> Q=%b",
            clock, clear, load, en, up, D, Q);
        $display("Counter Test");

        #0 clear = 0;
           load  = 0;
           en    = 0;
           up    = 1;
           D     = 4'b0011;

        #1 load = 1;
        #1 load = 0;

        #1 en   = 1;

        #2 en   = 1;
        #1 up   = 0;

        #2 en   = 1;

        #2 en   = 1;

        #1 clear = 1;

        #1 $finish;
    end
endmodule: Counter_test

module ShiftRegisterSIPO_test;
    logic [3:0] Q;
    logic       en, left, serial, clock;
    
    ShiftRegisterSIPO #(4) srSIPO(.Q, .en, .left, .serial, .clock);

    initial begin
        clock  = 0;
        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time,,
            "clock=%b en=%b left=%b serial=%b -> Q=%b",
            clock, en, left, serial, Q);
        $display("ShiftRegisterSIPO Test");

        #1 left   = 1;
           en     = 0;
        
        #2 serial = 0;
        #2 serial = 1;
        #2 serial = 0;
        #2 serial = 1;

        #1 en     = 1;
        #1 serial = 0;
        #2 serial = 1;
        #2 serial = 0;
        #2 serial = 1;

        #1 left   = 0;
        #1 serial = 1;
        #2 serial = 1;
        #2 serial = 1;
        #2 serial = 1;

        #1 $finish;
    end
endmodule: ShiftRegisterSIPO_test

module ShiftRegisterPIPO_test;
    logic [3:0] D, Q;
    logic       en, left, load, clock;
    
    ShiftRegisterPIPO #(4) srPIPO(.D, .Q, .en, .left, .load, .clock);

    initial begin
        clock  = 0;
        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time,,
            "clock=%b en=%b left=%b load=%b D=%b -> Q=%b",
            clock, en, left, load, D, Q);
        $display("ShiftRegisterPIPO Test");

        #0 left = 1;
           en   = 0;
        
        #1 load = 1;
           D    = 4'b0101;
        #1 load = 0;
           D    = 4'b0000;
    
        #1 en   = 1;
        #2
        #2
        #1 left = 0;

        #1
        #2
        #1 en   = 0;
        #1
        #1 en   = 1;
        #2

        #1 $finish;
    end
endmodule: ShiftRegisterPIPO_test;

module BarrelShiftRegister_test;
    logic [7:0] D, Q;
    logic [1:0] by;
    logic       en, load, clock;
    
    BarrelShiftRegister bsReg(.D, .Q, .by, .en, .load, .clock);

    initial begin
        clock  = 0;
        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time,,
            "clock=%b load=%b en=%b by=%b D=%b -> Q=%b",
            clock, load, en, by, D, Q);
        $display("BarrelShiftRegister Test");

        #0 load = 1;
           en   = 0;
           by   = 2'b00;
           D    = 8'b0000_0001;
        
        #1

        #2 load = 0;
           en   = 1;

        #2 en   = 1;
           by   = 2'b01;

        #1 en   = 0;
        #1 by   = 2'b10;

        #1 en   = 1;
        #1 by   = 2'b10;

        #2 by   = 2'b11;

        #1 $finish;
    end
endmodule: BarrelShiftRegister_test;

module Memory_test;
    logic [3:0] addr;          // 4-bit address
    logic       re, we, clock;
    tri   [7:0] data;          // 8-bit data

    // tristate driver intermediates
    logic [7:0] dataDriver;
    logic       isDriven;
    
    Memory #(8, 4) memory(.addr, .data, .re, .we, .clock);

    initial begin
        clock  = 0;
        forever #1 clock = ~clock;
    end

    assign data = isDriven ? dataDriver : 'bz;

    initial begin
        $monitor($time,,
            "clock=%b re=%b we=%b data=%b addr=%b",
            clock, re, we, data, addr);
        $display("Memory Test");

        #0 re   = 0;
           we   = 0;
           addr = 4'b0000;
           
           isDriven   = 0;
           dataDriver = 0;

        #1 re = 0;
           we = 1;
        for (addr=4'b0000; addr < 4'b1111; addr++) begin
            dataDriver = {addr, addr};
            isDriven    = 1;
            #2;
        end

        #0 isDriven = 0;
           re = 1;
           we = 0;
        for (addr=4'b0000; addr < 4'b1111; addr++) #2;

        #1 $finish;
    end
endmodule: Memory_test;


module RangeCheck_test;
  logic [1:0] low, val, high;
  logic       is_between;

  RangeCheck #(2) rangeCheck(.*);

  initial begin
      $monitor($time,,
          "low=%b val=%b high=%b -> is_between=%b",
          low, val, high, is_between);

      $display("Range Check Test");

      // is_between = 1

      #0 low  = 2'b00;
         val  = 2'b00;
         high = 2'b00;

      #1 low  = 2'b00;
         val  = 2'b01;
         high = 2'b01;

      #1 low  = 2'b00;
         val  = 2'b01;
         high = 2'b10;

      // is_between = 0

      #1 low  = 2'b00;
         val  = 2'b01;
         high = 2'b00;

      #1 low  = 2'b00;
         val  = 2'b10;
         high = 2'b01;

      #1 low  = 2'b01;
         val  = 2'b00;
         high = 2'b10;

      #1 $finish;
  end
endmodule: RangeCheck_test


module OffsetCheck_test;
  logic [1:0] low, val, delta;
  logic       is_between;

  OffsetCheck #(2) offsetCheck(.*);

  initial begin
      $monitor($time,,
          "low=%b val=%b delta=%b -> is_between=%b",
          low, val, delta, is_between);

      $display("Offset Check Test");

      // is_between = 1

      #0 low   = 2'b01;
         val   = 2'b01;
         delta = 2'b00;

      #1 low   = 2'b01;
         val   = 2'b10;
         delta = 2'b01;

      #1 low   = 2'b01;
         val   = 2'b01;
         delta = 2'b01;

      // is_between = 0

      #1 low   = 2'b01;
         val   = 2'b00;
         delta = 2'b00;

      #1 low   = 2'b01;
         val   = 2'b11;
         delta = 2'b01;

      #1 low   = 2'b01;
         val   = 2'b10;
         delta = 2'b00;

      #1 $finish;
  end
endmodule: OffsetCheck_test

`default_nettype wire