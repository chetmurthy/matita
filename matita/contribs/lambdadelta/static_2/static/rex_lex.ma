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

include "static_2/relocation/lex.ma".
include "static_2/static/rex_fsle.ma".
include "static_2/static/req.ma".

(* GENERIC EXTENSION ON REFERRED ENTRIES OF A CONTEXT-SENSITIVE REALTION ****)

(* Properties with generic extension of a context-sensitive relation ********)

lemma rex_lex (R):
      ∀L1,L2. L1 ⪤[R] L2 → ∀T. L1 ⪤[R,T] L2.
#R #L1 #L2 * #f #Hf #HL12 #T
elim (frees_total L1 T) #g #Hg
/4 width=5 by sex_sdj, sdj_isid_sn, ex2_intro/
qed.

(* Inversion lemmas with generic extension of a context sensitive relation **)

lemma rex_inv_req_lex (R):
      c_reflexive … R → f_confluent1_next R ceq →
      ∀L1,L2,T. L1 ⪤[R,T] L2 →
      ∃∃L. L1 ≡[T] L & L ⪤[R] L2.
#R #H1R #H2R #L1 #L2 #T * #f1 #Hf1 #HL
elim (sex_sdj_split_dx … ceq_ext … HL 𝐈𝐝) -HL
[ #L0 #HL10 #HL02
  lapply (sex_sdj … HL02 f1 ?) /2 width=1 by sdj_isid_sn/ #H
  /3 width=5 by (* 2x *) ex2_intro/
|*: /2 width=1 by ext2_refl, sdj_isid_dx/
  #g #I #K #n #HLK #Hg @H2R /width=7 by/ (**) (* no auto with H2R *)
]
qed-.

(* Forward lemmas with generic extension of a context sensitive relation **)

lemma rex_fwd_lex_req (R):
      c_reflexive … R → rex_fsge_compatible R →
      ∀L1,L2,T. L1 ⪤[R,T] L2 →
      ∃∃L. L1 ⪤[R] L & L ≡[T] L2.
#R #H1R #H2R #L1 #L2 #T * #f1 #Hf1 #HL
elim (sex_sdj_split_sn … ceq_ext … HL 𝐈𝐝 ?) -HL
[ #L0 #HL10 #HL02 |*: /2 width=1 by ext2_refl, sdj_isid_dx/ ] -H1R
lapply (sex_sdj … HL10 f1 ?) /2 width=1 by sdj_isid_sn/ #H
elim (frees_sex_conf_fsge … Hf1 … H) // -H2R -H #f0 #Hf0 #Hf01
/4 width=7 by sle_sex_trans, (* 2x *) ex2_intro/
qed-.
