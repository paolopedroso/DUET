`timescale 1ns/1ps
`include "config.svh"

module golden (
    input D, 
    input C, 
    input R, 
    input E, 
    output Q
);

generate
    if (`IS_SDFFE_PP0P) begin : gen_sdffe_pp0p
        _SDFFE_PP0P_ sdffe_inst (
            .D(D),
            .C(C),
            .R(R),
            .E(E),
            .Q(Q)
        );
    end else if (`IS_SDFFE_PN0P) begin : gen_sdffe_pn0p
        _SDFFE_PN0P_ sdffe_inst (
            .D(D),
            .C(C),
            .R(R),
            .E(E),
            .Q(Q)
        );
    end else if (`IS_DFFE_PP) begin : gen_dffe_pp
        _DFFE_PP_ dffe_inst (
            .D(D),
            .C(C),
            .E(E),
            .Q(Q)
        );
    end else if (`IS_SDFF_PP0) begin : gen_sdff_pp0
        _SDFF_PP0_ sdff_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.Q(Q)
        );
    end else if (`IS_SDFF_PP1) begin : gen_sdff_pp1
        _SDFF_PP1_ sdff_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.Q(Q)
        );
    end else if (`IS_DFFE_PP0P) begin : gen_dffe_pp0p
        _DFFE_PP0P_ dffe_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else if (`IS_DFF_N) begin : gen_dff_n
        _DFF_N_ dff_inst (
            .D(D)
            ,.C(C)
            ,.Q(Q)
        );
    end else if (`IS_DFF_PP0) begin : gen_dff_pp0
        _DFF_PP0_ dff_inst (
            .D(D)
            ,.R(R)
            ,.C(C)
            ,.Q(Q)   
        );
    end else if (`IS_SDFF_PN0) begin : gen_sdff_pn0 
        _SDFF_PN0_ sdff_inst (
            .D(D)
            ,.R(R)
            ,.C(C)
            ,.Q(Q) 
        );
    end else if (`IS_SDFF_PN1) begin : gen_sdff_pn1
        _SDFF_PN1_ sdff_inst (
            .D(D)
            ,.R(R)
            ,.C(C)
            ,.Q(Q) 
        );
    end else if (`IS_DFF_PN1) begin : gen_dff_pn1 
        _DFF_PN1_ dff_inst (
            .D(D)
            ,.R(R)
            ,.C(C)
            ,.Q(Q) 
        );
    end else if (`IS_DFF_NN0) begin : gen_dff_nn0 
        _DFF_NN0_ dff_inst (
            .D(D)
            ,.R(R)
            ,.C(C)
            ,.Q(Q) 
        );
    end else if (`IS_DFFE_PN0P) begin : gen_dffe_pn0p
        _DFFE_PN0P_ dffe_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else if (`IS_SDFFCE_PP0P) begin : gen_sdffce_pp0p
        _SDFFCE_PP0P_ sdffce_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else if (`IS_SDFFCE_PP1P) begin : gen_sdffce_pp1p
        _SDFFCE_PP1P_ sdffce_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else if (`IS_DFFE_PN1P) begin : gen_dffe_pn1p
        _DFFE_PN1P_ sdffce_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else if (`IS_DFFE_PN0P) begin : gen_dffe_pn0p
        _DFFE_PN0P_ sdffce_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else if (`IS_SDFFCE_PN0P) begin : gen_sdffce_pn0p
        _SDFFCE_PN0P_ sdffce_inst (
            .D(D)
            ,.C(C)
            ,.R(R)
            ,.E(E)
            ,.Q(Q)
        );
    end else begin
        initial $fatal(1,"Not implemented.");
    end
endgenerate

endmodule
