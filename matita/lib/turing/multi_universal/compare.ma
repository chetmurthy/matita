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

include "turing/multi_universal/moves.ma".
include "turing/if_multi.ma".
include "turing/inject.ma".
include "turing/basic_machines.ma".

definition compare_states ≝ initN 3.

definition comp0 : compare_states ≝ mk_Sig ?? 0 (leb_true_to_le 1 3 (refl …)).
definition comp1 : compare_states ≝ mk_Sig ?? 1 (leb_true_to_le 2 3 (refl …)).
definition comp2 : compare_states ≝ mk_Sig ?? 2 (leb_true_to_le 3 3 (refl …)).

(*

0) (x,x) → (x,x)(R,R) → 1
   (x,y≠x) → None 2
1) (_,_) → None 1
2) (_,_) → None 2

*)

definition trans_compare_step ≝ 
 λi,j.λsig:FinSet.λn.λis_endc.
 λp:compare_states × (Vector (option sig) (S n)).
 let 〈q,a〉 ≝ p in
 match pi1 … q with
 [ O ⇒ match nth i ? a (None ?) with
   [ None ⇒ 〈comp2,null_action ? n〉
   | Some ai ⇒ match nth j ? a (None ?) with 
     [ None ⇒ 〈comp2,null_action ? n〉
     | Some aj ⇒ if notb (is_endc ai) ∧ ai == aj 
         then 〈comp1,change_vec ? (S n) 
                      (change_vec ? (S n) (null_action ? n) (Some ? 〈ai,R〉) i)
                        (Some ? 〈aj,R〉) j〉
         else 〈comp2,null_action ? n〉 ]
   ]
 | S q ⇒ match q with 
   [ O ⇒ (* 1 *) 〈comp1,null_action ? n〉
   | S _ ⇒ (* 2 *) 〈comp2,null_action ? n〉 ] ].

definition compare_step ≝ 
  λi,j,sig,n,is_endc.
  mk_mTM sig n compare_states (trans_compare_step i j sig n is_endc) 
    comp0 (λq.q == comp1 ∨ q == comp2).

definition R_comp_step_true ≝ 
  λi,j,sig,n,is_endc.λint,outt: Vector (tape sig) (S n).
  ∃x.
   is_endc x = false ∧
   current ? (nth i ? int (niltape ?)) = Some ? x ∧
   current ? (nth j ? int (niltape ?)) = Some ? x ∧
   outt = change_vec ?? 
            (change_vec ?? int
              (tape_move ? (nth i ? int (niltape ?)) (Some ? 〈x,R〉)) i)
            (tape_move ? (nth j ? int (niltape ?)) (Some ? 〈x,R〉)) j.

definition R_comp_step_false ≝ 
  λi,j:nat.λsig,n,is_endc.λint,outt: Vector (tape sig) (S n).
   ((∃x.current ? (nth i ? int (niltape ?)) = Some ? x ∧ is_endc x = true) ∨
   current ? (nth i ? int (niltape ?)) ≠ current ? (nth j ? int (niltape ?)) ∨
   current ? (nth i ? int (niltape ?)) = None ? ∨
   current ? (nth j ? int (niltape ?)) = None ?) ∧ outt = int.

lemma comp_q0_q2_null :
  ∀i,j,sig,n,is_endc,v.i < S n → j < S n → 
  (nth i ? (current_chars ?? v) (None ?) = None ? ∨
   nth j ? (current_chars ?? v) (None ?) = None ?) → 
  step sig n (compare_step i j sig n is_endc) (mk_mconfig ??? comp0 v) 
  = mk_mconfig ??? comp2 v.
#i #j #sig #n #is_endc #v #Hi #Hj
whd in ⊢ (? → ??%?); >(eq_pair_fst_snd … (trans ????)) whd in ⊢ (?→??%?);
* #Hcurrent
[ @eq_f2
  [ whd in ⊢ (??(???%)?); >Hcurrent %
  | whd in ⊢ (??(???????(???%))?); >Hcurrent @tape_move_null_action ]
| @eq_f2
  [ whd in ⊢ (??(???%)?); >Hcurrent cases (nth i ?? (None sig)) //
  | whd in ⊢ (??(???????(???%))?); >Hcurrent
    cases (nth i ?? (None sig)) [|#x] @tape_move_null_action ] ]
qed.

lemma comp_q0_q2_neq :
  ∀i,j,sig,n,is_endc,v.i < S n → j < S n → 
  ((∃x.nth i ? (current_chars ?? v) (None ?) = Some ? x ∧ is_endc x = true) ∨ 
    nth i ? (current_chars ?? v) (None ?) ≠ nth j ? (current_chars ?? v) (None ?)) → 
  step sig n (compare_step i j sig n is_endc) (mk_mconfig ??? comp0 v) 
  = mk_mconfig ??? comp2 v.
#i #j #sig #n #is_endc #v #Hi #Hj lapply (refl ? (nth i ?(current_chars ?? v)(None ?)))
cases (nth i ?? (None ?)) in ⊢ (???%→?);
[ #Hnth #_ @comp_q0_q2_null // % //
| #ai #Hai lapply (refl ? (nth j ?(current_chars ?? v)(None ?)))
  cases (nth j ?? (None ?)) in ⊢ (???%→?);
  [ #Hnth #_ @comp_q0_q2_null // %2 //
  | #aj #Haj *
    [ * #c * >Hai #Heq #Hendc whd in ⊢ (??%?); 
      >(eq_pair_fst_snd … (trans ????)) whd in ⊢ (??%?); @eq_f2
      [ whd in match (trans ????); >Hai >Haj destruct (Heq) 
        whd in ⊢ (??(???%)?); >Hendc // 
      | whd in match (trans ????); >Hai >Haj destruct (Heq) 
        whd in ⊢ (??(???????(???%))?); >Hendc @tape_move_null_action
      ]
    | #Hneq
      whd in ⊢ (??%?); >(eq_pair_fst_snd … (trans ????)) whd in ⊢ (??%?); @eq_f2
      [ whd in match (trans ????); >Hai >Haj
        whd in ⊢ (??(???%)?); cut ((¬is_endc ai∧ai==aj)=false)
        [>(\bf ?) /2 by not_to_not/ cases (is_endc ai) // |#Hcut >Hcut //]
        | whd in match (trans ????); >Hai >Haj
          whd in ⊢ (??(???????(???%))?); cut ((¬is_endc ai∧ai==aj)=false)
          [>(\bf ?) /2 by not_to_not/ cases (is_endc ai) // 
          |#Hcut >Hcut @tape_move_null_action
          ]
        ]
      ]
    ]
]
qed.

lemma comp_q0_q1 :
  ∀i,j,sig,n,is_endc,v,a.i ≠ j → i < S n → j < S n → 
  nth i ? (current_chars ?? v) (None ?) = Some ? a → is_endc a = false →
  nth j ? (current_chars ?? v) (None ?) = Some ? a → 
  step sig n (compare_step i j sig n is_endc) (mk_mconfig ??? comp0 v) =
    mk_mconfig ??? comp1 
     (change_vec ? (S n) 
       (change_vec ?? v
         (tape_move ? (nth i ? v (niltape ?)) (Some ? 〈a,R〉)) i)
       (tape_move ? (nth j ? v (niltape ?)) (Some ? 〈a,R〉)) j).
#i #j #sig #n #is_endc #v #a #Heq #Hi #Hj #Ha1 #Hnotendc #Ha2
whd in ⊢ (??%?); >(eq_pair_fst_snd … (trans ????)) whd in ⊢ (??%?); @eq_f2
[ whd in match (trans ????);
  >Ha1 >Ha2 whd in ⊢ (??(???%)?); >Hnotendc >(\b ?) //
| whd in match (trans ????);
  >Ha1 >Ha2 whd in ⊢ (??(???????(???%))?); >Hnotendc >(\b ?) //
  change with (change_vec ?????) in ⊢ (??(???????%)?);
  <(change_vec_same … v j (niltape ?)) in ⊢ (??%?);
  <(change_vec_same … v i (niltape ?)) in ⊢ (??%?);
  >pmap_change >pmap_change >tape_move_null_action
  @eq_f2 // @eq_f2 // >nth_change_vec_neq //
]
qed.

lemma sem_comp_step :
  ∀i,j,sig,n,is_endc.i ≠ j → i < S n → j < S n → 
  compare_step i j sig n is_endc ⊨ 
    [ comp1: R_comp_step_true i j sig n is_endc, 
             R_comp_step_false i j sig n is_endc ].
#i #j #sig #n #is_endc #Hneq #Hi #Hj #int
lapply (refl ? (current ? (nth i ? int (niltape ?))))
cases (current ? (nth i ? int (niltape ?))) in ⊢ (???%→?);
[ #Hcuri %{2} %
  [| % [ %
    [ whd in ⊢ (??%?); >comp_q0_q2_null /2/ % <Hcuri in ⊢ (???%); 
      @sym_eq @nth_vec_map
    | normalize in ⊢ (%→?); #H destruct (H) ]
  | #_ % // % %2 // ] ]
| #a #Ha lapply (refl ? (current ? (nth j ? int (niltape ?))))
  cases (current ? (nth j ? int (niltape ?))) in ⊢ (???%→?);
  [ #Hcurj %{2} %
    [| % [ %
       [ whd in ⊢ (??%?); >comp_q0_q2_null /2/ %2 <Hcurj in ⊢ (???%); 
         @sym_eq @nth_vec_map
       | normalize in ⊢ (%→?); #H destruct (H) ]
       | #_ % // >Ha >Hcurj % % %2 % #H destruct (H) ] ]
  | #b #Hb %{2} 
   cases (true_or_false (is_endc a)) #Haendc
    [ %
      [| % [ % 
        [whd in ⊢  (??%?);  >comp_q0_q2_neq //
         % %{a} % // <Ha @sym_eq @nth_vec_map
        | normalize in ⊢ (%→?); #H destruct (H) ]
      | #_ % // % % % >Ha %{a} % // ]
      ]
    |cases (true_or_false (a == b)) #Hab
      [ %
        [| % [ % 
          [whd in ⊢  (??%?);  >(comp_q0_q1 … a Hneq Hi Hj) //
            [>(\P Hab) <Hb @sym_eq @nth_vec_map
            |<Ha @sym_eq @nth_vec_map ]
          | #_ whd >(\P Hab) %{b} % // % // <(\P Hab) % // ]
          | * #H @False_ind @H %
        ] ]
      | %
        [| % [ % 
          [whd in ⊢  (??%?);  >comp_q0_q2_neq //
           <(nth_vec_map ?? (current …) i ? int (niltape ?))
           <(nth_vec_map ?? (current …) j ? int (niltape ?)) %2 >Ha >Hb
           @(not_to_not ??? (\Pf Hab)) #H destruct (H) %
          | normalize in ⊢ (%→?); #H destruct (H) ]
        | #_ % // % % %2 >Ha >Hb @(not_to_not ??? (\Pf Hab)) #H destruct (H) % ] ]
      ]
    ]
  ]
]
qed.

definition compare ≝ λi,j,sig,n,is_endc.
  whileTM … (compare_step i j sig n is_endc) comp1.

definition R_compare ≝ 
  λi,j,sig,n,is_endc.λint,outt: Vector (tape sig) (S n).
  ((∃x.current ? (nth i ? int (niltape ?)) = Some ? x ∧ is_endc x = true) ∨
   (current ? (nth i ? int (niltape ?)) ≠ current ? (nth j ? int (niltape ?)) ∨
    current ? (nth i ? int (niltape ?)) = None ? ∨
    current ? (nth j ? int (niltape ?)) = None ?) → outt = int) ∧
  (∀ls,x,xs,ci,rs,ls0,rs0. 
    nth i ? int (niltape ?) = midtape sig ls x (xs@ci::rs) →
    nth j ? int (niltape ?) = midtape sig ls0 x (xs@rs0) →
    (∀c0. memb ? c0 (x::xs) = true → is_endc c0 = false) → 
    (rs0 = [ ] ∧
     outt = change_vec ?? 
           (change_vec ?? int (midtape sig (reverse ? xs@x::ls) ci rs) i)
           (mk_tape sig (reverse ? xs@x::ls0) (None ?) []) j) ∨
    ∃cj,rs1.rs0 = cj::rs1 ∧
    ((is_endc ci = true ∨ ci ≠ cj) → 
    outt = change_vec ?? 
           (change_vec ?? int (midtape sig (reverse ? xs@x::ls) ci rs) i)
           (midtape sig (reverse ? xs@x::ls0) cj rs1) j)).
          
lemma wsem_compare : ∀i,j,sig,n,is_endc.i ≠ j → i < S n → j < S n → 
  compare i j sig n is_endc ⊫ R_compare i j sig n is_endc.
#i #j #sig #n #is_endc #Hneq #Hi #Hj #ta #k #outc #Hloop
lapply (sem_while … (sem_comp_step i j sig n is_endc Hneq Hi Hj) … Hloop) //
-Hloop * #tb * #Hstar @(star_ind_l ??????? Hstar) -Hstar
[ whd in ⊢ (%→?); * * [ * [ *
  [* #curi * #Hcuri #Hendi #Houtc %
    [ #_ @Houtc  
    | #ls #x #xs #ci #rs #ls0 #rs0 #Hnthi #Hnthj #Hnotendc 
      @False_ind
      >Hnthi in Hcuri; normalize in ⊢ (%→?); #H destruct (H)
      >(Hnotendc ? (memb_hd … )) in Hendi; #H destruct (H)
    ]
  |#Hcicj #Houtc % 
    [ #_ @Houtc
    | #ls #x #xs #ci #rs #ls0 #rs0 #Hnthi #Hnthj
      >Hnthi in Hcicj; >Hnthj normalize in ⊢ (%→?); * #H @False_ind @H %
    ]]
  | #Hci #Houtc %
    [ #_ @Houtc
    | #ls #x #xs #ci #rs #ls0 #rs0 #Hnthi >Hnthi in Hci;
      normalize in ⊢ (%→?); #H destruct (H) ] ]
  | #Hcj #Houtc %
    [ #_ @Houtc
    | #ls #x #xs #ci #rs #ls0 #rs0 #_ #Hnthj >Hnthj in Hcj;
      normalize in ⊢ (%→?); #H destruct (H) ] ]
  | #td #te * #x * * * #Hendcx #Hci #Hcj #Hd #Hstar #IH #He lapply (IH He) -IH *
    #IH1 #IH2 %
    [ >Hci >Hcj * [* #x0 * #H destruct (H) >Hendcx #H destruct (H) 
    |* [* #H @False_ind [cases H -H #H @H % | destruct (H)] | #H destruct (H)]] 
    | #ls #c0 #xs #ci #rs #ls0 #rs0 cases xs
      [ #Hnthi #Hnthj #Hnotendc cases rs0 in Hnthj;
        [ #Hnthj % % // >IH1
          [ >Hd @eq_f3 //
            [ @eq_f3 // >(?:c0=x) [ >Hnthi % ]
              >Hnthi in Hci;normalize #H destruct (H) %
            | >(?:c0=x) [ >Hnthj % ]
              >Hnthi in Hci;normalize #H destruct (H) % ]
          | >Hd %2 %2 >nth_change_vec // >Hnthj % ]
        | #r1 #rs1 #Hnthj %2 %{r1} %{rs1} % // *
          [ #Hendci >IH1
            [ >Hd @eq_f3 // 
              [ @eq_f3 // >(?:c0=x) [ >Hnthi % ]
             >Hnthi in Hci;normalize #H destruct (H) %
            | >(?:c0=x) [ >Hnthj % ]
            >Hnthi in Hci;normalize #H destruct (H) % ]
        | >Hd >nth_change_vec // >nth_change_vec_neq [|@sym_not_eq //]
          >nth_change_vec // >Hnthi >Hnthj normalize % %{ci} % //
        ]
      |#Hcir1 >IH1
        [>Hd @eq_f3 // 
          [ @eq_f3 // >(?:c0=x) [ >Hnthi % ]
            >Hnthi in Hci;normalize #H destruct (H) %
          | >(?:c0=x) [ >Hnthj % ]
            >Hnthi in Hci;normalize #H destruct (H) % ]
        | >Hd %2 % % >nth_change_vec //
          >nth_change_vec_neq [|@sym_not_eq //]
          >nth_change_vec // >Hnthi >Hnthj normalize @(not_to_not … Hcir1)
          #H destruct (H) % ]
      ]
    ]
  |#x0 #xs0 #Hnthi #Hnthj #Hnotendc 
   cut (c0 = x) [ >Hnthi in Hci; normalize #H destruct (H) // ]
   #Hcut destruct (Hcut) cases rs0 in Hnthj;
    [ #Hnthj % % // 
      cases (IH2 (x::ls) x0 xs0 ci rs (x::ls0) [ ] ???) -IH2
      [ * #_ #IH2 >IH2 >Hd >change_vec_commute in ⊢ (??%?); //
        >change_vec_change_vec >change_vec_commute in ⊢ (??%?); //
        @sym_not_eq //
      | * #cj * #rs1 * #H destruct (H)
      | >Hd >nth_change_vec_neq [|@sym_not_eq //] >nth_change_vec //
        >Hnthi %
      | >Hd >nth_change_vec // >Hnthj %
      | #c0 #Hc0 @Hnotendc @memb_cons @Hc0 ]
    | #r1 #rs1 #Hnthj %2 %{r1} %{rs1} % // #Hcir1
      cases(IH2 (x::ls) x0 xs0 ci rs (x::ls0) (r1::rs1) ???)
      [ * #H destruct (H)
      | * #r1' * #rs1' * #H destruct (H) #Hc1r1 >Hc1r1 //
        >Hd >change_vec_commute in ⊢ (??%?); //
        >change_vec_change_vec >change_vec_commute in ⊢ (??%?); //
          @sym_not_eq //
      | >Hd >nth_change_vec_neq [|@sym_not_eq //] >nth_change_vec //
        >Hnthi //
      | >Hd >nth_change_vec // >Hnthi >Hnthj %
      | #c0 #Hc0 @Hnotendc @memb_cons @Hc0
]]]]]
qed.      
 
lemma terminate_compare :  ∀i,j,sig,n,is_endc,t.
  i ≠ j → i < S n → j < S n → 
  compare i j sig n is_endc ↓ t.
#i #j #sig #n #is_endc #t #Hneq #Hi #Hj
@(terminate_while … (sem_comp_step …)) //
<(change_vec_same … t i (niltape ?))
cases (nth i (tape sig) t (niltape ?))
[ % #t1 * #x * * * #_ >nth_change_vec // normalize in ⊢ (%→?); #Hx destruct 
|2,3: #a0 #al0 % #t1 * #x * * * #_ >nth_change_vec // normalize in ⊢ (%→?); #Hx destruct
| #ls #c #rs lapply c -c lapply ls -ls lapply t -t elim rs
  [#t #ls #c % #t1 * #x * * * #Hendcx >nth_change_vec // normalize in ⊢ (%→?);
   #H1 destruct (H1) #Hxsep >change_vec_change_vec #Ht1 % 
   #t2 * #x0 * * * #Hendcx0 >Ht1 >nth_change_vec_neq [|@sym_not_eq //]
   >nth_change_vec // normalize in ⊢ (%→?); #H destruct (H)
  |#r0 #rs0 #IH #t #ls #c % #t1 * #x * * >nth_change_vec //
   normalize in ⊢ (%→?); #H destruct (H) #Hcur
   >change_vec_change_vec >change_vec_commute // #Ht1 >Ht1 @IH
  ]
]
qed.

lemma sem_compare : ∀i,j,sig,n,is_endc.
  i ≠ j → i < S n → j < S n → 
  compare i j sig n is_endc ⊨ R_compare i j sig n is_endc.
#i #j #sig #n #is_endc #Hneq #Hi #Hj @WRealize_to_Realize /2/
qed.
