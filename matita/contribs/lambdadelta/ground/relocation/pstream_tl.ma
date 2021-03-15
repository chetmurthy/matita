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

include "ground/lib/stream_hdtl.ma".
include "ground/relocation/pstream.ma".

(* RELOCATION P-STREAM ******************************************************)

(* Poperties with stream_tl *************************************************)

lemma tl_push: ∀f. f = ⫰⫯f.
// qed.

lemma tl_next: ∀f. ⫰f = ⫰↑f.
* // qed.
