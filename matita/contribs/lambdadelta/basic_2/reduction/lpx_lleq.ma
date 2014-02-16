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

include "basic_2/substitution/lleq_ext.ma".
include "basic_2/reduction/lpx_ldrop.ma".

(* SN EXTENDED PARALLEL REDUCTION FOR LOCAL ENVIRONMENTS ********************)

(* Properties on lazy equivalence for local environments ********************)
(*
lamma pippo: ∀h,g,G,L2,K2. ⦃G, L2⦄ ⊢ ➡[h, g] K2 → ∀L1. |L1| = |L2| →
             ∃∃K1. ⦃G, L1⦄ ⊢ ➡[h, g] K1 & |K1| = |K2| &
                   (∀T,d. L1 ⋕[T, d] L2 ↔ K1 ⋕[T, d] K2).
#h #g #G #L2 #K2 #H elim H -L2 -K2
[ #L1 #H >(length_inv_zero_dx … H) -L1 /3 width=5 by ex3_intro, conj/
| #I2 #L2 #K2 #V2 #W2 #_ #HVW2 #IHLK2 #Y #H
  elim (length_inv_pos_dx … H) -H #I #L1 #V1 #HL12 #H destruct
  elim (IHLK2 … HL12) -IHLK2 #K1 #HLK1 #HK12 #IH
  elim (eq_term_dec V1 V2) #H destruct
  [ @(ex3_intro … (K1.ⓑ{I}W2)) normalize /2 width=1 by /
*)
axiom lleq_lpx_trans: ∀h,g,G,L2,K2. ⦃G, L2⦄ ⊢ ➡[h, g] K2 →
                      ∀L1,T,d. L1 ⋕[T, d] L2 →
                      ∃∃K1. ⦃G, L1⦄ ⊢ ➡[h, g] K1 & K1 ⋕[T, d] K2.
(*
#h #g #G #L2 #K2 #H elim H -L2 -K2
[ #L1 #T #d #H lapply (lleq_fwd_length … H) -H
  #H >(length_inv_zero_dx … H) -L1 /2 width=3 by ex2_intro/
| #I2 #L2 #K2 #V2 #W2 #HLK2 #HVW2 #IHLK2 #Y #T #d #HT
  lapply (lleq_fwd_length … HT) #H
  elim (length_inv_pos_dx … H) -H #I1 #L1 #V1 #HL12 #H destruct
  elim (eq_term_dec V1 V2) #H destruct
  [ @ex2_intro …
*)

lemma lpx_lleq_fqu_trans: ∀h,g,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊃ ⦃G2, L2, T2⦄ →
                          ∀K1. ⦃G1, K1⦄ ⊢ ➡[h, g] L1 → K1 ⋕[T1, 0] L1 →
                          ∃∃K2. ⦃G1, K1, T1⦄ ⊃ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡[h, g] L2 & K2 ⋕[T2, 0] L2.
#h #g #G1 #G2 #L1 #L2 #T1 #T2 #H elim H -G1 -G2 -L1 -L2 -T1 -T2
[ #I #G1 #L1 #V1 #X #H1 #H2 elim (lpx_inv_pair2 … H1) -H1
  #K0 #V0 #H1KL1 #_ #H destruct
  elim (lleq_inv_lref_ge_dx … H2 ? I L1 V1) -H2 //
  #I1 #K1 #H #H2KL1 lapply (ldrop_inv_O2 … H) -H #H destruct
  /2 width=4 by fqu_lref_O, ex3_intro/
| * [ #a ] #I #G1 #L1 #V1 #T1 #K1 #HLK1 #H
  [ elim (lleq_inv_bind … H)
  | elim (lleq_inv_flat … H)
  ] -H /2 width=4 by fqu_pair_sn, ex3_intro/
| #a #I #G1 #L1 #V1 #T1 #K1 #HLK1 #H elim (lleq_inv_bind_O … H) -H
  /3 width=4 by lpx_pair, fqu_bind_dx, ex3_intro/
| #I #G1 #L1 #V1 #T1 #K1 #HLK1 #H elim (lleq_inv_flat … H) -H
  /2 width=4 by fqu_flat_dx, ex3_intro/
| #G1 #L1 #L #T1 #U1 #e #HL1 #HTU1 #K1 #H1KL1 #H2KL1
  elim (ldrop_O1_le (e+1) K1)
  [ #K #HK1 lapply (lleq_inv_lift_le … H2KL1 … HK1 HL1 … HTU1 ?) -H2KL1 //
    #H2KL elim (lpx_ldrop_trans_O1 … H1KL1 … HL1) -L1
    #K0 #HK10 #H1KL lapply (ldrop_mono … HK10 … HK1) -HK10 #H destruct
    /3 width=4 by fqu_drop, ex3_intro/
  | lapply (ldrop_fwd_length_le2 … HL1) -L -T1 -g
    lapply (lleq_fwd_length … H2KL1) //
  ]
]
qed-.

lemma lpx_lleq_fquq_trans: ∀h,g,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊃⸮ ⦃G2, L2, T2⦄ →
                           ∀K1. ⦃G1, K1⦄ ⊢ ➡[h, g] L1 → K1 ⋕[T1, 0] L1 →
                           ∃∃K2. ⦃G1, K1, T1⦄ ⊃⸮ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡[h, g] L2 & K2 ⋕[T2, 0] L2.
#h #g #G1 #G2 #L1 #L2 #T1 #T2 #H #K1 #H1KL1 #H2KL1
elim (fquq_inv_gen … H) -H
[ #H elim (lpx_lleq_fqu_trans … H … H1KL1 H2KL1) -L1
  /3 width=4 by fqu_fquq, ex3_intro/
| * #HG #HL #HT destruct /2 width=4 by ex3_intro/
]
qed-.

lemma lpx_lleq_fqup_trans: ∀h,g,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊃+ ⦃G2, L2, T2⦄ →
                           ∀K1. ⦃G1, K1⦄ ⊢ ➡[h, g] L1 → K1 ⋕[T1, 0] L1 →
                           ∃∃K2. ⦃G1, K1, T1⦄ ⊃+ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡[h, g] L2 & K2 ⋕[T2, 0] L2.
#h #g #G1 #G2 #L1 #L2 #T1 #T2 #H @(fqup_ind … H) -G2 -L2 -T2
[ #G2 #L2 #T2 #H #K1 #H1KL1 #H2KL1 elim (lpx_lleq_fqu_trans … H … H1KL1 H2KL1) -L1
  /3 width=4 by fqu_fqup, ex3_intro/
| #G #G2 #L #L2 #T #T2 #_ #HT2 #IHT1 #K1 #H1KL1 #H2KL1 elim (IHT1 … H2KL1) // -L1
  #K #HT1 #H1KL #H2KL elim (lpx_lleq_fqu_trans … HT2 … H1KL H2KL) -L
  /3 width=5 by fqup_strap1, ex3_intro/
]
qed-.

lemma lpx_lleq_fqus_trans: ∀h,g,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊃* ⦃G2, L2, T2⦄ →
                           ∀K1. ⦃G1, K1⦄ ⊢ ➡[h, g] L1 → K1 ⋕[T1, 0] L1 →
                           ∃∃K2. ⦃G1, K1, T1⦄ ⊃* ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡[h, g] L2 & K2 ⋕[T2, 0] L2.
#h #g #G1 #G2 #L1 #L2 #T1 #T2 #H #K1 #H1KL1 #H2KL1
elim (fqus_inv_gen … H) -H
[ #H elim (lpx_lleq_fqup_trans … H … H1KL1 H2KL1) -L1
  /3 width=4 by fqup_fqus, ex3_intro/
| * #HG #HL #HT destruct /2 width=4 by ex3_intro/
]
qed-.
