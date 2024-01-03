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

include "delayed_updating/syntax/path_structure.ma".
include "delayed_updating/syntax/path_clear.ma".

(* CLEAR FOR PATH ***********************************************************)

(* Constructions with structure *********************************************)

lemma path_clear_structure (p):
      ⊗p = ⓪⊗p.
#p elim p -p //
* [ #k ] #p #IH //
qed.

lemma path_structure_clear (p):
      ⊗p = ⊗⓪p.
#p elim p -p //
* [ #k ] #p #IH //
<path_clear_d_dx //
qed.

lemma path_structure_clear_swap (p):
      ⓪⊗p = ⊗⓪p.
// qed-.

(* Advanced onstructions with structure *************************************)

lemma path_structure_pAbLq_clear (p) (xa) (b) (xl) (q):
      (𝐞) = ⊗xa → (𝐞) = ⊗xl →
      ⊗p●𝗔◗⓪⊗b●𝗟◗⊗q = ⊗(p●xa●𝗔◗⓪b●⓪xl●𝗟◗q).
#p #xa #b #xl #q #Ha #Hl
<structure_append <structure_append <Ha <structure_A_sn -Ha
<structure_append <structure_append <structure_L_sn
<path_structure_clear_swap <path_structure_clear_swap <Hl -Hl
<list_append_empty_dx <list_append_empty_dx //
qed.
