(**************************************************************************)
(*       ___                                                              *)
(*      ||M||                                                             *)
(*      ||A||       A project by Andrea Asperti                           *)
(*      ||T||                                                             *)
(*      ||I||       Developers:                                           *)
(*      ||T||         The HELM team.                                      *)
(*      ||A||         http://helm.cs.unibo.it                             *)
(*      \   /                                                             *)
(*       \ /        This file is distributed under the terms of the       *)
(*        v         GNU General Public License Version 2                  *)
(*                                                                        *)
(**************************************************************************)

include "basic_2/rt_computation/cpms_fpbg.ma".
include "basic_2/rt_computation/cprs_cprs.ma".
include "basic_2/rt_computation/lprs_cpms.ma".
include "basic_2/dynamic/cnv_drops.ma".
(*
include "basic_2/dynamic/snv_aaa.ma".
*)
include "basic_2/dynamic/cnv_etc.ma".
(*
include "basic_2/dynamic/lsubsv_snv.ma".
*)
(* CONTEXT-SENSITIVE NATIVE VALIDITY FOR TERMS ******************************)

(* Properties with context-free parallel reduction for local environments *****)

fact cnv_cpm_trans_lpr_aux (a) (h) (o): a = Ⓕ →
                           ∀G0,L0,T0.
                           (∀G1,L1,T1. ⦃G0, L0, T0⦄ >[h, o] ⦃G1, L1, T1⦄ → IH_cnv_cpms_conf_lpr a h G1 L1 T1) →
                           (∀G1,L1,T1. ⦃G0, L0, T0⦄ >[h, o] ⦃G1, L1, T1⦄ → IH_cnv_cpm_trans_lpr a h G1 L1 T1) →
                           ∀G1,L1,T1. G0 = G1 → L0 = L1 → T0 = T1 → IH_cnv_cpm_trans_lpr a h G1 L1 T1.
#a #h #o #Ha #G0 #L0 #T0 (* #IH4 #IH3 *) #IH2 #IH1 #G1 #L1 * * [|||| * ]
[ #s #HG0 #HL0 #HT0 #H1 #x #X #H2 #L2 #_ destruct (* -IH4 -IH3 *) -IH2 -IH1 -H1
  elim (cpm_inv_sort1 … H2) -H2 * #H1 #H2 destruct //
| #i #HG0 #HL0 #HT0 #H1 #x #X #H2 #L2 #HL12 destruct (* -IH4 -IH3 *) -IH2
  elim (cnv_inv_lref_drops … H1) -H1 #I #K1 #V1 #HLK1 #HV1
  elim (lpr_drops_conf … HLK1 … HL12) -HL12 // #Y #H #HLK2
  elim (lpr_inv_pair_sn … H) -H #K2 #V2 #HK12 #HV12 #H destruct
  lapply (fqup_lref (Ⓣ) … G1 … HLK1) #HKL
  elim (cpm_inv_lref1_drops … H2) -H2 *
  [ #H1 #H2 destruct -HLK1 /4 width=7 by fqup_fpbg, cnv_lref_drops/
  | #K0 #V0 #W0 #H #HVW0 #W0 -HV12
    lapply (drops_mono … H … HLK1) -HLK1 -H #H destruct
    lapply (drops_isuni_fwd_drop2 … HLK2) -HLK2 /4 width=7 by fqup_fpbg, cnv_lifts/
  | #n #K0 #V0 #W0 #H #HVW0 #W0 #H destruct -HV12
    lapply (drops_mono … H … HLK1) -HLK1 -H #H destruct
    lapply (drops_isuni_fwd_drop2 … HLK2) -HLK2 /4 width=7 by fqup_fpbg, cnv_lifts/
  ]
| #l #HG0 #HL0 #HT0 #H1 #x #X #H2 #L2 #HL12 destruct (* -IH4 -IH3 *) -IH2 -IH1
  elim (cnv_inv_gref … H1)
| #p #I #V1 #T1 #HG0 #HL0 #HT0 #H1 #x #X #H2 #L2 #HL12 destruct (* -IH4 -IH3 *) -IH2
  elim (cnv_inv_bind … H1) -H1 #HV1 #HT1
  elim (cpm_inv_bind1 … H2) -H2 *
  [ #V2 #T2 #HV12 #HT12 #H destruct /4 width=9 by fqup_fpbg, cnv_bind, lpr_pair/
  | #T2 #HT12 #HXT2 #H1 #H2 destruct -HV1
    /4 width=11 by fqup_fpbg, cnv_inv_lifts, lpr_pair, drops_refl, drops_drop/
  ]
| #V1 #T1 #HG0 #HL0 #HT0 #H1 #x #X #H2 #L2 #HL12 destruct
  elim (cnv_inv_appl … H1) -H1 #n #p #W1 #U1 #Hn #HV1 #HT1 #HVW1 #HTU1
  elim (cpm_inv_appl1 … H2) -H2 *
  [ #V2 #T2 #HV12 #HT12 #H destruct (* -IH4 *)
    lapply (IH1 … HV12 … HL12) /2 width=1 by fqup_fpbg/ #HV2
    lapply (IH1 … HT12 … HL12) /2 width=1 by fqup_fpbg/ #HT2
    elim (IH2 … HVW1 … V2 … L2 … L2) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HVW1 -HV12
    <minus_n_O <minus_O_n #XW1 #HXW1 #HXV2
    elim (IH2 … HTU1 … T2 … L2 … L2) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HTU1 -HT12
    #X #H #HTU2 (* -IH3 *) -IH2 -IH1 -L1 -V1 -T1
    elim (cpms_inv_abst_sn … H) -H #W2 #U2 #HW12 #_ #H destruct
    elim (cprs_conf … HXW1 … HW12) -W1 #W1 #HXW1 #HW21
    lapply (cpms_trans … HXV2 … HXW1) -XW1 <plus_n_O #HV2W1
    lapply (cpms_trans … HTU2 … (ⓛ{p}W1.U2) ?)
    [3:|*: /2 width=2 by cpms_bind/ ] -W2 <plus_n_O #HTU2
    @(cnv_appl … HV2W1 HTU2) // #H destruct
  | #q #V2 #W10 #W20 #T10 #T20 #HV12 #HW120 #HT120 #H1 #H2 destruct
    elim (cnv_inv_bind … HT1) -HT1 #HW10 #HT10
    elim (cpms_inv_abst_sn … HTU1) -HTU1 #W30 #T30 #HW130 #_ #H destruct -T30
    lapply (IH1 … HV12 … HL12) /2 width=1 by fqup_fpbg/ #HV2
    lapply (IH1 … HW120 … HL12) /2 width=1 by fqup_fpbg/ #HW20
    lapply (IH1 … HT10 … HT120 … (L2.ⓛW20) ?) /2 width=1 by fqup_fpbg, lpr_pair/ -HT10 -HT120 #HT20
    elim (IH2 … HVW1 … V2 … L2 … L2) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HVW1 -HV12
    <minus_n_O <minus_O_n #XW1 #HXW1 #HXV2
    elim (IH2 … HW130 … W20 … L2 … L2) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HW130 -HW120
    <minus_n_O #XW30 #HXW30 #HW230
    elim (cprs_conf … HXW1 … HXW30) -W30 #W30 #HXW1 #HXW30
    lapply (cpms_trans … HXV2 … HXW1) -XW1 <plus_n_O #HV2W30
    lapply (cprs_trans … HW230 … HXW30) -XW30 #HW230
    @cnv_bind [ /2 width=3 by cnv_cast/ ]
(*
    @(lsubsv_snv_trans … HT20) -HT20
    @(lsubsv_beta … (d-1)) //
    @shnv_cast [1,2: // ] #d0 #Hd0
    lapply (scpes_le_aux … IH4 IH1 IH2 IH3 … HW20d … HV2d … d0 … HVW20) -IH4 -IH3 -IH2 -IH1 -HW20d -HV2d -HVW20
    /3 width=5 by fpbg_fpbs_trans, fqup_fpbg, cpr_lpr_fpbs, le_S_S/
*)
  | #q #V0 #V2 #W0 #W2 #T0 #T2 #HV10 #HV02 #HW02 #HT02 #H1 #H2 destruct (* -IH4 *)
    elim (cnv_inv_bind … HT1) -HT1 #HW0 #HT0
    elim (cpms_inv_abbr_abst … HTU1) -HTU1 #X #HTU0 #HX #H destruct
    elim (lifts_inv_bind1 … HX) -HX #W3 #U3 #HW13 #_ #H destruct
    lapply (IH1 … HW02 … HL12) /2 width=1 by fqup_fpbg/ #HW2
    lapply (IH1 … HV10 … HL12) /2 width=1 by fqup_fpbg/ #HV0
    lapply (IH1 … HT02 (L2.ⓓW2) ?) /2 width=1 by fqup_fpbg, lpr_pair/ #HT2
    elim (IH2 … HVW1 … V0 … L2 … L2) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HVW1 -HV10
    <minus_n_O <minus_O_n #XW1 #HXW1 #HXV0
    elim (IH2 … HTU0 … T2 … (L2.ⓓW2) … (L2.ⓓW2)) [|*: /2 width=2 by fqup_fpbg, cpm_cpms, lpr_pair/ ] -HT02 -HTU0 -HW02
    #X #H #HTU2 -IH2 -IH1
    elim (cpms_inv_abst_sn … H) -H #W #U2 #HW3 #_ #H destruct -U3
    lapply (cnv_lifts … HV0 (Ⓣ) … (L2.ⓓW2) … HV02) /3 width=1 by drops_refl, drops_drop/ -HV0 #HV2
    elim (cpms_lifts_sn … HXV0 (Ⓣ) … (L2.ⓓW2) … HV02) /3 width=1 by drops_refl, drops_drop/ -V0 #XW2 #HXW12 #HXVW2
    lapply (cpms_lifts_bi … HXW1 (Ⓣ) … (L2.ⓓW2) … HW13 … HXW12) /3 width=1 by drops_refl, drops_drop/ -W1 -XW1 #HXW32
    elim (cprs_conf … HXW32 … HW3) -W3 #W3 #HXW23 #HW3
    lapply (cpms_trans … HXVW2 … HXW23) -XW2 <plus_n_O #H1
    lapply (cpms_trans … HTU2 ? (ⓛ{p}W3.U2) ?) [3:|*:/2 width=2 by cpms_bind/ ] -W #H2
    @cnv_bind // @(cnv_appl … H1 H2) // #H destruct 
  ]
| #W1 #T1 #HG0 #HL0 #HT0 #H1 #x #X #H2 #L2 #HL12 destruct (* -IH4 *)
  elim (cnv_inv_cast … H1) -H1 #U1 #HW1 #HT1 #HWU1 #HTU1
  elim (cpm_inv_cast1 … H2) -H2
  [ * #W2 #T2 #HW12 #HT12 #H destruct
    lapply (IH1 … HW12 … HL12) /2 width=1 by fqup_fpbg/ #HW2
    lapply (IH1 … HT12 … HL12) /2 width=1 by fqup_fpbg/ #HT2
    lapply (cnv_cpms_trans_lpr_aux … IH1 … HTU1 L1 ?) /2 width=1 by fqup_fpbg/ #HU1
    elim (IH2 … HWU1 … W2 … L1 … HL12) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HW12
    <minus_n_O <minus_O_n #XW1 #HXUW1 #HXW21
    elim (IH2 … HTU1 … T2 … L1 … HL12) [|*: /2 width=2 by fqup_fpbg, cpm_cpms/ ] -HTU1 -HT12
    #XT1 #HXUT1 #HXT21
    elim (IH2 … HXUW1 … HXUT1 … HL12 … HL12) [|*: /2 width=4 by fqup_cpms_fwd_fpbg/ ] -HXUW1 -HXUT1 -HWU1
    >eq_minus_O // #W0 #H1 #H2
    lapply (cprs_trans … HXW21 … H1) -XW1 #H1
    lapply (cpms_trans … HXT21 … H2) -XT1 <arith_l #H2
    /2 width=3 by cnv_cast/
  | #HX (* -IH3 *) -IH2 -HW1 -U1
    lapply (IH1 … HX … HL12) /2 width=1 by fqup_fpbg/
  | * #n #HX #H destruct -IH2 -HT1 -U1
    lapply (IH1 … HX … HL12) /2 width=1 by fqup_fpbg/
  ]
]
(*
qed-.
*)
