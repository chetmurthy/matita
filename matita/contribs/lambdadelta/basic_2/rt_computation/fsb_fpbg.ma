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

include "basic_2/rt_computation/fpbg_fpbs.ma".
include "basic_2/rt_computation/fsb_ffdeq.ma".

(* STRONGLY NORMALIZING CLOSURES FOR PARALLEL RST-TRANSITION ****************)

(* Properties with parallel rst-computation for closures ********************)

lemma fsb_fpbs_trans: ∀h,o,G1,L1,T1. ≥[h, o] 𝐒⦃G1, L1, T1⦄ →
                      ∀G2,L2,T2. ⦃G1, L1, T1⦄ ≥[h, o] ⦃G2, L2, T2⦄ → ≥[h, o] 𝐒⦃G2, L2, T2⦄.
#h #o #G1 #L1 #T1 #H @(fsb_ind_alt … H) -G1 -L1 -T1
#G1 #L1 #T1 #H1 #IH #G2 #L2 #T2 #H12
elim (fpbs_inv_fpbg … H12) -H12
[ -IH /2 width=5 by fsb_ffdeq_trans/
| -H1 * /2 width=5 by/
]
qed-.

(* Properties with proper parallel rst-computation for closures *************)

lemma fsb_intro_fpbg: ∀h,o,G1,L1,T1. (
                         ∀G2,L2,T2. ⦃G1, L1, T1⦄ >[h, o] ⦃G2, L2, T2⦄ → ≥[h, o] 𝐒⦃G2, L2, T2⦄
                      ) → ≥[h, o] 𝐒⦃G1, L1, T1⦄.
/4 width=1 by fsb_intro, fpb_fpbg/ qed.

(* Eliminators with proper parallel rst-computation for closures ************)

lemma fsb_ind_fpbg_fpbs: ∀h,o. ∀R:relation3 genv lenv term.
                         (∀G1,L1,T1. ≥[h, o] 𝐒⦃G1, L1, T1⦄ →
                                     (∀G2,L2,T2. ⦃G1, L1, T1⦄ >[h, o] ⦃G2, L2, T2⦄ → R G2 L2 T2) →
                                     R G1 L1 T1
                         ) →
                         ∀G1,L1,T1. ≥[h, o] 𝐒⦃G1, L1, T1⦄ → 
                         ∀G2,L2,T2. ⦃G1, L1, T1⦄ ≥[h, o] ⦃G2, L2, T2⦄ → R G2 L2 T2.
#h #o #R #IH1 #G1 #L1 #T1 #H @(fsb_ind_alt … H) -G1 -L1 -T1
#G1 #L1 #T1 #H1 #IH #G2 #L2 #T2 #H12
@IH1 -IH1
[ -IH /2 width=5 by fsb_fpbs_trans/
| -H1 #G0 #L0 #T0 #H10
  elim (fpbs_fpbg_trans … H12 … H10) -G2 -L2 -T2
  /2 width=5 by/
]
qed-.

lemma fsb_ind_fpbg: ∀h,o. ∀R:relation3 genv lenv term.
                    (∀G1,L1,T1. ≥[h, o] 𝐒⦃G1, L1, T1⦄ →
                                (∀G2,L2,T2. ⦃G1, L1, T1⦄ >[h, o] ⦃G2, L2, T2⦄ → R G2 L2 T2) →
                                R G1 L1 T1
                    ) →
                    ∀G1,L1,T1. ≥[h, o] 𝐒⦃G1, L1, T1⦄ → R G1 L1 T1.
#h #o #R #IH #G1 #L1 #T1 #H @(fsb_ind_fpbg_fpbs … H) -H
/3 width=1 by/
qed-.
