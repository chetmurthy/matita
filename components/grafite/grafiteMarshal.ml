(* Copyright (C) 2005, HELM Team.
 * 
 * This file is part of HELM, an Hypertextual, Electronic
 * Library of Mathematics, developed at the Computer Science
 * Department, University of Bologna, Italy.
 * 
 * HELM is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * HELM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with HELM; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 * MA  02111-1307, USA.
 * 
 * For details, see the HELM World-Wide-Web page,
 * http://helm.cs.unibo.it/
 *)

(* $Id$ *)

type ast_command = (Cic.term,Cic.obj) GrafiteAst.command
type moo = ast_command list

let format_name = "grafite"

let save_moo_to_file ~fname moo =
  HMarshal.save ~fmt:format_name ~version:GrafiteAst.magic ~fname moo

let load_moo_from_file ~fname =
  let raw = HMarshal.load ~fmt:format_name ~version:GrafiteAst.magic ~fname in
  (raw: moo)

let rehash_cmd_uris =
  let rehash_uri uri =
    UriManager.uri_of_string (UriManager.string_of_uri uri) in
  function
  | GrafiteAst.Default (loc, name, uris) ->
      let uris = List.map rehash_uri uris in
      GrafiteAst.Default (loc, name, uris)
  | GrafiteAst.PreferCoercion (loc, uri) ->
      GrafiteAst.PreferCoercion (loc, CicUtil.rehash_term uri)
  | GrafiteAst.Coercion (loc, uri, close, arity, saturations) ->
      GrafiteAst.Coercion (loc, CicUtil.rehash_term uri, close, arity, saturations)
  | GrafiteAst.Index (loc, key, uri) ->
      GrafiteAst.Index (loc, HExtlib.map_option CicUtil.rehash_term key, rehash_uri uri)
  | GrafiteAst.Select (loc, uri) -> 
      GrafiteAst.Select (loc, rehash_uri uri)
  | GrafiteAst.Include _ as cmd -> cmd
  | cmd ->
      prerr_endline "Found a command not expected in a .moo:";
      let term_pp _ = assert false in
      let obj_pp _ = assert false in
      prerr_endline (GrafiteAstPp.pp_command ~term_pp ~obj_pp cmd);
      assert false

let save_moo ~fname moo = save_moo_to_file ~fname (List.rev moo)

let load_moo ~fname =
  let moo = load_moo_from_file ~fname in
  List.map rehash_cmd_uris moo

