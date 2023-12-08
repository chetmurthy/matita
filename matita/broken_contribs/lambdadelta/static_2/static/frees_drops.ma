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

include "ground/relocation/nstream_coafter.ma".
include "static_2/relocation/drops_drops.ma".
include "static_2/static/frees_fqup.ma".

(* CONTEXT-SENSITIVE FREE VARIABLES *****************************************)

(* Advanced properties ******************************************************)

lemma frees_atom_drops:
      ∀b,L,i. ⇩*[b,𝐔❨i❩] L ≘ ⋆ →
      ∀f. 𝐈❨f❩ → L ⊢ 𝐅+❨#i❩ ≘ ⫯*[i]↑f.
#b #L elim L -L /2 width=1 by frees_atom/
#L #I #IH *
[ #H lapply (drops_fwd_isid … H ?) -H // #H destruct
| /4 width=3 by frees_lref, drops_inv_drop1/
]
qed.

lemma frees_pair_drops:
      ∀f,K,V. K ⊢ 𝐅+❨V❩ ≘ f →
      ∀i,I,L. ⇩[i] L ≘ K.ⓑ[I]V → L ⊢ 𝐅+❨#i❩ ≘ ⫯*[i] ↑f.
#f #K #V #Hf #i elim i -i
[ #I #L #H lapply (drops_fwd_isid … H ?) -H /2 width=1 by frees_pair/
| #i #IH #I #L #H elim (drops_inv_succ … H) -H /3 width=2 by frees_lref/
]
qed.

lemma frees_unit_drops:
      ∀f.  𝐈❨f❩ → ∀I,K,i,L. ⇩[i] L ≘ K.ⓤ[I] →
      L ⊢ 𝐅+❨#i❩ ≘ ⫯*[i] ↑f.
#f #Hf #I #K #i elim i -i
[ #L #H lapply (drops_fwd_isid … H ?) -H /2 width=1 by frees_unit/
| #i #IH #Y #H elim (drops_inv_succ … H) -H
  #J #L #HLK #H destruct /3 width=1 by frees_lref/
]
qed.

lemma frees_lref_pushs:
      ∀f,K,j. K ⊢ 𝐅+❨#j❩ ≘ f →
      ∀i,L. ⇩[i] L ≘ K → L ⊢ 𝐅+❨#(i+j)❩ ≘ ⫯*[i] f.
#f #K #j #Hf #i elim i -i
[ #L #H lapply (drops_fwd_isid … H ?) -H //
| #i #IH #L #H elim (drops_inv_succ … H) -H
  #I #Y #HYK #H destruct /3 width=1 by frees_lref/
]
qed.

(* Advanced inversion lemmas ************************************************)

lemma frees_inv_lref_drops:
      ∀L,i,f. L ⊢ 𝐅+❨#i❩ ≘ f →
      ∨∨ ∃∃g. ⇩*[ⓕ,𝐔❨i❩] L ≘ ⋆ & 𝐈❨g❩ & f = ⫯*[i] ↑g
       | ∃∃g,I,K,V. K ⊢ 𝐅+❨V❩ ≘ g & ⇩[i] L ≘ K.ⓑ[I]V & f = ⫯*[i] ↑g
       | ∃∃g,I,K. ⇩[i] L ≘ K.ⓤ[I] & 𝐈❨g❩ & f = ⫯*[i] ↑g.
#L elim L -L
[ #i #g | #L #I #IH * [ #g cases I -I [ #I | #I #V ] -IH | #i #g ] ] #H
[ elim (frees_inv_atom … H) -H #f #Hf #H destruct
  /3 width=3 by or3_intro0, ex3_intro/
| elim (frees_inv_unit … H) -H #f #Hf #H destruct
  /4 width=3 by drops_refl, or3_intro2, ex3_3_intro/
| elim (frees_inv_pair … H) -H #f #Hf #H destruct
  /4 width=7 by drops_refl, or3_intro1, ex3_4_intro/
| elim (frees_inv_lref … H) -H #f #Hf #H destruct
  elim (IH … Hf) -IH -Hf *
  [ /4 width=3 by drops_drop, or3_intro0, ex3_intro/
  | /4 width=7 by drops_drop, or3_intro1, ex3_4_intro/
  | /4 width=3 by drops_drop, or3_intro2, ex3_3_intro/
  ]
]
qed-.

(* Properties with generic slicing for local environments *******************)

lemma frees_lifts:
      ∀b,f1,K,T. K ⊢ 𝐅+❨T❩ ≘ f1 →
      ∀f,L. ⇩*[b,f] L ≘ K → ∀U. ⇧*[f] T ≘ U →
      ∀f2. f ~⊚ f1 ≘ f2 → L ⊢ 𝐅+❨U❩ ≘ f2.
#b #f1 #K #T #H lapply (frees_fwd_isfin … H) elim H -f1 -K -T
[ #f1 #K #s #Hf1 #_ #f #L #HLK #U #H2 #f2 #H3
  lapply (pr_coafter_isi_inv_dx … H3 … Hf1) -f1 #Hf2
  >(lifts_inv_sort1 … H2) -U /2 width=1 by frees_sort/
| #f1 #i #Hf1 #_ #f #L #H1 #U #H2 #f2 #H3
  elim (lifts_inv_lref1 … H2) -H2 #j #Hij #H destruct
  elim (coafter_fwd_xnx_pushs … Hij H3) -H3 #g2 #Hg2 #H2 destruct
  lapply (pr_coafter_isi_inv_dx … Hg2 … Hf1) -f1 #Hf2
  elim (drops_inv_atom2 … H1) -H1 #n #g #H1 #Hf
  elim (pr_after_pat_des … Hij … Hf) -f #x #_ #Hj -g -i
  lapply (pr_pat_inv_uni … Hj) -Hj #H destruct
  /3 width=8 by frees_atom_drops, drops_trans/
| #f1 #I #K #V #_ #IH #Hf1 #f #L #H1 #U #H2 #f2 #H3
  lapply (pr_isf_inv_next … Hf1 ??) -Hf1 [3: |*: // ] #Hf1
  lapply (lifts_inv_lref1 … H2) -H2 * #j #Hf #H destruct
  elim (drops_split_trans_bind2 … H1) -H1 [ |*: // ] #Z #Y #HLY #HYK #H
  elim (liftsb_inv_pair_sn … H) -H #W #HVW #H destruct
  elim (coafter_fwd_xnx_pushs … Hf H3) -H3 #g2 #H3 #H2 destruct
  lapply (IH … HYK … HVW … H3) -IH -H3 -HYK -HVW //
  /2 width=5 by frees_pair_drops/
| #f1 #I #K #Hf1 #_ #f #L #H1 #U #H2 #f2 #H3
  lapply (lifts_inv_lref1 … H2) -H2 * #j #Hf #H destruct
  elim (coafter_fwd_xnx_pushs … Hf H3) -H3 #g2 #H3 #H2 destruct
  lapply (pr_coafter_isi_inv_dx … H3 … Hf1) -f1 #Hg2
  elim (drops_split_trans_bind2 … H1 … Hf) -H1 -Hf #Z #Y #HLY #_ #H
  lapply (liftsb_inv_unit_sn … H) -H #H destruct
  /2 width=3 by frees_unit_drops/
| #f1 #I #K #i #_ #IH #Hf1 #f #L #H1 #U #H2 #f2 #H3
  lapply (pr_isf_inv_push … Hf1 ??) -Hf1 [3: |*: // ] #Hf1
  lapply (lifts_inv_lref1 … H2) -H2 * #x #Hf #H destruct
  elim (pr_pat_inv_succ_sn … Hf) -Hf [ |*: // ] #j #Hf #H destruct
  elim (drops_split_trans_bind2 … H1) -H1 [ |*: // ] #Z #Y #HLY #HYK #_
  elim (coafter_fwd_xpx_pushs … 0 … H3) [ |*: // ] #g2 #H3 #H2 destruct
  lapply (drops_isuni_fwd_drop2 … HLY) -HLY // #HLY
  lapply (IH … HYK … H3) -IH -H3 -HYK [4: |*: /2 width=2 by lifts_lref/ ]
  >nplus_succ_sn /2 width=3 by frees_lref_pushs/ (**) (* full auto fails *)
| #f1 #K #l #Hf1 #_ #f #L #HLK #U #H2 #f2 #H3
  lapply (pr_coafter_isi_inv_dx … H3 … Hf1) -f1 #Hf2
  >(lifts_inv_gref1 … H2) -U /2 width=1 by frees_gref/
| #f1V #f1T #f1 #p #I #K #V #T #_ #_ #H1f1 #IHV #IHT #H2f1 #f #L #H1 #Y #H2 #f2 #H3
  elim (pr_sor_inv_isf … H1f1) // #Hf1V #H
  lapply (pr_isf_inv_tl … H) -H
  elim (lifts_inv_bind1 … H2) -H2 #W #U #HVW #HTU #H destruct
  elim (pr_sor_coafter_dx_tans … H3 … H1f1) /2 width=5 by pr_coafter_des_ist_isf/ -H3 -H1f1 #f2V #f2T #Hf2V #H
  elim (pr_coafter_inv_tl_dx … H) -H
  /5 width=5 by frees_bind, drops_skip, ext2_pair/
| #f1V #f1T #f1 #I #K #V #T #_ #_ #H1f1 #IHV #IHT #H2f1 #f #L #H1 #Y #H2 #f2 #H3
  elim (pr_sor_inv_isf … H1f1) //
  elim (lifts_inv_flat1 … H2) -H2 #W #U #HVW #HTU #H destruct
  elim (pr_sor_coafter_dx_tans … H3 … H1f1)
  /3 width=5 by pr_coafter_des_ist_isf, frees_flat/
]
qed-.

lemma frees_lifts_SO:
      ∀b,L,K. ⇩*[b,𝐔❨1❩] L ≘ K → ∀T,U. ⇧[1] T ≘ U →
      ∀f. K ⊢ 𝐅+❨T❩ ≘ f → L ⊢ 𝐅+❨U❩ ≘ ⫯f.
#b #L #K #HLK #T #U #HTU #f #Hf
@(frees_lifts b … Hf … HTU) //  (**) (* auto fails *)
qed.

(* Forward lemmas with generic slicing for local environments ***************)

lemma frees_fwd_coafter:
      ∀b,f2,L,U. L ⊢ 𝐅+❨U❩ ≘ f2 →
      ∀f,K. ⇩*[b,f] L ≘ K → ∀T. ⇧*[f] T ≘ U →
      ∀f1. K ⊢ 𝐅+❨T❩ ≘ f1 → f ~⊚ f1 ≘ f2.
/4 width=11 by frees_lifts, frees_mono, pr_coafter_eq_repl_back/ qed-.

(* Inversion lemmas with generic slicing for local environments *************)

lemma frees_inv_lifts_ex:
      ∀b,f2,L,U. L ⊢ 𝐅+❨U❩ ≘ f2 →
      ∀f,K. ⇩*[b,f] L ≘ K → ∀T. ⇧*[f] T ≘ U →
      ∃∃f1. f ~⊚ f1 ≘ f2 & K ⊢ 𝐅+❨T❩ ≘ f1.
#b #f2 #L #U #Hf2 #f #K #HLK #T elim (frees_total K T)
/3 width=9 by frees_fwd_coafter, ex2_intro/
qed-.

lemma frees_inv_lifts_SO:
      ∀b,f,L,U. L ⊢ 𝐅+❨U❩ ≘ f →
      ∀K. ⇩*[b,𝐔❨1❩] L ≘ K → ∀T. ⇧[1] T ≘ U →
      K ⊢ 𝐅+❨T❩ ≘ ⫰f.
#b #f #L #U #H #K #HLK #T #HTU elim(frees_inv_lifts_ex … H … HLK … HTU) -b -L -U
#f1 #Hf #Hf1 elim (pr_coafter_inv_next_sn … Hf) -Hf
/3 width=5 by frees_eq_repl_back, pr_coafter_isi_inv_sn/
qed-.

lemma frees_inv_lifts:
      ∀b,f2,L,U. L ⊢ 𝐅+❨U❩ ≘ f2 →
      ∀f,K. ⇩*[b,f] L ≘ K → ∀T. ⇧*[f] T ≘ U →
      ∀f1. f ~⊚ f1 ≘ f2 → K ⊢ 𝐅+❨T❩ ≘ f1.
#b #f2 #L #U #H #f #K #HLK #T #HTU #f1 #Hf2 elim (frees_inv_lifts_ex … H … HLK … HTU) -b -L -U
/3 width=7 by frees_eq_repl_back, pr_coafter_inj/
qed-.

(* Note: this is used by rex_conf and might be modified *)
lemma frees_inv_drops_next:
      ∀f1,L1,T1. L1 ⊢ 𝐅+❨T1❩ ≘ f1 →
      ∀I2,L2,V2,i. ⇩[i] L1 ≘ L2.ⓑ[I2]V2 →
      ∀g1. ↑g1 = ⫰*[i] f1 →
      ∃∃g2. L2 ⊢ 𝐅+❨V2❩ ≘ g2 & g2 ⊆ g1.
#f1 #L1 #T1 #H elim H -f1 -L1 -T1
[ #f1 #L1 #s #Hf1 #I2 #L2 #V2 #j #_ #g1 #H1 -I2 -L1 -s
  lapply (pr_isi_tls j … Hf1) -Hf1 <H1 -f1 #Hf1
  elim (pr_isi_inv_next … Hf1) -Hf1 //
| #f1 #i #_ #I2 #L2 #V2 #j #H
  elim (drops_inv_atom1 … H) -H #H destruct
| #f1 #I1 #L1 #V1 #Hf1 #IH #I2 #L2 #V2 *
  [ -IH #HL12 lapply (drops_fwd_isid … HL12 ?) -HL12 //
    #H destruct #g1 #Hgf1 >(eq_inv_pr_next_bi … Hgf1) -g1
    /2 width=3 by ex2_intro/
  | -Hf1 #j #HL12 lapply (drops_inv_drop1 … HL12) -HL12
    #HL12 #g1 <pr_tls_swap <pr_tl_next #Hgf1 elim (IH … HL12 … Hgf1) -IH -HL12 -Hgf1
    /2 width=3 by ex2_intro/
  ]
| #f1 #I1 #L1 #Hf1 #I2 #L2 #V2 *
  [ #HL12 lapply (drops_fwd_isid … HL12 ?) -HL12 // #H destruct
  | #j #_ #g1 #Hgf1 elim (pr_isi_inv_next … Hgf1) -Hgf1 <pr_tls_swap /2 width=1 by pr_isi_tls/
  ]
| #f1 #I1 #L1 #i #_ #IH #I2 #L2 #V2 *
  [ -IH #_ #g1 #Hgf1 elim (eq_inv_pr_next_push … Hgf1)
  | #j #HL12 lapply (drops_inv_drop1 … HL12) -HL12
    #HL12 #g1 <pr_tls_swap #Hgf1 elim (IH … HL12 … Hgf1) -IH -HL12 -Hgf1
    /2 width=3 by ex2_intro/
  ]
| #f1 #L1 #l #Hf1 #I2 #L2 #V2 #j #_ #g1 #H1 -I2 -L1 -l
  lapply (pr_isi_tls j … Hf1) -Hf1 <H1 -f1 #Hf1
  elim (pr_isi_inv_next … Hf1) -Hf1 //
| #fV1 #fT1 #f1 #p #I1 #L1 #V1 #T1 #_ #_ #Hf1 #IHV1 #IHT1 #I2 #L2 #V2 #j #HL12 #g1 #Hgf1
  lapply (pr_sor_tls … Hf1 j) -Hf1 <Hgf1 -Hgf1 #Hf1
  elim (pr_sor_next_tl … Hf1) [1,2: * |*: // ] -Hf1
  #gV1 #gT1 #Hg1
  [ -IHT1 #H1 #_ elim (IHV1 … HL12 … H1) -IHV1 -HL12 -H1
    /3 width=6 by pr_sor_inv_sle_sn_trans, ex2_intro/
  | -IHV1 #_ >pr_tls_swap #H2 elim (IHT1 … H2) -IHT1 -H2
    /3 width=6 by drops_drop, pr_sor_inv_sle_dx_trans, ex2_intro/
  ]
| #fV1 #fT1 #f1 #I1 #L1 #V1 #T1 #_ #_ #Hf1 #IHV1 #IHT1 #I2 #L2 #V2 #j #HL12 #g1 #Hgf1
  lapply (pr_sor_tls … Hf1 j) -Hf1 <Hgf1 -Hgf1 #Hf1
  elim (pr_sor_next_tl … Hf1) [1,2: * |*: // ] -Hf1
  #gV1 #gT1 #Hg1
  [ -IHT1 #H1 #_ elim (IHV1 … HL12 … H1) -IHV1 -HL12 -H1
    /3 width=6 by pr_sor_inv_sle_sn_trans, ex2_intro/
  | -IHV1 #_ #H2 elim (IHT1 … HL12 … H2) -IHT1 -HL12 -H2
    /3 width=6 by pr_sor_inv_sle_dx_trans, ex2_intro/
  ]
]
qed-.
