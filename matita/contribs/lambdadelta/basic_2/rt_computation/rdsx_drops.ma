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

include "static_2/static/rdeq_drops.ma".
include "basic_2/rt_transition/lpx_drops.ma".
include "basic_2/rt_computation/rdsx_length.ma".
include "basic_2/rt_computation/rdsx_fqup.ma".

(* STRONGLY NORMALIZING REFERRED LOCAL ENV.S FOR UNBOUND RT-TRANSITION ******)

(* Properties with generic relocation ***************************************)

(* Note: this uses length *)
(* Basic_2A1: uses: lsx_lift_le lsx_lift_ge *)
lemma rdsx_lifts (h) (o) (G): d_liftable1_isuni … (λL,T. G ⊢ ⬈*[h, o, T] 𝐒⦃L⦄).
#h #o #G #K #T #H @(rdsx_ind … H) -K
#K1 #_ #IH #b #f #L1 #HLK1 #Hf #U #HTU @rdsx_intro
#L2 #HL12 #HnL12 elim (lpx_drops_conf … HLK1 … HL12) 
/5 width=9 by rdeq_lifts_bi, lpx_fwd_length/
qed-.

(* Inversion lemmas on relocation *******************************************)

(* Basic_2A1: uses: lsx_inv_lift_le lsx_inv_lift_be lsx_inv_lift_ge *)
lemma rdsx_inv_lifts (h) (o) (G): d_deliftable1_isuni … (λL,T. G ⊢ ⬈*[h, o, T] 𝐒⦃L⦄).
#h #o #G #L #U #H @(rdsx_ind … H) -L
#L1 #_ #IH #b #f #K1 #HLK1 #Hf #T #HTU @rdsx_intro
#K2 #HK12 #HnK12 elim (drops_lpx_trans … HLK1 … HK12) -HK12
/4 width=10 by rdeq_inv_lifts_bi/
qed-.

(* Advanced properties ******************************************************)

(* Basic_2A1: uses: lsx_lref_free *)
lemma rdsx_lref_atom (h) (o) (G): ∀L,i. ⬇*[Ⓕ, 𝐔❴i❵] L ≘ ⋆ → G ⊢ ⬈*[h, o, #i] 𝐒⦃L⦄.
#h #o #G #L1 #i #HL1
@(rdsx_lifts … (#0) … HL1) -HL1 //
qed.

(* Basic_2A1: uses: lsx_lref_skip *)
lemma rdsx_lref_unit (h) (o) (G): ∀I,L,K,i. ⬇*[i] L ≘ K.ⓤ{I} → G ⊢ ⬈*[h, o, #i] 𝐒⦃L⦄.
#h #o #G #I #L1 #K1 #i #HL1
@(rdsx_lifts … (#0) … HL1) -HL1 //
qed.

(* Advanced forward lemmas **************************************************)

(* Basic_2A1: uses: lsx_fwd_lref_be *)
lemma rdsx_fwd_lref_pair (h) (o) (G):
                         ∀L,i. G ⊢ ⬈*[h, o, #i] 𝐒⦃L⦄ →
                         ∀I,K,V. ⬇*[i] L ≘ K.ⓑ{I}V → G ⊢ ⬈*[h, o, V] 𝐒⦃K⦄.
#h #o #G #L #i #HL #I #K #V #HLK
lapply (rdsx_inv_lifts … HL … HLK … (#0) ?) -L
/2 width=2 by rdsx_fwd_pair/
qed-.
