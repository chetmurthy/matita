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

include "basics/core_notation/imply_2.ma".

include "lambda/notation/xoa/ex_1_2.ma".

(* multiple existental quantifier (1, 2) *)

inductive ex1_2 (A0,A1:Type[0]) (P0:A0→A1→Prop) : Prop ≝
   | ex1_2_intro: ∀x0,x1. P0 x0 x1 → ex1_2 ? ? ?
.

interpretation "multiple existental quantifier (1, 2)" 'Ex2 P0 = (ex1_2 ? ? P0).

