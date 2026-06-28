// `default_nettype none

module Comparator
   #(parameter W = 8)
    (input  logic [W-1:0] A, B,
     output logic         AeqB);

    assign AeqB = A == B;
endmodule: Comparator

module MagComp
   #(parameter W = 8)
    (input  logic [W-1:0] A, B,
     output logic         AltB, AeqB, AgtB);

    always_comb begin
        AltB = 0;
        AeqB = 0;
        AgtB = 0;

        if (A == B)
            AeqB = 1;
        else if (A < B)
            AltB = 1;
        else
            AgtB = 1;
    end
endmodule: MagComp

module Adder
   #(parameter W = 8)
    (input  logic [W-1:0] A, B,
     input  logic         cin,
     output logic [W-1:0] sum,
     output logic         cout);
    
    logic [W:0] AplusBplusCin;

    assign AplusBplusCin = A + B + cin;

    assign sum  = AplusBplusCin[W-1:0];
    assign cout = AplusBplusCin[W];
endmodule: Adder

module Subtracter
   #(parameter W = 8)
    (input  logic [W-1:0] A, B,
     input  logic         bin,
     output logic [W-1:0] diff,
     output logic         bout);
    
    logic [W:0] AminusBminusBin;

    assign AminusBminusBin = {1'b0, A} - {1'b0, B} - bin;

    assign diff = AminusBminusBin[W-1:0];
    assign bout = AminusBminusBin[W];
endmodule: Subtracter

module Multiplexer
   #(parameter W = 8)
    (input  logic [W-1:0]       I,
     input  logic [$clog2(W):0] S,
     output logic               Y);

    assign Y = I[S];
endmodule: Multiplexer

module Mux2to1
   #(parameter W = 8)
    (input  logic [W-1:0] I0, I1,
     input  logic         S,
     output logic [W-1:0] Y);
    
    assign Y = S ? I1 : I0;
endmodule: Mux2to1

module Decoder
   #(parameter W = 8)
    (input  logic [$clog2(W):0] I,
     input  logic               en,
     output logic [W-1:0]       D);

    assign D = en ? 1'b1 << I : '0;
endmodule: Decoder

module DFlipFlop
    (input  logic D, clock, preset_L, reset_L,
     output logic Q);

     always_ff @(posedge clock, negedge preset_L, negedge reset_L)
        if (~reset_L)
            Q <= 0;
        else if (~preset_L)
            Q <= 1;
        else
            Q <= D;
endmodule: DFlipFlop

module Register
   #(parameter W = 8)
    (input  logic [W-1:0] D,
     input  logic         en, clear, clock,
     output logic [W-1:0] Q);

     always_ff @(posedge clock)
        if (en)
            Q <= D;
        else if (clear)
            Q <= '0;
endmodule: Register

module Counter
   #(parameter W = 8)
    (input  logic [W-1:0] D,
     input  logic         en, clear, load, up, clock,
     output logic [W-1:0] Q);
    
    always_ff @(posedge clock)
        if (clear)
            Q <= '0;
        else if (load)
            Q <= D;
        else if (en)
            Q <= up ? Q + 1 : Q - 1;
endmodule: Counter

module ShiftRegisterSIPO
   #(parameter W = 8)
    (input  logic         en, left, serial, clock,
     output logic [W-1:0] Q);

    always_ff @(posedge clock)
        if (en)
            Q <= left ? {Q[W-2:0], serial} : {serial, Q[W-1:1]};
endmodule: ShiftRegisterSIPO

module ShiftRegisterPIPO
   #(parameter W = 8)
    (input  logic [W-1:0] D,
     input  logic         en, left, load, clock,
     output logic [W-1:0] Q);

    always_ff @(posedge clock)
        if (load)
            Q <= D;
        else if (en)
            Q <= left ? Q << 1 : Q >> 1;
endmodule: ShiftRegisterPIPO

module BarrelShiftRegister
   #(parameter W = 8)
    (input  logic [W-1:0] D,
     input  logic [1:0]   by,
     input  logic         en, load, clock,
     output logic [W-1:0] Q);

    always_ff @(posedge clock)
        if (load)
            Q <= D;
        else if (en)
            Q <= Q << by;
endmodule: BarrelShiftRegister

module Synchronizer
    (input  logic async, clock,
     output logic sync);

    logic ff1, ff2;

    always_ff @(posedge clock) begin
        ff1 <= async;
        ff2 <= ff1;
    end

    assign sync = ff2;
endmodule: Synchronizer

module BusDriver
   #(parameter W = 8)
    (input  logic [W-1:0] data,
     input  logic         en,
     output logic [W-1:0] buff, 
     inout  tri   [W-1:0] bus);

    assign bus  = en ? data : 'bz;
    assign buff = bus;
endmodule: BusDriver

module Memory
   #(parameter DW = 8,
               AW = 16)
    (input  logic [AW-1:0] addr,
     input  logic          re, we, clock,
     inout  tri   [DW-1:0] data);
    
    logic [DW-1:0] memory[AW**2];
    logic [DW-1:0] readData;

    assign data = (re) ? readData : 'z;

    always_ff @(posedge clock)
        if (we)
            memory[addr] <= data;
    
    always_comb
        readData = memory[addr];
endmodule: Memory


module RangeCheck
 #(parameter W = 8)
  (input  logic [W-1:0] low, val, high,
   output logic         is_between);

  logic lowLtVal, lowEqVal, valLtHigh, valEqHigh;
    
  MagComp #(W) 
    // check if loW <= val
    compLoW (.A(low), .B(val),  .AltB(lowLtVal),  .AeqB(lowEqVal),
             .AgtB()),
    // check if val <= high
    compHigh(.A(val), .B(high), .AltB(valLtHigh), .AeqB(valEqHigh),
             .AgtB());

  // is_between set if loW <= val & val <= high
  assign is_between = (lowLtVal | lowEqVal) & (valLtHigh | valEqHigh);

endmodule: RangeCheck


module OffsetCheck
 #(parameter W = 8)
  (input  logic [W-1:0] low, val, delta,
   output logic         is_between);

  logic [W-1:0] lowDeltaSum;

  Adder #(W) 
    // lowDeltaSum = loW + delta
    lowDeltaAdder(.A(low), .B(delta), .cin('0), .sum(lowDeltaSum), .cout());

  RangeCheck #(W) 
    // is_between set if loW <= val <= lowDeltaSum
    rangeCheckVal(.low, .val, .high(lowDeltaSum), .is_between);

endmodule: OffsetCheck

`default_nettype wire