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

include "basic_2/computation/cpds_cpds.ma".
include "basic_2/computation/fpbs_fpbs.ma".
include "basic_2/dynamic/snv_aaa.ma".
include "basic_2/dynamic/snv_cpcs.ma".
include "basic_2/dynamic/lsubsv_lsstas.ma".

(* STRATIFIED NATIVE VALIDITY FOR TERMS *************************************)

(* Properties on sn parallel reduction for local environments ***************)

fact lsstas_cpr_lpr_aux: ∀h,g,G0,L0,T0.
                         (∀G1,L1,T1. ⦃G0, L0, T0⦄ >⋕[h, g] ⦃G1, L1, T1⦄ → IH_snv_lsstas h g G1 L1 T1) →
                         (∀G1,L1,T1. ⦃G0, L0, T0⦄ >⋕[h, g] ⦃G1, L1, T1⦄ → IH_snv_cpr_lpr h g G1 L1 T1) →
                         (∀G1,L1,T1. ⦃G0, L0, T0⦄ >⋕[h, g] ⦃G1, L1, T1⦄ → IH_da_cpr_lpr h g G1 L1 T1) →
                         (∀G1,L1,T1. ⦃G0, L0, T0⦄ >⋕[h, g] ⦃G1, L1, T1⦄ → IH_lsstas_cpr_lpr h g G1 L1 T1) →
                         ∀G1,L1,T1. G0 = G1 → L0 = L1 → T0 = T1 → IH_lsstas_cpr_lpr h g G1 L1 T1.
#h #g #G0 #L0 #T0 #IH4 #IH3 #IH2 #IH1 #G1 #L1 * * [|||| * ]
[ #k #_ #_ #_ #_ #l1 #l2 #_ #_ #X2 #H2 #X3 #H3 #L2 #_ -IH4 -IH3 -IH2 -IH1
  >(lsstas_inv_sort1 … H2) -X2
  >(cpr_inv_sort1 … H3) -X3 /2 width=3 by cpr_atom, ex2_intro/
| #i #HG0 #HL0 #HT0 #H1 #l1 #l2 @(nat_ind_plus … l2) -l2 [ #_ | #l2 #_ #Hl21 ] #Hl1 #X2 #H2 #X3 #H3 #L2 #HL12 destruct -IH4 -IH3
  [ lapply (lsstas_inv_O … H2) -H2 #H destruct -IH1 -H1 -l1 /4 width=5 by lpr_cpcs_conf, cpr_cpcs_dx, ex2_intro/ ]
  elim (snv_inv_lref … H1) -H1 #I0 #K0 #X0 #HK0 #HX0
  elim (da_inv_lref … Hl1) -Hl1 * #K1 [ #V1 | #W1 #l0 ] #HLK1 [ #HVl1 | #HWl1 #H destruct ]
  lapply (ldrop_mono … HK0 … HLK1) -HK0 #H destruct
  elim (lsstas_inv_lref1 … H2) -H2 * #K0 #V0 #W0 [2,4: #l ] #HK0 [1,2: #Hl ] #HW0 #HX2
  lapply (ldrop_mono … HK0 … HLK1) -HK0 #H destruct
  [ lapply (da_mono … Hl … HWl1) -Hl #H destruct
    lapply (le_plus_to_le_r … Hl21) -Hl21 #Hl21
  ]
  lapply (fqup_lref … G1 … HLK1) #HKV1
  elim (lpr_ldrop_conf … HLK1 … HL12) -HL12 #X #H #HLK2
  elim (lpr_inv_pair1 … H) -H #K2 [ #W2 | #V2 ] #HK12 [ #HW12 | #HV12 ] #H destruct
  lapply (ldrop_fwd_ldrop2 … HLK2) #H2
  elim (cpr_inv_lref1 … H3) -H3
  [1,3: #H destruct -HLK1
  |2,4: * #K0 #V0 #X0 #H #HVX0 #HX0
        lapply (ldrop_mono … H … HLK1) -H -HLK1 #H destruct
  ]
  [ elim (IH1 … HWl1 … HW0 … HW12 … HK12) -IH1 -HW0 /2 width=1 by fqup_fpbg/ #V2 #HWV2 #HV2
    elim (lift_total V2 0 (i+1))
    /6 width=11 by fqup_fpbg, cpcs_lift, lsstas_ldec, ex2_intro/
  | elim (IH1 … HVl1 … HW0 … HV12 … HK12) -IH1 -HVl1 -HW0 -HV12 -HK12 -IH2 /2 width=1 by fqup_fpbg/ #W2 #HVW2 #HW02
    elim (lift_total W2 0 (i+1))
    /4 width=11 by cpcs_lift, lsstas_ldef, ex2_intro/
  | elim (IH1 … HVl1 … HW0 … HVX0 … HK12) -IH1 -HVl1 -HW0 -HVX0 -HK12 -IH2 -V2 /2 width=1 by fqup_fpbg/ -l1 #W2 #HXW2 #HW02
    elim (lift_total W2 0 (i+1))
    /3 width=11 by cpcs_lift, lsstas_lift, ex2_intro/
  ]
| #p #_ #_ #HT0 #H1 destruct -IH4 -IH3 -IH2 -IH1
  elim (snv_inv_gref … H1)
| #a #I #V1 #T1 #HG0 #HL0 #HT0 #H1 #l1 #l2 #Hl21 #Hl1 #X2 #H2 #X3 #H3 #L2 #HL12 destruct -IH4 -IH3 -IH2
  elim (snv_inv_bind … H1) -H1 #_ #HT1
  lapply (da_inv_bind … Hl1) -Hl1 #Hl1
  elim (lsstas_inv_bind1 … H2) -H2 #U1 #HTU1 #H destruct
  elim (cpr_inv_bind1 … H3) -H3 *
  [ #V2 #T2 #HV12 #HT12 #H destruct
    elim (IH1 … Hl1 … HTU1 … HT12 (L2.ⓑ{I}V2)) -IH1 -Hl1 -HTU1 -HT12 /2 width=1 by fqup_fpbg, lpr_pair/ -T1
    /4 width=5 by cpcs_bind2, lpr_cpr_conf, lsstas_bind, ex2_intro/
  | #T3 #HT13 #HXT3 #H1 #H2 destruct
    elim (IH1 … Hl1 … HTU1 … HT13 (L2.ⓓV1)) -IH1 -Hl1 -HTU1 -HT13 /2 width=1 by fqup_fpbg, lpr_pair/ -T1 -HL12 #U3 #HTU3 #HU13
    elim (lsstas_inv_lift1 … HTU3 L2 … HXT3) -T3
    /5 width=8 by cpcs_cpr_strap1, cpcs_bind1, cpr_zeta, ldrop_ldrop, ex2_intro/
  ]
| #V1 #T1 #HG0 #HL0 #HT0 #H1 #l1 #l2 #Hl21 #Hl1 #X2 #H2 #X3 #H3 #L2 #HL12 destruct
  elim (snv_inv_appl … H1) -H1 #a #W1 #W10 #U10 #l0 #HV1 #HT1 #Hl0 #HVW1 #HW10 #HTU10
  lapply (da_inv_flat … Hl1) -Hl1 #Hl1
  elim (lsstas_inv_appl1 … H2) -H2 #U1 #HTU1 #H destruct
  elim (cpr_inv_appl1 … H3) -H3 *
  [ #V2 #T2 #HV12 #HT12 #H destruct -a -l0 -W1 -W10 -U10 -HV1 -IH4 -IH3 -IH2
    elim (IH1 … Hl1 … HTU1 … HT12 … HL12) -IH1 -Hl1 -HTU1
    /4 width=5 by fqup_fpbg, cpcs_flat, lpr_cpr_conf, lsstas_appl, ex2_intro/
  | #b #V2 #W2 #W3 #T2 #T3 #HV12 #HW23 #HT23 #H1 #H2 destruct
    elim (snv_inv_bind … HT1) -HT1 #HW2 #HT2
    lapply (da_inv_bind … Hl1) -Hl1 #Hl1
    elim (lsstas_inv_bind1 … HTU1) -HTU1 #U2 #HTU2 #H destruct
    elim (cpds_inv_abst1 … HTU10) -HTU10 #W0 #U0 #HW20 #_ #H destruct
    lapply (cprs_div … HW10 … HW20) -W0 #HW12
    lapply (ssta_da_conf … HVW1 … Hl0) <minus_plus_m_m #H
    elim (snv_fwd_da … HW2) #l #Hl
    lapply (IH4 … HV1 … 1 … Hl0 W1 ?) /2 width=1 by fqup_fpbg, ssta_lsstas/ #HW1
    lapply (da_cpcs_aux … IH3 IH2 … H … Hl … HW12) // -H
    /3 width=5 by fpbg_fpbs_trans, fqup_fpbg, ssta_fpbs/ #H destruct
    lapply (IH3 … HV12 … HL12) /2 width=1 by fqup_fpbg/ #HV2
    lapply (IH2 … Hl0 … HV12 … HL12) /2 width=1 by fqup_fpbg/ #HV2l
    elim (IH1 … 1 … Hl0 … W1 … HV12 … HL12) /2 width=1 by fqup_fpbg, ssta_lsstas/ -HVW1 #W4 #H #HW14
    lapply (lsstas_inv_SO … H) #HV2W4
    lapply (ssta_da_conf … HV2W4 … HV2l) <minus_plus_m_m #HW4l
    lapply (IH4 … HV2 … HV2l … H) -H /3 width=5 by fpbg_fpbs_trans, fqup_fpbg, cpr_lpr_fpbs/ #HW4
    lapply (IH3 … HW23 … HL12) /2 width=1 by fqup_fpbg/ #HW3
    lapply (IH2 … Hl … HW23 … HL12) /2 width=1 by fqup_fpbg/ #HW3l
    elim (IH1 … Hl1 … HTU2 … HT23 (L2.ⓛW3)) -HTU2 /2 width=1 by fqup_fpbg, lpr_pair/ #U3 #HTU3 #HU23
    lapply (cpcs_cpr_strap1 … HW12 … HW23) #H
    lapply (lpr_cpcs_conf … HL12 … H) -H #H
    lapply (cpcs_canc_sn … HW14 H) -H #HW43
    elim (lsubsv_lsstas_trans … HTU3 … Hl21 … (L2.ⓓⓝW3.V2)) -HTU3
    [ #U4 #HT3U4 #HU43 -HW12 -HW3 -HW3l -W4 -IH2 -IH3 -IH4
      @(ex2_intro … (ⓓ{b}ⓝW3.V2.U4)) /2 width=1 by lsstas_bind/ -HT3U4
      @(cpcs_canc_dx … (ⓓ{b}ⓝW3.V2.U3)) /2 width=1 by cpcs_bind_dx/ -HU43
      @(cpcs_cpr_strap1 … (ⓐV2.ⓛ{b}W3.U3)) /2 width=1 by cpr_beta/
      /4 width=3 by cpcs_flat, cpcs_bind2, lpr_cpr_conf/
    | -U3
      @(lsubsv_abbr … l) /3 width=7 by fqup_fpbg/
      #W #W0 #l0 #Hl0 #HV2W #HW30
      lapply (lsstas_ssta_conf_pos … HV2W4 … HV2W) -HV2W #HW4W
      @(lsstas_cpcs_lpr_aux … IH3 IH2 IH1 … Hl0 … HW4W … Hl0 … HW30 … HW43) //
      [ /3 width=9 by fpbg_fpbs_trans, fqup_fpbg, cpr_lpr_ssta_fpbs/
      | /3 width=5 by fpbg_fpbs_trans, fqup_fpbg, cpr_lpr_fpbs/
      ]
    | -IH1 -IH3 -IH4 /3 width=9 by fqup_fpbg, lpr_pair/
    ]
  | #b #V0 #V2 #W0 #W2 #T0 #T2 #HV10 #HV02 #HW02 #HT02 #H1 #H2 destruct -a -l0 -W1 -W10 -HV1 -IH4 -IH3 -IH2
    elim (snv_inv_bind … HT1) -HT1 #_ #HT0
    lapply (da_inv_bind … Hl1) -Hl1 #Hl1
    elim (lsstas_inv_bind1 … HTU1) -HTU1 #U0 #HTU0 #H destruct
    elim (IH1 … Hl1 … HTU0 … HT02 (L2.ⓓW2)) -IH1 -Hl1 -HTU0 /2 width=1 by fqup_fpbg, lpr_pair/ -T0 #U2 #HTU2 #HU02
    lapply (lpr_cpr_conf … HL12 … HV10) -HV10 #HV10
    lapply (lpr_cpr_conf … HL12 … HW02) -L1 #HW02
    lapply (cpcs_bind2 b … HW02 … HU02) -HW02 -HU02 #HU02
    lapply (cpcs_flat … HV10 … HU02 Appl) -HV10 -HU02 #HU02
    lapply (cpcs_cpr_strap1 … HU02 (ⓓ{b}W2.ⓐV2.U2) ?)
    /4 width=3 by lsstas_appl, lsstas_bind, cpr_theta, ex2_intro/
  ]
| #W1 #T1 #HG0 #HL0 #HT0 #H1 #l1 #l2 @(nat_ind_plus … l2) -l2 [ #_ | #l2 #_ #Hl21 ] #Hl1 #X2 #H2 #X3 #H3 #L2 #HL12 destruct -IH4 -IH3 -IH2
  [ lapply (lsstas_inv_O … H2) -H2 #H destruct -IH1 -H1 -l1 /4 width=5 by lpr_cpcs_conf, cpr_cpcs_dx, ex2_intro/ ]
  elim (snv_inv_cast … H1) -H1 #U1 #l #_ #HT1 #_ #_ #_ -U1 -l
  lapply (da_inv_flat … Hl1) -Hl1 #Hl1
  lapply (lsstas_inv_cast1 … H2) -H2 #HTU1
  elim (cpr_inv_cast1 … H3) -H3
  [ * #U2 #T2 #_ #HT12 #H destruct
    elim (IH1 … Hl1 … HTU1 … HT12 … HL12) -IH1 -Hl1 -HTU1 -HL12
    /3 width=3 by fqup_fpbg, lsstas_cast, ex2_intro/
  | #HT1X3
    elim (IH1 … Hl1 … HTU1 … HT1X3 … HL12) -IH1 -Hl1 -HTU1 -HL12
    /2 width=3 by fqup_fpbg, ex2_intro/
  ]
]
qed-.
