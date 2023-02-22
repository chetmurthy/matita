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

include "static_2/static/rex_drops.ma".
include "basic_2/rt_transition/cpx_drops.ma".
include "basic_2/rt_transition/rpx.ma".

(* EXTENDED PARALLEL RT-TRANSITION FOR REFERRED LOCAL ENVIRONMENTS **********)

(* Properties with generic slicing for local environments *******************)

lemma rpx_lifts_sn (G): f_dedropable_sn (cpx G).
/3 width=6 by rex_liftable_dedropable_sn, cpx_lifts_sn/ qed-.

(* Inversion lemmas with generic slicing for local environments *************)

lemma rpx_inv_lifts_sn (G): f_dropable_sn (cpx G).
/2 width=5 by rex_dropable_sn/ qed-.

lemma rpx_inv_lifts_dx (G): f_dropable_dx (cpx G).
/2 width=5 by rex_dropable_dx/ qed-.

lemma rpx_inv_lifts_bi (G):
      ∀L1,L2,U. ❨G,L1❩ ⊢ ⬈[U] L2 → ∀b,f. 𝐔❨f❩ →
      ∀K1,K2. ⇩*[b,f] L1 ≘ K1 → ⇩*[b,f] L2 ≘ K2 →
      ∀T. ⇧*[f]T ≘ U → ❨G,K1❩ ⊢ ⬈[T] K2.
/2 width=10 by rex_inv_lifts_bi/ qed-.
