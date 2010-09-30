(*
    ||M||  This file is part of HELM, an Hypertextual, Electronic        
    ||A||  Library of Mathematics, developed at the Computer Science     
    ||T||  Department, University of Bologna, Italy.                     
    ||I||                                                                
    ||T||  HELM is free software; you can redistribute it and/or         
    ||A||  modify it under the terms of the GNU General Public License   
    \   /  version 2 or (at your option) any later version.      
     \ /   This software is distributed as is, NO WARRANTY.     
      V_______________________________________________________________ *)

(* $Id: nCic.ml 9058 2008-10-13 17:42:30Z tassi $ *)

open Printf

open DisambiguateTypes
open UriManager

module Ast = CicNotationPt
module NRef = NReference 

let debug_print s = prerr_endline (Lazy.force s);;
let debug_print _ = ();;

let reference_of_oxuri = ref (fun _ -> assert false);;
let set_reference_of_oxuri f = reference_of_oxuri := f;;

let cic_name_of_name = function
  | Ast.Ident (n, None) ->  n
  | _ -> assert false
;;

let rec mk_rels howmany from =
  match howmany with 
  | 0 -> []
  | _ -> (NCic.Rel (howmany + from)) :: (mk_rels (howmany-1) from)
;;

let refine_term 
 metasenv subst context uri ~rdb ~use_coercions term expty _ ~localization_tbl=
  assert (uri=None);
  debug_print (lazy (sprintf "TEST_INTERPRETATION: %s" 
    (NCicPp.ppterm ~metasenv ~subst ~context term)));
  try
    let localise t = 
      try NCicUntrusted.NCicHash.find localization_tbl t
      with Not_found -> 
        prerr_endline ("NOT LOCALISED" ^ NCicPp.ppterm ~metasenv ~subst ~context t);
        (*assert false*) HExtlib.dummy_floc
    in
    let metasenv, subst, term, _ = 
      NCicRefiner.typeof 
        (rdb#set_coerc_db 
          (if use_coercions then rdb#coerc_db else NCicCoercion.empty_db))
        metasenv subst context term expty ~localise 
    in
     Disambiguate.Ok (term, metasenv, subst, ())
  with
  | NCicRefiner.Uncertain loc_msg ->
      debug_print (lazy ("UNCERTAIN: [" ^ snd (Lazy.force loc_msg) ^ "] " ^ 
        NCicPp.ppterm ~metasenv ~subst ~context term)) ;
      Disambiguate.Uncertain loc_msg
  | NCicRefiner.RefineFailure loc_msg ->
      debug_print (lazy (sprintf "PRUNED:\nterm%s\nmessage:%s"
        (NCicPp.ppterm ~metasenv ~subst ~context term) (snd(Lazy.force loc_msg))));
      Disambiguate.Ko loc_msg
;;

let refine_obj 
  ~rdb metasenv subst _context _uri 
  ~use_coercions obj _ _ugraph ~localization_tbl 
=
  assert (metasenv=[]);
  assert (subst=[]);
  let localise t = 
    try NCicUntrusted.NCicHash.find localization_tbl t
    with Not_found -> 
      (*assert false*)HExtlib.dummy_floc
  in
  try
    let obj =
      NCicRefiner.typeof_obj
        (rdb#set_coerc_db
           (if use_coercions then rdb#coerc_db 
            else NCicCoercion.empty_db))
        obj ~localise 
    in
      Disambiguate.Ok (obj, [], [], ())
  with
  | NCicRefiner.Uncertain loc_msg ->
      debug_print (lazy ("UNCERTAIN: [" ^ snd (Lazy.force loc_msg) ^ "] " ^ 
        NCicPp.ppobj obj)) ;
      Disambiguate.Uncertain loc_msg
  | NCicRefiner.RefineFailure loc_msg ->
      debug_print (lazy (sprintf "PRUNED:\nobj: %s\nmessage: %s"
        (NCicPp.ppobj obj) (snd(Lazy.force loc_msg))));
      Disambiguate.Ko loc_msg
;;
  

  (* TODO move it to Cic *)
let find_in_context name context =
  let rec aux acc = function
    | [] -> raise Not_found
    | hd :: _ when hd = name -> acc
    | _ :: tl ->  aux (acc + 1) tl
  in
  aux 1 context

let interpretate_term_and_interpretate_term_option 
  ?(create_dummy_ids=false) 
    ~obj_context ~mk_choice ~env ~uri ~is_path ~localization_tbl 
=
  (* create_dummy_ids shouldbe used only for interpretating patterns *)
  assert (uri = None);

  let rec aux ~localize loc context = function
    | CicNotationPt.AttributedTerm (`Loc loc, term) ->
        let res = aux ~localize loc context term in
        if localize then 
         NCicUntrusted.NCicHash.add localization_tbl res loc;
       res
    | CicNotationPt.AttributedTerm (_, term) -> aux ~localize loc context term
    | CicNotationPt.Appl (CicNotationPt.Appl inner :: args) ->
        aux ~localize loc context (CicNotationPt.Appl (inner @ args))
    | CicNotationPt.Appl 
        (CicNotationPt.AttributedTerm (att,(CicNotationPt.Appl inner))::args)->
        aux ~localize loc context 
          (CicNotationPt.AttributedTerm (att,CicNotationPt.Appl (inner @ args)))
    | CicNotationPt.Appl (CicNotationPt.Symbol (symb, i) :: args) ->
        let cic_args = List.map (aux ~localize loc context) args in
        Disambiguate.resolve ~mk_choice ~env (Symbol (symb, i)) (`Args cic_args)
    | CicNotationPt.Appl terms ->
       NCic.Appl (List.map (aux ~localize loc context) terms)
    | CicNotationPt.Binder (binder_kind, (var, typ), body) ->
        let cic_type = aux_option ~localize loc context `Type typ in
        let cic_name = cic_name_of_name var  in
        let cic_body = aux ~localize loc (cic_name :: context) body in
        (match binder_kind with
        | `Lambda -> NCic.Lambda (cic_name, cic_type, cic_body)
        | `Pi
        | `Forall -> NCic.Prod (cic_name, cic_type, cic_body)
        | `Exists ->
            Disambiguate.resolve ~env ~mk_choice (Symbol ("exists", 0))
              (`Args [ cic_type; NCic.Lambda (cic_name, cic_type, cic_body) ]))
    | CicNotationPt.Case (term, indty_ident, outtype, branches) ->
        let cic_term = aux ~localize loc context term in
        let cic_outtype = aux_option ~localize loc context `Term outtype in
        let do_branch ((_, _, args), term) =
         let rec do_branch' context = function
           | [] -> aux ~localize loc context term
           | (name, typ) :: tl ->
               let cic_name = cic_name_of_name name in
               let cic_body = do_branch' (cic_name :: context) tl in
               let typ =
                 match typ with
                 | None -> NCic.Implicit `Type
                 | Some typ -> aux ~localize loc context typ
               in
               NCic.Lambda (cic_name, typ, cic_body)
         in
          do_branch' context args
        in
        if create_dummy_ids then
         let branches =
          List.map
           (function
               Ast.Wildcard,term -> ("wildcard",None,[]), term
             | Ast.Pattern _,_ ->
                raise (DisambiguateTypes.Invalid_choice 
                 (lazy (loc, "Syntax error: the left hand side of a "^
                   "branch pattern must be \"_\"")))
           ) branches
         in
         (*
          NCic.MutCase (ref, cic_outtype, cic_term,
            (List.map do_branch branches))
          *) ignore branches; assert false (* patterns not implemented yet *)
        else
         let indtype_ref =
          match indty_ident with
          | Some (indty_ident, _) ->
             (match Disambiguate.resolve ~env ~mk_choice 
                (Id indty_ident) (`Args []) with
              | NCic.Const (NReference.Ref (_,NReference.Ind _) as r) -> r
              | NCic.Implicit _ ->
                 raise (Disambiguate.Try_again 
                  (lazy "The type of the term to be matched is still unknown"))
              | t ->
                raise (DisambiguateTypes.Invalid_choice 
                  (lazy (loc,"The type of the term to be matched "^
                          "is not (co)inductive: " ^ NCicPp.ppterm 
                          ~metasenv:[] ~subst:[] ~context:[] t))))
          | None ->
              let rec fst_constructor =
                function
                   (Ast.Pattern (head, _, _), _) :: _ -> head
                 | (Ast.Wildcard, _) :: tl -> fst_constructor tl
                 | [] -> raise (Invalid_choice (lazy (loc,"The type "^
                     "of the term to be matched cannot be determined "^
                     "because it is an inductive type without constructors "^
                     "or because all patterns use wildcards")))
              in
(*
              DisambiguateTypes.Environment.iter
                  (fun k v ->
                      prerr_endline
                        (DisambiguateTypes.string_of_domain_item k ^ " => " ^
                        description_of_alias v)) env; 
*)
              (match Disambiguate.resolve ~env ~mk_choice
                (Id (fst_constructor branches)) (`Args []) with
              | NCic.Const (NReference.Ref (_,NReference.Con _) as r) -> 
                   let b,_,_,_,_ = NCicEnvironment.get_checked_indtys r in
                   NReference.mk_indty b r
              | NCic.Implicit _ ->
                 raise (Disambiguate.Try_again 
                  (lazy "The type of the term to be matched is still unknown"))
              | t ->
                raise (DisambiguateTypes.Invalid_choice 
                  (lazy (loc, 
                  "The type of the term to be matched is not (co)inductive: " 
                  ^ NCicPp.ppterm ~metasenv:[] ~subst:[] ~context:[] t))))
         in
         let _,leftsno,itl,_,indtyp_no =
          NCicEnvironment.get_checked_indtys indtype_ref in
         let _,_,_,cl =
          try
           List.nth itl indtyp_no
          with _ -> assert false in
         let rec count_prod t =
                 match NCicReduction.whd ~subst:[] [] t with
               NCic.Prod (_, _, t) -> 1 + (count_prod t)
             | _ -> 0 
         in 
         let rec sort branches cl =
          match cl with
             [] ->
              let rec analyze unused unrecognized useless =
               function
                  [] ->
                   if unrecognized != [] then
                    raise (DisambiguateTypes.Invalid_choice
                     (lazy
                       (loc,"Unrecognized constructors: " ^
                        String.concat " " unrecognized)))
                   else if useless > 0 then
                    raise (DisambiguateTypes.Invalid_choice
                     (lazy
                       (loc,"The last " ^ string_of_int useless ^
                        "case" ^ if useless > 1 then "s are" else " is" ^
                        " unused")))
                   else
                    []
                | (Ast.Wildcard,_)::tl when not unused ->
                    analyze true unrecognized useless tl
                | (Ast.Pattern (head,_,_),_)::tl when not unused ->
                    analyze unused (head::unrecognized) useless tl
                | _::tl -> analyze unused unrecognized (useless + 1) tl
              in
               analyze false [] 0 branches
           | (_,name,ty)::cltl ->
              let rec find_and_remove =
               function
                  [] ->
                   raise
                    (DisambiguateTypes.Invalid_choice
                     (lazy (loc, "Missing case: " ^ name)))
                | ((Ast.Wildcard, _) as branch :: _) as branches ->
                    branch, branches
                | (Ast.Pattern (name',_,_),_) as branch :: tl
                   when name = name' ->
                    branch,tl
                | branch::tl ->
                   let found,rest = find_and_remove tl in
                    found, branch::rest
              in
               let branch,tl = find_and_remove branches in
               match branch with
                  Ast.Pattern (name,y,args),term ->
                   if List.length args = count_prod ty - leftsno then
                    ((name,y,args),term)::sort tl cltl
                   else
                    raise
                     (DisambiguateTypes.Invalid_choice
                      (lazy (loc,"Wrong number of arguments for " ^ name)))
                | Ast.Wildcard,term ->
                   let rec mk_lambdas =
                    function
                       0 -> term
                     | n ->
                        CicNotationPt.Binder
                         (`Lambda, (CicNotationPt.Ident ("_", None), None),
                           mk_lambdas (n - 1))
                   in
                    (("wildcard",None,[]),
                     mk_lambdas (count_prod ty - leftsno)) :: sort tl cltl
         in
          let branches = sort branches cl in
           NCic.Match (indtype_ref, cic_outtype, cic_term,
            (List.map do_branch branches))
    | CicNotationPt.Cast (t1, t2) ->
        let cic_t1 = aux ~localize loc context t1 in
        let cic_t2 = aux ~localize loc context t2 in
        NCic.LetIn ("_",cic_t2,cic_t1, NCic.Rel 1)
    | CicNotationPt.LetIn ((name, typ), def, body) ->
        let cic_def = aux ~localize loc context def in
        let cic_name = cic_name_of_name name in
        let cic_typ =
          match typ with
          | None -> NCic.Implicit `Type
          | Some t -> aux ~localize loc context t
        in
        let cic_body = aux ~localize loc (cic_name :: context) body in
        NCic.LetIn (cic_name, cic_typ, cic_def, cic_body)
    | CicNotationPt.LetRec (_kind, _defs, _body) -> NCic.Implicit `Term
    | CicNotationPt.Ident _
    | CicNotationPt.Uri _
    | CicNotationPt.NRef _ when is_path -> raise Disambiguate.PathNotWellFormed
    | CicNotationPt.Ident (name, subst) ->
       assert (subst = None);
       (try
             NCic.Rel (find_in_context name context)
       with Not_found -> 
         try NCic.Const (List.assoc name obj_context)
         with Not_found ->
            Disambiguate.resolve ~env ~mk_choice (Id name) (`Args []))
    | CicNotationPt.Uri (uri, subst) ->
       assert (subst = None);
       (try
         NCic.Const (!reference_of_oxuri(UriManager.uri_of_string uri))
        with NRef.IllFormedReference _ ->
         CicNotationPt.fail loc "Ill formed reference")
    | CicNotationPt.NRef nref -> NCic.Const nref
    | CicNotationPt.NCic t -> 
           let context = (* to make metas_of_term happy *)
             List.map (fun x -> x,NCic.Decl (NCic.Implicit `Type)) context in
           assert(NCicUntrusted.metas_of_term [] context t = []); t
    | CicNotationPt.Implicit `Vector -> NCic.Implicit `Vector
    | CicNotationPt.Implicit `JustOne -> NCic.Implicit `Term
    | CicNotationPt.Implicit (`Tagged s) -> NCic.Implicit (`Tagged s)
    | CicNotationPt.UserInput -> NCic.Implicit `Hole
    | CicNotationPt.Num (num, i) -> 
        Disambiguate.resolve ~env ~mk_choice (Num i) (`Num_arg num)
    | CicNotationPt.Meta (index, subst) ->
        let cic_subst =
         List.map
          (function None -> assert false| Some t -> aux ~localize loc context t)
          subst
        in
         NCic.Meta (index, (0, NCic.Ctx cic_subst))
    | CicNotationPt.Sort `Prop -> NCic.Sort NCic.Prop
    | CicNotationPt.Sort `Set -> NCic.Sort (NCic.Type
       [`Type,NUri.uri_of_string "cic:/matita/pts/Type.univ"])
    | CicNotationPt.Sort (`Type _u) -> NCic.Sort (NCic.Type
       [`Type,NUri.uri_of_string "cic:/matita/pts/Type0.univ"])
    | CicNotationPt.Sort (`NType s) -> NCic.Sort (NCic.Type
       [`Type,NUri.uri_of_string ("cic:/matita/pts/Type" ^ s ^ ".univ")])
    | CicNotationPt.Sort (`NCProp s) -> NCic.Sort (NCic.Type
       [`CProp,NUri.uri_of_string ("cic:/matita/pts/Type" ^ s ^ ".univ")])
    | CicNotationPt.Sort (`CProp _u) -> NCic.Sort (NCic.Type
       [`CProp,NUri.uri_of_string "cic:/matita/pts/Type.univ"])
    | CicNotationPt.Symbol (symbol, instance) ->
        Disambiguate.resolve ~env ~mk_choice 
         (Symbol (symbol, instance)) (`Args [])
    | CicNotationPt.Variable _
    | CicNotationPt.Magic _
    | CicNotationPt.Layout _
    | CicNotationPt.Literal _ -> assert false (* god bless Bologna *)
  and aux_option ~localize loc context annotation = function
    | None -> NCic.Implicit annotation
    | Some (CicNotationPt.AttributedTerm (`Loc loc, term)) ->
        let res = aux_option ~localize loc context annotation (Some term) in
        if localize then 
          NCicUntrusted.NCicHash.add localization_tbl res loc;
        res
    | Some (CicNotationPt.AttributedTerm (_, term)) ->
        aux_option ~localize loc context annotation (Some term)
    | Some CicNotationPt.Implicit `JustOne -> NCic.Implicit annotation
    | Some CicNotationPt.Implicit `Vector -> NCic.Implicit `Vector
    | Some term -> aux ~localize loc context term
  in
   (fun ~context -> aux ~localize:true HExtlib.dummy_floc context),
   (fun ~context -> aux_option ~localize:true HExtlib.dummy_floc context)
;;

let interpretate_term ?(create_dummy_ids=false) ~context ~env ~uri ~is_path ast
     ~obj_context ~localization_tbl ~mk_choice
=
  let context = List.map fst context in
  fst 
    (interpretate_term_and_interpretate_term_option 
      ~obj_context ~mk_choice ~create_dummy_ids ~env ~uri ~is_path ~localization_tbl)
    ~context ast
;;

let interpretate_term_option 
  ?(create_dummy_ids=false) ~context ~env ~uri ~is_path 
  ~localization_tbl ~mk_choice ~obj_context
=
  let context = List.map fst context in
  snd 
    (interpretate_term_and_interpretate_term_option 
      ~obj_context ~mk_choice ~create_dummy_ids ~env ~uri ~is_path ~localization_tbl)
    ~context 
;;

let disambiguate_path path =
  let localization_tbl = NCicUntrusted.NCicHash.create 23 in
  fst
    (interpretate_term_and_interpretate_term_option 
    ~obj_context:[] ~mk_choice:(fun _ -> assert false)
    ~create_dummy_ids:true ~env:DisambiguateTypes.Environment.empty
    ~uri:None ~is_path:true ~localization_tbl) ~context:[] path
;;

let new_flavour_of_flavour = function 
  | `Definition -> `Definition
  | `MutualDefinition -> `Definition 
  | `Fact -> `Fact
  | `Lemma -> `Lemma
  | `Remark -> `Example
  | `Theorem -> `Theorem
  | `Variant -> `Corollary 
  | `Axiom -> `Fact
;;

let ncic_name_of_ident = function
  | Ast.Ident (name, None) -> name
  | _ -> assert false
;;

let interpretate_obj 
(*      ?(create_dummy_ids=false)  *)
     ~context ~env ~uri ~is_path obj ~localization_tbl ~mk_choice 
=
 assert (context = []);
 assert (is_path = false);
 let interpretate_term ~obj_context =
  interpretate_term ~mk_choice ~localization_tbl ~obj_context in
 let interpretate_term_option ~obj_context =
   interpretate_term_option ~mk_choice ~localization_tbl ~obj_context in
 let uri = match uri with | None -> assert false | Some u -> u in
 match obj with
 | CicNotationPt.Theorem (flavour, name, ty, bo, pragma) ->
     let ty' = 
       interpretate_term 
         ~obj_context:[] ~context:[] ~env ~uri:None ~is_path:false ty 
     in
     let height = (* XXX calculate *) 0 in
     uri, height, [], [], 
     (match bo,flavour with
      | None,`Axiom -> 
          let attrs = `Provided, new_flavour_of_flavour flavour, pragma in
          NCic.Constant ([],name,None,ty',attrs)
      | Some _,`Axiom -> assert false
      | None,_ ->
          let attrs = `Provided, new_flavour_of_flavour flavour, pragma in
          NCic.Constant ([],name,Some (NCic.Implicit `Term),ty',attrs)
      | Some bo,_ ->
        (match bo with
         | CicNotationPt.LetRec (kind, defs, _) ->
             let inductive = kind = `Inductive in
             let _,obj_context =
               List.fold_left
                 (fun (i,acc) (_,(name,_),_,k) -> 
                  (i+1, 
                    (ncic_name_of_ident name, NReference.reference_of_spec uri 
                     (if inductive then NReference.Fix (i,k,0)
                      else NReference.CoFix i)) :: acc))
                 (0,[]) defs
             in
             let inductiveFuns =
               List.map
                 (fun (params, (name, typ), body, decr_idx) ->
                   let add_binders kind t =
                    List.fold_right
                     (fun var t -> 
                        CicNotationPt.Binder (kind, var, t)) params t
                   in
                   let cic_body =
                     interpretate_term 
                       ~obj_context ~context ~env ~uri:None ~is_path:false
                       (add_binders `Lambda body) 
                   in
                   let cic_type =
                     interpretate_term_option 
                       ~obj_context:[]
                       ~context ~env ~uri:None ~is_path:false `Type
                       (HExtlib.map_option (add_binders `Pi) typ)
                   in
                   ([],ncic_name_of_ident name, decr_idx, cic_type, cic_body))
                 defs
             in
             let attrs = `Provided, new_flavour_of_flavour flavour, pragma in
             NCic.Fixpoint (inductive,inductiveFuns,attrs)
         | bo -> 
             let bo = 
               interpretate_term 
                ~obj_context:[] ~context:[] ~env ~uri:None ~is_path:false bo
             in
             let attrs = `Provided, new_flavour_of_flavour flavour, pragma in
             NCic.Constant ([],name,Some bo,ty',attrs)))
 | CicNotationPt.Inductive (params,tyl) ->
    let context,params =
     let context,res =
      List.fold_left
       (fun (context,res) (name,t) ->
         let t =
          match t with
             None -> CicNotationPt.Implicit `JustOne
           | Some t -> t in
         let name = cic_name_of_name name in
         let t =
          interpretate_term ~obj_context:[] ~context ~env ~uri:None
           ~is_path:false t
         in
          (name,NCic.Decl t)::context,(name,t)::res
       ) ([],[]) params
     in
      context,List.rev res in
    let add_params =
     List.fold_right (fun (name,ty) t -> NCic.Prod (name,ty,t)) params in
    let leftno = List.length params in
    let _,inductive,_,_ = try List.hd tyl with Failure _ -> assert false in
    let obj_context =
     snd (
      List.fold_left
       (fun (i,res) (name,_,_,_) ->
         let nref =
          NReference.reference_of_spec uri (NReference.Ind (inductive,i,leftno))
         in
          i+1,(name,nref)::res)
       (0,[]) tyl) in
    let tyl =
     List.map
      (fun (name,_,ty,cl) ->
        let ty' =
         add_params
         (interpretate_term ~obj_context:[] ~context ~env ~uri:None
           ~is_path:false ty) in
        let cl' =
         List.map
          (fun (name,ty) ->
            let ty' =
             add_params
              (interpretate_term ~obj_context ~context ~env ~uri:None
                ~is_path:false ty) in
            let relevance = [] in
             relevance,name,ty'
          ) cl in
        let relevance = [] in
         relevance,name,ty',cl'
      ) tyl
    in
     let height = (* XXX calculate *) 0 in
     let attrs = `Provided, `Regular in
     uri, height, [], [], 
     NCic.Inductive (inductive,leftno,tyl,attrs)
 | CicNotationPt.Record (params,name,ty,fields) ->
    let context,params =
     let context,res =
      List.fold_left
       (fun (context,res) (name,t) ->
         let t =
          match t with
             None -> CicNotationPt.Implicit `JustOne
           | Some t -> t in
         let name = cic_name_of_name name in
         let t =
          interpretate_term ~obj_context:[] ~context ~env ~uri:None
           ~is_path:false t
         in
          (name,NCic.Decl t)::context,(name,t)::res
       ) ([],[]) params
     in
      context,List.rev res in
    let add_params =
     List.fold_right (fun (name,ty) t -> NCic.Prod (name,ty,t)) params in
    let leftno = List.length params in
    let ty' =
     add_params
      (interpretate_term ~obj_context:[] ~context ~env ~uri:None
        ~is_path:false ty) in
    let nref =
     NReference.reference_of_spec uri (NReference.Ind (true,0,leftno)) in
    let obj_context = [name,nref] in
    let fields' =
     snd (
      List.fold_left
       (fun (context,res) (name,ty,_coercion,_arity) ->
         let ty =
          interpretate_term ~obj_context ~context ~env ~uri:None
           ~is_path:false ty in
         let context' = (name,NCic.Decl ty)::context in
          context',(name,ty)::res
       ) (context,[]) fields) in
    let concl =
     let mutind = NCic.Const nref in
     if params = [] then mutind
     else
      NCic.Appl
       (mutind::mk_rels (List.length params) (List.length fields)) in
    let con =
     List.fold_left (fun t (name,ty) -> NCic.Prod (name,ty,t)) concl fields' in
    let con' = add_params con in
    let relevance = [] in
    let tyl = [relevance,name,ty',[relevance,"mk_" ^ name,con']] in
    let field_names = List.map (fun (x,_,y,z) -> x,y,z) fields in
     let height = (* XXX calculate *) 0 in
     let attrs = `Provided, `Record field_names in
     uri, height, [], [], 
     NCic.Inductive (true,leftno,tyl,attrs)
;;

let disambiguate_term ~context ~metasenv ~subst ~expty
   ~mk_implicit ~description_of_alias ~fix_instance ~mk_choice
   ~aliases ~universe ~rdb ~lookup_in_library 
   (text,prefix_len,term) 
 =
  let mk_localization_tbl x = NCicUntrusted.NCicHash.create x in
   let res,b =
    MultiPassDisambiguator.disambiguate_thing
     ~freshen_thing:CicNotationUtil.freshen_term
     ~context ~metasenv ~initial_ugraph:() ~aliases
     ~mk_implicit ~description_of_alias ~fix_instance
     ~string_context_of_context:(List.map (fun (x,_) -> Some x))
     ~universe ~uri:None ~pp_thing:CicNotationPp.pp_term
     ~passes:(MultiPassDisambiguator.passes ())
     ~lookup_in_library ~domain_of_thing:Disambiguate.domain_of_term
     ~interpretate_thing:(interpretate_term ~obj_context:[] ~mk_choice (?create_dummy_ids:None))
     ~refine_thing:(refine_term ~rdb) (text,prefix_len,term)
     ~mk_localization_tbl ~expty ~subst
   in
    List.map (function (a,b,c,d,_) -> a,b,c,d) res, b
;;

let disambiguate_obj 
   ~mk_implicit ~description_of_alias ~fix_instance ~mk_choice
   ~aliases ~universe ~rdb ~lookup_in_library ~uri
   (text,prefix_len,obj) 
 =
  let mk_localization_tbl x = NCicUntrusted.NCicHash.create x in
   let res,b =
    MultiPassDisambiguator.disambiguate_thing
     ~freshen_thing:CicNotationUtil.freshen_obj
     ~context:[] ~metasenv:[] ~subst:[] ~initial_ugraph:() ~aliases
     ~mk_implicit ~description_of_alias ~fix_instance
     ~string_context_of_context:(List.map (fun (x,_) -> Some x))
     ~universe 
     ~uri:(Some uri)
     ~pp_thing:(CicNotationPp.pp_obj CicNotationPp.pp_term)
     ~passes:(MultiPassDisambiguator.passes ())
     ~lookup_in_library ~domain_of_thing:Disambiguate.domain_of_obj
     ~interpretate_thing:(interpretate_obj ~mk_choice)
     ~refine_thing:(refine_obj ~rdb) 
     (text,prefix_len,obj)
     ~mk_localization_tbl ~expty:None
   in
    List.map (function (a,b,c,d,_) -> a,b,c,d) res, b
;;
(*
let _ = 
let mk_type n = 
  if n = 0 then
     [false, NUri.uri_of_string ("cic:/matita/pts/Type.univ")]
  else
     [false, NUri.uri_of_string ("cic:/matita/pts/Type"^string_of_int n^".univ")]
in
let mk_cprop n = 
  if n = 0 then 
    [false, NUri.uri_of_string ("cic:/matita/pts/CProp.univ")]
  else
    [false, NUri.uri_of_string ("cic:/matita/pts/CProp"^string_of_int n^".univ")]
in
         NCicEnvironment.add_constraint true (mk_type 0) (mk_type 1);
         NCicEnvironment.add_constraint true (mk_cprop 0) (mk_cprop 1);
         NCicEnvironment.add_constraint true (mk_cprop 0) (mk_type 1);
         NCicEnvironment.add_constraint true (mk_type 0) (mk_cprop 1);
         NCicEnvironment.add_constraint false (mk_cprop 0) (mk_type 0);
         NCicEnvironment.add_constraint false (mk_type 0) (mk_cprop 0);

         NCicEnvironment.add_constraint true (mk_type 1) (mk_type 2);
         NCicEnvironment.add_constraint true (mk_cprop 1) (mk_cprop 2);
         NCicEnvironment.add_constraint true (mk_cprop 1) (mk_type 2);
         NCicEnvironment.add_constraint true (mk_type 1) (mk_cprop 2);
         NCicEnvironment.add_constraint false (mk_cprop 1) (mk_type 1);
         NCicEnvironment.add_constraint false (mk_type 1) (mk_cprop 1);

         NCicEnvironment.add_constraint true (mk_type 2) (mk_type 3);
         NCicEnvironment.add_constraint true (mk_cprop 2) (mk_cprop 3);
         NCicEnvironment.add_constraint true (mk_cprop 2) (mk_type 3);
         NCicEnvironment.add_constraint true (mk_type 2) (mk_cprop 3);
         NCicEnvironment.add_constraint false (mk_cprop 2) (mk_type 2);
         NCicEnvironment.add_constraint false (mk_type 2) (mk_cprop 2);

         NCicEnvironment.add_constraint false (mk_cprop 3) (mk_type 3);
         NCicEnvironment.add_constraint false (mk_type 3) (mk_cprop 3);

;;
*)

