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

(* Note: multiple existental quantifier (7, 4) *)
notation > "hvbox(∃∃ ident x0 , ident x1 , ident x2 , ident x3 break . term 19 P0 break & term 19 P1 break & term 19 P2 break & term 19 P3 break & term 19 P4 break & term 19 P5 break & term 19 P6)"
  non associative with precedence 20
  for @{ 'Ex4 (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P0) (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P1) (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P2) (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P3) (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P4) (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P5) (λ${ident x0}.λ${ident x1}.λ${ident x2}.λ${ident x3}.$P6) }.

notation < "hvbox(∃∃ ident x0 , ident x1 , ident x2 , ident x3 break . term 19 P0 break & term 19 P1 break & term 19 P2 break & term 19 P3 break & term 19 P4 break & term 19 P5 break & term 19 P6)"
  non associative with precedence 20
  for @{ 'Ex4 (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P0) (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P1) (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P2) (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P3) (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P4) (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P5) (λ${ident x0}:$T0.λ${ident x1}:$T1.λ${ident x2}:$T2.λ${ident x3}:$T3.$P6) }.

