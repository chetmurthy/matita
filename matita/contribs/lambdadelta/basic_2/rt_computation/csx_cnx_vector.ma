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

(* STRONGLY NORMALIZING TERM VECTORS FOR UNCOUNTED PARALLEL RT-TRANSITION ***)

include "basic_2/rt_computation/cpxs_theq_vector.ma".
include "basic_2/rt_computation/csx_simple_theq.ma".
include "basic_2/rt_computation/csx_cnx.ma".
include "basic_2/rt_computation/csx_cpxs.ma".
include "basic_2/rt_computation/csx_vector.ma".

(* Properties with normal terms for uncounted parallel rt-transition ********)

(* Basic_1: was just: sn3_appls_lref *)
lemma csx_applv_cnx: ∀h,o,G,L,T. 𝐒⦃T⦄ → ⦃G, L⦄ ⊢ ⬈[h, o] 𝐍⦃T⦄ →
                     ∀Vs. ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃Vs⦄ → ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃ⒶVs.T⦄.
#h #o #G #L #T #H1T #H2T #Vs elim Vs -Vs
[ #_ normalize in ⊢ (?????%); /2 width=1/
| #V #Vs #IHV #H
  elim (csxv_inv_cons … H) -H #HV #HVs
  @csx_appl_simple_theq /2 width=1 by applv_simple/ -IHV -HV -HVs
  #X #H #H0
  lapply (cpxs_fwd_cnx_vector … o … H) -H // -H1T -H2T #H
  elim (H0) -H0 //
]
qed.

(* Advanced properties ******************************************************)

lemma csx_applv_sort: ∀h,o,G,L,s,Vs. ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃Vs⦄ → ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃ⒶVs.⋆s⦄.
#h #o #G #L #s elim (deg_total h o s)
#d generalize in match s; -s elim d -d
[ /3 width=6 by csx_applv_cnx, cnx_sort, simple_atom/
| #d #IHd #s #Hd #Vs elim Vs -Vs /2 width=1 by/
  #V #Vs #IHVs #HVVs
  elim (csxv_inv_cons … HVVs) #HV #HVs
  @csx_appl_simple_theq /2 width=1 by applv_simple, simple_atom/
  #X #H #H0
  elim (cpxs_fwd_sort_vector … o … H) -H #H
  [ elim H0 -H0 //
  | -H0 @(csx_cpxs_trans … (Ⓐ(V@Vs).⋆(next h s)))
    /3 width=1 by cpxs_flat_dx, deg_next_SO/
  ]
]
qed.
