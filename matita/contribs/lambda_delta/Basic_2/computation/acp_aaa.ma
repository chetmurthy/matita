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

include "Basic_2/unfold/lifts_lifts.ma".
include "Basic_2/unfold/ldrops_ldrops.ma".
include "Basic_2/static/aaa.ma".
include "Basic_2/computation/lsubc.ma".

(* NOTE: The constant (0) can not be generalized *)
axiom lsubc_ldrop_trans: ∀RP,L1,L2. L1 [RP] ⊑ L2 → ∀K2,e. ⇩[0, e] L2 ≡ K2 →
                         ∃∃K1. ⇩[0, e] L1 ≡ K1 & K1 [RP] ⊑ K2.

axiom ldrops_lsubc_trans: ∀RP,L1,K1,des. ⇩*[des] L1 ≡ K1 → ∀K2. K1 [RP] ⊑ K2 →
                          ∃∃L2. L1 [RP] ⊑ L2 & ⇩*[des] L2 ≡ K2.

(* ABSTRACT COMPUTATION PROPERTIES ******************************************)

(* Main propertis ***********************************************************)

axiom aacr_aaa_csubc_lifts: ∀RR,RS,RP.
                              acp RR RS RP → acr RR RS RP (λL,T. RP L T) →
                              ∀L1,T,A. L1 ⊢ T ÷ A → ∀L0,des. ⇩*[des] L0 ≡ L1 →
                              ∀T0. ⇧*[des] T ≡ T0 → ∀L2. L2 [RP] ⊑ L0 →
                              ⦃L2, T0⦄ [RP] ϵ 〚A〛.
(*
#RR #RS #RP #H1RP #H2RP #L1 #T #A #H elim H -L1 -T -A
[ #L #k #L0 #des #HL0 #X #H #L2 #HL20
  >(lifts_inv_sort1 … H) -H
  lapply (aacr_acr … H1RP H2RP 𝕒) #HAtom
  @(s2 … HAtom … ◊) // /2 width=2/
| * #L #K #V #B #i #HLK #_ #IHB #L0 #des #HL0 #X #H #L2 #HL20
  elim (lifts_inv_lref1 … H) -H #i0 #Hi0 #H destruct
  elim (ldrops_ldrop_trans … HL0 … HLK) -L #L #des1 #i1 #HL0 #HLK #Hi1 #Hdes1 

  elim (lsubc_ldrop_trans … HL20 … HL0) -L0 #L0 #HL20 #HL0 
  [
  | lapply (aacr_acr … H1RP H2RP B) #HB
    @(s2 … HB … ◊) //
    @(cp2 … H1RP)
  ]

| #L #V #T #B #A #_ #_ #IHB #IHA #L0 #des #HL0 #X #H #L2 #HL20
  elim (lifts_inv_bind1 … H) -H #V0 #T0 #HV0 #HT0 #H destruct
  lapply (aacr_acr … H1RP H2RP A) #HA
  lapply (aacr_acr … H1RP H2RP B) #HB
  lapply (s1 … HB) -HB #HB
  @(s5 … HA … ◊ ◊) // /3 width=5/
| #L #W #T #B #A #_ #_ #IHB #IHA #L0 #des #HL0 #X #H #L2 #HL02
  elim (lifts_inv_bind1 … H) -H #W0 #T0 #HW0 #HT0 #H destruct
  @(aacr_abst  … H1RP H2RP)
  [ lapply (aacr_acr … H1RP H2RP B) #HB
    @(s1 … HB) /2 width=5/
  | #L3 #V3 #T3 #des3 #HL32 #HT03 #HB
    elim (lifts_total des3 W0) #W2 #HW02
    elim (ldrops_lsubc_trans … HL32 … HL02) -L2 #L2 #HL32 #HL20
    @(IHA (L2. 𝕓{Abst} W2) … (ss des @ ss des3))
    /2 width=3/ /3 width=5/ /4 width=6/
  ]
| #L #V #T #B #A #_ #_ #IHB #IHA #L0 #des #HL0 #X #H #L2 #HL20
  elim (lifts_inv_flat1 … H) -H #V0 #T0 #HV0 #HT0 #H destruct
  /3 width=10/
| #L #V #T #A #_ #_ #IH1A #IH2A #L0 #des #HL0 #X #H #L2 #HL20
  elim (lifts_inv_flat1 … H) -H #V0 #T0 #HV0 #HT0 #H destruct
  lapply (aacr_acr … H1RP H2RP A) #HA
  lapply (s1 … HA) #H
  @(s6 … HA … ◊) /2 width=5/ /3 width=5/
]
*)
lemma acp_aaa: ∀RR,RS,RP. acp RR RS RP → acr RR RS RP (λL,T. RP L T) →
               ∀L,T,A. L ⊢ T ÷ A → RP L T.
#RR #RS #RP #H1RP #H2RP #L #T #A #HT
lapply (aacr_acr … H1RP H2RP A) #HA
@(s1 … HA) /2 width=8/
qed.
