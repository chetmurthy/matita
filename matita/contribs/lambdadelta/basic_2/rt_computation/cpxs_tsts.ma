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

include "basic_2/syntax/tsts_tdeq.ma".
include "basic_2/rt_computation/cpxs_lsubr.ma".
include "basic_2/rt_computation/cpxs_cnx.ma".
include "basic_2/rt_computation/lfpxs_cpxs.ma".

(* UNCOUNTED CONTEXT-SENSITIVE PARALLEL RT-COMPUTATION FOR TERMS ************)

(* Forward lemmas with same top term structure ******************************)

lemma cpxs_fwd_sort: ∀h,o,G,L,U,s. ⦃G, L⦄ ⊢ ⋆s ⬈*[h] U →
                     ⋆s ⩳[h, o] U ∨ ⦃G, L⦄ ⊢ ⋆(next h s) ⬈*[h] U.
#h #o #G #L #U #s #H elim (cpxs_inv_sort1 … H) -H *
[ #H destruct /2 width=1 by or_introl/
| #n #H destruct
  @or_intror >iter_S <(iter_n_Sm … (next h)) // (**)
]
qed-.

(* Basic_1: was just: pr3_iso_beta *)
lemma cpxs_fwd_beta: ∀h,o,p,G,L,V,W,T,U. ⦃G, L⦄ ⊢ ⓐV.ⓛ{p}W.T ⬈*[h] U →
                     ⓐV.ⓛ{p}W.T ⩳[h, o] U ∨ ⦃G, L⦄ ⊢ ⓓ{p}ⓝW.V.T ⬈*[h] U.
#h #o #p #G #L #V #W #T #U #H elim (cpxs_inv_appl1 … H) -H *
[ #V0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair, or_introl/
| #b #W0 #T0 #HT0 #HU
  elim (cpxs_inv_abst1 … HT0) -HT0 #W1 #T1 #HW1 #HT1 #H destruct
  lapply (lsubr_cpxs_trans … HT1 (L.ⓓⓝW.V) ?) -HT1
  /5 width=3 by cpxs_trans, cpxs_bind, cpxs_pair_sn, lsubr_beta, or_intror/
| #b #V1 #V2 #V0 #T1 #_ #_ #HT1 #_
  elim (cpxs_inv_abst1 … HT1) -HT1 #W2 #T2 #_ #_ #H destruct
]
qed-.

(* Note: probably this is an inversion lemma *)
(* Basic_2A1: was: cpxs_fwd_delta *)
lemma cpxs_fwd_delta_drops: ∀h,o,I,G,L,K,V1,i. ⬇*[i] L ≡ K.ⓑ{I}V1 →
                            ∀V2. ⬆*[⫯i] V1 ≡ V2 →
                            ∀U. ⦃G, L⦄ ⊢ #i ⬈*[h] U →
                            #i ⩳[h, o] U ∨ ⦃G, L⦄ ⊢ V2 ⬈*[h] U.
#h #o #I #G #L #K #V1 #i #HLK #V2 #HV12 #U #H
elim (cpxs_inv_lref1_drops … H) -H /2 width=1 by or_introl/
* #I0 #K0 #V0 #U0 #HLK0 #HVU0 #HU0
lapply (drops_mono … HLK0 … HLK) -HLK0 #H destruct
elim (cpxs_lifts … HVU0 (Ⓣ) … L … HV12) -HVU0 -HV12 /2 width=3 by drops_isuni_fwd_drop2/ #X #H
<(lifts_mono … HU0 … H) -U0 -X /2 width=1 by or_intror/
qed-.

lemma cpxs_fwd_theta: ∀h,o,p,G,L,V1,V,T,U. ⦃G, L⦄ ⊢ ⓐV1.ⓓ{p}V.T ⬈*[h] U →
                      ∀V2. ⬆*[1] V1 ≡ V2 → ⓐV1.ⓓ{p}V.T ⩳[h, o] U ∨
                      ⦃G, L⦄ ⊢ ⓓ{p}V.ⓐV2.T ⬈*[h] U.
#h #o #p #G #L #V1 #V #T #U #H #V2 #HV12
elim (cpxs_inv_appl1 … H) -H *
[ -HV12 #V0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair, or_introl/
| #q #W #T0 #HT0 #HU
  elim (cpxs_inv_abbr1 … HT0) -HT0 *
  [ #V3 #T3 #_ #_ #H destruct
  | #X #HT2 #H #H0 destruct
    elim (lifts_inv_bind1 … H) -H #W2 #T2 #HW2 #HT02 #H destruct
    @or_intror @(cpxs_trans … HU) -U (**) (* explicit constructor *)
    @(cpxs_trans … (+ⓓV.ⓐV2.ⓛ{q}W2.T2)) [ /3 width=1 by cpxs_flat_dx, cpxs_bind_dx/ ] -T
    @(cpxs_strap2 … (ⓐV1.ⓛ{q}W.T0)) [2: /2 width=1 by cpxs_beta_dx/ ]
    /4 width=7 by cpx_zeta, lifts_bind, lifts_flat/
  ]
| #q #V3 #V4 #V0 #T0 #HV13 #HV34 #HT0 #HU
  @or_intror @(cpxs_trans … HU) -U (**) (* explicit constructor *)
  elim (cpxs_inv_abbr1 … HT0) -HT0 *
  [ #V5 #T5 #HV5 #HT5 #H destruct
    elim (cpxs_lifts … HV13 (Ⓣ) … (L.ⓓV) … HV12) -V1 /3 width=1 by drops_refl, drops_drop/ #X #H
    <(lifts_mono … HV34 … H) -V3 -X /3 width=1 by cpxs_flat, cpxs_bind/
  | #X #HT1 #H #H0 destruct
    elim (lifts_inv_bind1 … H) -H #V5 #T5 #HV05 #HT05 #H destruct
    elim (cpxs_lifts … HV13 (Ⓣ) … (L.ⓓV0) … HV12) -HV13 /3 width=1 by drops_refl, drops_drop/ #X #H
    <(lifts_mono … HV34 … H) -V3 -X #HV24
    @(cpxs_trans … (+ⓓV.ⓐV2.ⓓ{q}V5.T5)) [ /3 width=1 by cpxs_flat_dx, cpxs_bind_dx/ ] -T
    @(cpxs_strap2 … (ⓐV1.ⓓ{q}V0.T0)) [ /4 width=7 by cpx_zeta, lifts_bind, lifts_flat/ ] -V -V5 -T5
    @(cpxs_strap2 … (ⓓ{q}V0.ⓐV2.T0)) /3 width=3 by cpxs_pair_sn, cpxs_bind_dx, cpx_theta/
  ]
]
qed-.

lemma cpxs_fwd_cast: ∀h,o,G,L,W,T,U. ⦃G, L⦄ ⊢ ⓝW.T ⬈*[h] U →
                     ∨∨ ⓝW. T ⩳[h, o] U | ⦃G, L⦄ ⊢ T ⬈*[h] U | ⦃G, L⦄ ⊢ W ⬈*[h] U.
#h #o #G #L #W #T #U #H
elim (cpxs_inv_cast1 … H) -H /2 width=1 by or3_intro1, or3_intro2/ *
#W0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair, or3_intro0/
qed-.

lemma cpxs_fwd_cnx: ∀h,o,G,L,T. ⦃G, L⦄ ⊢ ⬈[h, o] 𝐍⦃T⦄ →
                    ∀U. ⦃G, L⦄ ⊢ T ⬈*[h] U → T ⩳[h, o] U.
/3 width=4 by cpxs_inv_cnx1, tdeq_tsts/ qed-.
