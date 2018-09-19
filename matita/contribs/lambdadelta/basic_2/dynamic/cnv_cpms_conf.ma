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

include "basic_2/dynamic/cnv_cpm_tdeq_conf.ma".
include "basic_2/dynamic/cnv_cpms_tdeq.ma".
(*
include "basic_2/dynamic/cnv_cpm_trans.ma".
include "basic_2/dynamic/cnv_cpm_conf.ma".
*)

(* CONTEXT-SENSITIVE NATIVE VALIDITY FOR TERMS ******************************)

(* Sub confluence propery with t-bound rt-computation for terms *************)

fact cnv_cpms_tdeq_strip_lpr_aux (a) (h) (o) (G0) (L0) (T0):
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpm_trans_lpr a h G L T) →
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpms_conf_lpr a h G L T) →
     ∀n1,T1. ⦃G0,L0⦄ ⊢ T0 ➡*[n1,h] T1 → ⦃G0,L0⦄ ⊢ T0 ![a,h] → T0 ≛[h,o] T1 →
     ∀n2,T2. ⦃G0,L0⦄ ⊢ T0 ➡[n2,h] T2 → T0 ≛[h,o] T2 →
     ∀L1. ⦃G0,L0⦄ ⊢ ➡[h] L1 → ∀L2. ⦃G0,L0⦄ ⊢ ➡[h] L2 →
     ∃∃T. ⦃G0,L1⦄ ⊢ T1 ➡[n2-n1,h] T & T1 ≛[h,o] T & ⦃G0,L2⦄ ⊢ T2 ➡*[n1-n2,h] T & T2 ≛[h,o] T.
#a #h #o #G #L0 #T0 #IH2 #IH1 #n1 #T1 #H1T01 #H0T0 #H2T01
@(cpms_tdeq_ind_sn … H1T01 H0T0 H2T01 IH1 IH2) -n1 -T0
[ #H0T1 #n2 #T2 #H1T12 #H2T12 #L1 #HL01 #L2 #HL02
  <minus_O_n <minus_n_O
  elim (cnv_cpm_tdeq_conf_lpr … H0T1 0 T1 … H1T12 H2T12 … HL01 … HL02) // -L0 -H2T12
  <minus_O_n <minus_n_O #T #H1T1 #H2T1 #H1T2 #H2T2
  /3 width=5 by cpm_cpms, ex4_intro/
| #m1 #m2 #T0 #T3 #H1T03 #H0T0 #H2T03 #_ #_ #_ #IH
  #n2 #T2 #H1T02 #H2T02 #L1 #HL01 #L2 #HL02
  elim (cnv_cpm_tdeq_conf_lpr … H0T0 … H1T03 H2T03 … H1T02 H2T02 … L0 … HL02) -T0 //
  #T0 #H1T30 #H2T30 #H1T20 #H2T20
  elim (IH … H1T30 H2T30 … HL01 … HL02) -L0 -T3
  #T3 #H1T13 #H2T13 #H1T03 #H2T03
  <minus_plus >arith_l3
  /3 width=7 by cpms_step_sn, tdeq_trans, ex4_intro/
]
qed-.

fact cnv_cpms_tdeq_conf_lpr_aux (a) (h) (o) (G0) (L0) (T0):
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpm_trans_lpr a h G L T) →
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpms_conf_lpr a h G L T) →
     ∀n1,T1. ⦃G0,L0⦄ ⊢ T0 ➡*[n1,h] T1 → ⦃G0,L0⦄ ⊢ T0 ![a,h] → T0 ≛[h,o] T1 →
     ∀n2,T2. ⦃G0,L0⦄ ⊢ T0 ➡*[n2,h] T2 → T0 ≛[h,o] T2 →
     ∀L1. ⦃G0,L0⦄ ⊢ ➡[h] L1 → ∀L2. ⦃G0,L0⦄ ⊢ ➡[h] L2 →
     ∃∃T. ⦃G0,L1⦄ ⊢ T1 ➡*[n2-n1,h] T & T1 ≛[h,o] T & ⦃G0,L2⦄ ⊢ T2 ➡*[n1-n2,h] T & T2 ≛[h,o] T.
#a #h #o #G #L0 #T0 #IH2 #IH1 #n1 #T1 #H1T01 #H0T0 #H2T01
generalize in match IH1; generalize in match IH2;
@(cpms_tdeq_ind_sn … H1T01 H0T0 H2T01 IH1 IH2) -n1 -T0
[ #H0T1 #IH2 #IH1 #n2 #T2 #H1T12 #H2T12 #L1 #HL01 #L2 #HL02
  <minus_O_n <minus_n_O
  elim (cnv_cpms_tdeq_strip_lpr_aux … IH2 IH1 … H1T12 H0T1 H2T12 0 T1 … HL02 … HL01) // -L0 -H2T12
  <minus_O_n <minus_n_O #T #H1T2 #H2T2 #H1T1 #H2T1
  /3 width=5 by cpm_cpms, ex4_intro/
| #m1 #m2 #T0 #T3 #H1T03 #H0T0 #H2T03 #_ #_ #_ #IH #IH2 #IH1
  #n2 #T2 #H1T02 #H2T02 #L1 #HL01 #L2 #HL02
  elim (cnv_cpms_tdeq_strip_lpr_aux … IH2 IH1 … H1T02 H0T0 H2T02 … H1T03 H2T03 … HL02 L0) -H0T0 -H2T03 //
  #T4 #H1T24 #H2T24 #H1T34 #H2T34
  elim (IH … H1T34 H2T34 … HL01 … HL02) [|*: /4 width=5 by cpm_fpbq, fpbq_fpbg_trans/ ] -L0 -T0 -T3 (**)
  #T3 #H1T13 #H2T13 #H1T43 #H2T43
  <minus_plus >arith_l3
  /3 width=7 by cpms_step_sn, tdeq_trans, ex4_intro/
]
qed-.

(*
fact cnv_cpms_conf_lpr_refl_refl_aux (h) (G0) (L1) (L2) (T0:term):
     ∃∃T. ⦃G0,L1⦄ ⊢ T0 ➡*[h] T & ⦃G0,L2⦄ ⊢ T0 ➡*[h] T.
/2 width=3 by ex2_intro/ qed-.

fact cnv_cpms_conf_lpr_refl_step_aux (a) (h) (o) (G0) (L0) (T0) (m21) (m22):
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpm_trans_lpr a h G L T) →
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpms_conf_lpr a h G L T) →
     ⦃G0,L0⦄ ⊢ T0 ![a,h] →
     ∀X2. ⦃G0,L0⦄ ⊢ T0 ➡[m21,h] X2 → (T0 ≛[h,o] X2 → ⊥) → ∀T2. ⦃G0,L0⦄ ⊢ X2 ➡*[m22,h] T2 →
     ∀L1. ⦃G0,L0⦄ ⊢ ➡[h] L1 → ∀L2. ⦃G0,L0⦄ ⊢ ➡[h] L2 →
     ∃∃T. ⦃G0,L1⦄ ⊢ T0 ➡*[m21+m22,h] T& ⦃G0,L2⦄ ⊢ T2 ➡*[h] T.
#a #h #o #G0 #L0 #T0 #m21 #m22 #IH2 #IH1 #H0
#X2 #HX02 #HnX02 #T2 #HXT2
#L1 #HL01 #L2 #HL02
lapply (cnv_cpm_trans_lpr_aux … IH1 IH2 … HX02 … L0 ?) // #HX2
elim (cnv_cpm_conf_lpr_aux … IH2 IH1 … HX02 … 0 T0 … L0 … HL01) //
<minus_n_O <minus_O_n #Y1 #HXY1 #HTY1
elim (cnv_cpms_strip_lpr_sub … IH1 … HXT2 0 X2 … HL02 L0) [|*: /4 width=2 by fpb_fpbg, cpm_fpb/ ]
<minus_n_O <minus_O_n #Y2 #HTY2 #HXY2 -HXT2
elim (IH1 … HXY1 … HXY2 … HL01 … HL02) [|*: /4 width=2 by fpb_fpbg, cpm_fpb/ ]
-a -o -L0 -X2 <minus_n_O <minus_O_n #Y #HY1 #HY2
lapply (cpms_trans … HTY1 … HY1) -Y1 #HT0Y
lapply (cpms_trans … HTY2 … HY2) -Y2 #HT2Y
/2 width=3 by ex2_intro/
qed-.

fact cnv_cpms_conf_lpr_step_step_aux (a) (h) (o) (G0) (L0) (T0) (m11) (m12) (m21) (m22):
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpm_trans_lpr a h G L T) →
     (∀G,L,T. ⦃G0,L0,T0⦄ >[h,o] ⦃G,L,T⦄ → IH_cnv_cpms_conf_lpr a h G L T) →
     ⦃G0,L0⦄ ⊢ T0 ![a,h] →
     ∀X1. ⦃G0,L0⦄ ⊢ T0 ➡[m11,h] X1 → (T0 ≛[h,o] X1 → ⊥) → ∀T1. ⦃G0,L0⦄ ⊢ X1 ➡*[m12,h] T1 →
     ∀X2. ⦃G0,L0⦄ ⊢ T0 ➡[m21,h] X2 → (T0 ≛[h,o] X2 → ⊥) → ∀T2. ⦃G0,L0⦄ ⊢ X2 ➡*[m22,h] T2 →
     ∀L1. ⦃G0,L0⦄ ⊢ ➡[h] L1 → ∀L2. ⦃G0,L0⦄ ⊢ ➡[h] L2 →
     ∃∃T. ⦃G0,L1⦄ ⊢ T1 ➡*[m21+m22-(m11+m12),h] T& ⦃G0,L2⦄ ⊢ T2 ➡*[m11+m12-(m21+m22),h] T.
#a #h #o #G0 #L0 #T0 #m11 #m12 #m21 #m22 #IH2 #IH1 #H0
#X1 #HX01 #HnX01 #T1 #HXT1 #X2 #HX02 #HnX02 #T2 #HXT2
#L1 #HL01 #L2 #HL02
lapply (cnv_cpm_trans_lpr_aux … IH1 IH2 … HX01 … L0 ?) // #HX1
lapply (cnv_cpm_trans_lpr_aux … IH1 IH2 … HX02 … L0 ?) // #HX2
elim (cnv_cpm_conf_lpr_aux … IH2 IH1 … HX01 … HX02 … L0 … L0) // #Z0 #HXZ10 #HXZ20
cut (⦃G0,L0,T0⦄ >[h,o] ⦃G0,L0,X1⦄) [ /4 width=5 by cpms_fwd_fpbs, cpm_fpb, ex2_3_intro/ ] #H1fpbg (**) (* cut *)
lapply (fpbg_fpbs_trans ??? G0 ? L0 ? Z0 ? … H1fpbg) [ /2 width=2 by cpms_fwd_fpbs/ ] #H2fpbg
lapply (cnv_cpms_trans_lpr_sub … IH2 … HXZ10 … L0 ?) // #HZ0
elim (IH1 … HXT1 … HXZ10 … L1 … L0) [|*: /4 width=2 by fpb_fpbg, cpm_fpb/ ] -HXT1 -HXZ10 #Z1 #HTZ1 #HZ01
elim (IH1 … HXT2 … HXZ20 … L2 … L0) [|*: /4 width=2 by fpb_fpbg, cpm_fpb/ ] -HXT2 -HXZ20 #Z2 #HTZ2 #HZ02
elim (IH1 … HZ01 … HZ02  L1 … L2) // -L0 -T0 -X1 -X2 -Z0 #Z #HZ01 #HZ02
lapply (cpms_trans … HTZ1 … HZ01) -Z1 <arith_l4 #HT1Z
lapply (cpms_trans … HTZ2 … HZ02) -Z2 <arith_l4 #HT2Z
/2 width=3 by ex2_intro/
qed-.

fact cnv_cpms_conf_lpr_aux (a) (h) (o):
                           ∀G0,L0,T0. 𝐏[h,o]⦃T0⦄ →
                           (∀G1,L1,T1. ⦃G0, L0, T0⦄ >[h, o] ⦃G1, L1, T1⦄ → IH_cnv_cpm_trans_lpr a h G1 L1 T1) →
                           (∀G1,L1,T1. ⦃G0, L0, T0⦄ >[h, o] ⦃G1, L1, T1⦄ → IH_cnv_cpms_conf_lpr a h G1 L1 T1) →
                           ∀G1,L1,T1. G0 = G1 → L0 = L1 → T0 = T1 → IH_cnv_cpms_conf_lpr a h G1 L1 T1.
#a #h #o #G #L #T #H0 #IH2 #IH1 #G0 #L0 #T0 #HG #HL #HT
#HT0 #n1 #T1 #HT01 #n2 #T2 #HT02 #L1 #HL01 #L2 #HL02 destruct
elim (cpms_fwd_tdpos_sn … HT0 H0 … HT01) *
elim (cpms_fwd_tdpos_sn … HT0 H0 … HT02) *
-H0 -HT01 -HT02
[ #H21 #H22 #H11 #H12 destruct -a -o -L0
  <minus_n_O 
  /2 width=1 by cnv_cpms_conf_lpr_refl_refl_aux/
| #m21 #m22 #X2 #HX02 #HnX02 #HXT2 #H2 #H11 #H12 destruct
  <minus_n_O <minus_O_n
  @(cnv_cpms_conf_lpr_refl_step_aux … IH2 IH1) -IH2 -IH1 /2 width=4 by/
| #H21 #H22 #m11 #m12 #X1 #HX01 #HnX01 #HXT1 #H1 destruct
  <minus_n_O <minus_O_n
  @ex2_commute @(cnv_cpms_conf_lpr_refl_step_aux … IH2 IH1) -IH2 -IH1 /2 width=4 by/
| #m21 #m22 #X2 #HX02 #HnX02 #HXT2 #H2 #m11 #m12 #X1 #HX01 #HnX01 #HXT1 #H1 destruct
  @(cnv_cpms_conf_lpr_step_step_aux … IH2 IH1) -IH2 -IH1 /2 width=4 by/
]
qed-.
*)
