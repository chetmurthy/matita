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

include "basics/vectors.ma".
(* include "basics/relations.ma". *)

record tape (sig:FinSet): Type[0] ≝ 
{ left : list sig;
  right: list sig
}.

inductive move : Type[0] ≝
| L : move 
| R : move
.

(* We do not distinuish an input tape *)

record TM (sig:FinSet): Type[1] ≝ 
{ states : FinSet;
  trans : states × (option sig) → states × (option (sig × move));
  start: states;
  halt : states → bool
}.

record config (sig:FinSet) (M:TM sig): Type[0] ≝ 
{ cstate : states sig M;
  ctape: tape sig
}.

definition option_hd ≝ λA.λl:list A.
  match l with
  [nil ⇒ None ?
  |cons a _ ⇒ Some ? a
  ].

definition tape_move ≝ λsig.λt: tape sig.λm:option (sig × move).
  match m with 
  [ None ⇒ t
  | Some m1 ⇒ 
    match \snd m1 with
    [ R ⇒ mk_tape sig ((\fst m1)::(left ? t)) (tail ? (right ? t))
    | L ⇒ mk_tape sig (tail ? (left ? t)) ((\fst m1)::(right ? t))
    ]
  ].

definition step ≝ λsig.λM:TM sig.λc:config sig M.
  let current_char ≝ option_hd ? (right ? (ctape ?? c)) in
  let 〈news,mv〉 ≝ trans sig M 〈cstate ?? c,current_char〉 in
  mk_config ?? news (tape_move sig (ctape ?? c) mv).
  
let rec loop (A:Type[0]) n (f:A→A) p a on n ≝
  match n with 
  [ O ⇒ None ?
  | S m ⇒ if p a then (Some ? a) else loop A m f p (f a)
  ].
  
lemma loop_incr : ∀A,f,p,k1,k2,a1,a2. 
  loop A k1 f p a1 = Some ? a2 → 
    loop A (k2+k1) f p a1 = Some ? a2.
#A #f #p #k1 #k2 #a1 #a2 generalize in match a1; elim k1
[normalize #a0 #Hfalse destruct
|#k1' #IH #a0 <plus_n_Sm whd in ⊢ (??%? → ??%?);
 cases (true_or_false (p a0)) #Hpa0 >Hpa0 whd in ⊢ (??%? → ??%?); // @IH
]
qed.

lemma loop_split : ∀A,f,p,q.(∀b. p b = false → q b = false) →
 ∀k1,k2,a1,a2,a3,a4.
   loop A k1 f p a1 = Some ? a2 → 
     f a2 = a3 → q a2 = false → 
       loop A k2 f q a3 = Some ? a4 →
         loop A (k1+k2) f q a1 = Some ? a4.
#Sig #f #p #q #Hpq #k1 elim k1 
  [normalize #k2 #a1 #a2 #a3 #a4 #H destruct
  |#k1' #Hind #k2 #a1 #a2 #a3 #a4 normalize in ⊢ (%→?);
   cases (true_or_false (p a1)) #pa1 >pa1 normalize in ⊢ (%→?);
   [#eqa1a2 destruct #eqa2a3 #Hqa2 #H
    whd in ⊢ (??(??%???)?); >plus_n_Sm @loop_incr
    whd in ⊢ (??%?); >Hqa2 >eqa2a3 @H
   |normalize >(Hpq … pa1) normalize 
    #H1 #H2 #H3 @(Hind … H2) //
   ]
 ]
qed.

(*
lemma loop_split : ∀A,f,p,q.(∀b. p b = false → q b = false) →
 ∀k1,k2,a1,a2,a3.
   loop A k1 f p a1 = Some ? a2 → 
     loop A k2 f q a2 = Some ? a3 →
       loop A (k1+k2) f q a1 = Some ? a3.
#Sig #f #p #q #Hpq #k1 elim k1 
  [normalize #k2 #a1 #a2 #a3 #H destruct
  |#k1' #Hind #k2 #a1 #a2 #a3 normalize in ⊢ (%→?→?);
   cases (true_or_false (p a1)) #pa1 >pa1 normalize in ⊢ (%→?);
   [#eqa1a2 destruct #H @loop_incr //
   |normalize >(Hpq … pa1) normalize 
    #H1 #H2 @(Hind … H2) //
   ]
 ]
qed.
*)

definition initc ≝ λsig.λM:TM sig.λt.
  mk_config sig M (start sig M) t.

definition Realize ≝ λsig.λM:TM sig.λR:relation (tape sig).
∀t.∃i.∃outc.
  loop ? i (step sig M) (λc.halt sig M (cstate ?? c)) (initc sig M t) = Some ? outc ∧
  R t (ctape ?? outc).

(* Compositions *)

definition seq_trans ≝ λsig. λM1,M2 : TM sig. 
λp. let 〈s,a〉 ≝ p in
  match s with 
  [ inl s1 ⇒ 
      if halt sig M1 s1 then 〈inr … (start sig M2), None ?〉
      else 
      let 〈news1,m〉 ≝ trans sig M1 〈s1,a〉 in
      〈inl … news1,m〉
  | inr s2 ⇒ 
      let 〈news2,m〉 ≝ trans sig M2 〈s2,a〉 in
      〈inr … news2,m〉
  ].
 
definition seq ≝ λsig. λM1,M2 : TM sig. 
  mk_TM sig 
    (FinSum (states sig M1) (states sig M2))
    (seq_trans sig M1 M2) 
    (inl … (start sig M1))
    (λs.match s with
      [ inl _ ⇒ false | inr s2 ⇒ halt sig M2 s2]). 

definition Rcomp ≝ λA.λR1,R2:relation A.λa1,a2.
  ∃am.R1 a1 am ∧ R2 am a2.

(*
definition injectRl ≝ λsig.λM1.λM2.λR.
   λc1,c2. ∃c11,c12. 
     inl … (cstate sig M1 c11) = cstate sig (seq sig M1 M2) c1 ∧ 
     inl … (cstate sig M1 c12) = cstate sig (seq sig M1 M2) c2 ∧
     ctape sig M1 c11 = ctape sig (seq sig M1 M2) c1 ∧ 
     ctape sig M1 c12 = ctape sig (seq sig M1 M2) c2 ∧ 
     R c11 c12.

definition injectRr ≝ λsig.λM1.λM2.λR.
   λc1,c2. ∃c21,c22. 
     inr … (cstate sig M2 c21) = cstate sig (seq sig M1 M2) c1 ∧ 
     inr … (cstate sig M2 c22) = cstate sig (seq sig M1 M2) c2 ∧
     ctape sig M2 c21 = ctape sig (seq sig M1 M2) c1 ∧ 
     ctape sig M2 c22 = ctape sig (seq sig M1 M2) c2 ∧ 
     R c21 c22.
     
definition Rlink ≝ λsig.λM1,M2.λc1,c2.
  ctape sig (seq sig M1 M2) c1 = ctape sig (seq sig M1 M2) c2 ∧
  cstate sig (seq sig M1 M2) c1 = inl … (halt sig M1) ∧
  cstate sig (seq sig M1 M2) c2 = inr … (start sig M2). *)
  
interpretation "relation composition" 'compose R1 R2 = (Rcomp ? R1 R2).

definition lift_confL ≝ 
  λsig,M1,M2,c.match c with
  [ mk_config s t ⇒ mk_config ? (seq sig M1 M2) (inl … s) t ].
definition lift_confR ≝ 
  λsig,M1,M2,c.match c with
  [ mk_config s t ⇒ mk_config ? (seq sig M1 M2) (inr … s) t ].
  
definition halt_liftL ≝ 
  λsig.λM1,M2:TM sig.λs:FinSum (states ? M1) (states ? M2).
  match s with
  [ inl s1 ⇒ halt sig M1 s1
  | inr _ ⇒ true ]. (* should be vacuous in all cases we use halt_liftL *)

definition halt_liftR ≝ 
  λsig.λM1,M2:TM sig.λs:FinSum (states ? M1) (states ? M2).
  match s with
  [ inl _ ⇒ false 
  | inr s2 ⇒ halt sig M2 s2 ].
      
lemma p_halt_liftL : ∀sig,M1,M2,c.
  halt sig M1 (cstate … c) =
     halt_liftL sig M1 M2 (cstate … (lift_confL … c)).
#sig #M1 #M2 #c cases c #s #t %
qed.

lemma trans_liftL : ∀sig,M1,M2,s,a,news,move.
  halt ? M1 s = false → 
  trans sig M1 〈s,a〉 = 〈news,move〉 → 
  trans sig (seq sig M1 M2) 〈inl … s,a〉 = 〈inl … news,move〉.
#sig (*#M1*) * #Q1 #T1 #init1 #halt1 #M2 #s #a #news #move
#Hhalt #Htrans whd in ⊢ (??%?); >Hhalt >Htrans %
qed.

lemma trans_liftR : ∀sig,M1,M2,s,a,news,move.
  halt ? M2 s = false → 
  trans sig M2 〈s,a〉 = 〈news,move〉 → 
  trans sig (seq sig M1 M2) 〈inr … s,a〉 = 〈inr … news,move〉.
#sig #M1 * #Q2 #T2 #init2 #halt2 #s #a #news #move
#Hhalt #Htrans whd in ⊢ (??%?); >Hhalt >Htrans %
qed.

lemma config_eq : 
  ∀sig,M,c1,c2.
  cstate sig M c1 = cstate sig M c2 → 
  ctape sig M c1 = ctape sig M c2 →  c1 = c2.
#sig #M1 * #s1 #t1 * #s2 #t2 //
qed.

lemma step_lift_confR : ∀sig,M1,M2,c0.
 halt ? M2 (cstate ?? c0) = false → 
 step sig (seq sig M1 M2) (lift_confR sig M1 M2 c0) =
 lift_confR sig M1 M2 (step sig M2 c0).
#sig #M1 (* * #Q1 #T1 #init1 #halt1 *) #M2 * #s * #lt
#rs #Hhalt
whd in ⊢ (???(????%));whd in ⊢ (???%);
lapply (refl ? (trans ?? 〈s,option_hd sig rs〉))
cases (trans ?? 〈s,option_hd sig rs〉) in ⊢ (???% → %);
#s0 #m0 #Heq whd in ⊢ (???%);
whd in ⊢ (??(???%)?); whd in ⊢ (??%?);
>(trans_liftR … Heq)
[% | //]
qed.

lemma step_lift_confL : ∀sig,M1,M2,c0.
 halt ? M1 (cstate ?? c0) = false → 
 step sig (seq sig M1 M2) (lift_confL sig M1 M2 c0) =
 lift_confL sig M1 M2 (step sig M1 c0).
#sig #M1 (* * #Q1 #T1 #init1 #halt1 *) #M2 * #s * #lt
#rs #Hhalt
whd in ⊢ (???(????%));whd in ⊢ (???%);
lapply (refl ? (trans ?? 〈s,option_hd sig rs〉))
cases (trans ?? 〈s,option_hd sig rs〉) in ⊢ (???% → %);
#s0 #m0 #Heq whd in ⊢ (???%);
whd in ⊢ (??(???%)?); whd in ⊢ (??%?);
>(trans_liftL … Heq)
[% | //]
qed.

lemma loop_liftL : ∀sig,k,M1,M2,c1,c2.
  loop ? k (step sig M1) (λc.halt sig M1 (cstate ?? c)) c1 = Some ? c2 →
    loop ? k (step sig (seq sig M1 M2)) 
      (λc.halt_liftL sig M1 M2 (cstate ?? c)) (lift_confL … c1) = 
    Some ? (lift_confL … c2).
#sig #k #M1 #M2 #c1 #c2 generalize in match c1;
elim k
[#c0 normalize in ⊢ (??%? → ?); #Hfalse destruct (Hfalse)
|#k0 #IH #c0 whd in ⊢ (??%? → ??%?);
 lapply (refl ? (halt ?? (cstate sig M1 c0))) 
 cases (halt ?? (cstate sig M1 c0)) in ⊢ (???% → ?); #Hc0 >Hc0
 [ >(?: halt_liftL ??? (cstate sig (seq ? M1 M2) (lift_confL … c0)) = true)
   [ whd in ⊢ (??%? → ??%?); #Hc2 destruct (Hc2) %
   | // ]
 | >(?: halt_liftL ??? (cstate sig (seq ? M1 M2) (lift_confL … c0)) = false)
   [whd in ⊢ (??%? → ??%?); #Hc2 <(IH ? Hc2) @eq_f
    @step_lift_confL //
   | // ]
qed.

lemma loop_liftR : ∀sig,k,M1,M2,c1,c2.
  loop ? k (step sig M2) (λc.halt sig M2 (cstate ?? c)) c1 = Some ? c2 →
    loop ? k (step sig (seq sig M1 M2)) 
      (λc.halt sig (seq sig M1 M2) (cstate ?? c)) (lift_confR … c1) = 
    Some ? (lift_confR … c2).
#sig #k #M1 #M2 #c1 #c2 generalize in match c1;
elim k
[#c0 normalize in ⊢ (??%? → ?); #Hfalse destruct (Hfalse)
|#k0 #IH #c0 whd in ⊢ (??%? → ??%?);
 lapply (refl ? (halt ?? (cstate sig M2 c0))) 
 cases (halt ?? (cstate sig M2 c0)) in ⊢ (???% → ?); #Hc0 >Hc0
 [ >(?: halt ?? (cstate sig (seq ? M1 M2) (lift_confR … c0)) = true)
   [ whd in ⊢ (??%? → ??%?); #Hc2 destruct (Hc2) %
   | <Hc0 cases c0 // ]
 | >(?: halt ?? (cstate sig (seq ? M1 M2) (lift_confR … c0)) = false)
   [whd in ⊢ (??%? → ??%?); #Hc2 <(IH ? Hc2) @eq_f
    @step_lift_confR //
   | <Hc0 cases c0 // ]
 ]
qed.  
    
lemma loop_Some : 
  ∀A,k,f,p,a,b.loop A k f p a = Some ? b → p b = true.
#A #k #f #p elim k 
[#a #b normalize #Hfalse destruct
|#k0 #IH #a #b whd in ⊢ (??%? → ?); cases (true_or_false (p a)) #Hpa
 [ >Hpa normalize #H1 destruct //
 | >Hpa normalize @IH
 ]
]
qed. 

lemma trans_liftL_true : ∀sig,M1,M2,s,a.
  halt ? M1 s = true → 
  trans sig (seq sig M1 M2) 〈inl … s,a〉 = 〈inr … (start ? M2),None ?〉.
#sig #M1 #M2 #s #a
#Hhalt whd in ⊢ (??%?); >Hhalt %
qed.

lemma eq_ctape_lift_conf_L : ∀sig,M1,M2,outc.
  ctape sig (seq sig M1 M2) (lift_confL … outc) = ctape … outc.
#sig #M1 #M2 #outc cases outc #s #t %
qed.
  
lemma eq_ctape_lift_conf_R : ∀sig,M1,M2,outc.
  ctape sig (seq sig M1 M2) (lift_confR … outc) = ctape … outc.
#sig #M1 #M2 #outc cases outc #s #t %
qed.

theorem sem_seq: ∀sig,M1,M2,R1,R2.
  Realize sig M1 R1 → Realize sig M2 R2 → 
    Realize sig (seq sig M1 M2) (R1 ∘ R2).
#sig #M1 #M2 #R1 #R2 #HR1 #HR2 #t 
cases (HR1 t) #k1 * #outc1 * #Hloop1 #HM1
cases (HR2 (ctape sig M1 outc1)) #k2 * #outc2 * #Hloop2 #HM2
@(ex_intro … (k1+k2)) @(ex_intro … (lift_confR … outc2))
%
[@(loop_split ??????????? (loop_liftL … Hloop1))
 [* *
   [ #sl #tl whd in ⊢ (??%? → ?); #Hl %
   | #sr #tr whd in ⊢ (??%? → ?); #Hr destruct (Hr) ]
 ||4:cases outc1 #s1 #t1 %
 |5:@(loop_liftR … Hloop2) 
 |whd in ⊢ (??(???%)?);whd in ⊢ (??%?);
  generalize in match Hloop1; cases outc1 #sc1 #tc1 #Hloop10 
  >(trans_liftL_true sig M1 M2 ??) 
  [ whd in ⊢ (??%?); whd in ⊢ (???%);
    @config_eq //
  | @(loop_Some ?????? Hloop10) ]
 ]
| @(ex_intro … (ctape ? (seq sig M1 M2) (lift_confL … outc1)))
  % //
]
qed.

