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

include "static_2/relocation/lifts_teqg.ma".
include "static_2/static/rex_drops.ma".
include "static_2/static/reqg.ma".

(* GENERIC EQUIVALENCE FOR LOCAL ENVIRONMENTS ON REFERRED ENTRIES ***********)

(* Properties with generic slicing for local environments *******************)

lemma reqg_lifts_sn (S):
      reflexive … S → f_dedropable_sn (ceqg S).
/3 width=5 by rex_liftable_dedropable_sn, teqg_lifts_sn, teqg_refl/ qed-.

(* Inversion lemmas with generic slicing for local environments *************)

lemma reqg_inv_lifts_sn (S):
      f_dropable_sn (ceqg S).
/2 width=5 by rex_dropable_sn/ qed-.

lemma reqg_inv_lifts_dx (S):
      f_dropable_dx (ceqg S).
/2 width=5 by rex_dropable_dx/ qed-.

lemma reqg_inv_lifts_bi (S):
      ∀L1,L2,U. L1 ≛[S,U] L2 → ∀b,f. 𝐔❨f❩ →
      ∀K1,K2. ⇩*[b,f] L1 ≘ K1 → ⇩*[b,f] L2 ≘ K2 →
      ∀T. ⇧*[f] T ≘ U → K1 ≛[S,T] K2.
/2 width=10 by rex_inv_lifts_bi/ qed-.

lemma reqg_inv_lref_pair_sn (S):
      ∀L1,L2,i. L1 ≛[S,#i] L2 → ∀I,K1,V1. ⇩[i] L1 ≘ K1.ⓑ[I]V1 →
      ∃∃K2,V2. ⇩[i] L2 ≘ K2.ⓑ[I]V2 & K1 ≛[S,V1] K2 & V1 ≛[S] V2.
/2 width=3 by rex_inv_lref_pair_sn/ qed-.

lemma reqg_inv_lref_pair_dx (S):
      ∀L1,L2,i. L1 ≛[S,#i] L2 → ∀I,K2,V2. ⇩[i] L2 ≘ K2.ⓑ[I]V2 →
      ∃∃K1,V1. ⇩[i] L1 ≘ K1.ⓑ[I]V1 & K1 ≛[S,V1] K2 & V1 ≛[S] V2.
/2 width=3 by rex_inv_lref_pair_dx/ qed-.

lemma reqg_inv_lref_pair_bi (S) (L1) (L2) (i):
      L1 ≛[S,#i] L2 →
      ∀I1,K1,V1. ⇩[i] L1 ≘ K1.ⓑ[I1]V1 →
      ∀I2,K2,V2. ⇩[i] L2 ≘ K2.ⓑ[I2]V2 →
      ∧∧ K1 ≛[S,V1] K2 & V1 ≛[S] V2 & I1 = I2.
/2 width=6 by rex_inv_lref_pair_bi/ qed-.
