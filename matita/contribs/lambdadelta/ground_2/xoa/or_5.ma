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

(* This file was generated by xoa.native: do not edit *********************)

include "basics/pts.ma".

include "ground_2/notation/xoa/or_5.ma".

(* multiple disjunction connective (5) *)

inductive or5 (P0,P1,P2,P3,P4:Prop) : Prop ≝
   | or5_intro0: P0 → or5 ? ? ? ? ?
   | or5_intro1: P1 → or5 ? ? ? ? ?
   | or5_intro2: P2 → or5 ? ? ? ? ?
   | or5_intro3: P3 → or5 ? ? ? ? ?
   | or5_intro4: P4 → or5 ? ? ? ? ?
.

interpretation "multiple disjunction connective (5)" 'Or P0 P1 P2 P3 P4 = (or5 P0 P1 P2 P3 P4).

