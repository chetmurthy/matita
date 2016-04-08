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

include "basic_2/grammar/tsts_vector.ma".
include "basic_2/substitution/lift_vector.ma".
include "basic_2/computation/cpxs_tsts.ma".

(* CONTEXT-SENSITIVE EXTENDED PARALLEL COMPUTATION ON TERMS *****************)

(* Vector form of forward lemmas involving same top term structure **********)

(* Basic_1: was just: nf2_iso_appls_lref *)
lemma cpxs_fwd_cnx_vector: ∀h,o,G,L,T.  𝐒⦃T⦄ → ⦃G, L⦄ ⊢ ➡[h, o] 𝐍⦃T⦄ →
                           ∀Vs,U. ⦃G, L⦄ ⊢ ⒶVs.T ➡*[h, o] U → ⒶVs.T ≂ U.
#h #o #G #L #T #H1T #H2T #Vs elim Vs -Vs [ @(cpxs_fwd_cnx … H2T) ] (**) (* /2 width=3 by cpxs_fwd_cnx/ does not work *)
#V #Vs #IHVs #U #H
elim (cpxs_inv_appl1 … H) -H *
[ -IHVs #V0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair/
| #a #W0 #T0 #HT0 #HU
  lapply (IHVs … HT0) -IHVs -HT0 #HT0
  elim (tsts_inv_bind_applv_simple … HT0) //
| #a #V1 #V2 #V0 #T0 #HV1 #HV12 #HT0 #HU
  lapply (IHVs … HT0) -IHVs -HT0 #HT0
  elim (tsts_inv_bind_applv_simple … HT0) //
]
qed-.

lemma cpxs_fwd_sort_vector: ∀h,o,G,L,s,Vs,U. ⦃G, L⦄ ⊢ ⒶVs.⋆s ➡*[h, o] U →
                            ⒶVs.⋆s ≂ U ∨ ⦃G, L⦄ ⊢ ⒶVs.⋆(next h s) ➡*[h, o] U.
#h #o #G #L #s #Vs elim Vs -Vs /2 width=1 by cpxs_fwd_sort/
#V #Vs #IHVs #U #H
elim (cpxs_inv_appl1 … H) -H *
[ -IHVs #V1 #T1 #_ #_ #H destruct /2 width=1 by tsts_pair, or_introl/
| #a #W1 #T1 #HT1 #HU
  elim (IHVs … HT1) -IHVs -HT1 #HT1
  [ elim (tsts_inv_bind_applv_simple … HT1) //
  | @or_intror (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV.ⓛ{a}W1.T1)) /3 width=1 by cpxs_flat_dx, cpr_cpx, cpr_beta/
  ]
| #a #V1 #V2 #V3 #T1 #HV01 #HV12 #HT1 #HU
  elim (IHVs … HT1) -IHVs -HT1 #HT1
  [ elim (tsts_inv_bind_applv_simple … HT1) //
  | @or_intror (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV1.ⓓ{a}V3.T1)) /3 width=3 by cpxs_flat, cpr_cpx, cpr_theta/
  ]
]
qed-.


(* Basic_1: was just: pr3_iso_appls_beta *)
lemma cpxs_fwd_beta_vector: ∀h,o,a,G,L,Vs,V,W,T,U. ⦃G, L⦄ ⊢ ⒶVs.ⓐV.ⓛ{a}W.T ➡*[h, o] U →
                            ⒶVs. ⓐV. ⓛ{a}W. T ≂ U ∨ ⦃G, L⦄ ⊢ ⒶVs.ⓓ{a}ⓝW.V.T ➡*[h, o] U.
#h #o #a #G #L #Vs elim Vs -Vs /2 width=1 by cpxs_fwd_beta/
#V0 #Vs #IHVs #V #W #T #U #H
elim (cpxs_inv_appl1 … H) -H *
[ -IHVs #V1 #T1 #_ #_ #H destruct /2 width=1 by tsts_pair, or_introl/
| #b #W1 #T1 #HT1 #HU
  elim (IHVs … HT1) -IHVs -HT1 #HT1
  [ elim (tsts_inv_bind_applv_simple … HT1) //
  | @or_intror (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV0.ⓛ{b}W1.T1)) /3 width=1 by cpxs_flat_dx, cpr_cpx, cpr_beta/
  ]
| #b #V1 #V2 #V3 #T1 #HV01 #HV12 #HT1 #HU
  elim (IHVs … HT1) -IHVs -HT1 #HT1
  [ elim (tsts_inv_bind_applv_simple … HT1) //
  | @or_intror (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV1.ⓓ{b}V3.T1)) /3 width=3 by cpxs_flat, cpr_cpx, cpr_theta/
  ]
]
qed-.

lemma cpxs_fwd_delta_vector: ∀h,o,I,G,L,K,V1,i. ⬇[i] L ≡ K.ⓑ{I}V1 →
                             ∀V2. ⬆[0, i + 1] V1 ≡ V2 →
                             ∀Vs,U. ⦃G, L⦄ ⊢ ⒶVs.#i ➡*[h, o] U →
                             ⒶVs.#i ≂ U ∨ ⦃G, L⦄ ⊢ ⒶVs.V2 ➡*[h, o] U.
#h #o #I #G #L #K #V1 #i #HLK #V2 #HV12 #Vs elim Vs -Vs /2 width=5 by cpxs_fwd_delta/
#V #Vs #IHVs #U #H -K -V1
elim (cpxs_inv_appl1 … H) -H *
[ -IHVs #V0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair, or_introl/
| #b #W0 #T0 #HT0 #HU
  elim (IHVs … HT0) -IHVs -HT0 #HT0
  [ elim (tsts_inv_bind_applv_simple … HT0) //
  | @or_intror -i (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV.ⓛ{b}W0.T0)) /3 width=1 by cpxs_flat_dx, cpr_cpx, cpr_beta/
  ]
| #b #V0 #V1 #V3 #T0 #HV0 #HV01 #HT0 #HU
  elim (IHVs … HT0) -IHVs -HT0 #HT0
  [ elim (tsts_inv_bind_applv_simple … HT0) //
  | @or_intror -i (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV0.ⓓ{b}V3.T0)) /3 width=3 by cpxs_flat, cpr_cpx, cpr_theta/
  ]
]
qed-.

(* Basic_1: was just: pr3_iso_appls_abbr *)
lemma cpxs_fwd_theta_vector: ∀h,o,G,L,V1c,V2c. ⬆[0, 1] V1c ≡ V2c →
                             ∀a,V,T,U. ⦃G, L⦄ ⊢ ⒶV1c.ⓓ{a}V.T ➡*[h, o] U →
                             ⒶV1c. ⓓ{a}V. T ≂ U ∨ ⦃G, L⦄ ⊢ ⓓ{a}V.ⒶV2c.T ➡*[h, o] U.
#h #o #G #L #V1c #V2c * -V1c -V2c /3 width=1 by or_intror/
#V1c #V2c #V1a #V2a #HV12a #HV12c #a
generalize in match HV12a; -HV12a
generalize in match V2a; -V2a
generalize in match V1a; -V1a
elim HV12c -V1c -V2c /2 width=1 by cpxs_fwd_theta/
#V1c #V2c #V1b #V2b #HV12b #_ #IHV12c #V1a #V2a #HV12a #V #T #U #H
elim (cpxs_inv_appl1 … H) -H *
[ -IHV12c -HV12a -HV12b #V0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair, or_introl/
| #b #W0 #T0 #HT0 #HU
  elim (IHV12c … HV12b … HT0) -IHV12c -HT0 #HT0
  [ -HV12a -HV12b -HU
    elim (tsts_inv_pair1 … HT0) #V1 #T1 #H destruct
  | @or_intror -V1c (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    elim (cpxs_inv_abbr1 … HT0) -HT0 *
    [ -HV12a -HV12b #V1 #T1 #_ #_ #H destruct
    | -V1b #X #HT1 #H #H0 destruct
      elim (lift_inv_bind1 … H) -H #W1 #T1 #HW01 #HT01 #H destruct
      @(cpxs_trans … (+ⓓV.ⓐV2a.ⓛ{b}W1.T1)) [ /3 width=1 by cpxs_flat_dx, cpxs_bind_dx/ ] -T -V2b -V2c
      @(cpxs_strap2 … (ⓐV1a.ⓛ{b}W0.T0))
      /4 width=7 by cpxs_beta_dx, cpx_zeta, lift_bind, lift_flat/
    ]
  ]
| #b #V0a #Va #V0 #T0 #HV10a #HV0a #HT0 #HU
  elim (IHV12c … HV12b … HT0) -HV12b -IHV12c -HT0 #HT0
  [ -HV12a -HV10a -HV0a -HU
    elim (tsts_inv_pair1 … HT0) #V1 #T1 #H destruct
  | @or_intror -V1c -V1b (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    elim (cpxs_inv_abbr1 … HT0) -HT0 *
    [ #V1 #T1 #HV1 #HT1 #H destruct
      lapply (cpxs_lift … HV10a (L.ⓓV) (Ⓕ) … HV12a … HV0a) -V1a -V0a [ /2 width=1 by drop_drop/ ] #HV2a
      @(cpxs_trans … (ⓓ{a}V.ⓐV2a.T1)) /3 width=1 by cpxs_bind, cpxs_pair_sn, cpxs_flat_dx, cpxs_bind_dx/
    | #X #HT1 #H #H0 destruct
      elim (lift_inv_bind1 … H) -H #V1 #T1 #HW01 #HT01 #H destruct
      lapply (cpxs_lift … HV10a (L.ⓓV0) (Ⓕ) … HV12a … HV0a) -V0a [ /2 width=1 by drop_drop/ ] #HV2a
      @(cpxs_trans … (+ⓓV.ⓐV2a.ⓓ{b}V1.T1)) [ /3 width=1 by cpxs_flat_dx, cpxs_bind_dx/ ] -T -V2b -V2c
      @(cpxs_strap2 … (ⓐV1a.ⓓ{b}V0.T0)) [ /4 width=7 by cpx_zeta, lift_bind, lift_flat/ ] -V -V1 -T1
      @(cpxs_strap2 … (ⓓ{b}V0.ⓐV2a.T0)) /3 width=3 by cpxs_pair_sn, cpxs_bind_dx, cpr_cpx, cpr_theta/
    ]
  ]
]
qed-.

(* Basic_1: was just: pr3_iso_appls_cast *)
lemma cpxs_fwd_cast_vector: ∀h,o,G,L,Vs,W,T,U. ⦃G, L⦄ ⊢ ⒶVs.ⓝW.T ➡*[h, o] U →
                            ∨∨ ⒶVs. ⓝW. T ≂ U
                             | ⦃G, L⦄ ⊢ ⒶVs.T ➡*[h, o] U
                             | ⦃G, L⦄ ⊢ ⒶVs.W ➡*[h, o] U.
#h #o #G #L #Vs elim Vs -Vs /2 width=1 by cpxs_fwd_cast/
#V #Vs #IHVs #W #T #U #H
elim (cpxs_inv_appl1 … H) -H *
[ -IHVs #V0 #T0 #_ #_ #H destruct /2 width=1 by tsts_pair, or3_intro0/
| #b #W0 #T0 #HT0 #HU elim (IHVs … HT0) -IHVs -HT0 #HT0
  [ elim (tsts_inv_bind_applv_simple … HT0) //
  | @or3_intro1 -W (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV.ⓛ{b}W0.T0)) /2 width=1 by cpxs_flat_dx, cpx_beta/
  | @or3_intro2 -T (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV.ⓛ{b}W0.T0)) /2 width=1 by cpxs_flat_dx, cpx_beta/
  ]
| #b #V0 #V1 #V2 #T0 #HV0 #HV01 #HT0 #HU
  elim (IHVs … HT0) -IHVs -HT0 #HT0
  [ elim (tsts_inv_bind_applv_simple … HT0) //
  | @or3_intro1 -W (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV0.ⓓ{b}V2.T0)) /2 width=3 by cpxs_flat, cpx_theta/
  | @or3_intro2 -T (**) (* explicit constructor *)
    @(cpxs_trans … HU) -U
    @(cpxs_strap1 … (ⓐV0.ⓓ{b}V2.T0)) /2 width=3 by cpxs_flat, cpx_theta/
  ]
]
qed-.
