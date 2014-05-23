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

include "basic_2/substitution/cofrees_alt.ma".
include "basic_2/substitution/llpx_sn_alt1.ma".

(* LAZY SN POINTWISE EXTENSION OF A CONTEXT-SENSITIVE REALTION FOR TERMS ****)

(* alternative definition of llpx_sn (not recursive) *)
definition llpx_sn_alt2: relation4 bind2 lenv term term → relation4 ynat term lenv lenv ≝
                         λR,d,T,L1,L2. |L1| = |L2| ∧
                         (∀I1,I2,K1,K2,V1,V2,i. d ≤ yinj i → (L1 ⊢ i ~ϵ 𝐅*[d]⦃T⦄ → ⊥) →
                            ⇩[i] L1 ≡ K1.ⓑ{I1}V1 → ⇩[i] L2 ≡ K2.ⓑ{I2}V2 →
                            I1 = I2 ∧ R I1 K1 V1 V2
                         ).

(* Main properties **********************************************************)

theorem llpx_sn_llpx_sn_alt2: ∀R,T,L1,L2,d. llpx_sn R d T L1 L2 → llpx_sn_alt2 R d T L1 L2.
#R #U #L1 @(f2_ind … rfw … L1 U) -L1 -U
#n #IHn #L1 #U #Hn #L2 #d #H elim (llpx_sn_inv_alt1 … H) -H
#HL12 #IHU @conj //
#I1 #I2 #K1 #K2 #V1 #V2 #i #Hdi #H #HLK1 #HLK2 elim (frees_inv_ge … H) -H //
[ -n #HnU elim (IHU … HnU HLK1 HLK2) -IHU -HnU -HLK1 -HLK2 /2 width=1 by conj/
| * #J1 #K10 #W10 #j #Hdj #Hji #HLK10 #HnW10 #HnU destruct
  lapply (ldrop_fwd_drop2 … HLK10) #H
  lapply (ldrop_conf_ge … H … HLK1 ?) -H /2 width=1 by lt_to_le/ <minus_plus #HK10
  elim (ldrop_O1_lt (Ⓕ) L2 j) [2: <HL12 /2 width=5 by ldrop_fwd_length_lt2/ ] #J2 #K20 #W20 #HLK20
  lapply (ldrop_fwd_drop2 … HLK20) #H
  lapply (ldrop_conf_ge … H … HLK2 ?) -H /2 width=1 by lt_to_le/ <minus_plus #HK20
  elim (IHn K10 W10 … K20 0) /3 width=6 by ldrop_fwd_rfw/ -IHn
  elim (IHU … HnU HLK10 HLK20) -IHU -HnU -HLK10 -HLK20 //
]
qed.  
