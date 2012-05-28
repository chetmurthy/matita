(*
    ||M||  This file is part of HELM, an Hypertextual, Electronic   
    ||A||  Library of Mathematics, developed at the Computer Science 
    ||T||  Department of the University of Bologna, Italy.           
    ||I||                                                            
    ||T||  
    ||A||  
    \   /  This file is distributed under the terms of the       
     \ /   GNU General Public License Version 2   
      V_____________________________________________________________*)


(* COMPARE BIT

*)

include "turing/universal/marks.ma".

definition STape ≝ FinProd … FSUnialpha FinBool.

definition only_bits ≝ λl.
  ∀c.memb STape c l = true → is_bit (\fst c) = true.

definition only_bits_or_nulls ≝ λl.
  ∀c.memb STape c l = true → bit_or_null (\fst c) = true.
  
definition no_grids ≝ λl.
  ∀c.memb STape c l = true → is_grid (\fst c) = false.

definition no_bars ≝ λl.
  ∀c.memb STape c l = true → is_bar (\fst c) = false.

definition no_marks ≝ λl.
  ∀c.memb STape c l = true → is_marked ? c = false.

lemma bit_not_grid: ∀d. is_bit d = true → is_grid d = false.
* // normalize #H destruct
qed.

lemma bit_or_null_not_grid: ∀d. bit_or_null d = true → is_grid d = false.
* // normalize #H destruct
qed.

lemma bit_not_bar: ∀d. is_bit d = true → is_bar d = false.
* // normalize #H destruct
qed.

lemma bit_or_null_not_bar: ∀d. bit_or_null d = true → is_bar d = false.
* // normalize #H destruct
qed.

definition mk_tuple ≝ λqin,cin,qout,cout,mv.
  qin @ cin :: 〈comma,false〉:: qout @ cout :: 〈comma,false〉 :: [mv].

axiom num_of_state : ∀state:FinSet. state → list (unialpha × bool).

definition tuple_of_pair ≝ λstates: FinSet.
  λhalt:states →bool. 
  λp: (states × (option FinBool)) × (states × (option (FinBool × move))).
  let 〈inp,outp〉 ≝ p in
  let 〈q,a〉 ≝ inp in
  let cin ≝ match a with [ None ⇒ null | Some b ⇒ bit b ] in
  let 〈qn,action〉 ≝ outp in
  let 〈cout,mv〉 ≝ 
    match action with 
    [ None ⇒ 〈null,null〉
    | Some act ⇒ let 〈na,m〉 ≝ act in 
      match m with 
      [ R ⇒ 〈bit na,bit true〉
      | L ⇒ 〈bit na,bit false〉
      | N ⇒ 〈bit na,null〉]
    ] in
  let qin ≝ num_of_state states q in
  let qout ≝ num_of_state states qn in
  mk_tuple qin 〈cin,false〉 qout 〈cout,false〉 〈mv,false〉.


  
  

(* by definition, a tuple is not marked *)
definition tuple_TM : nat → list STape → Prop ≝ 
 λn,t.∃qin,cin,qout,cout,mv.
 no_marks qin ∧ no_marks qout ∧
 only_bits qin ∧ only_bits qout ∧ 
 bit_or_null cin = true ∧ bit_or_null cout = true ∧ bit_or_null mv = true ∧
 (cout = null → mv = null) ∧
 |qin| = n ∧ |qout| = n ∧
 t = mk_tuple qin 〈cin,false〉 qout 〈cout,false〉 〈mv,false〉.
 
inductive table_TM (n:nat) : list STape → Prop ≝ 
| ttm_nil  : table_TM n [] 
| ttm_cons : ∀t1,T.tuple_TM n t1 → table_TM n T → table_TM n (t1@〈bar,false〉::T).

inductive match_in_table (n:nat) (qin:list STape) (cin: STape) 
                         (qout:list STape) (cout:STape) (mv:STape) 
: list STape → Prop ≝ 
| mit_hd : 
   ∀tb.
   tuple_TM n (mk_tuple qin cin qout cout mv) → 
   match_in_table n qin cin qout cout mv 
     (mk_tuple qin cin qout cout mv @〈bar,false〉::tb)
| mit_tl :
   ∀qin0,cin0,qout0,cout0,mv0,tb.
   tuple_TM n (mk_tuple qin0 cin0 qout0 cout0 mv0) → 
   match_in_table n qin cin qout cout mv tb → 
   match_in_table n qin cin qout cout mv  
     (mk_tuple qin0 cin0 qout0 cout0 mv0@〈bar,false〉::tb).
     
axiom append_l1_injective : 
  ∀A.∀l1,l2,l3,l4:list A. |l1| = |l2| → l1@l3 = l2@l4 → l1 = l2.
axiom append_l2_injective : 
  ∀A.∀l1,l2,l3,l4:list A. |l1| = |l2| → l1@l3 = l2@l4 → l3 = l4.
axiom cons_injective_l : ∀A.∀a1,a2:A.∀l1,l2.a1::l1 = a2::l2 → a1 = a2.
axiom cons_injective_r : ∀A.∀a1,a2:A.∀l1,l2.a1::l1 = a2::l2 → l1 = l2.
axiom tuple_len : ∀n,t.tuple_TM n t → |t| = 2*n+5.
axiom append_eq_tech1 :
  ∀A,l1,l2,l3,l4,a.l1@a::l2 = l3@l4 → |l1| < |l3| → ∃la:list A.l1@a::la = l3.
axiom append_eq_tech2 :
  ∀A,l1,l2,l3,l4,a.l1@a::l2 = l3@l4 → memb A a l4 = false → ∃la:list A.l3 = l1@a::la.
(*axiom list_decompose_cases : 
  ∀A,l1,l2,l3,l4,a.l1@a::l2 = l3@l4 → ∃la,lb:list A.l3 = la@a::lb ∨ l4 = la@a::lb.
axiom list_decompose_l :
  ∀A,l1,l2,l3,l4,a.l1@a::l2 = l3@l4 → memb A a l4 = false → 
  ∃la,lb.l2 = la@lb ∧ l3 = l1@a::la.
axiom list_decompose_r :
  ∀A,l1,l2,l3,l4,a.l1@a::l2 = l3@l4 → memb A a l3 = false → 
  ∃la,lb.l1 = la@lb ∧ l4 = lb@a::l2.
axiom list_decompose_memb :
  ∀A,l1,l2,l3,l4,a.l1@a::l2 = l3@l4 → |l1| < |l3| → memb A a l3 = true.*)

lemma table_invert_r : ∀n,t,T.
  tuple_TM n t → table_TM n (t@〈bar,false〉::T) → table_TM n T.
#n #t #T #Htuple #Htable inversion Htable
[ cases t normalize [ #Hfalse | #p #t0 #Hfalse ] destruct (Hfalse)
| #t0 #T0 #Htuple0 #Htable0 #_ #Heq lapply (append_l2_injective ?????? Heq)
  [ >(tuple_len … Htuple) >(tuple_len … Htuple0) % ]
  -Heq #Heq destruct (Heq) // ]
qed.

lemma match_in_table_to_tuple :
  ∀n,T,qin,cin,qout,cout,mv.
  match_in_table n qin cin qout cout mv T → table_TM n T → 
  tuple_TM n (mk_tuple qin cin qout cout mv).
#n #T #qin #cin #qout #cout #mv #Hmatch elim Hmatch
[ //
| #qin0 #cin0 #qout0 #cout0 #mv0 #tb #Htuple #Hmatch #IH #Htable
  @IH @(table_invert_r ???? Htable) @Htuple
]
qed.

lemma generic_match_to_match_in_table :
  ∀n,T.table_TM n T → 
  ∀qin,cin,qout,cout,mv.|qin| = n → |qout| = n → 
  only_bits qin → only_bits qout → 
  bit_or_null (\fst cin) = true → bit_or_null (\fst cout) = true → 
  bit_or_null (\fst mv) = true →  
  ∀t1,t2.
  T = (t1@qin@cin::〈comma,false〉::qout@cout::〈comma,false〉::[mv])@t2 → 
  match_in_table n qin cin qout cout mv T.
#n #T #Htable #qin #cin #qout #cout #mv #Hlenqin #Hlenqout
#Hqinbits #Hqoutbits #Hcin #Hcout #Hmv
elim Htable
[ #t1 #t2 <associative_append cases (t1@qin) normalize in ⊢ (%→?);
  [ #Hfalse destruct (Hfalse) | #c0 #t0 #Hfalse whd in Hfalse:(???%); destruct (Hfalse) ]
| #tuple #T0 #H1 #Htable0#IH #t1 #t2 #HT cases H1 #qin0 * #cin0 * #qout0 * #cout0 * #mv0
  * * * * * * * * * *
  #Hqin0marks #Hqout0marks #Hqin0bits #Hqout0bits #Hcin0 #Hcout0 #Hmv0 #Hcout0mv0
  #Hlenqin0 #Hlenqout0 #Htuple >Htuple in H1; #H1 
  lapply (ttm_cons … T0 H1 Htable0) #Htable
  cases t1 in HT;
  [ >Htuple normalize in ⊢ (??%%→?);
    >associative_append >associative_append #HT
    cut (qin0 = qin ∧ (〈cin0,false〉 = cin ∧ (qout0 = qout ∧ 
         (〈cout0,false〉 = cout ∧ (〈mv0,false〉 = mv ∧ 〈bar,false〉::T0 = t2)))))
    [ lapply (append_l1_injective … HT) [ >Hlenqin @Hlenqin0 ]
      #Hqin % [ @Hqin ] -Hqin
      lapply (append_l2_injective … HT) [ >Hlenqin @Hlenqin0 ] -HT #HT
      lapply (cons_injective_l ????? HT) #Hcin % [ @Hcin ] -Hcin
      lapply (cons_injective_r ????? HT) -HT #HT 
      lapply (cons_injective_r ????? HT) -HT
      >associative_append >associative_append #HT
      lapply (append_l1_injective … HT) [ >Hlenqout @Hlenqout0 ]
      #Hqout % [ @Hqout ] -Hqout
      lapply (append_l2_injective … HT) [ >Hlenqout @Hlenqout0 ] -HT normalize #HT
      lapply (cons_injective_l ????? HT) #Hcout % [ @Hcout ] -Hcout
      lapply (cons_injective_r ????? HT) -HT #HT 
      lapply (cons_injective_r ????? HT) -HT #HT
      lapply (cons_injective_l ????? HT) #Hmv % [ @Hmv ] -Hmv
      @(cons_injective_r ????? HT) ]
    -HT * #Hqin * #Hcin * #Hqout * #Hcout * #Hmv #HT0
    >(?:qin0@(〈cin0,false〉::〈comma,false〉::qout0@[〈cout0,false〉;〈comma,false〉;〈mv0,false〉])@〈bar,false〉::T0
        = mk_tuple qin cin qout cout mv@〈bar,false〉::T0)
    [|>Hqin >Hqout >Hcin >Hcout >Hmv normalize >associative_append >associative_append
       normalize >associative_append % ]
    % %{qin0} %{cin0} %{qout0} %{cout0} %{mv0} % // % [|@Hlenqout0] % // % 
        [ | @Hcout0mv0 ] % // % // % // % // % // % // %
  | #c0 #cs0 #HT cut (∃cs1.c0::cs0 = tuple@〈bar,false〉::cs1)
    [ cases (append_eq_tech1 ?????? HT ?)
      [ -HT #ta #Hta cases (append_eq_tech2 … Hta ?)
        [ -Hta #tb #Htb %{tb} @Htb 
        | @daemon ]
      | @le_S_S >length_append >(plus_n_O (|tuple|)) >commutative_plus @le_plus
        [ @le_O_n
        | >Htuple normalize >length_append >length_append @le_plus [ >Hlenqin >Hlenqin0 % ]
          @le_S_S @le_S_S >length_append >length_append @le_plus [ >Hlenqout >Hlenqout0 % ] %] ] 
    ]
    * #cs1 #Hcs1 >Hcs1 in HT; >associative_append >associative_append #HT
    lapply (append_l2_injective … HT) // -HT #HT
    lapply (cons_injective_r ????? HT) -HT
    <associative_append #HT >Htuple %2 // @(IH … HT)
  ]
]
qed.

(*
lemma table_invert_l : ∀n,T0,qin,cin,qout,cout,mv.
  table_TM n (mk_tuple qin cin qout cout mv@〈bar,false〉::T0) → 
  tuple_TM n (mk_tuple qin cin qout cout mv).
#n #T #qin #cin #qout #cout #mv #HT inversion HT
[ change with (append ???) in ⊢ (??(??%?)?→?);cases qin [ #Hfalse | #t0 #ts0 #Hfalse] normalize in Hfalse; destruct (Hfalse)
| #t0 #T0 #Ht0 #HT0 #_

  
lemma table_invert_r : ∀n,T0,qin,cin,qout,cout,mv.
  table n (mk_tuple qin cin qout cout mv@〈bar,false〉::T0) → table n T0. 
*)

lemma no_grids_in_tuple : ∀n,l.tuple_TM n l → no_grids l.
#n #l * #qin * #cin * #qout * #cout * #mv * * * * * * * * * *
#_ #_ #Hqin #Hqout #Hcin #Hcout #Hmv #_ #_ #_ #Hl >Hl
#c #Hc normalize in Hc; cases (memb_append … Hc) -Hc #Hc
[ @bit_not_grid @(Hqin … Hc)
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈cin,false〉 = true) in Hc; >(\P Hc) @bit_or_null_not_grid //
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈comma,false〉 = true) in Hc; >(\P Hc) %
| cases (memb_append …Hc) -Hc #Hc
[ @bit_not_grid @(Hqout … Hc)
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈cout,false〉 = true) in Hc; >(\P Hc) @bit_or_null_not_grid //
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈comma,false〉 = true) in Hc; >(\P Hc) %
| >(memb_single … Hc) @bit_or_null_not_grid @Hmv
]]]]]]
qed.

lemma no_marks_in_tuple : ∀n,l.tuple_TM n l → no_marks l.
#n #l * #qin * #cin * #qout * #cout * #mv * * * * * * * * * *
#Hqin #Hqout #_ #_ #_ #_ #_ #_ #_ #_ #Hl >Hl
#c #Hc normalize in Hc; cases (memb_append … Hc) -Hc #Hc
[ @(Hqin … Hc)
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈cin,false〉 = true) in Hc; >(\P Hc) %
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈comma,false〉 = true) in Hc; >(\P Hc) %
| cases (memb_append … Hc) -Hc #Hc
[ @(Hqout … Hc)
| cases (orb_true_l … Hc) -Hc #Hc 
[ change with (c == 〈cout,false〉 = true) in Hc; >(\P Hc) %
| cases (orb_true_l … Hc) -Hc #Hc 

[ change with (c == 〈comma,false〉 = true) in Hc; >(\P Hc) %
| >(memb_single … Hc) %
]]]]]]
qed.

lemma no_grids_in_table: ∀n.∀l.table_TM n l → no_grids l.
#n #l #t elim t   
  [normalize #c #H destruct
  |#t1 #t2 #Ht1 #Ht2 #IH lapply (no_grids_in_tuple … Ht1) -Ht1 #Ht1 #x #Hx
   cases (memb_append … Hx) -Hx #Hx
   [ @(Ht1 … Hx)
   | cases (orb_true_l … Hx) -Hx #Hx
     [ >(\P Hx) %
     | @(IH … Hx) ] ] ]
qed.

lemma no_marks_in_table: ∀n.∀l.table_TM n l → no_marks l.
#n #l #t elim t   
  [normalize #c #H destruct
  |#t1 #t2 #Ht1 #Ht2 #IH lapply (no_marks_in_tuple … Ht1) -Ht1 #Ht1 #x #Hx
   cases (memb_append … Hx) -Hx #Hx
   [ @(Ht1 … Hx)
   | cases (orb_true_l … Hx) -Hx #Hx
     [ >(\P Hx) %
     | @(IH … Hx) ] ] ]
qed.      
          
axiom last_of_table: ∀n,l,b.¬ table_TM n (l@[〈bar,b〉]).
   
(*
l0 x* a l1 x0* a0 l2 ------> l0 x a* l1 x0 a0* l2
   ^                               ^

if current (* x *) = #
   then 
   else if x = 0
      then move_right; ----
           adv_to_mark_r;
           if current (* x0 *) = 0
              then advance_mark ----
                   adv_to_mark_l;
                   advance_mark
              else STOP
      else x = 1 (* analogo *)

*)


(*
   MARK NEXT TUPLE machine
   (partially axiomatized)
   
   marks the first character after the first bar (rightwards)
 *)
 
definition bar_or_grid ≝ λc:STape.is_bar (\fst c) ∨ is_grid (\fst c).

definition mark_next_tuple ≝ 
  seq ? (adv_to_mark_r ? bar_or_grid)
     (ifTM ? (test_char ? (λc:STape.is_bar (\fst c)))
       (move_right_and_mark ?) (nop ?) tc_true).

definition R_mark_next_tuple ≝ 
  λt1,t2.
    ∀ls,c,rs1,rs2.
    (* c non può essere un separatore ... speriamo *)
    t1 = midtape STape ls c (rs1@〈grid,false〉::rs2) → 
    no_marks rs1 → no_grids rs1 → bar_or_grid c = false → 
    (∃rs3,rs4,d,b.rs1 = rs3 @ 〈bar,false〉 :: rs4 ∧
      no_bars rs3 ∧
      Some ? 〈d,b〉 = option_hd ? (rs4@〈grid,false〉::rs2) ∧
      t2 = midtape STape (〈bar,false〉::reverse ? rs3@c::ls) 〈d,true〉 (tail ? (rs4@〈grid,false〉::rs2)))
    ∨
    (no_bars rs1 ∧ t2 = midtape ? (reverse ? rs1@c::ls) 〈grid,false〉 rs2).
     
axiom tech_split :
  ∀A:DeqSet.∀f,l.
   (∀x.memb A x l = true → f x = false) ∨
   (∃l1,c,l2.f c = true ∧ l = l1@c::l2 ∧ ∀x.memb ? x l1 = true → f x = false).
(*#A #f #l elim l
[ % #x normalize #Hfalse *)
     
theorem sem_mark_next_tuple :
  Realize ? mark_next_tuple R_mark_next_tuple.
#intape 
lapply (sem_seq ? (adv_to_mark_r ? bar_or_grid)
         (ifTM ? (test_char ? (λc:STape.is_bar (\fst c))) (move_right_and_mark ?) (nop ?) tc_true) ????)
[@sem_if [5: // |6: @sem_move_right_and_mark |7: // |*:skip]
| //
|||#Hif cases (Hif intape) -Hif
   #j * #outc * #Hloop * #ta * #Hleft #Hright
   @(ex_intro ?? j) @ex_intro [|% [@Hloop] ]
   -Hloop
   #ls #c #rs1 #rs2 #Hrs #Hrs1 #Hrs1' #Hc
   cases (Hleft … Hrs)
   [ * #Hfalse >Hfalse in Hc; #Htf destruct (Htf)
   | * #_ #Hta cases (tech_split STape (λc.is_bar (\fst c)) rs1)
     [ #H1 lapply (Hta rs1 〈grid,false〉 rs2 (refl ??) ? ?)
       [ * #x #b #Hx whd in ⊢ (??%?); >(Hrs1' … Hx) >(H1 … Hx) %
       | %
       | -Hta #Hta cases Hright
         [ * #tb * whd in ⊢ (%→?); #Hcurrent
           @False_ind cases (Hcurrent 〈grid,false〉 ?)
           [ normalize in ⊢ (%→?); #Hfalse destruct (Hfalse)
           | >Hta % ]
         | * #tb * whd in ⊢ (%→?); #Hcurrent
           cases (Hcurrent 〈grid,false〉 ?)
           [  #_ #Htb whd in ⊢ (%→?); #Houtc
             %2 %
             [ @H1
             | >Houtc >Htb >Hta % ]
           | >Hta % ]
         ]
       ]
    | * #rs3 * #c0 * #rs4 * * #Hc0 #Hsplit #Hrs3
      % @(ex_intro ?? rs3) @(ex_intro ?? rs4)
     lapply (Hta rs3 c0 (rs4@〈grid,false〉::rs2) ???)
     [ #x #Hrs3' whd in ⊢ (??%?); >Hsplit in Hrs1;>Hsplit in Hrs3;
       #Hrs3 #Hrs1 >(Hrs1 …) [| @memb_append_l1 @Hrs3'|]
       >(Hrs3 … Hrs3') @Hrs1' >Hsplit @memb_append_l1 //
     | whd in ⊢ (??%?); >Hc0 %
     | >Hsplit >associative_append % ] -Hta #Hta
       cases Hright
       [ * #tb * whd in ⊢ (%→?); #Hta'
         whd in ⊢ (%→?); #Htb
         cases (Hta' c0 ?)
         [ #_ #Htb' >Htb' in Htb; #Htb
           generalize in match Hsplit; -Hsplit
           cases rs4 in Hta;
           [ #Hta #Hsplit >(Htb … Hta)
             >(?:c0 = 〈bar,false〉)
             [ @(ex_intro ?? grid) @(ex_intro ?? false)
               % [ % [ % 
               [(* Hsplit *) @daemon |(*Hrs3*) @daemon ] | % ] | % ] 
               | (* Hc0 *) @daemon ]
           | #r5 #rs5 >(eq_pair_fst_snd … r5)
             #Hta #Hsplit >(Htb … Hta)
             >(?:c0 = 〈bar,false〉)
             [ @(ex_intro ?? (\fst r5)) @(ex_intro ?? (\snd r5))
               % [ % [ % [ (* Hc0, Hsplit *) @daemon | (*Hrs3*) @daemon ] | % ]
                     | % ] | (* Hc0 *) @daemon ] ] | >Hta % ]
             | * #tb * whd in ⊢ (%→?); #Hta'
               whd in ⊢ (%→?); #Htb
               cases (Hta' c0 ?)
               [ #Hfalse @False_ind >Hfalse in Hc0;
                 #Hc0 destruct (Hc0)
               | >Hta % ]
]]]]
qed.

definition init_current_on_match ≝ 
  (seq ? (move_l ?)
    (seq ? (adv_to_mark_l ? (λc:STape.is_grid (\fst c)))
      (seq ? (move_r ?) (mark ?)))).
          
definition R_init_current_on_match ≝ λt1,t2.
  ∀l1,l2,c,rs. no_grids l1 → is_grid c = false → 
  t1 = midtape STape (l1@〈c,false〉::〈grid,false〉::l2)  〈grid,false〉 rs → 
  t2 = midtape STape (〈grid,false〉::l2) 〈c,true〉 ((reverse ? l1)@〈grid,false〉::rs).

lemma sem_init_current_on_match : 
  Realize ? init_current_on_match R_init_current_on_match.
#intape 
cases (sem_seq ????? (sem_move_l ?)
        (sem_seq ????? (sem_adv_to_mark_l ? (λc:STape.is_grid (\fst c)))
           (sem_seq ????? (sem_move_r ?) (sem_mark ?))) intape)
#k * #outc * #Hloop #HR 
@(ex_intro ?? k) @(ex_intro ?? outc) % [@Hloop] -Hloop
#l1 #l2 #c #rs #Hl1 #Hc #Hintape
cases HR -HR #ta * whd in ⊢ (%→?); #Hta lapply (Hta … Hintape) -Hta -Hintape 
generalize in match Hl1; cases l1
  [#Hl1 whd in ⊢ ((???(??%%%))→?); #Hta
   * #tb * whd in ⊢ (%→?); #Htb cases (Htb … Hta) -Hta
    [* >Hc #Htemp destruct (Htemp) ]
   * #_ #Htc lapply (Htc [ ] 〈grid,false〉 ? (refl ??) (refl …) Hl1) 
   whd in ⊢ ((???(??%%%))→?); -Htc #Htc
   * #td * whd in ⊢ (%→?); #Htd lapply (Htd … Htc) -Htc -Htd 
   whd in ⊢ ((???(??%%%))→?); #Htd
   whd in ⊢ (%→?); #Houtc lapply (Houtc … Htd) -Houtc #Houtc
   >Houtc % 
  |#d #tl #Htl whd in ⊢ ((???(??%%%))→?); #Hta
   * #tb * whd in ⊢ (%→?); #Htb cases (Htb … Hta) -Htb
    [* >(Htl … (memb_hd …)) #Htemp destruct (Htemp)]    
   * #Hd >append_cons #Htb lapply (Htb … (refl ??) (refl …) ?)
    [#x #membx cases (memb_append … membx) -membx #membx
      [@Htl @memb_cons @membx | >(memb_single … membx) @Hc]]-Htb  #Htb
   * #tc * whd in ⊢ (%→?); #Htc lapply (Htc … Htb) -Htb -Htc 
   >reverse_append >associative_append whd in ⊢ ((???(??%%%))→?); #Htc
   whd in ⊢ (%→?); #Houtc lapply (Houtc … Htc) -Houtc #Houtc 
   >Houtc >reverse_cons >associative_append % 
  ]
qed.   

(*
definition init_current_gen ≝ 
  seq ? (adv_to_mark_l ? (is_marked ?))
    (seq ? (clear_mark ?)
       (seq ? (move_l ?)
         (seq ? (adv_to_mark_l ? (λc:STape.is_grid (\fst c)))
            (seq ? (move_r ?) (mark ?))))).
          
definition R_init_current_gen ≝ λt1,t2.
  ∀l1,c,l2,b,l3,c1,rs,c0,b0. no_marks l1 → no_grids l2 →
  Some ? 〈c0,b0〉 = option_hd ? (reverse ? (〈c,true〉::l2)) → 
  t1 = midtape STape (l1@〈c,true〉::l2@〈grid,b〉::l3) 〈c1,false〉 rs → 
  t2 = midtape STape (〈grid,b〉::l3) 〈c0,true〉
        ((tail ? (reverse ? (l1@〈c,false〉::l2))@〈c1,false〉::rs)).

lemma sem_init_current_gen : Realize ? init_current_gen R_init_current_gen.
#intape 
cases (sem_seq ????? (sem_adv_to_mark_l ? (is_marked ?))
        (sem_seq ????? (sem_clear_mark ?)
          (sem_seq ????? (sem_move_l ?)
            (sem_seq ????? (sem_adv_to_mark_l ? (λc:STape.is_grid (\fst c)))
              (sem_seq ????? (sem_move_r ?) (sem_mark ?))))) intape)
#k * #outc * #Hloop #HR 
@(ex_intro ?? k) @(ex_intro ?? outc) % [@Hloop] -Hloop
#l1 #c #l2 #b #l3 #c1 #rs #c0 #b0 #Hl1 #Hl2 #Hc #Hintape
cases HR -HR #ta * whd in ⊢ (%→?); #Hta cases (Hta … Hintape) -Hta -Hintape
  [ * #Hfalse normalize in Hfalse; destruct (Hfalse) ]
* #_ #Hta lapply (Hta l1 〈c,true〉 ? (refl ??) ??) [@Hl1|%] -Hta #Hta
* #tb * whd in ⊢ (%→?); #Htb lapply (Htb … Hta) -Htb -Hta #Htb 
* #tc * whd in ⊢ (%→?); #Htc lapply (Htc … Htb) -Htc -Htb 
generalize in match Hc; generalize in match Hl2; cases l2
  [#_ whd in ⊢ ((???%)→?); #Htemp destruct (Htemp) 
   whd in ⊢ ((???(??%%%))→?); #Htc
   * #td * whd in ⊢ (%→?); #Htd cases (Htd … Htc) -Htd
    [2: * whd in ⊢ (??%?→?); #Htemp destruct (Htemp) ]
   * #_ #Htd >Htd in Htc; -Htd #Htd
   * #te * whd in ⊢ (%→?); #Hte lapply (Hte … Htd) -Htd
   >reverse_append >reverse_cons 
   whd in ⊢ ((???(??%%%))→?); #Hte
   whd in ⊢ (%→?); #Houtc lapply (Houtc … Hte) -Houtc -Hte #Houtc
   >Houtc %
  |#d #tl #Htl #Hc0 whd in ⊢ ((???(??%%%))→?); #Htc
   * #td * whd in ⊢ (%→?); #Htd cases (Htd … Htc) -Htd
    [* >(Htl … (memb_hd …)) whd in ⊢ (??%?→?); #Htemp destruct (Htemp)]    
   * #Hd #Htd lapply (Htd … (refl ??) (refl ??) ?)
    [#x #membx @Htl @memb_cons @membx] -Htd #Htd
   * #te * whd in ⊢ (%→?); #Hte lapply (Hte … Htd) -Htd
   >reverse_append >reverse_cons >reverse_cons
   >reverse_cons in Hc0; >reverse_cons cases (reverse ? tl)
     [normalize in ⊢ (%→?); #Hc0 destruct (Hc0) #Hte 
      whd in ⊢ (%→?); #Houtc lapply (Houtc … Hte) -Houtc -Hte #Houtc
      >Houtc %
     |* #c2 #b2 #tl2 normalize in ⊢ (%→?); #Hc0 destruct (Hc0)  
      whd in ⊢ ((???(??%%%))→?); #Hte 
      whd in ⊢ (%→?); #Houtc lapply (Houtc … Hte) -Houtc -Hte #Houtc
      >Houtc >associative_append >associative_append >associative_append %
     ]
   ]
qed.
*)

definition init_current ≝ 
  seq ? (adv_to_mark_l ? (is_marked ?))
    (seq ? (clear_mark ?)
       (seq ? (adv_to_mark_l ? (λc:STape.is_grid (\fst c)))
          (seq ? (move_r ?) (mark ?)))).
          
definition R_init_current ≝ λt1,t2.
  ∀l1,c,l2,b,l3,c1,rs,c0,b0. no_marks l1 → no_grids l2 → is_grid c = false → 
  Some ? 〈c0,b0〉 = option_hd ? (reverse ? (〈c,true〉::l2)) → 
  t1 = midtape STape (l1@〈c,true〉::l2@〈grid,b〉::l3) 〈c1,false〉 rs → 
  t2 = midtape STape (〈grid,b〉::l3) 〈c0,true〉
        ((tail ? (reverse ? (l1@〈c,false〉::l2))@〈c1,false〉::rs)).

lemma sem_init_current : Realize ? init_current R_init_current.
#intape 
cases (sem_seq ????? (sem_adv_to_mark_l ? (is_marked ?))
        (sem_seq ????? (sem_clear_mark ?)
           (sem_seq ????? (sem_adv_to_mark_l ? (λc:STape.is_grid (\fst c)))
             (sem_seq ????? (sem_move_r ?) (sem_mark ?)))) intape)
#k * #outc * #Hloop #HR 
@(ex_intro ?? k) @(ex_intro ?? outc) % [@Hloop]
cases HR -HR #ta * whd in ⊢ (%→?); #Hta 
* #tb * whd in ⊢ (%→?); #Htb 
* #tc * whd in ⊢ (%→?); #Htc 
* #td * whd in ⊢ (%→%→?); #Htd #Houtc
#l1 #c #l2 #b #l3 #c1 #rs #c0 #b0 #Hl1 #Hl2 #Hc #Hc0 #Hintape
cases (Hta … Hintape) [ * #Hfalse normalize in Hfalse; destruct (Hfalse) ]
-Hta * #_ #Hta lapply (Hta l1 〈c,true〉 ? (refl ??) ??) [@Hl1|%]
-Hta #Hta lapply (Htb … Hta) -Htb #Htb cases (Htc … Htb) [ >Hc -Hc * #Hc destruct (Hc) ] 
-Htc * #_ #Htc lapply (Htc … (refl ??) (refl ??) ?) [@Hl2]
-Htc #Htc lapply (Htd … Htc) -Htd
>reverse_append >reverse_cons 
>reverse_cons in Hc0; cases (reverse … l2)
[ normalize in ⊢ (%→?); #Hc0 destruct (Hc0)
  #Htd >(Houtc … Htd) %
| * #c2 #b2 #tl2 normalize in ⊢ (%→?);
  #Hc0 #Htd >(Houtc … Htd)
  whd in ⊢ (???%); destruct (Hc0)
  >associative_append >associative_append %
]
qed.

definition match_tuple_step ≝ 
  ifTM ? (test_char ? (λc:STape.¬ is_grid (\fst c))) 
   (single_finalTM ? 
     (seq ? compare
      (ifTM ? (test_char ? (λc:STape.is_grid (\fst c)))
        (nop ?)
        (seq ? mark_next_tuple 
           (ifTM ? (test_char ? (λc:STape.is_grid (\fst c)))
             (mark ?) (seq ? (move_l ?) init_current) tc_true)) tc_true)))
    (nop ?) tc_true.

definition R_match_tuple_step_true ≝ λt1,t2.
  ∀ls,cur,rs.t1 = midtape STape ls cur rs → 
  \fst cur ≠ grid ∧ 
  (∀ls0,c,l1,l2,c1,l3,l4,rs0,n.
   only_bits_or_nulls l1 → no_marks l1 (* → no_grids l2 *) → 
   bit_or_null c = true → bit_or_null c1 = true →
   only_bits_or_nulls l3 → S n = |l1| → |l1| = |l3| →
   table_TM (S n) (l2@〈c1,false〉::l3@〈comma,false〉::l4) → 
   ls = 〈grid,false〉::ls0 → cur = 〈c,true〉 → 
   rs = l1@〈grid,false〉::l2@〈c1,true〉::l3@〈comma,false〉::l4@〈grid,false〉::rs0 → 
   (* facciamo match *)
   (〈c,false〉::l1 = 〈c1,false〉::l3 ∧
   t2 = midtape ? (reverse ? l1@〈c,false〉::〈grid,false〉::ls0) 〈grid,false〉
         (l2@〈c1,false〉::l3@〈comma,true〉::l4@〈grid,false〉::rs0))
   ∨
   (* non facciamo match e marchiamo la prossima tupla *)
   (〈c,false〉::l1 ≠ 〈c1,false〉::l3 ∧
    ∃c2,l5,l6.l4 = l5@〈bar,false〉::〈c2,false〉::l6 ∧
    (* condizioni su l5 l6 l7 *)
    t2 = midtape STape (〈grid,false〉::ls0) 〈c,true〉 
          (l1@〈grid,false〉::l2@〈c1,false〉::l3@〈comma,false〉::
           l5@〈bar,false〉::〈c2,true〉::l6@〈grid,false〉::rs0))
   ∨  
   (* non facciamo match e non c'è una prossima tupla:
      non specifichiamo condizioni sul nastro di output, perché
      non eseguiremo altre operazioni, quindi il suo formato non ci interessa *)
   (〈c,false〉::l1 ≠ 〈c1,false〉::l3 ∧ no_bars l4 ∧ current ? t2 = Some ? 〈grid,true〉)).  
  
definition R_match_tuple_step_false ≝ λt1,t2.
  ∀ls,c,rs.t1 = midtape STape ls c rs → is_grid (\fst c) = true ∧ t2 = t1.
  
include alias "basics/logic.ma". 

(*
lemma eq_f4: ∀A1,A2,A3,A4,B.∀f:A1 → A2 →A3 →A4 →B.
  ∀x1,x2,x3,x4,y1,y2,y3,y4. x1 = y1 → x2 = y2 →x3=y3 →x4 = y4 →   
    f x1 x2 x3 x4 = f y1 y2 y3 y4.
//
qed-. *)

lemma some_option_hd: ∀A.∀l:list A.∀a.∃b.
  Some ? b = option_hd ? (l@[a]) .
#A #l #a cases l normalize /2/
qed.

axiom tech_split2 : ∀A,l1,l2,l3,l4,x. 
  memb A x l1 = false → memb ? x l3 = false → 
  l1@x::l2 = l3@x::l4 → l1 = l3 ∧ l2 = l4.
  
axiom injective_append : ∀A,l.injective … (λx.append A x l).

lemma sem_match_tuple_step: 
    accRealize ? match_tuple_step (inr … (inl … (inr … start_nop))) 
    R_match_tuple_step_true R_match_tuple_step_false.
@(acc_sem_if_app … (sem_test_char ? (λc:STape.¬ is_grid (\fst c))) …
  (sem_seq … sem_compare
    (sem_if … (sem_test_char ? (λc:STape.is_grid (\fst c)))
      (sem_nop …)
        (sem_seq … sem_mark_next_tuple 
           (sem_if … (sem_test_char ? (λc:STape.is_grid (\fst c)))
             (sem_mark ?) (sem_seq … (sem_move_l …) (sem_init_current …))))))
  (sem_nop ?) …)
[(* is_grid: termination case *)
 2:#t1 #t2 #t3 whd in ⊢ (%→?); #H #H1 whd #ls #c #rs #Ht1
  cases (H c ?) [2: >Ht1 %] #Hgrid #Heq %
    [@injective_notb @Hgrid | <Heq @H1]
|#tapea #tapeout #tapeb whd in ⊢ (%→?); #Hcur
 * #tapec * whd in ⊢ (%→?); #Hcompare #Hor 
 #ls #cur #rs #Htapea >Htapea in Hcur; #Hcur cases (Hcur ? (refl ??)) 
 -Hcur #Hcur #Htapeb %
 [ % #Hfalse >Hfalse in Hcur; normalize #Hfalse1 destruct (Hfalse1)]
 #ls0 #c #l1 #l2 #c1 #l3 #l4 #rs0 #n #Hl1bitnull #Hl1marks #Hc #Hc1 #Hl3 #eqn
 #eqlen #Htable #Hls #Hcur #Hrs -Htapea >Hls in Htapeb; >Hcur >Hrs #Htapeb
 cases (Hcompare … Htapeb) -Hcompare -Htapeb * #_ #_ #Hcompare
 cases (Hcompare c c1 l1 l3 l2 (l4@〈grid,false〉::rs0) eqlen Hl1bitnull Hl3 Hl1marks … (refl …) Hc ?)  
 -Hcompare 
   [* #Htemp destruct (Htemp) #Htapec %1 % % [%]
    >Htapec in Hor; -Htapec *
     [2: * #t3 * whd in ⊢ (%→?); #H @False_ind
      cases (H … (refl …)) whd in ⊢ ((??%?)→?); #H destruct (H)
     |* #taped * whd in ⊢ (%→?); #Htaped cases (Htaped ? (refl …)) -Htaped *
      #Htaped whd in ⊢ (%→?); #Htapeout >Htapeout >Htaped
      %
     ]
   |* #la * #c' * #d' * #lb * #lc * * * #H1 #H2 #H3 #Htapec 
    cut (〈c,false〉::l1 ≠ 〈c1,false〉::l3) 
      [>H2 >H3 elim la
        [@(not_to_not …H1) normalize #H destruct % 
        |#x #tl @not_to_not normalize #H destruct // 
        ]
      ] #Hnoteq
    cut (bit_or_null d' = true) 
      [cases la in H3;
        [normalize in ⊢ (%→?); #H destruct //
        |#x #tl #H @(Hl3 〈d',false〉)
         normalize in H; destruct @memb_append_l2 @memb_hd
        ] 
      ] #Hd'
    >Htapec in Hor; -Htapec *
     [* #taped * whd in ⊢ (%→?); #H @False_ind
      cases (H … (refl …)) >(bit_or_null_not_grid ? Hd') #Htemp destruct (Htemp)
     |* #taped * whd in ⊢ (%→?); #H cases (H … (refl …)) -H #_
      #Htaped * #tapee * whd in ⊢ (%→?); #Htapee  
      <(associative_append ? lc (〈comma,false〉::l4)) in Htaped; #Htaped
      cases (Htapee … Htaped ???) -Htaped -Htapee 
       [* #rs3 * * (* we proceed by cases on rs4 *) 
         [(* rs4 is empty : the case is absurd since the tape
            cannot end with a bar *)
          * #d * #b * * * #Heq1 @False_ind 
          cut (∀A,l1,l2.∀a:A. a::l1@l2=(a::l1)@l2) [//] #Hcut 
          >Hcut in Htable; >H3 >associative_append
          normalize >Heq1 <associative_append >Hcut
          <associative_append #Htable @(absurd … Htable) 
          @last_of_table
         |(* rs4 not empty *)
          * #d2 #b2 #rs3' * #d  * #b * * * #Heq1 #Hnobars
          cut (memb STape 〈d2,b2〉 (l2@〈c1,false〉::l3@〈comma,false〉::l4) = true)
            [@memb_append_l2
             cut (∀A,l1,l2.∀a:A. a::l1@l2=(a::l1)@l2) [//] #Hcut
             >Hcut >H3 >associative_append @memb_append_l2 
             @memb_cons >Heq1 @memb_append_l2 @memb_cons @memb_hd] #d2intable
          cut (is_grid d2 = false) 
            [@(no_grids_in_table … Htable … 〈d2,b2〉 d2intable)] #Hd2
          cut (b2 = false) 
            [@(no_marks_in_table … Htable … 〈d2,b2〉 d2intable)] #Hb2 
          >Hb2 in Heq1; #Heq1 -Hb2 -b2
          whd in ⊢ ((???%)→?); #Htemp destruct (Htemp) #Htapee >Htapee -Htapee *
           [(* we know current is not grid *)
            * #tapef * whd in ⊢ (%→?); #Htapef 
            cases (Htapef … (refl …)) >Hd2 #Htemp destruct (Htemp) 
           |* #tapef * whd in ⊢ (%→?); #Htapef 
            cases (Htapef … (refl …)) #_ -Htapef #Htapef
            * #tapeg >Htapef -Htapef * 
            (* move_l *)
            whd in ⊢ (%→?); 
            #H lapply (H … (refl …)) whd in ⊢ (???%→?); -H  #Htapeg
            >Htapeg -Htapeg
            (* init_current *)
             whd in ⊢ (%→?); #Htapeout
             cases (some_option_hd ? (reverse ? (reverse ? la)) 〈c',true〉)
             * #c00 #b00 #Hoption
             lapply 
              (Htapeout (reverse ? rs3 @〈d',false〉::reverse ? la@reverse ? l2@(〈grid,false〉::reverse ? lb))
              c' (reverse ? la) false ls0 bar (〈d2,true〉::rs3'@〈grid,false〉::rs0) c00 b00 ?????) -Htapeout
               [whd in ⊢ (??(??%??)?); @eq_f3 [2:%|3: %]
                >associative_append 
                 generalize in match (〈c',true〉::reverse ? la@〈grid,false〉::ls0); #l
                whd in ⊢ (???(???%)); >associative_append >associative_append % 
               |>reverse_cons @Hoption
               |cases la in H2; 
                 [normalize in ⊢ (%→?); #Htemp destruct (Htemp) 
                  @bit_or_null_not_grid @Hc
                 |#x #tl normalize in ⊢ (%→?); #Htemp destruct (Htemp)
                  @bit_or_null_not_grid @(Hl1bitnull 〈c',false〉) @memb_append_l2 @memb_hd
                 ]
               |cut (only_bits_or_nulls (la@(〈c',false〉::lb)))
                 [<H2 whd #c0 #Hmemb cases (orb_true_l … Hmemb)
                   [#eqc0 >(\P eqc0) @Hc |@Hl1bitnull]
                 |#Hl1' #x #Hx @bit_or_null_not_grid @Hl1'
                  @memb_append_l1 @daemon
                 ]
               |@daemon] #Htapeout % %2 % //
            @(ex_intro … d2)
            cut (∃rs32.rs3 = lc@〈comma,false〉::rs32) 
                 [ (*cases (tech_split STape (λc.c == 〈bar,false〉) l4)
                  [
                  | * #l41 * * #cbar #bfalse * #l42 * * #Hbar #Hl4 #Hl41
                    @(ex_intro ?? l41) >Hl4 in Heq1; #Heq1
                
                cut (sublist … lc l3)
                  [ #x #Hx cases la in H3;
                    [ normalize #H3 destruct (H3) @Hx
                    | #p #la' normalize #Hla' destruct (Hla')
                      @memb_append_l2 @memb_cons @Hx ] ] #Hsublist*)
                @daemon]
                * #rs32 #Hrs3
                (* cut 
                (〈c1,false〉::l3@〈comma,false〉::l4= la@〈d',false〉::rs3@〈bar,false〉::〈d2,b2〉::rs3')
                [@daemon] #Hcut *)
                cut (l4=rs32@〈bar,false〉::〈d2,false〉::rs3')
                [ >Hrs3 in Heq1; @daemon ] #Hl4
                @(ex_intro … rs32) @(ex_intro … rs3') % [@Hl4]
                >Htapeout @eq_f2
                   [@daemon
                   |(*>Hrs3 *)>append_cons
                    > (?:l1@〈grid,false〉::l2@〈c1,false〉::l3@〈comma,false〉::rs32@〈bar,false〉::〈d2,true〉::rs3'@〈grid,false〉::rs
                        = (l1@〈grid,false〉::l2@〈c1,false〉::l3@〈comma,false〉::rs32@[〈bar,false〉])@〈d2,true〉::rs3'@〈grid,false〉::rs)
                    [|>associative_append normalize 
                      >associative_append normalize
                      >associative_append normalize
                      >associative_append normalize
                       % ]
                    >reverse_append >reverse_append >reverse_cons
                    >reverse_reverse >reverse_cons >reverse_reverse
                    >reverse_append >reverse_append >reverse_cons
                    >reverse_reverse >reverse_reverse >reverse_reverse
                    >(?:(la@[〈c',false〉])@((((lb@[〈grid,false〉])@l2)@la)@[〈d',false〉])@rs3
                       =((la@〈c',false〉::lb)@([〈grid,false〉]@l2@la@[〈d',false〉]@rs3)))
                    [|>associative_append >associative_append 
                      >associative_append >associative_append >associative_append
                      >associative_append % ]
                    <H2 normalize in ⊢ (??%?); >Hrs3
                    >associative_append >associative_append normalize
                    >associative_append >associative_append
                    @eq_f @eq_f @eq_f
                    >(?:la@(〈d',false〉::lc@〈comma,false〉::rs32)@〈bar,false〉::〈d2,true〉::rs3'@〈grid,false〉::rs0 = 
                        (la@〈d',false〉::lc)@〈comma,false〉::rs32@〈bar,false〉::〈d2,true〉::rs3'@〈grid,false〉::rs0 )
                    [| >associative_append normalize >associative_append % ]
                    <H3 %
                   ]
                 ]
              ]
       |* #Hnobars #Htapee >Htapee -Htapee *
         [whd in ⊢ (%→?); * #tapef * whd in ⊢ (%→?); #Htapef
          cases (Htapef … (refl …)) -Htapef #_ #Htapef >Htapef -Htapef
          whd in ⊢ (%→?); #Htapeout %2 % 
          [% [//] whd #x #Hx @Hnobars @memb_append_l2 @memb_cons //
          | >(Htapeout … (refl …)) % ]
         |whd in ⊢ (%→?); * #tapef * whd in ⊢ (%→?); #Htapef
          cases (Htapef … (refl …)) -Htapef 
          whd in ⊢ ((??%?)→?); #Htemp destruct (Htemp) 
         ]
       |(* no marks in table *)
        #x #membx @(no_marks_in_table … Htable) 
        @memb_append_l2
        cut (∀A,l1,l2.∀a:A. a::l1@l2=(a::l1)@l2) [//] #Hcut >Hcut
        >H3 >associative_append @memb_append_l2 @memb_cons @membx
       |(* no grids in table *)
        #x #membx @(no_grids_in_table … Htable) 
        @memb_append_l2
        cut (∀A,l1,l2.∀a:A. a::l1@l2=(a::l1)@l2) [//] #Hcut >Hcut
        >H3 >associative_append @memb_append_l2 @memb_cons @membx
       |whd in ⊢ (??%?); >(bit_or_null_not_grid … Hd') >(bit_or_null_not_bar … Hd') %
       ]
     ]
   |#x #membx @(no_marks_in_table … Htable) 
    @memb_append_l2 @memb_cons @memb_append_l1 @membx 
   |#x #membx @(no_marks_in_table … Htable) 
    @memb_append_l1 @membx
   |%
   ]
 ]
qed.

(* 
  MATCH TUPLE

  scrolls through the tuples in the transition table until one matching the
  current configuration is found
*)

definition match_tuple ≝  whileTM ? match_tuple_step (inr … (inl … (inr … start_nop))).

lemma is_grid_true : ∀c.is_grid c = true → c = grid.
* normalize [ #b ] #H // destruct (H)
qed.

definition R_match_tuple ≝ λt1,t2.
  ∀ls,c,l1,c1,l2,rs,n.
  is_bit c = true → only_bits l1 → is_bit c1 = true → n = |l1| →
  table_TM (S n) (〈c1,true〉::l2) → 
  t1 = midtape STape (〈grid,false〉::ls) 〈c,true〉 
         (l1@〈grid,false〉::〈c1,true〉::l2@〈grid,false〉::rs) → 
  (* facciamo match *)
  (∃l3,newc,mv,l4.
   〈c1,false〉::l2 = l3@〈c,false〉::l1@〈comma,false〉::newc@〈comma,false〉::mv@l4 ∧
   t2 = midtape ? (reverse ? l1@〈c,false〉::〈grid,false〉::ls) 〈grid,false〉
        (l3@〈c,false〉::l1@〈comma,true〉::newc@〈comma,false〉::mv@l4@〈grid,false〉::rs))
  ∨
  (* non facciamo match su nessuna tupla;
     non specifichiamo condizioni sul nastro di output, perché
     non eseguiremo altre operazioni, quindi il suo formato non ci interessa *)
  (current ? t2 = Some ? 〈grid,true〉 ∧
   ∀l3,newc,mv,l4.
   〈c1,false〉::l2 ≠ l3@〈c,false〉::l1@〈comma,false〉::newc@〈comma,false〉::mv@l4). 

definition weakR_match_tuple ≝ λt1,t2.
  ∀ls,cur,rs.
  t1 = midtape STape ls cur rs → 
  (is_grid (\fst cur) = true → t2 = t1) ∧
  (∀c,l1,c1,l2,l3,ls0,rs0,n.
  ls = 〈grid,false〉::ls0 → 
  cur = 〈c,true〉 → 
  rs = l1@〈grid,false〉::l2@〈c1,true〉::l3@〈grid,false〉::rs0 → 
  is_bit c = true → is_bit c1 = true → 
  only_bits_or_nulls l1 → no_marks l1 → S n = |l1| →
  table_TM (S n) (l2@〈c1,false〉::l3) → 
  (* facciamo match *)
  (∃l4,newc,mv,l5.
   〈c1,false〉::l3 = l4@〈c,false〉::l1@〈comma,false〉::newc@〈comma,false〉::mv::l5 ∧
   t2 = midtape ? (reverse ? l1@〈c,false〉::〈grid,false〉::ls0) 〈grid,false〉
        (l2@l4@〈c,false〉::l1@〈comma,true〉::newc@〈comma,false〉::mv::l5@
        〈grid,false〉::rs0))
  ∨
  (* non facciamo match su nessuna tupla;
     non specifichiamo condizioni sul nastro di output, perché
     non eseguiremo altre operazioni, quindi il suo formato non ci interessa *)
  (current ? t2 = Some ? 〈grid,true〉 ∧
   ∀l4,newc,mv,l5.
   〈c1,false〉::l3 ≠ l4@〈c,false〉::l1@〈comma,false〉::newc@〈comma,false〉::mv::l5)).  

axiom table_bit_after_bar : 
  ∀n,l1,c,l2.table_TM n (l1@〈bar,false〉::〈c,false〉::l2) → is_bit c = true.

lemma wsem_match_tuple : WRealize ? match_tuple weakR_match_tuple.
#intape #k #outc #Hloop 
lapply (sem_while … sem_match_tuple_step intape k outc Hloop) [%] -Hloop
* #ta * #Hstar @(star_ind_l ??????? Hstar)
[ #tb whd in ⊢ (%→?); #Hleft
  #ls #cur #rs #Htb cases (Hleft … Htb) #Hgrid #Houtc %
  [ #_ @Houtc 
  | #c #l1 #c1 #l2 #l3 #ls0 #rs0 #n #Hls #Hcur #Hrs 
    >Hcur in Hgrid; #Hgrid >(is_grid_true … Hgrid) normalize in ⊢ (%→?);
    #Hc destruct (Hc)
    
  ]
| #tb #tc #td whd in ⊢ (%→?); #Htc
  #Hstar1 #IH whd in ⊢ (%→?); #Hright lapply (IH Hright) -IH whd in ⊢ (%→?); #IH
  #ls #cur #rs #Htb %
  [ #Hcur cases (Htc … Htb) * #Hfalse @False_ind @Hfalse @(is_grid_true … Hcur)
  |#c #l1 #c1 #l2 #l3 #ls0 #rs0 #n #Hls #Hcur #Hrs #Hc #Hc1 #Hl1bitnull #Hl1marks 
   #Hl1len #Htable cases (Htc … Htb) -Htc -Htb * #_ #Htc
   cut (∃la,lb,mv,lc.l3 = la@〈comma,false〉::lb@〈comma,false〉::mv::lc ∧
         S n = |la| ∧ only_bits_or_nulls la)
   [@daemon] * #la * #lb * #mv * #lc * * #Hl3 #Hlalen #Hlabitnull
   >Hl3 in Htable;
  >(?: 〈c1,true〉::(la@〈comma,false〉::lb@〈comma,false〉::mv::lc)@〈grid,false〉::rs =
       〈c1,true〉::la@〈comma,false〉::(lb@〈comma,false〉::mv::lc)@〈grid,false〉::rs)
  [#Htable cases (Htc ?? l1 l2 ??? rs0 ???????? Htable Hls Hcur ?)
   [10: >Hrs >Hl3 >associative_append >associative_append
    normalize >associative_append % ] //
   [3: whd in ⊢ (??%?); >Hc %
   |4: whd in ⊢ (??%?); >Hc1 %
   |5: @Hl1len
   |6: <Hl1len @Hlalen
   | * 
     [ * #Heq #Htc % %{[]} %{lb} %{mv} %{lc}
       destruct (Heq) %
       [ %
       | cases (IH … Htc) #Houtc #_ >(Houtc (refl ??)) -Houtc
         >Htc @eq_f normalize >associative_append %
       ]
     | * #Hdiff * #c2 * #l5 * #l6 * #Hnext #Htc
       cases (IH … Htc) -IH #_ #IH >Hnext in Htable;
       >(?:l2@〈c1,false〉::la@〈comma,false〉::l5@〈bar,false〉::〈c2,false〉::l6 =
          (l2@〈c1,false〉::la@〈comma,false〉::l5@[〈bar,false〉])@〈c2,false〉::l6)
       [|@daemon] #Htable
       cases (IH ? l1 ? (l2@〈c1,false〉::la@〈comma,false〉::l5@[〈bar,false〉]) l6 ? rs0 ?
                (refl ??) (refl ??) … Htable) //
       [3: >associative_append normalize >associative_append 
           normalize >associative_append %
       |4: @(table_bit_after_bar (S n) (l2@〈c1,false〉::la@〈comma,false〉::l5) ? l6)
           >associative_append in Htable; normalize >associative_append normalize
           >associative_append normalize >associative_append normalize
           >associative_append normalize //
       | * #l4 * #newc * #mv0 * #l50 * #Heq #Houtc %
         @(ex_intro ?? (〈c1,false〉::la@〈comma,false〉::l5@〈bar,false〉::l4))
         @(ex_intro ?? newc) @(ex_intro ?? mv0) @(ex_intro ?? l50) >Heq %
         [ normalize >associative_append normalize >associative_append %
         | >Houtc @eq_f normalize >associative_append normalize >associative_append
           normalize >associative_append normalize >associative_append
           normalize >associative_append %
         ]
       | * #Houtc #Hneq %2 % [@Houtc]
         #l4 #newc #mv0 #l50
         (* difficile (sempre che sia dimostrabile) 
            dobbiamo veramente considerare di fare la table in modo più 
            strutturato
         *)
         @daemon
       ]
     ]
   | * * #Hdiff #Hnobars generalize in match (refl ? tc);
     cases tc in ⊢ (???% → %);
     [ #_ normalize in ⊢ (??%?→?); #Hfalse destruct (Hfalse)
     |2,3: #x #xs #_ normalize in ⊢ (??%?→?); #Hfalse destruct (Hfalse) ]
     #ls1 #cur1 #rs1 #Htc normalize in ⊢ (??%?→?); #Hcur1
     cases (IH … Htc) -IH #IH #_ %2 %
     [ destruct (Hcur1) >IH [ >Htc % | % ]
     | (* difficile (sempre che sia dimostrabile) 
          dobbiamo veramente considerare di fare la table in modo più 
          strutturato
        *)
        @daemon
     ]
   ]
| >associative_append %
]
qed.

