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

include "turing/universal/tuples.ma".

definition write_states ≝ initN 2.

definition write ≝ λalpha,c.
  mk_TM alpha write_states
  (λp.let 〈q,a〉 ≝ p in
    match q with 
    [ O ⇒ 〈1,Some ? 〈c,N〉〉
    | S _ ⇒ 〈1,None ?〉 ])
  O (λx.x == 1).
  
definition R_write ≝ λalpha,c,t1,t2.
  ∀ls,x,rs.t1 = midtape alpha ls x rs → t2 = midtape alpha ls c rs.
  
axiom sem_write : ∀alpha,c.Realize ? (write alpha c) (R_write alpha c).

definition copy_step_subcase ≝
  λalpha,c,elseM.ifTM ? (test_char ? (λx.x == 〈c,true〉))
    (seq (FinProd alpha FinBool) (adv_mark_r …)
      (seq ? (move_l …)
        (seq ? (adv_to_mark_l … (is_marked alpha))
          (seq ? (write ? 〈c,false〉)
            (seq ? (move_r …)
              (seq ? (mark …)
                (seq ? (move_r …) (adv_to_mark_r … (is_marked alpha)))))))))
    elseM tc_true.

definition R_copy_step_subcase ≝ 
  λalpha,c,RelseM,t1,t2.
    ∀a,l1,x0,a0,l2,x,l3.
    t1 = midtape (FinProd … alpha FinBool) (l1@〈a0,false〉::〈x0,true〉::l2) 
         〈x,true〉 (〈a,false〉::l3) → 
    (∀c.memb ? c l1 = true → is_marked ? c = false) →          
    (x = c ∧ t2 = midtape ? (〈x,false〉::l1@〈a0,true〉::〈x,false〉::l2) 〈a,true〉 l3) ∨
    (x ≠ c ∧ RelseM t1 t2).
    
axiom sem_copy_step_subcase : 
  ∀alpha,c,elseM,RelseM.
  Realize ? (copy_step_subcase alpha c elseM) (R_copy_step_subcase alpha c RelseM).
    
(*
if current = 0,tt
   then advance_mark_r;
        move_l;
        advance_to_mark_l;
        write(0,ff)
        move_r;
        mark;
        move_r;
        advance_to_mark_r;
else if current = 1,tt
   then advance_mark_r;
        move_l;
        advance_to_mark_l;
        write(1,ff)
        move_r;
        mark;
        move_r;
        advance_to_mark_r;
else if current = null 
   then advance_mark_r;
        move_l;
        advance_to_mark_l
        adv_mark_r;
        move_r;
        advance_to_mark_r
*)

definition nocopy_subcase ≝
  ifTM STape (test_char ? (λx:STape.x == 〈null,true〉))
    (seq ? (adv_mark_r …)
      (seq ? (move_l …)
        (seq ? (adv_to_mark_l … (is_marked ?))
          (seq ? (adv_mark_r …)
            (seq ? (move_r …) (adv_to_mark_r … (is_marked ?)))))))
    (nop ?) tc_true.

definition R_nocopy_subcase ≝ 
  λt1,t2.
    ∀a,l1,x0,a0,l2,x,l3.
    t1 = midtape STape (l1@〈a0,false〉::〈x0,true〉::l2) 
         〈x,true〉 (〈a,false〉::l3) → 
    (∀c.memb ? c l1 = true → is_marked ? c = false) →          
    (x = null ∧
     t2 = midtape ? (〈x,false〉::l1@〈a0,true〉::〈x0,false〉::l2) 〈a,true〉 l3) ∨
    (x ≠ null ∧ t2 = t1).
    
axiom sem_nocopy_subcase : Realize ? nocopy_subcase R_nocopy_subcase.
(* #intape
cases (sem_if ? (test_char ? (λx:STape.x == 〈null,true〉)) ?????? tc_true
 (sem_test_char ? (λx:STape.x == 〈null,true〉))
        (sem_seq … (sem_adv_mark_r …)
           (sem_seq … (sem_move_l …)
             (sem_seq … (sem_adv_to_mark_l … (is_marked ?))
               (sem_seq … (sem_adv_mark_r …)
                 (sem_seq … (sem_move_r …) (sem_adv_to_mark_r … (is_marked ?))
                 ))))) (sem_nop ?) intape)
#k * #outc * #Hloop #HR @(ex_intro ?? k) @(ex_intro ?? outc)  % [@Hloop] -Hloop
cases HR -HR
[| * #ta * whd in ⊢ (%→%→?); #Hta #Houtc
   #ls #x #rs #Hintape %2  >Hintape in Hta; #Hta cases (Hta ? (refl ??)) -Hta #Hx #Hta %
   [ lapply (\Pf Hx) @not_to_not #Hx' >Hx' %
   | <Hta @Houtc ] ]
@daemon
qed. *)

definition copy_step ≝
  ifTM ? (test_char STape (λc.is_bit (\fst c)))
  (single_finalTM ? (copy_step_subcase FSUnialpha (bit false)
    (copy_step_subcase FSUnialpha (bit true) nocopy_subcase)))
  (nop ?)
  tc_true.
  
definition R_copy_step_true ≝ 
  λt1,t2.
    ∀ls,c,rs. t1 = midtape STape ls 〈c,true〉 rs → 
    bit_or_null c = true ∧
    (∀a,l1,x0,a0,l2,l3.
     ls = (l1@〈a0,false〉::〈x0,true〉::l2) → 
     rs = (〈a,false〉::l3) → 
     no_marks l1 →          
     ((∃x. c = bit x ∧
      t2 = midtape STape (〈bit x,false〉::l1@〈a0,true〉::〈bit x,false〉::l2) 〈a,true〉 l3) ∨
      (c = null ∧
      t2 = midtape ? (〈null,false〉::l1@〈a0,true〉::〈x0,false〉::l2) 〈a,true〉 l3))).
     
definition R_copy_step_false ≝ 
  λt1,t2.
   ∀ls,c,rs.t1 = midtape (FinProd … FSUnialpha FinBool) ls c rs → 
   bit_or_null (\fst c) = false ∧ t2 = t1.

axiom sem_copy_step : 
  accRealize ? copy_step (inr … (inl … (inr … 0))) R_copy_step_true R_copy_step_false.

(*
1) il primo carattere è marcato
2) l'ultimo carattere è l'unico che può essere null, gli altri sono bit
3) il terminatore non è né bit, né null
*)
   
definition copy0 ≝ whileTM ? copy_step (inr … (inl … (inr … 0))).

let rec merge_config (l1,l2:list STape) ≝ 
  match l1 with
  [ nil ⇒ nil ?
  | cons p1 l1' ⇒ match l2 with
    [ nil ⇒ nil ? 
    | cons p2 l2' ⇒ 
           let 〈c1,b1〉 ≝ p1 in let 〈c2,b2〉 ≝ p2 in
           match c2 with
           [ null ⇒ p1 :: merge_config l1' l2'
           | _ ⇒ p2 :: merge_config l1' l2' ] ] ].

definition R_copy0 ≝ λt1,t2.
  ∀ls,c,c0,rs,l1,l3,l4.
  t1 = midtape STape (l3@l4@〈c0,true〉::ls) 〈c,true〉 (l1@rs) → 
  no_marks l1 → no_marks (l3@l4) → |l1| = |l4| → 
  ∀l1',bv.〈c,false〉::l1 = l1'@[〈comma,bv〉] → only_bits_or_nulls l1' → 
  ∀l4',bg.l4@[〈c0,false〉] = 〈grid,bg〉::l4' → only_bits_or_nulls l4' → 
  (c = comma ∧ t2 = t1) ∨
  (c ≠ comma ∧ 
    t2 = midtape ? (reverse ? l1'@l3@〈grid,true〉::
                  merge_config l4' (reverse ? l1')@ls) 
     〈comma,true〉 rs).

lemma wsem_copy0 : WRealize ? copy0 R_copy0.
#intape #k #outc #Hloop 
lapply (sem_while … sem_copy_step intape k outc Hloop) [%] -Hloop
* #ta * #Hstar @(star_ind_l ??????? Hstar)
[ #tb whd in ⊢ (%→?); #Hleft
  #ls #c #c0 #rs #l1 #l3 #l4 #Htb #Hl1nomarks #Hl3l4nomarks #Hlen #l1' #bv
  #Hl1 #Hl1bits #l4' #bg #Hl4 #Hl4bits
  cases (Hleft … Htb) -Hleft #Hc #Houtc % %
  [ generalize in match Hl1bits; -Hl1bits cases l1' in Hl1;
    [ normalize #Hl1 #c1 destruct (Hl1) %
    | * #c' #b' #l0 #Heq normalize in Heq; destruct (Heq)
      #Hl1bits lapply (Hl1bits 〈c',false〉 ?) [ @memb_hd ] 
      >Hc #Hfalse destruct ]
  | @Houtc ]
| #tb #tc #td whd in ⊢ (%→?→(?→%)→%→?); #Htc #Hstar1 #Hind #Htd
  lapply (Hind Htd) -Hind #Hind
  #ls #c #c0 #rs #l1 #l3 #l4 #Htb #Hl1nomarks #Hl3l4nomarks #Hlen #l1' #bv
  #Hl1 #Hl1bits #l4' #bg #Hl4 #Hl4bits %2
  cases (Htc … Htb) -Htc #Hcbitnull #Htc
  % [ % #Hc' >Hc' in Hcbitnull; normalize #Hfalse destruct (Hfalse) ]
  cut (|l1| = |reverse ? l4|) [@daemon] #Hlen1
  @(list_cases_2 … Hlen1)
  [ #Hl1nil @False_ind >Hl1nil in Hl1; cases l1' normalize
    [ #Hl1 destruct normalize in Hcbitnull; destruct (Hcbitnull)
    | #p0 #l0 normalize #Hfalse destruct (Hfalse) cases l0 in e0;
      [ normalize #Hfalse1 destruct (Hfalse1)
      | #p0' #l0' normalize #Hfalse1 destruct (Hfalse1) ] ]
  | * #a #ba * #a0 #ba0 #l1'' #l4'' #Hl1cons #Hl4cons
    lapply (eq_f ?? (reverse ?) ?? Hl4cons) >reverse_reverse >reverse_cons -Hl4cons #Hl4cons
    cut (ba = false) [ @daemon ] #Hba
    cut (ba0 = false) [ @daemon ] #Hba0
    >Hba0 in Hl4cons; >Hba in Hl1cons; -Hba0 -Hba #Hl1cons #Hl4cons
    >Hl4cons in Htc; >Hl1cons #Htc
    lapply (Htc a (l3@reverse ? l4'') c0 a0 ls (l1''@rs) ? (refl ??) ?)
    [ #x #Hx @Hl3l4nomarks >Hl4cons <associative_append
      @memb_append_l1 @Hx
    | >associative_append >associative_append %
    | -Htc *
      [ * #x * #Hx #Htc 
        lapply (Hind (〈bit x,false〉::ls) a a0 rs l1'' 
                (〈bit x,false〉::l3) (reverse ? l4'') ????) 
        [ >Hl1cons in Hlen; >Hl4cons >length_append >commutative_plus 
          normalize #Hlen destruct (Hlen) //
        | #x0 #Hx0 cases (orb_true_l … Hx0)
          [ #Hx0eq >(\P Hx0eq) %
          | -Hx0 #Hx0 @Hl3l4nomarks >Hl4cons
            <associative_append @memb_append_l1 // ]
        | #x0 #Hx0 @Hl1nomarks >Hl1cons @memb_cons //
        | >Htc >associative_append % 
        | -Hind 
          cut (∃la.l1' = 〈c,false〉::la)
          [ >Hl1cons in Hl1; cases l1'
            [normalize #Hfalse destruct (Hfalse)
            | #p #la normalize #Hla destruct (Hla) @(ex_intro ?? la) % ] ]
          * #la #Hla
          cut (∃lb.l4' = lb@[〈c0,false〉])
            [ >Hl4cons in Hl4;
              @(list_elim_left … l4')
              (* si usa l'iniettività del "cons destro" 
              [ normalize 
              | #p #lb
             cases l4'
              [normalize
              | #p #lb *)
            
            @(list_elim_left … l4')
           <Hl1cons <Hl4cons #Hind lapply (Hind ?? Hl1 ??? Hl4 ?)

definition copy
≝ 
  seq STape (move_l …) (seq ? (adv_to_mark_l … (is_marked ?))
   (seq ? (clear_mark …) (seq ? (adv_to_mark_r … (is_marked ?)) (clear_mark …)))).

definition R_copy ≝ λt1,t2.
  ∀ls,c,c0,rs,l1,l3,l4.
  t1 = midtape STape (l3@〈grid,false〉::l4@〈c0,true〉::ls) 〈c,true〉 (l1@〈comma,false〉::rs) → 
  no_marks l1 → no_marks l3 → no_marks l4 → |l1| = |l4| → 
  only_bits_or_nulls (〈c0,true〉::l4) → only_bits_or_nulls (〈c,true〉::l1) → 
  t2 = midtape STape (reverse ? l1@l3@〈grid,false〉::
          merge_config (l4@[〈c0,false〉]) (reverse ? (〈c,false〉::l1))@ls) 
     〈comma,false〉 rs.
     
axiom sem_copy : Realize ? copy R_copy.
