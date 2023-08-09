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

(* Note: multiple disjunction connective (3) *)
notation "hvbox(∨∨ term 29 P0 break | term 29 P1 break | term 29 P2)"
  non associative with precedence 30
  for @{ 'Or $P0 $P1 $P2 }.

