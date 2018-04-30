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

(* GENERAL NOTATION USED BY THE FORMAL SYSTEM λδ ****************************)

notation < "hvbox( L ⊢ break term 46 T1 ≗ break term 46 T2 )"
   non associative with precedence 45
   for @{ 'RingEq $M $L $T1 $T2 }.

notation > "hvbox( L ⊢ break term 46 T1 ≗ break term 46 T2 )"
   non associative with precedence 45
   for @{ 'RingEq ? $L $T1 $T2 }.

notation > "hvbox( L ⊢ break term 46 T1 ≗{ break term 46 M } break term 46 T2 )"
   non associative with precedence 45
   for @{ 'RingEq $M $L $T1 $T2 }.
