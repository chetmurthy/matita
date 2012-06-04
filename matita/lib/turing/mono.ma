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

(******************************** tape ****************************************)

(* A tape is essentially a triple 〈left,current,right〉 where however the current 
symbol could be missing. This may happen for three different reasons: both tapes 
are empty; we are on the left extremity of a non-empty tape (left overflow), or 
we are on the right extremity of a non-empty tape (right overflow). *)

inductive tape (sig:FinSet) : Type[0] ≝ 
| niltape : tape sig
| leftof  : sig → list sig → tape sig
| rightof : sig → list sig → tape sig
| midtape : list sig → sig → list sig → tape sig.

definition left ≝ 
 λsig.λt:tape sig.match t with
 [ niltape ⇒ [] | leftof _ _ ⇒ [] | rightof s l ⇒ s::l | midtape l _ _ ⇒ l ].

definition right ≝ 
 λsig.λt:tape sig.match t with
 [ niltape ⇒ [] | leftof s r ⇒ s::r | rightof _ _ ⇒ []| midtape _ _ r ⇒ r ].
 
definition current ≝ 
 λsig.λt:tape sig.match t with
 [ midtape _ c _ ⇒ Some ? c | _ ⇒ None ? ].
 
definition mk_tape : 
  ∀sig:FinSet.list sig → option sig → list sig → tape sig ≝ 
  λsig,lt,c,rt.match c with
  [ Some c' ⇒ midtape sig lt c' rt
  | None ⇒ match lt with 
    [ nil ⇒ match rt with
      [ nil ⇒ niltape ?
      | cons r0 rs0 ⇒ leftof ? r0 rs0 ]
    | cons l0 ls0 ⇒ rightof ? l0 ls0 ] ].

inductive move : Type[0] ≝
  | L : move | R : move | N : move.

(********************************** machine ***********************************)

record TM (sig:FinSet): Type[1] ≝ 
{ states : FinSet;
  trans : states × (option sig) → states × (option (sig × move));
  start: states;
  halt : states → bool
}.

definition tape_move_left ≝ λsig:FinSet.λlt:list sig.λc:sig.λrt:list sig.
  match lt with
  [ nil ⇒ leftof sig c rt
  | cons c0 lt0 ⇒ midtape sig lt0 c0 (c::rt) ].
  
definition tape_move_right ≝ λsig:FinSet.λlt:list sig.λc:sig.λrt:list sig.
  match rt with
  [ nil ⇒ rightof sig c lt
  | cons c0 rt0 ⇒ midtape sig (c::lt) c0 rt0 ].

definition tape_move ≝ λsig.λt: tape sig.λm:option (sig × move).
  match m with
  [ None ⇒ t
  | Some m' ⇒ 
    let 〈s,m1〉 ≝ m' in 
    match m1 with
      [ R ⇒ tape_move_right ? (left ? t) s (right ? t)
      | L ⇒ tape_move_left ? (left ? t) s (right ? t)
      | N ⇒ midtape ? (left ? t) s (right ? t)
      ] ].

record config (sig,states:FinSet): Type[0] ≝ 
{ cstate : states;
  ctape: tape sig
}.
  
definition step ≝ λsig.λM:TM sig.λc:config sig (states sig M).
  let current_char ≝ current ? (ctape ?? c) in
  let 〈news,mv〉 ≝ trans sig M 〈cstate ?? c,current_char〉 in
  mk_config ?? news (tape_move sig (ctape ?? c) mv).

(******************************** loop ****************************************)
let rec loop (A:Type[0]) n (f:A→A) p a on n ≝
  match n with 
  [ O ⇒ None ?
  | S m ⇒ if p a then (Some ? a) else loop A m f p (f a)
  ].
  
lemma loop_S_true : 
  ∀A,n,f,p,a. p a = true → 
    loop A (S n) f p a = Some ? a.
#A #n #f #p #a #pa normalize >pa //
qed.

lemma loop_S_false : 
  ∀A,n,f,p,a.  p a = false → 
    loop A (S n) f p a = loop A n f p (f a).
normalize #A #n #f #p #a #Hpa >Hpa %
qed.  
  
lemma loop_incr : ∀A,f,p,k1,k2,a1,a2. 
  loop A k1 f p a1 = Some ? a2 → 
    loop A (k2+k1) f p a1 = Some ? a2.
#A #f #p #k1 #k2 #a1 #a2 generalize in match a1; elim k1
[normalize #a0 #Hfalse destruct
|#k1' #IH #a0 <plus_n_Sm whd in ⊢ (??%? → ??%?);
 cases (true_or_false (p a0)) #Hpa0 >Hpa0 whd in ⊢ (??%? → ??%?); // @IH
]
qed.

lemma loop_merge : ∀A,f,p,q.(∀b. p b = false → q b = false) →
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
   |normalize >(Hpq … pa1) normalize #H1 #H2 #H3 @(Hind … H2) //
   ]
 ]
qed.

lemma loop_split : ∀A,f,p,q.(∀b. q b = true → p b = true) →
 ∀k,a1,a2.
   loop A k f q a1 = Some ? a2 → 
   ∃k1,a3.
    loop A k1 f p a1 = Some ? a3 ∧ 
      loop A (S(k-k1)) f q a3 = Some ? a2.
#A #f #p #q #Hpq #k elim k
  [#a1 #a2 normalize #Heq destruct
  |#i #Hind #a1 #a2 normalize 
   cases (true_or_false (q a1)) #Hqa1 >Hqa1 normalize
    [ #Ha1a2 destruct
     @(ex_intro … 1) @(ex_intro … a2) % 
       [normalize >(Hpq …Hqa1) // |>Hqa1 //]
    |#Hloop cases (true_or_false (p a1)) #Hpa1 
       [@(ex_intro … 1) @(ex_intro … a1) % 
         [normalize >Hpa1 // |>Hqa1 <Hloop normalize //]
       |cases (Hind …Hloop) #k2 * #a3 * #Hloop1 #Hloop2
        @(ex_intro … (S k2)) @(ex_intro … a3) %
         [normalize >Hpa1 normalize // | @Hloop2 ]
       ]
    ]
  ]
qed.

lemma loop_eq : ∀sig,f,q,i,j,a,x,y. 
  loop sig i f q a = Some ? x → loop sig j f q a = Some ? y → x = y.
#sig #f #q #i #j @(nat_elim2 … i j)
[ #n #a #x #y normalize #Hfalse destruct (Hfalse)
| #n #a #x #y #H1 normalize #Hfalse destruct (Hfalse)
| #n1 #n2 #IH #a #x #y normalize cases (q a) normalize
  [ #H1 #H2 destruct %
  | /2/ ]
]
qed.

(************************** Realizability *************************************)
definition loopM ≝ λsig,M,i,cin.
  loop ? i (step sig M) (λc.halt sig M (cstate ?? c)) cin.

definition initc ≝ λsig.λM:TM sig.λt.
  mk_config sig (states sig M) (start sig M) t.

definition Realize ≝ λsig.λM:TM sig.λR:relation (tape sig).
∀t.∃i.∃outc.
  loopM sig M i (initc sig M t) = Some ? outc ∧ R t (ctape ?? outc).

definition WRealize ≝ λsig.λM:TM sig.λR:relation (tape sig).
∀t,i,outc.
  loopM sig M i (initc sig M t) = Some ? outc → R t (ctape ?? outc).

definition Terminate ≝ λsig.λM:TM sig.λt. ∃i,outc.
  loopM sig M i (initc sig M t) = Some ? outc.

lemma WRealize_to_Realize : ∀sig.∀M: TM sig.∀R.
  (∀t.Terminate sig M t) → WRealize sig M R → Realize sig M R.
#sig #M #R #HT #HW #t cases (HT … t) #i * #outc #Hloop 
@(ex_intro … i) @(ex_intro … outc) % // @(HW … i) //
qed.

theorem Realize_to_WRealize : ∀sig,M,R.
  Realize sig M R → WRealize sig M R.
#sig #M #R #H1 #inc #i #outc #Hloop 
cases (H1 inc) #k * #outc1 * #Hloop1 #HR >(loop_eq … Hloop Hloop1) //
qed.

definition accRealize ≝ λsig.λM:TM sig.λacc:states sig M.λRtrue,Rfalse.
∀t.∃i.∃outc.
  loopM sig M i (initc sig M t) = Some ? outc ∧
    (cstate ?? outc = acc → Rtrue t (ctape ?? outc)) ∧ 
    (cstate ?? outc ≠ acc → Rfalse t (ctape ?? outc)).

(******************************** NOP Machine *********************************)

(* NO OPERATION
   t1 = t2 *)
  
definition nop_states ≝ initN 1.
definition start_nop : initN 1 ≝ mk_Sig ?? 0 (le_n … 1).

definition nop ≝ 
  λalpha:FinSet.mk_TM alpha nop_states
  (λp.let 〈q,a〉 ≝ p in 〈q,None ?〉)
  start_nop (λ_.true).
  
definition R_nop ≝ λalpha.λt1,t2:tape alpha.t2 = t1.

lemma sem_nop :
  ∀alpha.Realize alpha (nop alpha) (R_nop alpha).
#alpha #intape @(ex_intro ?? 1) 
@(ex_intro … (mk_config ?? start_nop intape)) % % 
qed.

(************************** Sequential Composition ****************************)

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
  
interpretation "relation composition" 'compose R1 R2 = (Rcomp ? R1 R2).

definition lift_confL ≝ 
  λsig,S1,S2,c.match c with 
  [ mk_config s t ⇒ mk_config sig (FinSum S1 S2) (inl … s) t ].
  
definition lift_confR ≝ 
  λsig,S1,S2,c.match c with
  [ mk_config s t ⇒ mk_config sig (FinSum S1 S2) (inr … s) t ].
  
definition halt_liftL ≝ 
  λS1,S2,halt.λs:FinSum S1 S2.
  match s with
  [ inl s1 ⇒ halt s1
  | inr _ ⇒ true ]. (* should be vacuous in all cases we use halt_liftL *)

definition halt_liftR ≝ 
  λS1,S2,halt.λs:FinSum S1 S2.
  match s with
  [ inl _ ⇒ false 
  | inr s2 ⇒ halt s2 ].
      
lemma p_halt_liftL : ∀sig,S1,S2,halt,c.
  halt (cstate sig S1 c) =
     halt_liftL S1 S2 halt (cstate … (lift_confL … c)).
#sig #S1 #S2 #halt #c cases c #s #t %
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
 step sig (seq sig M1 M2) (lift_confR sig (states ? M1) (states ? M2) c0) =
 lift_confR sig (states ? M1) (states ? M2) (step sig M2 c0).
#sig #M1 (* * #Q1 #T1 #init1 #halt1 *) #M2 * #s #t
  lapply (refl ? (trans ?? 〈s,current sig t〉))
  cases (trans ?? 〈s,current sig t〉) in ⊢ (???% → %);
  #s0 #m0 cases t
  [ #Heq #Hhalt
  | 2,3: #s1 #l1 #Heq #Hhalt 
  |#ls #s1 #rs #Heq #Hhalt ]
  whd in ⊢ (???(????%)); >Heq
  whd in ⊢ (???%);
  whd in ⊢ (??(???%)?); whd in ⊢ (??%?);
  >(trans_liftR … Heq) //
qed.

lemma step_lift_confL : ∀sig,M1,M2,c0.
 halt ? M1 (cstate ?? c0) = false → 
 step sig (seq sig M1 M2) (lift_confL sig (states ? M1) (states ? M2) c0) =
 lift_confL sig ?? (step sig M1 c0).
#sig #M1 (* * #Q1 #T1 #init1 #halt1 *) #M2 * #s #t
  lapply (refl ? (trans ?? 〈s,current sig t〉))
  cases (trans ?? 〈s,current sig t〉) in ⊢ (???% → %);
  #s0 #m0 cases t
  [ #Heq #Hhalt
  | 2,3: #s1 #l1 #Heq #Hhalt 
  |#ls #s1 #rs #Heq #Hhalt ]
  whd in ⊢ (???(????%)); >Heq
  whd in ⊢ (???%);
  whd in ⊢ (??(???%)?); whd in ⊢ (??%?);
  >(trans_liftL … Heq) //
qed.

lemma loop_lift : ∀A,B,k,lift,f,g,h,hlift,c1,c2.
  (∀x.hlift (lift x) = h x) → 
  (∀x.h x = false → lift (f x) = g (lift x)) → 
  loop A k f h c1 = Some ? c2 → 
  loop B k g hlift (lift c1) = Some ? (lift … c2).
#A #B #k #lift #f #g #h #hlift #c1 #c2 #Hfg #Hhlift
generalize in match c1; elim k
[#c0 normalize in ⊢ (??%? → ?); #Hfalse destruct (Hfalse)
|#k0 #IH #c0 whd in ⊢ (??%? → ??%?);
 cases (true_or_false (h c0)) #Hc0 >Hfg >Hc0
 [ normalize #Heq destruct (Heq) %
 | normalize <Hhlift // @IH ]
qed.

(* 
lemma loop_liftL : ∀sig,k,M1,M2,c1,c2.
  loop ? k (step sig M1) (λc.halt sig M1 (cstate ?? c)) c1 = Some ? c2 →
    loop ? k (step sig (seq sig M1 M2)) 
      (λc.halt_liftL ?? (halt sig M1) (cstate ?? c)) (lift_confL … c1) = 
    Some ? (lift_confL … c2).
#sig #k #M1 #M2 #c1 #c2 generalize in match c1;
elim k
[#c0 normalize in ⊢ (??%? → ?); #Hfalse destruct (Hfalse)
|#k0 #IH #c0 whd in ⊢ (??%? → ??%?);
 cases (true_or_false (halt ?? (cstate sig (states ? M1) c0))) #Hc0 >Hc0
 [ >(?: halt_liftL ?? (halt sig M1) (cstate sig ? (lift_confL … c0)) = true)
   [ whd in ⊢ (??%? → ??%?); #Hc2 destruct (Hc2) %
   | <Hc0 cases c0 // ]
 | >(?: halt_liftL ?? (halt sig M1) (cstate ?? (lift_confL … c0)) = false)
   [whd in ⊢ (??%? → ??%?); #Hc2 <(IH ? Hc2) @eq_f
    @step_lift_confL //
   | <Hc0 cases c0 // ]
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
 cases (true_or_false (halt ?? (cstate sig ? c0))) #Hc0 >Hc0
 [ >(?: halt ? (seq sig M1 M2) (cstate sig ? (lift_confR … c0)) = true)
   [ whd in ⊢ (??%? → ??%?); #Hc2 destruct (Hc2) %
   | <Hc0 cases c0 // ]
 | >(?: halt ? (seq sig M1 M2) (cstate sig ? (lift_confR … c0)) = false)
   [whd in ⊢ (??%? → ??%?); #Hc2 <(IH ? Hc2) @eq_f
    @step_lift_confR //
   | <Hc0 cases c0 // ]
 ]
qed.  

*)
    
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

lemma eq_ctape_lift_conf_L : ∀sig,S1,S2,outc.
  ctape sig (FinSum S1 S2) (lift_confL … outc) = ctape … outc.
#sig #S1 #S2 #outc cases outc #s #t %
qed.
  
lemma eq_ctape_lift_conf_R : ∀sig,S1,S2,outc.
  ctape sig (FinSum S1 S2) (lift_confR … outc) = ctape … outc.
#sig #S1 #S2 #outc cases outc #s #t %
qed.

theorem sem_seq: ∀sig,M1,M2,R1,R2.
  Realize sig M1 R1 → Realize sig M2 R2 → 
    Realize sig (seq sig M1 M2) (R1 ∘ R2).
#sig #M1 #M2 #R1 #R2 #HR1 #HR2 #t 
cases (HR1 t) #k1 * #outc1 * #Hloop1 #HM1
cases (HR2 (ctape sig (states ? M1) outc1)) #k2 * #outc2 * #Hloop2 #HM2
@(ex_intro … (k1+k2)) @(ex_intro … (lift_confR … outc2))
%
[@(loop_merge ??????????? 
   (loop_lift ??? (lift_confL sig (states sig M1) (states sig M2))
   (step sig M1) (step sig (seq sig M1 M2)) 
   (λc.halt sig M1 (cstate … c)) 
   (λc.halt_liftL ?? (halt sig M1) (cstate … c)) … Hloop1))
  [ * *
   [ #sl #tl whd in ⊢ (??%? → ?); #Hl %
   | #sr #tr whd in ⊢ (??%? → ?); #Hr destruct (Hr) ]
  || #c0 #Hhalt <step_lift_confL //
  | #x <p_halt_liftL %
  |6:cases outc1 #s1 #t1 %
  |7:@(loop_lift … (initc ?? (ctape … outc1)) … Hloop2) 
    [ * #s2 #t2 %
    | #c0 #Hhalt <step_lift_confR // ]
  |whd in ⊢ (??(???%)?);whd in ⊢ (??%?);
   generalize in match Hloop1; cases outc1 #sc1 #tc1 #Hloop10 
   >(trans_liftL_true sig M1 M2 ??) 
    [ whd in ⊢ (??%?); whd in ⊢ (???%);
      @config_eq whd in ⊢ (???%); //
    | @(loop_Some ?????? Hloop10) ]
 ]
| @(ex_intro … (ctape ? (FinSum (states ? M1) (states ? M2)) (lift_confL … outc1)))
  % // >eq_ctape_lift_conf_L >eq_ctape_lift_conf_R //
]
qed.

