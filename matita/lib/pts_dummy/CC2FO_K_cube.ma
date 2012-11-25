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

include "CC2FO_K.ma".
include "cube.ma".
include "inversion.ma".

(* The K interpretation in the λ-Cube *****************************************)

lemma ki_type: ∀G,t,u. G ⊢_{CC} t : u → u = Sort 1 → 𝕂{G} ⊢_{FO} 𝕂{t}_[G] : u.
#G #t #u #H elim H -H G t u
[ #i #j * #_ @ax //
| #G #A #i #HA #IHA #Heq  