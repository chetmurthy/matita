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

include "ground_2/notation/relations/isfinite_1.ma".
include "ground_2/relocation/rtmap_fcla.ma".

(* RELOCATION MAP ***********************************************************)

definition isfin: predicate rtmap ≝
                  λf. ∃n. 𝐂⦃f⦄ ≡ n.

interpretation "test for finite colength (rtmap)"
   'IsFinite f = (isfin f).

(* Basic properties *********************************************************)

lemma isfin_isid: ∀f. 𝐈⦃f⦄ → 𝐅⦃f⦄.
/3 width=2 by fcla_isid, ex_intro/ qed.

lemma isfin_push: ∀f. 𝐅⦃f⦄ → 𝐅⦃↑f⦄.
#f * /3 width=2 by fcla_push, ex_intro/
qed.

lemma isfin_next: ∀f. 𝐅⦃f⦄ → 𝐅⦃⫯f⦄.
#f * /3 width=2 by fcla_next, ex_intro/
qed.

lemma isfin_eq_repl_back: eq_repl_back … isfin.
#f1 * /3 width=4 by fcla_eq_repl_back, ex_intro/
qed-.

lemma isfin_eq_repl_fwd: eq_repl_fwd … isfin.
/3 width=3 by isfin_eq_repl_back, eq_repl_sym/ qed-.

(* Basic eliminators ********************************************************)

lemma isfin_ind (R:predicate rtmap): (∀f.  𝐈⦃f⦄ → R f) →
                                     (∀f. 𝐅⦃f⦄ → R f → R (↑f)) →
                                     (∀f. 𝐅⦃f⦄ → R f → R (⫯f)) →
                                     ∀f. 𝐅⦃f⦄ → R f.
#R #IH1 #IH2 #IH3 #f #H elim H -H
#n #H elim H -f -n /3 width=2 by ex_intro/
qed-.

(* Basic inversion lemmas ***************************************************)

lemma isfin_inv_next: ∀g. 𝐅⦃g⦄ → ∀f. ⫯f = g → 𝐅⦃f⦄.
#g * #n #H #f #H0 elim (fcla_inv_nx … H … H0) -g
/2 width=2 by ex_intro/
qed-.

(* Basic forward lemmas *****************************************************)

lemma isfin_fwd_push: ∀g. 𝐅⦃g⦄ → ∀f. ↑f = g → 𝐅⦃f⦄.
#g * /3 width=4 by fcla_inv_px, ex_intro/
qed-.
