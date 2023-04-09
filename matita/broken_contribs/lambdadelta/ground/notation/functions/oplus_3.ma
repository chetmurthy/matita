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

notation < "hvbox( hd ⨁ break tl )"
  right associative with precedence 47
  for @{ 'OPlus $S $hd $tl }.

notation > "hvbox( hd ⨁ break tl )"
  right associative with precedence 47
  for @{ 'OPlus ? $hd $tl }.

notation > "hvbox( hd ⨁{ break term 46 S } break term 46 tl )"
  non associative with precedence 47
  for @{ 'OPlus $S $hd $tl }.
