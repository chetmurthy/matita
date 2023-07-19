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

include "delayed_updating/unwind_k/preunwind2_rmap.ma".

(* TAILED PREUNWIND FOR RELOCATION MAP **************************************)

(* Constructions with trz_eq ************************************************)

lemma preunwind2_rmap_eq_repl (l):
      compatible_2_fwd … trz_eq trz_eq (λf.▶[f]l).
* //
qed-.
