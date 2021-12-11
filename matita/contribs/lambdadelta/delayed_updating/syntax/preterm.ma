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

include "ground/lib/subset.ma".
include "delayed_updating/syntax/path.ma".
include "delayed_updating/notation/functions/uptriangle_1.ma".

(* PRETERM ******************************************************************)

(* Note: preterms are subsets of complete paths *)
definition preterm: Type[0] ≝ 𝒫❨path❩.

definition preterm_root: preterm → preterm ≝
           λt,p. ∃q. p;;q ϵ t.

interpretation
  "root (preterm)"
  'UpTriangle t = (preterm_root t).

(* Basic constructions ******************************************************)

lemma preterm_in_comp_root (p) (t):
      p ϵ t → p ϵ ▵t.
/2 width=2 by ex_intro/
qed.
