type user_auth_pair = Auth_Pair of string * string;;       (* Auth Pair has user and password *)
type file = Path of string;;                               (* Path of the files *)
type hash = Hash of string;;                              (* Stores the hash value *)
type msg = CommitMsg of string;;                  
type commit = CommitDir of hash * file * msg;;                   (* Stores the pair of hash and commit dir location *)


type config = {
  user_credentials: user_auth_pair;
  commit_history: commit list;
  latest_add_hash: hash;
  tracked_files : file list;
  uncommitted_changes_count : int;                        (* stores the number of files added yet to be committed *)
}

let config_global : config ref = ref {
  user_credentials = Auth_Pair("", "");
  commit_history = [];
  latest_add_hash = Hash("");
  tracked_files = [];
  uncommitted_changes_count = 0;
}

let generateNewHash () = 
  let Hash str = !(config_global).latest_add_hash in
  let digstr = Digest.string str in
  let hashstr = Digest.to_hex digstr in
  Hash(hashstr);;


let mkdir_p (dir : string) = 
  let rec create path = 
      if not (Sys.file_exists path) then begin
          create (Filename.dirname path);
          Unix.mkdir path 0o777
      end
  in
  create dir;;

let _CONFIG_PATH = "./.config";;
let _COMMIT_DIR = "./.commits/";;
let _CURRENT_DIR = ".";;

(* module ConfigInterface = struct
  let get_user_credentials config = config.user_credentials
  let set_user_credentials config user_credentials = config.user_credentials <- user_credentials

  let get_commit_history config = config.commit_history
  let set_commit_history config commit_history = config.commit_history <- commit_history

  let get_latest_add_hash config = config.latest_add_hash
  let set_latest_add_hash config latest_add_hash = config.latest_add_hash <- latest_add_hash

  let get_tracked_files config = config.tracked_files
  let set_tracked_files config tracked_files = config.tracked_files <- tracked_files

  let get_uncommitted_changes_count config = config.uncommitted_changes_count
  let set_uncommitted_changes_count config uncommitted_changes_count = config.uncommitted_changes_count <- uncommitted_changes_count
end *)
