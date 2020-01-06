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

include "ground_2/notation/xoa/ex_4_2.ma".

(* multiple existental quantifier (4, 2) *)

inductive ex4_2 (A0,A1:Type[0]) (P0,P1,P2,P3:A0→A1→Prop) : Prop ≝
   | ex4_2_intro: ∀x0,x1. P0 x0 x1 → P1 x0 x1 → P2 x0 x1 → P3 x0 x1 → ex4_2 ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (4, 2)" 'Ex2 P0 P1 P2 P3 = (ex4_2 ? ? P0 P1 P2 P3).

