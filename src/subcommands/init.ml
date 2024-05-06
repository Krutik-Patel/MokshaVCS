(* make the methods private *)
(* add a way to add multiple authentications *)

(* Command: moksha init user pass *)

(* open FileHandler *)
open Global
open FileHandler

(* type user_auth_pair = Auth_Pair of string * string;;       (* Auth Pair has user and password *)
type file = Path of string;;                               (* Path of the files *)
type hash = Hash of string;;                               (* Stores the hash value *)
type commit = CommitDir of hash * file;;                   (* Stores the pair of hash and commit dir location *)


type config = {
  user_credentials: user_auth_pair;
  commit_history: commit list;
  latest_add_hash: hash;
  tracked_files : file list;
}

let config_global : config ref = ref {
      user_credentials = Auth_Pair("", "");
      commit_history = [];
      latest_add_hash = Hash("");
      tracked_files = [];
} *)

  
(* module FileHandler = struct
  let load_var var file = 
    let ic = open_in_bin file in
    let data = Marshal.from_channel ic in
    let _ = close_in ic in
    var := data;;

  let save_var data file = 
    let oc = open_out_bin file in
    let _ = Marshal.to_channel oc data [] in
    close_out oc;;
end;; *)


module Init = struct
  let tracked_Files : file list = [Path(_CONFIG_PATH)]
  let commit_History : commit list = [CommitDir(Hash("<INITIAL>"), Path(""), CommitMsg("<INITIAL>"))]
  let addHash : hash = Hash("<INITIAL>")
  
  let emit_config_file user_auth = 
    let config_elements : config = {
      user_credentials = user_auth;
      commit_history = commit_History;
      latest_add_hash = addHash;
      tracked_files = tracked_Files;
    } in 
    let _ = FileHandler.save_var config_elements _CONFIG_PATH in
    ()
  
  let parse_args (args_list : string list) =
    let user = List.nth args_list 0 in
    let pass = List.nth args_list 1 in
    let user_auth = Auth_Pair(user, pass) in
    let success = (emit_config_file user_auth) in 
    success;;

  (* let print_config_file = 
    let config_elem : config ref = ref {
      user_credentials = Auth_Pair("", "");
      commit_history = [];
      latest_add_hash = Hash("");
      tracked_files = [];
      } in
    let _ = FileHandler.load_var config_elem _CONFIG_PATH in
    match !(config_elem).user_credentials with
    | Auth_Pair(username, password) -> Printf.printf "User Credentials: { username: %s, password: %s }\n" username password;;
      (* Printf.printf "Commit History: [ %s ]\n" (String.concat "; " !(config_elem).commit_history);
      Printf.printf "Latest Add Hash: %s\n" !(config_elem).latest_add_hash;
      Printf.printf "Tracked Files: [ %s ]\n" (String.concat "; " !(config_elem).tracked_files);; *) *)
end;;

