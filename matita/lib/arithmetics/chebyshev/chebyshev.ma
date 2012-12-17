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

include "arithmetics/log.ma".
include "arithmetics/big_pi.ma". 
include "arithmetics/ord.ma".

(* include "nat/factorization.ma".
include "nat/factorial2.ma".
include "nat/o.ma". *)

(* (prim n) counts the number of prime numbers up to n included *)
definition prim ≝ λn. ∑_{i < S n | primeb i} 1.

lemma le_prim_n: ∀n. prim n ≤ n.
#n elim n // -n #n #H
whd in ⊢ (?%?); cases (primeb (S n)) whd in ⊢ (?%?);
  [@le_S_S @H |@le_S @H]
qed.

lemma not_prime_times_2: ∀n. 1 < n → ¬prime (2*n).
#n #ltn % * #H #H1 @(absurd (2 = 2*n))
  [@H1 // %{n} //
  |@lt_to_not_eq >(times_n_1 2) in ⊢ (?%?); @monotonic_lt_times_r //
  ]
qed.

theorem eq_prim_prim_pred: ∀n. 1 < n → 
  prim (2*n) = prim (pred (2*n)).
#n #ltn 
lapply (S_pred (2*n) ?) [>(times_n_1 0) in ⊢ (?%?); @lt_times //] #H2n
lapply (not_prime_times_2 n ltn) #notp2n
whd in ⊢ (??%?); >(not_prime_to_primeb_false … notp2n) whd in ⊢ (??%?);
<H2n in ⊢ (??%?); % 
qed.

theorem le_prim_n1: ∀n. 4 ≤ n → 
  prim (S(2*n)) ≤ n.
#n #le4 elim le4 -le4
  [@le_n
  |#m #le4 cut (S (2*m) = pred (2*(S m))) [normalize //] #Heq >Heq
   <eq_prim_prim_pred [2: @le_S_S @(transitive_le … le4) //] 
   #H whd in ⊢ (?%?); cases (primeb (S (2*S m))) 
    [@le_S_S @H |@le_S @H]
  ]
qed.
    
(* usefull to kill a successor in bertrand *) 
theorem le_prim_n2: ∀n. 7 ≤ n → prim (S(2*n)) ≤ pred n.
#n #le7 elim le7 -le7
  [@le_n
  |#m #le7 cut (S (2*m) = pred (2*(S m))) [normalize //] #Heq >Heq
   <eq_prim_prim_pred [2: @le_S_S @(transitive_le … le7) //] 
   #H whd in ⊢ (?%?); 
   whd in ⊢ (??%); <(S_pred m) in ⊢ (??%); [2: @(transitive_le … le7) //]
   cases (primeb (S (2*S m))) [@le_S_S @H |@le_S @H]
  ]
qed.

lemma even_or_odd: ∀n.∃a.n=2*a ∨ n = S(2*a).
#n elim n -n 
  [%{0} %1 %
  |#n * #a * #Hn [%{a} %2 @eq_f @Hn | %{(S a)} %1 >Hn normalize //
  ]
qed.

(* axiom daemon : ∀P:Prop.P. *)

(* la prova potrebbe essere migliorata *)
theorem le_prim_n3: ∀n. 15 ≤ n →
  prim n ≤ pred (n/2).
#n #len cases (even_or_odd (pred n)) #a * #Hpredn
  [cut (n = S (2*a)) [<Hpredn @sym_eq @S_pred @(transitive_le … len) //] #Hn
   >Hn @(transitive_le ? (pred a))
    [@le_prim_n2 @(le_times_to_le 2) [//|@le_S_S_to_le <Hn @len]
    |@monotonic_pred @le_times_to_le_div //
    ]
  |cut (n = (2*S a)) 
    [normalize normalize in Hpredn:(???%); <plus_n_Sm <Hpredn @sym_eq @S_pred
     @(transitive_le … len) //] #Hn 
   >Hn @(transitive_le ? (pred a)) 
    [>eq_prim_prim_pred 
      [2:@(lt_times_n_to_lt_r 2) <Hn @(transitive_le … len) //]
     <Hn >Hpredn @le_prim_n2 @le_S_S_to_le @(lt_times_n_to_lt_r 2) <Hn @len
    |@monotonic_pred @le_times_to_le_div //
    ]
  ]
qed. 

(* This is chebishev psi function *)
definition A: nat → nat ≝
  λn.∏_{p < S n | primeb p} (exp p (log p n)).
  
definition psi_def : ∀n. 
  A n = ∏_{p < S n | primeb p} (exp p (log p n)).
// qed.

theorem le_Al1: ∀n.
  A n ≤ ∏_{p < S n | primeb p} n.
#n cases n [@le_n |#m @le_pi #i #_ #_ @le_exp_log //]
qed.

theorem le_Al: ∀n. A n ≤ exp n (prim n).
#n <exp_sigma @le_Al1
qed.

theorem leA_r2: ∀n.
  exp n (prim n) ≤ A n * A n.
#n elim (le_to_or_lt_eq ?? (le_O_n n)) #Hn
  [<(exp_sigma (S n) n primeb) <times_pi
   @le_pi #i #lti #primei 
   cut (1<n) 
     [@(lt_to_le_to_lt … (le_S_S_to_le … lti)) @prime_to_lt_SO 
      @primeb_true_to_prime //] #lt1n
   <exp_plus_times
   @(transitive_le ? (exp i (S(log i n))))
    [@lt_to_le @lt_exp_log @prime_to_lt_SO @primeb_true_to_prime //
    |@le_exp 
      [@prime_to_lt_O @primeb_true_to_prime //
      |>(plus_n_O (log i n)) in ⊢ (?%?); >plus_n_Sm
       @monotonic_le_plus_r @lt_O_log //
       @le_S_S_to_le //
      ]
    ]
  |<Hn @le_n
  ]
qed.

(* an equivalent formulation for psi *)
definition A': nat → nat ≝
λn. ∏_{p < S n | primeb p} (∏_{i < log p n} p).

lemma Adef: ∀n. A' n = ∏_{p < S n | primeb p} (∏_{i < log p n} p).
// qed-.

theorem eq_A_A': ∀n.A n = A' n.
#n @same_bigop // #i #lti #primebi
@(trans_eq ? ? (exp i (∑_{x < log i n} 1)))
  [@eq_f @sym_eq @sigma_const
  |@sym_eq @exp_sigma
  ]
qed.

theorem eq_pi_p_primeb_divides_b: ∀n,m.
∏_{p<n | primeb p ∧ dividesb p m} (exp p (ord m p))
  = ∏_{p<n | primeb p} (exp p (ord m p)).
#n #m elim n // #n1 #Hind cases (true_or_false (primeb n1)) #Hprime
  [>bigop_Strue in ⊢ (???%); //
   cases (true_or_false (dividesb n1 m)) #Hdivides
    [>bigop_Strue [@eq_f @Hind| @true_to_andb_true //]
  |>bigop_Sfalse
    [>not_divides_to_ord_O
      [whd in ⊢ (???(?%?)); //
      |@dividesb_false_to_not_divides //
      |@primeb_true_to_prime // 
      ]
    |>Hprime >Hdivides % 
    ]
  ]
|>bigop_Sfalse [>bigop_Sfalse // |>Hprime %]
]
qed.

(* integrations to minimization *)
theorem false_to_lt_max: ∀f,n,m.O < n →
  f n = false → max m f ≤ n → max m f < n.
#f #n #m #posn #Hfn #Hmax cases (le_to_or_lt_eq ?? Hmax) -Hmax #Hmax 
  [//
  |cases (exists_max_forall_false f m)
    [* #_ #Hfmax @False_ind @(absurd ?? not_eq_true_false) //
    |* //
    ]
  ]
qed.

(* boh ...
theorem lt_max_to_false : ∀f,n,m. 
  max n f < m → m ≤ n → f m = false.
#f #n elim n
  [#m #H1 #H2 @False_ind @(absurd ? H2) @lt_to_not_le //
  |#n1 #Hind #m whd in ⊢ (?%?→?); #Hmax #ltm 
elim (max_S_max f n1); in H1 ⊢ %.
elim H1.
absurd (m \le S n1).assumption.
apply lt_to_not_le.rewrite < H5.assumption.
elim H1.
apply (le_n_Sm_elim m n1 H2).
intro.
apply H.rewrite < H5.assumption.
apply le_S_S_to_le.assumption.
intro.rewrite > H6.assumption.
qed. *)

(* integrations to minimization *)
lemma lt_1_max_prime: ∀n. 1 <  n → 
  1 < max (S n) (λi:nat.primeb i∧dividesb i n).
#n #lt1n
@(lt_to_le_to_lt ? (smallest_factor n))
  [@lt_SO_smallest_factor //
  |@true_to_le_max
    [@le_S_S @le_smallest_factor_n
    |@true_to_andb_true
      [@prime_to_primeb_true @prime_smallest_factor_n //
      |@divides_to_dividesb_true
        [@lt_O_smallest_factor @lt_to_le //
        |@divides_smallest_factor_n @lt_to_le //
        ]
      ]
    ]
  ]
qed. 

theorem lt_max_to_pi_p_primeb: ∀q,m. O<m → max (S m) (λi.primeb i ∧ dividesb i m)<q →
  m = ∏_{p < q | primeb p ∧ dividesb p m} (exp p (ord m p)).
#q elim q
  [#m #posm #Hmax normalize @False_ind @(absurd … Hmax (not_le_Sn_O ?))
  |#n #Hind #m #posm #Hmax 
   cases (true_or_false (primeb n∧dividesb n m)) #Hcase
    [>bigop_Strue
      [>(exp_ord n m … posm) in ⊢ (??%?);
        [@eq_f >(Hind (ord_rem m n))
          [@same_bigop
            [#x #ltxn cases (true_or_false (primeb x)) #Hx >Hx
              [cases (true_or_false (dividesb x (ord_rem m n))) #Hx1 >Hx1
                [@sym_eq @divides_to_dividesb_true
                  [@prime_to_lt_O @primeb_true_to_prime //
                  |@(transitive_divides ? (ord_rem m n))
                    [@dividesb_true_to_divides //
                    |@(divides_ord_rem … posm) @(transitive_lt … ltxn) 
                     @prime_to_lt_SO @primeb_true_to_prime //
                    ]
                  ]
                |@sym_eq @not_divides_to_dividesb_false
                  [@prime_to_lt_O @primeb_true_to_prime //
                  |@(ord_O_to_not_divides … posm)
                    [@primeb_true_to_prime //
                    |<(ord_ord_rem n … posm … ltxn)
                      [@not_divides_to_ord_O
                        [@primeb_true_to_prime //
                        |@dividesb_false_to_not_divides //
                        ]
                      |@primeb_true_to_prime //
                      |@primeb_true_to_prime @(andb_true_l ?? Hcase)
                      ]
                    ]
                  ]
                ]
              |//
              ]
            |#x #ltxn #Hx @eq_f @ord_ord_rem //
              [@primeb_true_to_prime @(andb_true_l ? ? Hcase)
              |@primeb_true_to_prime @(andb_true_l ? ? Hx)
              ]
            ]
          |@not_eq_to_le_to_lt
            [elim (exists_max_forall_false (λi:nat.primeb i∧dividesb i (ord_rem m n)) (S(ord_rem m n)))
              [* #Hex #Hord_rem cases Hex #x * #H6 #H7 % #H 
               >H in Hord_rem; #Hn @(absurd ?? (not_divides_ord_rem m n posm ?))
                [@dividesb_true_to_divides @(andb_true_r ?? Hn)
                |@prime_to_lt_SO @primeb_true_to_prime @(andb_true_l ?? Hn)
                ]
              |* #Hall #Hmax >Hmax @lt_to_not_eq @prime_to_lt_O
               @primeb_true_to_prime @(andb_true_l ?? Hcase)
              ]
            |@(transitive_le ? (max (S m) (λi:nat.primeb i∧dividesb i (ord_rem m n))))
              [@le_to_le_max @le_S_S @(divides_to_le … posm) @(divides_ord_rem … posm)
               @prime_to_lt_SO @primeb_true_to_prime @(andb_true_l ?? Hcase)
              |@(transitive_le ? (max (S m) (λi:nat.primeb i∧dividesb i m)))
                [@le_max_f_max_g #i #ltim #Hi 
                 cases (true_or_false (primeb i)) #Hprimei >Hprimei
                  [@divides_to_dividesb_true
                    [@prime_to_lt_O @primeb_true_to_prime //
                    |@(transitive_divides ? (ord_rem m n))
                      [@dividesb_true_to_divides @(andb_true_r ?? Hi)
                      |@(divides_ord_rem … posm)
                       @prime_to_lt_SO @primeb_true_to_prime
                       @(andb_true_l ?? Hcase)
                      ]
                    ]
                  |>Hprimei in Hi; #Hi @Hi 
                  ]
                |@le_S_S_to_le //
                ]
              ]
            ]
          |@(lt_O_ord_rem … posm) @prime_to_lt_SO
           @primeb_true_to_prime @(andb_true_l ?? Hcase)
          ]
        |@prime_to_lt_SO @primeb_true_to_prime @(andb_true_l ?? Hcase)
        ]
      |//
      ]
    |cases (le_to_or_lt_eq ?? posm) #Hm
      [>bigop_Sfalse
        [@(Hind … posm) @false_to_lt_max
          [@(lt_to_le_to_lt ? (max (S m) (λi:nat.primeb i∧dividesb i m)))
            [@lt_to_le @lt_1_max_prime // 
            |@le_S_S_to_le //
            ]
          |//
          |@le_S_S_to_le //
          ]
        |@Hcase
        ]
      |<Hm 
       <(bigop_false (S n) ? 1 times (λp:nat.p\sup(ord 1 p))) in ⊢ (??%?);
       @same_bigop
        [#i #lein cases (true_or_false (primeb i)) #primei >primei //
         @sym_eq @not_divides_to_dividesb_false
          [@prime_to_lt_O @primeb_true_to_prime //
          |% #divi @(absurd ?? (le_to_not_lt i 1 ?))
            [@prime_to_lt_SO @(primeb_true_to_prime ? primei)
            |@divides_to_le // 
            ]
          ]
        |// 
        ]
      ]
    ]
  ]
qed.

(* factorization of n into primes *)
theorem pi_p_primeb_dividesb: ∀n. O < n → 
  n = ∏_{ p < S n | primeb p ∧ dividesb p n} (exp p (ord n p)).
#n #posn @lt_max_to_pi_p_primeb // @lt_max_n @le_S @posn
qed.

theorem pi_p_primeb: ∀n. O < n → 
  n = ∏_{ p < (S n) | primeb p}(exp p (ord n p)).
#n #posn <eq_pi_p_primeb_divides_b @pi_p_primeb_dividesb //
qed.

theorem le_ord_log: ∀n,p. O < n → 1 < p →
  ord n p ≤ log p n.
#n #p #posn #lt1p >(exp_ord p ? lt1p posn) in ⊢ (??(??%)); 
>log_exp // @lt_O_ord_rem //
qed.

theorem sigma_p_dividesb:
∀m,n,p. O < n → prime p → p ∤ n →
m = ∑_{ i < m | dividesb (p\sup (S i)) ((exp p m)*n)} 1.
#m elim m // -m #m #Hind #n #p #posn #primep #ndivp
>bigop_Strue
  [>commutative_plus <plus_n_Sm @eq_f <plus_n_O
   >(Hind n p posn primep ndivp) in ⊢ (? ? % ?); 
   @same_bigop
    [#i #ltim cases (true_or_false (dividesb (p\sup(S i)) (p\sup m*n))) #Hc >Hc
      [@sym_eq @divides_to_dividesb_true
        [@lt_O_exp @prime_to_lt_O //
        |%{((exp p (m - i))*n)} <associative_times
         <exp_plus_times @eq_f2 // @eq_f normalize @eq_f >commutative_plus 
         @plus_minus_m_m @lt_to_le //
        ]
      |(* @sym_eq *)
       @False_ind @(absurd ?? (dividesb_false_to_not_divides ? ? Hc))
       %{((exp p (m - S i))*n)} <associative_times <exp_plus_times @eq_f2
        [@eq_f >commutative_plus @plus_minus_m_m //
           assumption
        |%
        ]
      ]
    |// 
    ]
  |@divides_to_dividesb_true
    [@lt_O_exp @prime_to_lt_O // | %{n} //]
  ]
qed.
  
theorem sigma_p_dividesb1:
∀m,n,p,k. O < n → prime p → p ∤ n → m ≤ k →
  m = ∑_{i < k | dividesb (p\sup (S i)) ((exp p m)*n)} 1.
#m #n #p #k #posn #primep #ndivp #lemk
lapply (prime_to_lt_SO ? primep) #lt1p
lapply (prime_to_lt_O ? primep) #posp
>(sigma_p_dividesb m n p posn primep ndivp) in ⊢ (??%?);
>(pad_bigop k m) // @same_bigop
  [#i #ltik cases (true_or_false (leb m i)) #Him > Him
    [whd in ⊢(??%?); @sym_eq 
     @not_divides_to_dividesb_false
      [@lt_O_exp //
      |lapply (leb_true_to_le … Him) -Him #Him
       % #Hdiv @(absurd ?? (le_to_not_lt ?? Him))
       (* <(ord_exp p m lt1p) *) >(plus_n_O m)
       <(not_divides_to_ord_O ?? primep ndivp)
       <(ord_exp p m lt1p)
       <ord_times //
        [whd <(ord_exp p (S i) lt1p)
         @divides_to_le_ord //
          [@lt_O_exp // 
          |>(times_n_O O) @lt_times // @lt_O_exp //
          ]
        |@lt_O_exp //
        ]
      ]
    |%
    ]
  |//
  ]
qed.

theorem eq_ord_sigma_p:
∀n,m,x. O < n → prime x → 
exp x m ≤ n → n < exp x (S m) →
ord n x= ∑_{i < m | dividesb (x\sup (S i)) n} 1.
#n #m #x #posn #primex #Hexp #ltn
lapply (prime_to_lt_SO ? primex) #lt1x 
>(exp_ord x n) in ⊢ (???%); // @sigma_p_dividesb1 
  [@lt_O_ord_rem // 
  |//
  |@not_divides_ord_rem // 
  |@le_S_S_to_le @(le_to_lt_to_lt ? (log x n))
    [@le_ord_log // 
    |@(lt_exp_to_lt x)
      [@lt_to_le //
      |@(le_to_lt_to_lt ? n ? ? ltn) @le_exp_log //
      ]
    ]
  ]
qed.
    
theorem pi_p_primeb1: ∀n. O < n → 
n = ∏_{p < S n| primeb p} 
  (∏_{i < log p n| dividesb (exp p (S i)) n} p).
#n #posn >(pi_p_primeb n posn) in ⊢ (??%?);
@same_bigop
  [// 
  |#p #ltp #primep >exp_sigma @eq_f @eq_ord_sigma_p 
    [//
    |@primeb_true_to_prime //
    |@le_exp_log // 
    |@lt_exp_log @prime_to_lt_SO @primeb_true_to_prime //
    ]
  ]
qed.

(* the factorial function *)
theorem eq_fact_pi_p:∀n.
  fact n = ∏_{i < S n | leb 1 i} i.
#n elim n // #n1 #Hind whd in ⊢ (??%?); >commutative_times >bigop_Strue 
  [@eq_f // | % ]
qed.
   
theorem eq_sigma_p_div: ∀n,q.O < q →
  ∑_{ m < S n | leb (S O) m ∧ dividesb q m} 1 =n/q.
#n #q #posq
@(div_mod_spec_to_eq n q ? (n \mod q) ? (n \mod q))
  [@div_mod_spec_intro
    [@lt_mod_m_m // 
    |elim n
      [normalize cases q // 
      |#n1 #Hind cases (or_div_mod1 n1 q posq)
        [* #divq #eqn1  >divides_to_mod_O //
         <plus_n_O >bigop_Strue
          [>eqn1 in ⊢ (??%?); @eq_f2
            [<commutative_plus <plus_n_Sm <plus_n_O @eq_f
             @(div_mod_spec_to_eq n1 q (div n1 q) (mod n1 q) ? (mod n1 q))
              [@div_mod_spec_div_mod //
              |@div_mod_spec_intro [@lt_mod_m_m // | //]
              ]
            |%
            ]
          |@true_to_andb_true [//|@divides_to_dividesb_true //]
          ]
        |* #ndiv #eqn1 >bigop_Sfalse
          [>(mod_S … posq) 
            [< plus_n_Sm @eq_f //
            |cases (le_to_or_lt_eq (S (mod n1 q)) q ?)
              [//
              |#eqq @False_ind cases ndiv #Hdiv @Hdiv
               %{(S(div n1 q))} <times_n_Sm <commutative_plus //
              |@lt_mod_m_m //
              ]
            ]
          |>not_divides_to_dividesb_false //
          ]
        ]
      ]
    ]
  |@div_mod_spec_div_mod //
  ]
qed.

definition Atimes ≝ mk_Aop nat 1 times ???. 
  [#a normalize <plus_n_O % 
  |#a @sym_eq @times_n_1 
  |#a #b #c @sym_eq @associative_times
  ]
qed.

definition ACtimes ≝ mk_ACop nat 1 Atimes commutative_times.         

lemma ACtimesdef: ∀n,m. ACtimes n m = n * m.
// qed-.

(* still another characterization of the factorial *)
theorem fact_pi_p: ∀n. 
fact n = ∏_{ p < S n | primeb p} 
           (∏_{i < log p n} (exp p (n /(exp p (S i))))).
#n >eq_fact_pi_p
@(trans_eq ?? 
  (∏_{m < S n | leb 1 m}
   (∏_{p < S m | primeb p}
    (∏_{i < log p m | dividesb (exp p (S i)) m} p))))
  [@same_bigop [// |#x #Hx1 #Hx2  @pi_p_primeb1 @leb_true_to_le //]
  |@(trans_eq ?? 
    (∏_{m < S n | leb 1 m}
      (∏_{p < S m | primeb p ∧ leb p m}
       (∏_{ i < log p m | dividesb ((p)\sup(S i)) m} p))))
    [@same_bigop
      [//
      |#x #Hx1 #Hx2 @same_bigop
        [#p #ltp >(le_to_leb_true … (le_S_S_to_le …ltp))
         cases (primeb p) //
        |//
        ]
      ]
    |@(trans_eq ?? 
      (∏_{m < S n | leb 1 m}
       (∏_{p < S n | primeb p ∧ leb p m}
         (∏_{i < log p m |dividesb ((p)\sup(S i)) m} p))))
      [@same_bigop
        [//
        |#p #Hp1 #Hp2 @pad_bigop1 
          [@Hp1
          |#i #lti #upi >lt_to_leb_false
            [cases (primeb i) //|@lti]
          ] 
        ]
      |(* make a general theorem *)
       @(trans_eq ?? 
        (∏_{p < S n | primeb p}
          (∏_{m < S n | leb p m}
           (∏_{i < log p m | dividesb (p^(S i)) m} p))))
        [@(bigop_commute … ACtimes … (lt_O_S n) (lt_O_S n))
         #i #j #lti #ltj
         cases (true_or_false (primeb j ∧ leb j i)) #Hc >Hc
          [>(le_to_leb_true 1 i)
            [//
            |@(transitive_le ? j)
              [@prime_to_lt_O @primeb_true_to_prime @(andb_true_l ? ? Hc)
              |@leb_true_to_le @(andb_true_r ?? Hc)
              ]
            ]
          |cases(leb 1 i) // 
          ]
        |@same_bigop
          [//
          |#p #Hp1 #Hp2
           @(trans_eq ?? 
            (∏_{m < S n | leb p m}
             (∏_{i < log p n | dividesb (p\sup(S i)) m} p)))
            [@same_bigop
              [//
              |#x #Hx1 #Hx2 @sym_eq 
               @sym_eq @pad_bigop1
                [@le_log
                  [@prime_to_lt_SO @primeb_true_to_prime //
                  |@le_S_S_to_le //
                  ]
                |#i #Hi1 #Hi2 @not_divides_to_dividesb_false
                  [@lt_O_exp @prime_to_lt_O @primeb_true_to_prime //
                  |@(not_to_not … (lt_to_not_le x (exp p (S i)) ?)) 
                    [#H @divides_to_le // @(lt_to_le_to_lt ? p)
                      [@prime_to_lt_O @primeb_true_to_prime //
                      |@leb_true_to_le //
                      ]
                    |@(lt_to_le_to_lt ? (exp p (S(log p x))))
                      [@lt_exp_log @prime_to_lt_SO @primeb_true_to_prime //
                      |@le_exp
                        [@ prime_to_lt_O @primeb_true_to_prime //
                        |@le_S_S //
                        ]
                      ]
                    ]
                  ]
                ]
              ]
            |@
             (trans_eq ? ? 
              (∏_{i < log p n}
                (∏_{m < S n | leb p m ∧ dividesb (p\sup(S i)) m} p)))
              [@(bigop_commute ?????? nat 1 ACtimes (λm,i.p) ???) //
               cut (p ≤ n) [@le_S_S_to_le //] #lepn 
               @(lt_O_log … lepn) @(lt_to_le_to_lt … lepn) @prime_to_lt_SO 
               @primeb_true_to_prime //
              |@same_bigop
                [//
                |#m #ltm #_ >exp_sigma @eq_f
                 @(trans_eq ?? 
                  (∑_{i < S n |leb 1 i∧dividesb (p\sup(S m)) i} 1))
                  [@same_bigop
                    [#i #lti
                     cases (true_or_false (dividesb (p\sup(S m)) i)) #Hc >Hc 
                      [cases (true_or_false (leb p i)) #Hp3 >Hp3 
                        [>le_to_leb_true 
                          [//
                          |@(transitive_le ? p)
                            [@prime_to_lt_O @primeb_true_to_prime //
                            |@leb_true_to_le //
                            ]
                          ]
                        |>lt_to_leb_false
                          [//
                          |@not_le_to_lt
                           @(not_to_not ??? (leb_false_to_not_le ?? Hp3)) #posi
                           @(transitive_le ? (exp p (S m)))
                            [>(exp_n_1 p) in ⊢ (?%?);
                             @le_exp
                              [@prime_to_lt_O @primeb_true_to_prime //
                              |@le_S_S @le_O_n
                              ]
                            |@(divides_to_le … posi)
                             @dividesb_true_to_divides //
                            ]
                          ]
                        ]
                      |cases (leb p i) cases (leb 1 i) //
                      ]
                    |// 
                    ]
                  |@eq_sigma_p_div @lt_O_exp
                   @prime_to_lt_O @primeb_true_to_prime //
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
qed.

theorem fact_pi_p2: ∀n. fact (2*n) =
∏_{p < S (2*n) | primeb p} 
  (∏_{i < log p (2*n)}
    (exp p (2*(n /(exp p (S i))))*(exp p (mod (2*n /(exp p (S i))) 2)))).
#n >fact_pi_p @same_bigop
  [//
  |#p #ltp #primep @same_bigop
    [//
    |#i #lti #_ <exp_plus_times @eq_f
     >commutative_times in ⊢ (???(?%?));
     cut (0 < p ^ (S i)) 
       [@lt_O_exp @prime_to_lt_O @primeb_true_to_prime //]
     generalize in match (p ^(S i)); #a #posa
     >(div_times_times n a 2) // >(commutative_times n 2)
     <eq_div_div_div_times //
    ]
  ]
qed.

theorem fact_pi_p3: ∀n. fact (2*n) =
∏_{p < S (2*n) | primeb p}
  (∏_{i < log p (2*n)}(exp p (2*(n /(exp p (S i)))))) *
∏_{p < S (2*n) | primeb p}
  (∏_{i < log p (2*n)}(exp p (mod (2*n /(exp p (S i))) 2))).
#n <times_pi >fact_pi_p2 @same_bigop
  [// 
  |#p #ltp #primep @times_pi
  ]
qed.

theorem pi_p_primeb4: ∀n. 1 < n →
∏_{p < S (2*n) | primeb p} 
  (∏_{i < log p (2*n)}(exp p (2*(n /(exp p (S i))))))
= 
∏_{p < S n | primeb p}
  (∏_{i < log p (2*n)}(exp p (2*(n /(exp p (S i)))))).
#n #lt1n
@sym_eq @(pad_bigop_nil … ACtimes)
  [@le_S_S /2 by /
  |#i #ltn #lti %2
   >log_i_2n //
    [>bigop_Strue // whd in ⊢ (??(??%)?); <times_n_1
     <exp_n_1 >eq_div_O //
    |@le_S_S_to_le // 
    ]
  ]
qed.
   
theorem pi_p_primeb5: ∀n. 1 < n →
∏_{p < S (2*n) | primeb p}
  (∏_{i < log p (2*n)} (exp p (2*(n /(exp p (S i))))))
= 
∏_{p < S n | primeb p} 
  (∏_{i < log p n} (exp p (2*(n /(exp p (S i)))))).
#n #lt1n >(pi_p_primeb4 ? lt1n) @same_bigop
  [//
  |#p #lepn #primebp @sym_eq @(pad_bigop_nil … ACtimes) 
    [@le_log
      [@prime_to_lt_SO @primeb_true_to_prime //
      |// 
      ]
    |#i #lelog #lti %2 >eq_div_O //
     @(lt_to_le_to_lt ? (exp p (S(log p n))))
      [@lt_exp_log @prime_to_lt_SO @primeb_true_to_prime //
      |@le_exp
        [@prime_to_lt_O @primeb_true_to_prime // |@le_S_S //]      
      ]
    ]
  ]
qed.

theorem exp_fact_2: ∀n.
exp (fact n) 2 = 
  ∏_{p < S n| primeb p}
    (∏_{i < log p n} (exp p (2*(n /(exp p (S i)))))).
#n >fact_pi_p <exp_pi @same_bigop
  [//
  |#p #ltp #primebp @sym_eq 
   @(trans_eq ?? (∏_{x < log p n} (exp (exp p (n/(exp p (S x)))) 2)))
  [@same_bigop
    [//
    |#x #ltx #_ @sym_eq >commutative_times @exp_exp_times
    ]
  |@exp_pi
  ]
qed.

definition B ≝ λn.
∏_{p < S n | primeb p} 
  (∏_{i < log p n} (exp p (mod (n /(exp p (S i))) 2))).
  
lemma Bdef : ∀n.B n = 
  ∏_{p < S n | primeb p} 
  (∏_{i < log p n} (exp p (mod (n /(exp p (S i))) 2))).
// qed-.

example B_SSSO: B 3 = 6. //
qed.

example B_SSSSO: B 4 = 6. //
qed.

example B_SSSSSO: B 5 = 30. //
qed.

example B_SSSSSSO: B 6 = 20. //
qed.

example B_SSSSSSSO: B 7 = 140. //
qed.

example B_SSSSSSSSO: B 8 = 70. //
qed.

theorem eq_fact_B:∀n. 1 < n →
  (2*n)! = exp (n!) 2 * B(2*n).
#n #lt1n >fact_pi_p3 @eq_f2
  [@sym_eq >pi_p_primeb5 [@exp_fact_2|//] |// ]
qed.

theorem le_B_A: ∀n. B n ≤ A n.
#n >eq_A_A' @le_pi #p #ltp #primep
@le_pi #i #lti #_ >(exp_n_1 p) in ⊢ (??%); @le_exp
  [@prime_to_lt_O @primeb_true_to_prime //
  |@le_S_S_to_le @lt_mod_m_m @lt_O_S
  ]
qed.

theorem le_B_A4: ∀n. O < n → 2 * B (4*n) ≤ A (4*n).
#n #posn >eq_A_A'
cut (2 < (S (4*n)))
  [@le_S_S >(times_n_1 2) in ⊢ (?%?); @le_times //] #H2
cut (O<log 2 (4*n))
  [@lt_O_log [@le_S_S_to_le @H2 |@le_S_S_to_le @H2]] #Hlog
>Bdef >(bigop_diff ??? ACtimes ? 2 ? H2) [2:%]
>Adef >(bigop_diff ??? ACtimes ? 2 ? H2) in ⊢ (??%); [2:%]
<associative_times @le_times
  [>(bigop_diff ??? ACtimes ? 0 ? Hlog) [2://]
   >(bigop_diff ??? ACtimes ? 0 ? Hlog) in ⊢ (??%); [2:%]
   <associative_times >ACtimesdef @le_times 
    [<exp_n_1 cut (4=2*2) [//] #H4 >H4 >associative_times
     >commutative_times in ⊢ (?(??(??(?(?%?)?)))?);
     >div_times [2://] >divides_to_mod_O
      [@le_n |%{n} // |@lt_O_S]
    |@le_pi #i #lti #H >(exp_n_1 2) in ⊢ (??%);
     @le_exp [@lt_O_S |@le_S_S_to_le @lt_mod_m_m @lt_O_S]
    ]
  |@le_pi #p #ltp #Hp @le_pi #i #lti #H
   >(exp_n_1 p) in ⊢ (??%); @le_exp
    [@prime_to_lt_O @primeb_true_to_prime @(andb_true_r ?? Hp)
    |@le_S_S_to_le @lt_mod_m_m @lt_O_S
    ]
  ]
qed.

(* not usefull    
theorem le_fact_A:\forall n.S O < n \to
fact (2*n) \le exp (fact n) 2 * A (2*n).
intros.
rewrite > eq_fact_B
  [apply le_times_r.
   apply le_B_A
  |assumption
  ]
qed. *)

theorem lt_SO_to_le_B_exp: ∀n. 1 < n →
  B (2*n) ≤ exp 2 (pred (2*n)).
#n #lt1n @(le_times_to_le (exp (fact n) 2))
  [@lt_O_exp //
  |<(eq_fact_B … lt1n) <commutative_times in ⊢ (??%);
   >exp_2 <associative_times @fact_to_exp 
  ]
qed.

theorem le_B_exp: ∀n.
  B (2*n) ≤ exp 2 (pred (2*n)).
#n cases n
  [@le_n|#n1 cases n1 [@le_n |#n2 @lt_SO_to_le_B_exp @le_S_S @lt_O_S]]
qed.

theorem lt_4_to_le_B_exp: ∀n.4 < n →
  B (2*n) \le exp 2 ((2*n)-2).
#n #lt4n @(le_times_to_le (exp (fact n) 2))
  [@lt_O_exp //
  |<eq_fact_B
    [<commutative_times in ⊢ (??%); >exp_2 <associative_times
     @lt_4_to_fact //
    |@lt_to_le @lt_to_le @lt_to_le //
    ]
  ]
qed.

theorem lt_1_to_le_exp_B: ∀n. 1 < n →
  exp 2 (2*n) ≤ 2 * n * B (2*n).
#n #lt1n 
@(le_times_to_le (exp (fact n) 2))
  [@lt_O_exp @le_1_fact
  |<associative_times in ⊢ (??%); >commutative_times in ⊢ (??(?%?));
   >associative_times in ⊢ (??%); <(eq_fact_B … lt1n)
   <commutative_times; @exp_to_fact2 @lt_to_le // 
  ]
qed.

theorem le_exp_B: ∀n. O < n →
  exp 2 (2*n) ≤ 2 * n * B (2*n).
#n #posn cases posn
  [@le_n |#m #lt1m @lt_1_to_le_exp_B @le_S_S // ]
qed.

let rec bool_to_nat b ≝ 
  match b with [true ⇒ 1 | false ⇒ 0].
  
theorem eq_A_2_n: ∀n.O < n →
A(2*n) =
 ∏_{p <S (2*n) | primeb p}
  (∏_{i <log p (2*n)} (exp p (bool_to_nat (leb (S n) (exp p (S i)))))) *A n.
#n #posn >eq_A_A' > eq_A_A' 
cut (
 ∏_{p < S n | primeb p} (∏_{i <log p n} p)
 = ∏_{p < S (2*n) | primeb p}
     (∏_{i <log p (2*n)} (p\sup(bool_to_nat (¬ (leb (S n) (exp p (S i))))))))
  [2: #Hcut >Adef in ⊢ (???%); >Hcut
   <times_pi >Adef @same_bigop
    [//
    |#p #lt1p #primep <times_pi @same_bigop
      [//
      |#i #lt1i #_ cases (true_or_false (leb (S n) (exp p (S i)))) #Hc >Hc
        [normalize <times_n_1 >plus_n_O //
        |normalize <plus_n_O <plus_n_O //
        ]
      ]
    ]
  |@(trans_eq ?? 
    (∏_{p < S n | primeb p} 
      (∏_{i < log p n} (p \sup(bool_to_nat (¬leb (S n) (exp p (S i))))))))
    [@same_bigop
      [//
      |#p #lt1p #primep @same_bigop
        [//
        |#i #lti#_ >lt_to_leb_false
          [normalize @plus_n_O
          |@le_S_S @(transitive_le ? (exp p (log p n)))
            [@le_exp [@prime_to_lt_O @primeb_true_to_prime //|//]
            |@le_exp_log //
            ]
          ]
        ]
      ]
    |@(trans_eq ?? 
      (∏_{p < S (2*n) | primeb p}
       (∏_{i <log p n} (p \sup(bool_to_nat (¬leb (S n) (p \sup(S i))))))))
      [@(pad_bigop_nil … Atimes)
        [@le_S_S //|#i #lti #upi %2 >lt_to_log_O //]
      |@same_bigop 
        [//
        |#p #ltp #primep @(pad_bigop_nil … Atimes)
          [@le_log
            [@prime_to_lt_SO @primeb_true_to_prime //|//]
          |#i #lei #iup %2 >le_to_leb_true
            [%
            |@(lt_to_le_to_lt ? (exp p (S (log p n))))
              [@lt_exp_log @prime_to_lt_SO @primeb_true_to_prime //
              |@le_exp
                [@prime_to_lt_O @primeb_true_to_prime //
                |@le_S_S //
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
qed.
               
theorem le_A_BA1: ∀n. O < n → 
  A(2*n) ≤ B(2*n)*A n.
#n #posn >(eq_A_2_n … posn) @le_times [2:@le_n]
>Bdef @le_pi #p #ltp #primep @le_pi #i #lti #_ @le_exp
  [@prime_to_lt_O @primeb_true_to_prime //
  |cases (true_or_false (leb (S n) (exp p (S i)))) #Hc >Hc
    [whd in ⊢ (?%?);
     cut (2*n/p\sup(S i) = 1) [2: #Hcut >Hcut @le_n]
     @(div_mod_spec_to_eq (2*n) (exp p (S i)) 
       ? (mod (2*n) (exp p (S i))) ? (minus (2*n) (exp p (S i))) )
      [@div_mod_spec_div_mod @lt_O_exp @prime_to_lt_O @primeb_true_to_prime //
      |cut (p\sup(S i)≤2*n)
        [@(transitive_le ? (exp p (log p (2*n))))
          [@le_exp [@prime_to_lt_O @primeb_true_to_prime // | //]
          |@le_exp_log >(times_n_O O) in ⊢ (?%?); @lt_times // 
          ]
        ] #Hcut
       @div_mod_spec_intro
        [@lt_plus_to_minus
          [// |normalize in ⊢ (? % ?); < plus_n_O @lt_plus @leb_true_to_le //]
        |>commutative_plus >commutative_times in ⊢ (???(??%));
         < times_n_1 @plus_minus_m_m //
        ]
      ]
    |@le_O_n
    ]
  ]
qed.

theorem le_A_BA: ∀n. A(2*n) \le B(2*n)*A n.
#n cases n [@le_n |#m @le_A_BA1 @lt_O_S]
qed.

theorem le_A_exp: ∀n. A(2*n) ≤ (exp 2 (pred (2*n)))*A n.
#n @(transitive_le ? (B(2*n)*A n))
  [@le_A_BA |@le_times [@le_B_exp |//]]
qed.

theorem lt_4_to_le_A_exp: ∀n. 4 < n →
  A(2*n) ≤ exp 2 ((2*n)-2)*A n.
#n #lt4n @(transitive_le ? (B(2*n)*A n))
  [@le_A_BA|@le_times [@(lt_4_to_le_B_exp … lt4n) |@le_n]]
qed.

(* two technical lemmas *)
lemma times_2_pred: ∀n. 2*(pred n) \le pred (2*n).
#n cases n
  [@le_n|#m @monotonic_le_plus_r @le_n_Sn]
qed.

lemma le_S_times_2: ∀n. O < n → S n ≤ 2*n.
#n #posn elim posn
  [@le_n
  |#m #posm #Hind 
   cut (2*(S m) = S(S(2*m))) [normalize <plus_n_Sm //] #Hcut >Hcut
   @le_S_S @(transitive_le … Hind) @le_n_Sn
  ]
qed.

theorem le_A_exp1: ∀n.
  A(exp 2 n) ≤ exp 2 ((2*(exp 2 n)-(S(S n)))).
#n elim n
  [@le_n
  |#n1 #Hind whd in ⊢ (?(?%)?); >commutative_times 
   @(transitive_le ??? (le_A_exp ?)) 
   @(transitive_le ? (2\sup(pred (2*2^n1))*2^(2*2^n1-(S(S n1)))))
    [@monotonic_le_times_r // 
    |<exp_plus_times @(le_exp … (lt_O_S ?))
     cut (S(S n1) ≤ 2*(exp 2 n1))
      [elim n1
        [@le_n
        |#n2 >commutative_times in ⊢ (%→?); #Hind1 @(transitive_le ? (2*(S(S n2))))
          [@le_S_times_2 @lt_O_S |@monotonic_le_times_r //] 
        ]
      ] #Hcut
     @le_S_S_to_le cut(∀a,b. S a + b = S (a+b)) [//] #Hplus <Hplus >S_pred
      [>eq_minus_S_pred in ⊢ (??%); >S_pred
        [>plus_minus_commutative
          [@monotonic_le_minus_l
           cut (∀a. 2*a = a + a) [//] #times2 <times2 
           @monotonic_le_times_r >commutative_times @le_n
          |@Hcut
          ]
        |@lt_plus_to_minus_r whd in ⊢ (?%?);
         @(lt_to_le_to_lt ? (2*(S(S n1))))
          [>(times_n_1 (S(S n1))) in ⊢ (?%?); >commutative_times
           @monotonic_lt_times_l [@lt_O_S |@le_n]
          |@monotonic_le_times_r whd in ⊢ (??%); //
          ]
        ]
      |whd >(times_n_1 1) in ⊢ (?%?); @le_times
        [@le_n_Sn |@lt_O_exp @lt_O_S]
      ]
    ]
  ]
qed.

theorem monotonic_A: monotonic nat le A.
#n #m #lenm elim lenm
  [@le_n
  |#n1 #len #Hind @(transitive_le … Hind)
   cut (∏_{p < S n1 | primeb p}(p^(log p n1))
          ≤∏_{p < S n1 | primeb p}(p^(log p (S n1))))
    [@le_pi #p #ltp #primep @le_exp
      [@prime_to_lt_O @primeb_true_to_prime //
      |@le_log [@prime_to_lt_SO @primeb_true_to_prime // | //]
      ]
    ] #Hcut
   >psi_def in ⊢ (??%); cases (true_or_false (primeb (S n1))) #Hc
    [>bigop_Strue in ⊢ (??%); [2://]
     >(times_n_1 (A n1)) >commutative_times @le_times
      [@lt_O_exp @lt_O_S |@Hcut]
    |>bigop_Sfalse in ⊢ (??%); // 
    ]
  ]
qed.

(*
theorem le_A_exp2: \forall n. O < n \to
A(n) \le (exp (S(S O)) ((S(S O)) * (S(S O)) * n)).
intros.
apply (trans_le ? (A (exp (S(S O)) (S(log (S(S O)) n)))))
  [apply monotonic_A.
   apply lt_to_le.
   apply lt_exp_log.
   apply le_n
  |apply (trans_le ? ((exp (S(S O)) ((S(S O))*(exp (S(S O)) (S(log (S(S O)) n)))))))
    [apply le_A_exp1
    |apply le_exp
      [apply lt_O_S
      |rewrite > assoc_times.apply le_times_r.
       change with ((S(S O))*((S(S O))\sup(log (S(S O)) n))≤(S(S O))*n).
       apply le_times_r.
       apply le_exp_log.
       assumption
      ]
    ]
  ]
qed.
*)

(* example *)
example A_1: A 1 = 1. // qed.

example A_2: A 2 = 2. // qed.

example A_3: A 3 = 6. // qed.

example A_4: A 4 = 12. // qed.

(*
(* a better result *)
theorem le_A_exp3: \forall n. S O < n \to
A(n) \le exp (pred n) (2*(exp 2 (2 * n)).
intro.
apply (nat_elim1 n).
intros.
elim (or_eq_eq_S m).
elim H2
  [elim (le_to_or_lt_eq (S O) a)
    [rewrite > H3 in ⊢ (? % ?).
     apply (trans_le ? ((exp (S(S O)) ((S(S O)*a)))*A a))
      [apply le_A_exp
      |apply (trans_le ? (((S(S O)))\sup((S(S O))*a)*
         ((pred a)\sup((S(S O)))*((S(S O)))\sup((S(S O))*a))))
        [apply le_times_r.
         apply H
          [rewrite > H3.
           rewrite > times_n_SO in ⊢ (? % ?).
           rewrite > sym_times.
           apply lt_times_l1
            [apply lt_to_le.assumption
            |apply le_n
            ]
          |assumption
          ]
        |rewrite > sym_times.
         rewrite > assoc_times.
         rewrite < exp_plus_times.
         apply (trans_le ? 
          (pred a\sup((S(S O)))*(S(S O))\sup(S(S O))*(S(S O))\sup((S(S O))*m)))
          [rewrite > assoc_times.
           apply le_times_r.
           rewrite < exp_plus_times.
           apply le_exp
            [apply lt_O_S
            |rewrite < H3.
             simplify.
             rewrite < plus_n_O.
             apply le_S.apply le_S.
             apply le_n
            ]
          |apply le_times_l.
           rewrite > times_exp.
           apply monotonic_exp1.
           rewrite > H3.
           rewrite > sym_times.
           cases a
            [apply le_n
            |simplify.
             rewrite < plus_n_Sm.
             apply le_S.
             apply le_n
            ]
          ]
        ]
      ]
    |rewrite < H4 in H3.
     simplify in H3.
     rewrite > H3.
     simplify.
     apply le_S_S.apply le_S_S.apply le_O_n
    |apply not_lt_to_le.intro.
     apply (lt_to_not_le ? ? H1).
     rewrite > H3.
     apply (le_n_O_elim a)
      [apply le_S_S_to_le.assumption
      |apply le_O_n
      ]
    ]
  |elim (le_to_or_lt_eq O a (le_O_n ?))
    [apply (trans_le ? (A ((S(S O))*(S a))))
      [apply monotonic_A.
       rewrite > H3.
       rewrite > times_SSO.
       apply le_n_Sn
      |apply (trans_le ? ((exp (S(S O)) ((S(S O)*(S a))))*A (S a)))
        [apply le_A_exp
        |apply (trans_le ? (((S(S O)))\sup((S(S O))*S a)*
           (a\sup((S(S O)))*((S(S O)))\sup((S(S O))*(S a)))))
          [apply le_times_r.
           apply H
            [rewrite > H3.
             apply le_S_S.
             simplify.
             rewrite > plus_n_SO.
             apply le_plus_r.
             rewrite < plus_n_O.
             assumption
            |apply le_S_S.assumption
            ]
          |rewrite > sym_times.
           rewrite > assoc_times.
           rewrite < exp_plus_times.
           apply (trans_le ? 
            (a\sup((S(S O)))*(S(S O))\sup(S(S O))*(S(S O))\sup((S(S O))*m)))
            [rewrite > assoc_times.
             apply le_times_r.
             rewrite < exp_plus_times.
             apply le_exp
              [apply lt_O_S
              |rewrite > times_SSO.
               rewrite < H3.
               simplify.
               rewrite < plus_n_Sm.
               rewrite < plus_n_O.
               apply le_n
              ]
            |apply le_times_l.
             rewrite > times_exp.
             apply monotonic_exp1.
             rewrite > H3.
             rewrite > sym_times.
             apply le_n
            ]
          ]
        ]
      ]
    |rewrite < H4 in H3.simplify in H3.
     apply False_ind.
     apply (lt_to_not_le ? ? H1).
     rewrite > H3.
     apply le_
    ]
  ]
qed.
*)

theorem le_A_exp4: ∀n. 1 < n →
  A(n) ≤ (pred n)*exp 2 ((2 * n) -3).
#n @(nat_elim1 n)
#m #Hind cases (even_or_odd m)
#a * #Hm >Hm #Hlt
  [cut (0<a) 
    [cases a in Hlt; 
      [whd in ⊢ (??%→?); #lt10 @False_ind @(absurd ? lt10 (not_le_Sn_O 1))
    |#b #_ //]
    ] #Hcut 
   cases (le_to_or_lt_eq … Hcut) #Ha
    [@(transitive_le ? (exp 2 (pred(2*a))*A a))
      [@le_A_exp
      |@(transitive_le ? (2\sup(pred(2*a))*((pred a)*2\sup((2*a)-3))))
        [@monotonic_le_times_r @(Hind ?? Ha)
         >Hm >(times_n_1 a) in ⊢ (?%?); >commutative_times
         @monotonic_lt_times_l [@lt_to_le // |@le_n]
        |<Hm <associative_times >commutative_times in ⊢ (?(?%?)?);
         >associative_times; @le_times
          [>Hm cases a[@le_n|#b normalize @le_plus_n_r]
          |<exp_plus_times @le_exp
            [@lt_O_S
            |@(transitive_le ? (m+(m-3)))
              [@monotonic_le_plus_l // 
              |normalize <plus_n_O >plus_minus_commutative
                [@le_n
                |>Hm @(transitive_le ? (2*2) ? (le_n_Sn 3))
                 @monotonic_le_times_r //
                ]
              ]
            ]
          ]
        ]
      ]
    |<Ha normalize @le_n
    ]
  |cases (le_to_or_lt_eq O a (le_O_n ?)) #Ha
    [@(transitive_le ? (A (2*(S a))))
      [@monotonic_A >Hm normalize <plus_n_Sm @le_n_Sn
      |@(transitive_le … (le_A_exp ?) ) 
       @(transitive_le ? ((2\sup(pred (2*S a)))*(a*(exp 2 ((2*(S a))-3)))))
        [@monotonic_le_times_r @Hind
          [>Hm @le_S_S >(times_n_1 a) in ⊢ (?%?); >commutative_times
           @monotonic_lt_times_l //
          |@le_S_S //
          ]
        |cut (pred (S (2*a)) = 2*a) [//] #Spred >Spred
         cut (pred (2*(S a)) = S (2 * a)) [normalize //] #Spred1 >Spred1
         cut (2*(S a) = S(S(2*a))) [normalize <plus_n_Sm //] #times2 
         cut (exp 2 (2*S a -3) = 2*(exp 2 (S(2*a) -3))) 
          [>(commutative_times 2) in ⊢ (???%); >times2 >minus_Sn_m [%]
           @le_S_S >(times_n_1 2) in ⊢ (?%?); @monotonic_le_times_r @Ha
          ] #Hcut >Hcut
         <associative_times in ⊢ (? (? ? %) ?); <associative_times
         >commutative_times in ⊢ (? (? % ?) ?);
         >commutative_times in ⊢ (? (? (? % ?) ?) ?);
         >associative_times @monotonic_le_times_r
         <exp_plus_times @(le_exp … (lt_O_S ?))
         >plus_minus_commutative
          [normalize >(plus_n_O (a+(a+0))) in ⊢ (?(?(??%)?)?); @le_n
          |@le_S_S >(times_n_1 2) in ⊢ (?%?); @monotonic_le_times_r @Ha
          ]
        ]
      ]
    |@False_ind <Ha in Hlt; normalize #Hfalse @(absurd ? Hfalse) //
    ]
  ]
qed.

theorem le_n_8_to_le_A_exp: ∀n. n ≤ 8 → 
  A(n) ≤ exp 2 ((2 * n) -3).
#n cases n
  [#_ @le_n
  |#n1 cases n1
    [#_ @le_n
    |#n2 cases n2
      [#_ @le_n
      |#n3 cases n3
        [#_ @leb_true_to_le //
        |#n4 cases n4
          [#_ @leb_true_to_le //
          |#n5 cases n5
            [#_ @leb_true_to_le //
            |#n6 cases n6
              [#_ @leb_true_to_le //
              |#n7 cases n7
                [#_ @leb_true_to_le //
                |#n8 cases n8
                  [#_ @leb_true_to_le //
                  |#n9 #H @False_ind @(absurd ?? (lt_to_not_le ?? H))
                   @leb_true_to_le //
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]
qed.
           
theorem le_A_exp5: ∀n. A(n) ≤ exp 2 ((2 * n) -3).
#n @(nat_elim1 n) #m #Hind
cases (decidable_le 9 m)
  [#lem cases (even_or_odd m) #a * #Hm
    [>Hm in ⊢ (?%?); @(transitive_le … (le_A_exp ?))
     @(transitive_le ? (2\sup(pred(2*a))*(2\sup((2*a)-3))))
      [@monotonic_le_times_r @Hind >Hm >(times_n_1 a) in ⊢ (?%?); 
       >commutative_times @(monotonic_lt_times_l  … (le_n ?))
       @(transitive_lt ? 3)
        [@lt_O_S |@(le_times_to_le 2) [@lt_O_S |<Hm @lt_to_le @lem]]
      |<Hm <exp_plus_times @(le_exp … (lt_O_S ?))
       whd in match (times 2 m); >commutative_times <times_n_1
       <plus_minus_commutative
        [@monotonic_le_plus_l @le_pred_n
        |@(transitive_le … lem) @leb_true_to_le //
        ]
      ]
    |@(transitive_le ? (A (2*(S a))))
      [@monotonic_A >Hm normalize <plus_n_Sm @le_n_Sn
      |@(transitive_le ? ((exp 2 ((2*(S a))-2))*A (S a)))
        [@lt_4_to_le_A_exp @le_S_S
         @(le_times_to_le 2)[@le_n_Sn|@le_S_S_to_le <Hm @lem]
        |@(transitive_le ? ((2\sup((2*S a)-2))*(exp 2 ((2*(S a))-3))))
          [@monotonic_le_times_r @Hind >Hm @le_S_S
           >(times_n_1 a) in ⊢ (?%?); 
           >commutative_times @(monotonic_lt_times_l  … (le_n ?))
           @(transitive_lt ? 3)
            [@lt_O_S |@(le_times_to_le 2) [@lt_O_S |@le_S_S_to_le <Hm @lem]]
          |cut (∀a. 2*(S a) = S(S(2*a))) [normalize #a <plus_n_Sm //] #times2
           >times2 <Hm <exp_plus_times @(le_exp … (lt_O_S ?))
           cases m
            [@le_n
            |#n1 cases n1
              [@le_n
              |#n2 normalize <minus_n_O <plus_n_O <plus_n_Sm
               normalize <minus_n_O <plus_n_Sm @le_n
              ]
            ]
          ]
        ]
      ]
    ]
  |#H @le_n_8_to_le_A_exp @le_S_S_to_le @not_le_to_lt //
  ]
qed.       

theorem le_exp_Al:∀n. O < n → exp 2 n ≤ A (2 * n).
#n #posn @(transitive_le ? ((exp 2 (2*n))/(2*n)))
  [@le_times_to_le_div
    [>(times_n_O O) in ⊢ (?%?); @lt_times [@lt_O_S|//]
    |normalize in ⊢ (??(??%)); < plus_n_O >exp_plus_times
     @le_times [2://] elim posn [//]
     #m #le1m #Hind whd in ⊢ (??%); >commutative_times in ⊢ (??%);
     @monotonic_le_times_r @(transitive_le … Hind) 
     >(times_n_1 m) in ⊢ (?%?); >commutative_times 
     @(monotonic_lt_times_l  … (le_n ?)) @le1m
    ]
  |@le_times_to_le_div2
    [>(times_n_O O) in ⊢ (?%?); @lt_times [@lt_O_S|//]
    |@(transitive_le ? ((B (2*n)*(2*n))))
      [<commutative_times in ⊢ (??%); @le_exp_B //
      |@le_times [@le_B_A|@le_n]
      ]
    ]
  ]
qed.

theorem le_exp_A2:∀n. 1 < n → exp 2 (n / 2) \le A n.
#n #lt1n @(transitive_le ? (A(n/2*2)))
  [>commutative_times @le_exp_Al
   cases (le_to_or_lt_eq ? ? (le_O_n (n/2))) [//]
   #Heq @False_ind @(absurd ?? (lt_to_not_le ?? lt1n))
   >(div_mod n 2) <Heq whd in ⊢ (?%?);
   @le_S_S_to_le @(lt_mod_m_m n 2) @lt_O_S
  |@monotonic_A >(div_mod n 2) in ⊢ (??%); @le_plus_n_r
  ]
qed.

theorem eq_sigma_pi_SO_n: ∀n.∑_{i < n} 1 = n.
#n elim n //
qed.

theorem leA_prim: ∀n.
  exp n (prim n) \le A n * ∏_{p < S n | primeb p} p.
#n <(exp_sigma (S n) n primeb) <times_pi @le_pi
#p #ltp #primep @lt_to_le @lt_exp_log
@prime_to_lt_SO @primeb_true_to_prime //
qed.

theorem le_prim_log : ∀n,b. 1 < b →
  log b (A n) ≤ prim n * (S (log b n)).
#n #b #lt1b @(transitive_le … (log_exp1 …)) [@le_log // | //]
qed.

(*********************** the inequalities ***********************)
lemma exp_Sn: ∀b,n. exp b (S n) = b * (exp b n).
normalize // 
qed.

theorem le_exp_priml: ∀n. O < n →
  exp 2 (2*n) ≤ exp (2*n) (S(prim (2*n))).
#n #posn @(transitive_le ? (((2*n*(B (2*n))))))
  [@le_exp_B // 
  |>exp_Sn @monotonic_le_times_r @(transitive_le ? (A (2*n)))
    [@le_B_A |@le_Al]
  ]
qed.

theorem le_exp_prim4l: ∀n. O < n →
  exp 2 (S(4*n)) ≤ exp (4*n) (S(prim (4*n))).
#n #posn @(transitive_le ? (2*(4*n*(B (4*n)))))
  [>exp_Sn @monotonic_le_times_r
   cut (4*n = 2*(2*n)) [<associative_times //] #Hcut
   >Hcut @le_exp_B @lt_to_le whd >(times_n_1 2) in ⊢ (?%?);
   @monotonic_le_times_r //
  |>exp_Sn <associative_times >commutative_times in ⊢ (?(?%?)?);
   >associative_times @monotonic_le_times_r @(transitive_le ? (A (4*n)))
    [@le_B_A4 // |@le_Al]
  ]
qed.

theorem le_priml: ∀n. O < n →
  2*n ≤ (S (log 2 (2*n)))*S(prim (2*n)).
#n #posn <(eq_log_exp 2 (2*n) ?) in ⊢ (?%?);
  [@(transitive_le ? ((log 2) (exp (2*n) (S(prim (2*n))))))
    [@le_log [@le_n |@le_exp_priml //]
    |>commutative_times in ⊢ (??%); @log_exp1 @le_n
    ]
  |@le_n
  ]
qed.

theorem le_exp_primr: ∀n.
  exp n (prim n) ≤ exp 2 (2*(2*n-3)).
#n @(transitive_le ? (exp (A n) 2))
  [>exp_Sn >exp_Sn whd in match (exp ? 0); <times_n_1 @leA_r2
  |>commutative_times <exp_exp_times @le_exp1 [@lt_O_S |@le_A_exp5]
  ]
qed.

(* bounds *)
theorem le_primr: ∀n. 1 < n → prim n \le 2*(2*n-3)/log 2 n.
#n #lt1n @le_times_to_le_div
  [@lt_O_log // 
  |@(transitive_le ? (log 2 (exp n (prim n))))
    [>commutative_times @log_exp2
      [@le_n |@lt_to_le //]
    |<(eq_log_exp 2 (2*(2*n-3))) in ⊢ (??%);
      [@le_log [@le_n |@le_exp_primr]
      |@le_n
      ]
    ]
  ]
qed.
     
theorem le_priml1: ∀n. O < n →
  2*n/((log 2 n)+2) - 1 ≤ prim (2*n).
#n #posn @le_plus_to_minus @le_times_to_le_div2
  [>commutative_plus @lt_O_S
  |>commutative_times in ⊢ (??%); <plus_n_Sm <plus_n_Sm in ⊢ (??(??%));
   <plus_n_O <commutative_plus <log_exp
    [@le_priml // | //| @le_n]
  ]
qed.




