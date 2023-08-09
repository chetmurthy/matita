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

(* NOTATION FOR GROUND ******************************************************)

(* NOTE: This file was generated by xoa, do not edit ************************)

(* Note: multiple existental quantifier (1, 3) *)
notation > "hvbox(∃∃ ident x0 , ident x1 , ident x2 break . term 19 P0)"
  non associative with precedence 20
  for @{ 'Ex3 (λ${ident x0}.λ${ident x1}.λ${ident x2}.$P0) }.

notation < "hvbox(∃∃ ident x0 , ident x1 , ident x2 break . term 19 P0)"
  non associative with precedence 20
  for @{ 'Ex3 (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.$P0) }.

