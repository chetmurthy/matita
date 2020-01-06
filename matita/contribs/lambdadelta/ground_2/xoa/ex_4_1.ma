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

include "ground_2/notation/xoa/ex_4_1.ma".

(* multiple existental quantifier (4, 1) *)

inductive ex4 (A0:Type[0]) (P0,P1,P2,P3:A0→Prop) : Prop ≝
   | ex4_intro: ∀x0. P0 x0 → P1 x0 → P2 x0 → P3 x0 → ex4 ? ? ? ? ?
.

interpretation "multiple existental quantifier (4, 1)" 'Ex P0 P1 P2 P3 = (ex4 ? P0 P1 P2 P3).

