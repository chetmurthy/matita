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

include "basic_2/rt_equivalence/cpcs_cpcs.ma".
include "basic_2/dynamic/cnv_cpcs.ma".
include "basic_2/dynamic/nta.ma".

(* NATIVE TYPE ASSIGNMENT FOR TERMS *****************************************)

(* Properties based on preservation *****************************************)

lemma cnv_cpms_nta (a) (h) (G) (L):
      ∀T. ⦃G,L⦄ ⊢ T ![a,h] → ∀U.⦃G,L⦄ ⊢ T ➡*[1,h] U → ⦃G,L⦄ ⊢ T :[a,h] U.
/3 width=4 by cnv_cast, cnv_cpms_trans/ qed.

lemma cnv_nta_sn (a) (h) (G) (L):
      ∀T. ⦃G,L⦄ ⊢ T ![a,h] → ∃U. ⦃G,L⦄ ⊢ T :[a,h] U.
#a #h #G #L #T #HT
elim (cnv_fwd_cpm_SO … HT) #U #HTU
/4 width=2 by cnv_cpms_nta, cpm_cpms, ex_intro/
qed-.

(* Basic_1: was: ty3_typecheck *)
lemma nta_typecheck (a) (h) (G) (L):
      ∀T,U. ⦃G,L⦄ ⊢ T :[a,h] U → ∃T0. ⦃G,L⦄ ⊢ ⓝU.T :[a,h] T0.
/3 width=1 by cnv_cast, cnv_nta_sn/ qed-.

(* Basic_1: was: ty3_correct *)
(* Basic_2A1: was: ntaa_fwd_correct *)
lemma nta_fwd_correct (a) (h) (G) (L):
      ∀T,U. ⦃G,L⦄ ⊢ T :[a,h] U → ∃T0. ⦃G,L⦄ ⊢ U :[a,h] T0.
/3 width=2 by nta_fwd_cnv_dx, cnv_nta_sn/ qed-.

lemma nta_pure_cnv (h) (G) (L):
      ∀T,U. ⦃G,L⦄ ⊢ T :*[h] U →
      ∀V. ⦃G,L⦄ ⊢ ⓐV.U !*[h] → ⦃G,L⦄ ⊢ ⓐV.T :*[h] ⓐV.U.
#h #G #L #T #U #H1 #V #H2
elim (cnv_inv_cast … H1) -H1 #X0 #HU #HT #HUX0 #HTX0
elim (cnv_inv_appl … H2) #n #p #X1 #X2 #_ #HV #_ #HVX1 #HUX2
elim (cnv_cpms_conf … HU … HUX0 … HUX2) -HU -HUX2
<minus_O_n <minus_n_O #X #HX0 #H
elim (cpms_inv_abst_sn … H) -H #X3 #X4 #HX13 #HX24 #H destruct
@(cnv_cast … (ⓐV.X0)) [2:|*: /2 width=1 by cpms_appl_dx/ ]
@(cnv_appl … X3) [4: |*: /2 width=7 by cpms_trans, cpms_cprs_trans/ ]
#H destruct
qed.

(* Inversion lemmas based on preservation ***********************************)

lemma nta_inv_ldef_sn (a) (h) (G) (K) (V):
      ∀X2. ⦃G,K.ⓓV⦄ ⊢ #0 :[a,h] X2 →
      ∃∃W,U. ⦃G,K⦄ ⊢ V :[a,h] W & ⬆*[1] W ≘ U & ⦃G,K.ⓓV⦄ ⊢ U ⬌*[h] X2 & ⦃G,K.ⓓV⦄ ⊢ X2 ![a,h].
#a #h #G #Y #X #X2 #H
elim (cnv_inv_cast … H) -H #X1 #HX2 #H1 #HX21 #H2
elim (cnv_inv_zero … H1) -H1 #Z #K #V #HV #H destruct
elim (cpms_inv_delta_sn … H2) -H2 *
[ #_ #H destruct
| #W #HVW #HWX1
  /3 width=5 by cnv_cpms_nta, cpcs_cprs_sn, ex4_2_intro/
]
qed-.

lemma nta_inv_lref_sn (a) (h) (G) (L):
      ∀X2,i. ⦃G,L⦄ ⊢ #↑i :[a,h] X2 →
      ∃∃I,K,T2,U2. ⦃G,K⦄ ⊢ #i :[a,h] T2 & ⬆*[1] T2 ≘ U2 & ⦃G,K.ⓘ{I}⦄ ⊢ U2 ⬌*[h] X2 & ⦃G,K.ⓘ{I}⦄ ⊢ X2 ![a,h] & L = K.ⓘ{I}.
#a #h #G #L #X2 #i #H
elim (cnv_inv_cast … H) -H #X1 #HX2 #H1 #HX21 #H2
elim (cnv_inv_lref … H1) -H1 #I #K #Hi #H destruct
elim (cpms_inv_lref_sn … H2) -H2 *
[ #_ #H destruct
| #X #HX #HX1
  /3 width=9 by cnv_cpms_nta, cpcs_cprs_sn, ex5_4_intro/
]
qed-.

lemma nta_inv_lref_sn_drops_cnv (a) (h) (G) (L): 
      ∀X2, i. ⦃G,L⦄ ⊢ #i :[a,h] X2 →
      ∨∨ ∃∃K,V,W,U. ⬇*[i] L ≘ K.ⓓV & ⦃G,K⦄ ⊢ V :[a,h] W & ⬆*[↑i] W ≘ U & ⦃G,L⦄ ⊢ U ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 ![a,h]
       | ∃∃K,W,U. ⬇*[i] L ≘ K. ⓛW & ⦃G,K⦄ ⊢ W ![a,h] & ⬆*[↑i] W ≘ U & ⦃G,L⦄ ⊢ U ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 ![a,h].
#a #h #G #L #X2 #i #H
elim (cnv_inv_cast … H) -H #X1 #HX2 #H1 #HX21 #H2
elim (cnv_inv_lref_drops … H1) -H1 #I #K #V #HLK #HV
elim (cpms_inv_lref1_drops … H2) -H2 *
[ #_ #H destruct
| #Y #X #W #H #HVW #HUX1
  lapply (drops_mono … H … HLK) -H #H destruct
  /4 width=8 by cnv_cpms_nta, cpcs_cprs_sn, ex5_4_intro, or_introl/
| #n #Y #X #U #H #HVU #HUX1 #H0 destruct
  lapply (drops_mono … H … HLK) -H #H destruct
  elim (lifts_total V (𝐔❴↑i❵)) #W #HVW
  lapply (cpms_lifts_bi … HVU (Ⓣ) … L … HVW … HUX1) -U
  [ /2 width=2 by drops_isuni_fwd_drop2/ ] #HWX1
  /4 width=9 by cprs_div, ex5_3_intro, or_intror/
]
qed-.

lemma nta_inv_bind_sn_cnv (a) (h) (p) (I) (G) (K) (X2):
      ∀V,T. ⦃G,K⦄ ⊢ ⓑ{p,I}V.T :[a,h] X2 →
      ∃∃U. ⦃G,K⦄ ⊢ V ![a,h] & ⦃G,K.ⓑ{I}V⦄ ⊢ T :[a,h] U & ⦃G,K⦄ ⊢ ⓑ{p,I}V.U ⬌*[h] X2 & ⦃G,K⦄ ⊢ X2 ![a,h].
#a #h #p * #G #K #X2 #V #T #H
elim (cnv_inv_cast … H) -H #X1 #HX2 #H1 #HX21 #H2
elim (cnv_inv_bind … H1) -H1 #HV #HT
[ elim (cpms_inv_abbr_sn_dx … H2) -H2 *
  [ #V0 #U #HV0 #HTU #H destruct
    /4 width=5 by cnv_cpms_nta, cprs_div, cpms_bind, ex4_intro/
  | #U #HTU #HX1U #H destruct
    /4 width=5 by cnv_cpms_nta, cprs_div, cpms_zeta, ex4_intro/
  ]
| elim (cpms_inv_abst_sn … H2) -H2 #V0 #U #HV0 #HTU #H destruct
  /4 width=5 by cnv_cpms_nta, cprs_div, cpms_bind, ex4_intro/
]
qed-.

(* Basic_1: uses: ty3_gen_appl *)
lemma nta_inv_appl_sn (h) (G) (L) (X2):
      ∀V,T. ⦃G,L⦄ ⊢ ⓐV.T :[h] X2 →
      ∃∃p,W,U. ⦃G,L⦄ ⊢ V :[h] W & ⦃G,L⦄ ⊢ T :[h] ⓛ{p}W.U & ⦃G,L⦄ ⊢ ⓐV.ⓛ{p}W.U ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 ![h].
#h #G #L #X2 #V #T #H
elim (cnv_inv_cast … H) -H #X #HX2 #H1 #HX2 #H2
elim (cnv_inv_appl … H1) * [ | #n ] #p #W #U #Hn #HV #HT #HVW #HTU
[ lapply (cnv_cpms_trans … HT … HTU) #H
  elim (cnv_inv_bind … H) -H #_ #HU
  elim (cnv_fwd_cpm_SO … HU) #U0 #HU0 -HU
  lapply (cpms_step_dx … HTU 1 (ⓛ{p}W.U0) ?) -HTU [ /2 width=1 by cpm_bind/ ] #HTU
| lapply (le_n_O_to_eq n ?) [ /3 width=1 by le_S_S_to_le/ ] -Hn #H destruct
]
/5 width=11 by cnv_cpms_nta, cnv_cpms_conf_eq, cpcs_cprs_div, cpms_appl_dx, ex4_3_intro/
qed-.

(* Basic_2A1: uses: nta_fwd_pure1 *)
lemma nta_inv_pure_sn_cnv (h) (G) (L) (X2):
                          ∀V,T. ⦃G,L⦄ ⊢ ⓐV.T :*[h] X2 →
                          ∨∨ ∃∃p,W,U. ⦃G,L⦄ ⊢ V :*[h] W & ⦃G,L⦄ ⊢ T :*[h] ⓛ{p}W.U & ⦃G,L⦄ ⊢ ⓐV.ⓛ{p}W.U ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 !*[h]
                           | ∃∃U. ⦃G,L⦄ ⊢ T :*[h] U & ⦃G,L⦄ ⊢ ⓐV.U !*[h] & ⦃G,L⦄ ⊢ ⓐV.U ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 !*[h].
#h #G #L #X2 #V #T #H
elim (cnv_inv_cast … H) -H #X1 #HX2 #H1 #HX21 #H
elim (cnv_inv_appl … H1) * [| #n ] #p #W0 #T0 #Hn #HV #HT #HW0 #HT0
[ lapply (cnv_cpms_trans … HT … HT0) #H0
  elim (cnv_inv_bind … H0) -H0 #_ #HU
  elim (cnv_fwd_cpm_SO … HU) #U0 #HU0 -HU
  lapply (cpms_step_dx … HT0 1 (ⓛ{p}W0.U0) ?) -HT0 [ /2 width=1 by cpm_bind/ ] #HT0
  lapply (cpms_appl_dx … V V … HT0) [ // ] #HTU0
  lapply (cnv_cpms_conf_eq … H1 … HTU0 … H) -H1 -H -HTU0 #HU0X1
  /4 width=8 by cnv_cpms_nta, cpcs_cprs_div, ex4_3_intro, or_introl/
| elim (cnv_cpms_fwd_appl_sn_decompose …  H1 … H) -H1 -H #X0 #_ #H #HX01
  elim (cpms_inv_plus … 1 n … HT0) #U #HTU #HUT0
  lapply (cnv_cpms_trans … HT … HTU) #HU
  lapply (cnv_cpms_conf_eq … HT … HTU … H) -H #HUX0
  @or_intror @(ex4_intro … U … HX2) -HX2
  [ /2 width=1 by cnv_cpms_nta/
  | /4 width=7 by cnv_appl, lt_to_le/
  | /4 width=3 by cpcs_trans, cpcs_cprs_div, cpcs_flat/
  ]
]
qed-.

(* Basic_2A1: uses: nta_inv_cast1 *)
lemma nta_inv_cast_sn (a) (h) (G) (L) (X2):
      ∀U,T. ⦃G,L⦄ ⊢ ⓝU.T :[a,h] X2 →
      ∧∧ ⦃G,L⦄ ⊢ T :[a,h] U & ⦃G,L⦄ ⊢ U ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 ![a,h].
#a #h #G #L #X2 #U #T #H
elim (cnv_inv_cast … H) -H #X0 #HX2 #H1 #HX20 #H2
elim (cnv_inv_cast … H1) #X #HU #HT #HUX #HTX
elim (cpms_inv_cast1 … H2) -H2 [ * || * ]
[ #U0 #T0 #HU0 #HT0 #H destruct -HU -HU0
  lapply (cnv_cpms_conf_eq … HT … HTX … HT0) -HT -HT0 -HTX #HXT0
  lapply (cprs_step_dx … HX20 T0 ?) -HX20 [ /2 width=1 by cpm_eps/ ] #HX20
| #HTX0 -HU
  lapply (cnv_cpms_conf_eq … HT … HTX … HTX0) -HT -HTX -HTX0 #HX0
| #m #HUX0 #H destruct -HT -HTX
  lapply (cnv_cpms_conf_eq … HU … HUX … HUX0) -HU -HUX0 #HX0
]
/4 width=3 by cpcs_cprs_div, cpcs_cprs_step_sn, and3_intro/
qed-.

(* Basic_1: uses: ty3_gen_cast *)
lemma nta_inv_cast_sn_old (a) (h) (G) (L) (X2):
      ∀T0,T1. ⦃G,L⦄ ⊢ ⓝT1.T0 :[a,h] X2 →
      ∃∃T2. ⦃G,L⦄ ⊢ T0 :[a,h] T1 & ⦃G,L⦄ ⊢ T1 :[a,h] T2 & ⦃G,L⦄ ⊢ ⓝT2.T1 ⬌*[h] X2 & ⦃G,L⦄ ⊢ X2 ![a,h].
#a #h #G #L #X2 #T0 #T1 #H
elim (cnv_inv_cast … H) -H #X0 #HX2 #H1 #HX20 #H2
elim (cnv_inv_cast … H1) #X #HT1 #HT0 #HT1X #HT0X
elim (cpms_inv_cast1 … H2) -H2 [ * || * ]
[ #U1 #U0 #HTU1 #HTU0 #H destruct
  lapply (cnv_cpms_conf_eq … HT0 … HT0X … HTU0) -HT0 -HT0X -HTU0 #HXU0
  /5 width=5 by cnv_cpms_nta, cpcs_cprs_div, cpcs_cprs_step_sn, cpcs_flat, ex4_intro/
| #HTX0
  elim (cnv_nta_sn … HT1) -HT1 #U1 #HTU1
  lapply (cnv_cpms_conf_eq … HT0 … HT0X … HTX0) -HT0 -HT0X -HTX0 #HX0
  lapply (cprs_step_sn … (ⓝU1.T1) … HT1X) -HT1X [ /2 width=1 by cpm_eps/ ] #HT1X
  /4 width=5 by cpcs_cprs_div, cpcs_cprs_step_sn, ex4_intro/
| #n #HT1X0 #H destruct -X -HT0
  elim (cnv_nta_sn … HT1) -HT1 #U1 #HTU1
  /4 width=5 by cprs_div, cpms_eps, ex4_intro/
]
qed-.

(* Forward lemmas based on preservation *************************************)

(* Basic_1: was: ty3_unique *)
theorem nta_mono (a) (h) (G) (L) (T):
        ∀U1. ⦃G,L⦄ ⊢ T :[a,h] U1 → ∀U2. ⦃G,L⦄ ⊢ T :[a,h] U2 → ⦃G,L⦄  ⊢ U1 ⬌*[h] U2.
#a #h #G #L #T #U1 #H1 #U2 #H2
elim (cnv_inv_cast … H1) -H1 #X1 #_ #_ #HUX1 #HTX1
elim (cnv_inv_cast … H2) -H2 #X2 #_ #HT #HUX2 #HTX2
lapply (cnv_cpms_conf_eq … HT … HTX1 … HTX2) -T #HX12
/3 width=3 by cpcs_cprs_div, cpcs_cprs_step_sn/
qed-.
