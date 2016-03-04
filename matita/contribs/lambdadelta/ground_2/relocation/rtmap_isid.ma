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

include "ground_2/notation/relations/isidentity_1.ma".
include "ground_2/relocation/rtmap_tls.ma".

(* RELOCATION MAP ***********************************************************)

coinductive isid: predicate rtmap ≝
| isid_push: ∀f,g. isid f → ↑f = g → isid g
.

interpretation "test for identity (rtmap)"
   'IsIdentity f = (isid f).

(* Basic inversion lemmas ***************************************************)

lemma isid_inv_gen: ∀g. 𝐈⦃g⦄ → ∃∃f. 𝐈⦃f⦄ & ↑f = g.
#g * -g
#f #g #Hf * /2 width=3 by ex2_intro/
qed-.

(* Advanced inversion lemmas ************************************************)

lemma isid_inv_push: ∀g. 𝐈⦃g⦄ → ∀f. ↑f = g → 𝐈⦃f⦄.
#g #H elim (isid_inv_gen … H) -H
#f #Hf * -g #g #H >(injective_push … H) -H //
qed-.

lemma isid_inv_next: ∀g. 𝐈⦃g⦄ → ∀f. ⫯f = g → ⊥.
#g #H elim (isid_inv_gen … H) -H
#f #Hf * -g #g #H elim (discr_next_push … H)
qed-.

let corec isid_inv_eq_repl: ∀f1,f2. 𝐈⦃f1⦄ → 𝐈⦃f2⦄ → f1 ≗ f2 ≝ ?.
#f1 #f2 #H1 #H2
cases (isid_inv_gen … H1) -H1
cases (isid_inv_gen … H2) -H2
/3 width=5 by eq_push/
qed-.

(* Basic properties *********************************************************)

let corec isid_eq_repl_back: eq_repl_back … isid ≝ ?.
#f1 #H cases (isid_inv_gen … H) -H
#g1 #Hg1 #H1 #f2 #Hf cases (eq_inv_px … Hf … H1) -f1
/3 width=3 by isid_push/
qed-.

lemma isid_eq_repl_fwd: eq_repl_fwd … isid.
/3 width=3 by isid_eq_repl_back, eq_repl_sym/ qed-.

(* Alternative definition ***************************************************)

let corec eq_push_isid: ∀f. ↑f ≗ f → 𝐈⦃f⦄ ≝ ?.
#f #H cases (eq_inv_px … H) -H /4 width=3 by isid_push, eq_trans/
qed.

let corec eq_push_inv_isid: ∀f. 𝐈⦃f⦄ → ↑f ≗ f ≝ ?.
#f * -f
#f #g #Hf #Hg @(eq_push … Hg) [2: @eq_push_inv_isid // | skip ]
@eq_f //
qed-.
