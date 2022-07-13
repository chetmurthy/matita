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

include "delayed_updating/substitution/lift_rmap.ma".
include "ground/relocation/tr_pn_eq.ma".
include "ground/lib/stream_tls_plus.ma".
include "ground/lib/stream_tls_eq.ma".
include "ground/arith/nat_plus_rplus.ma".
include "ground/arith/nat_rplus_pplus.ma".

(* LIFT FOR RELOCATION MAP **************************************************)

(* Constructions with lift_eq ***********************************************)

lemma lift_rmap_eq_repl (p):
      stream_eq_repl … (λf1,f2. ↑[p]f1 ≗ ↑[p]f2).
#p elim p -p //
* [ #k ] #p #IH #f1 #f2 #Hf
[ /3 width=1 by stream_tls_eq_repl/
| /2 width=1 by/
| /3 width=1 by tr_push_eq_repl/
| /2 width=1 by/
| /2 width=1 by/
]
qed.

lemma tls_lift_rmap_d_dx (f) (p) (n) (k):
      ⇂*[n+k]↑[p]f ≗ ⇂*[n]↑[p◖𝗱k]f.
#f #p #n #k
<lift_rmap_d_dx >nrplus_inj_dx >nrplus_inj_sn //
qed.
