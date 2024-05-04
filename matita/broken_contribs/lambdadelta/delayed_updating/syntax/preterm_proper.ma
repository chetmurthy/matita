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

include "ground/subsets/subset_le.ma".
include "delayed_updating/syntax/path_proper.ma".
include "delayed_updating/syntax/preterm.ma".

(* PRETERM ******************************************************************)

(* Constructions with ppc ***************************************************)

lemma term_grafted_S_dx_proper (t) (p):
      t ϵ 𝐓 → ⋔[p◖𝗦]t ⊆ 𝐏.
#t #p #Ht #q
elim (path_inv_ppc q) // #H0 #Hq destruct
elim (term_proper_S_post … Ht p) //
qed.

(* Destructions with ppc ****************************************************)

lemma term_in_comp_path_append_des_sn_rcons (t) (p) (q) (l):
      t ϵ 𝐓 → p◖l ϵ t → p●q ϵ t → q ϵ 𝐏.
#t #p #q #l #Ht #H1p #H2p #H0 destruct
lapply (term_complete_post … Ht … H1p H2p ?) -t // #H1
lapply (eq_inv_list_append_dx_dx_refl ? p (𝐞◖l) ?)
[ <list_append_lcons_sn //
| #H0 destruct
]
qed-.
