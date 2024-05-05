open FileHandler
open Global


module Log = struct
  let print_commit (comm : commit) = 
    let CommitDir ((Hash h), (Path p), (CommitMsg m)) = comm in
    let str = "Hash: " ^ h ^ "\t\tPath: " ^ p ^ "\t\tMessage: " ^ m ^ "\n" in
    let _ = print_string str in
    ()


  let parse_args (args_list : string list) = 
    let _ = FileHandler.load_var config_global _CONFIG_PATH in
    let commit_history_list = !(config_global).commit_history in
    let rec print_commit_history (lst : commit list) = 
      match lst with
      | [] -> ()
      | (com : commit) :: t -> let _ = print_commit com in print_commit_history t;
    in print_commit_history commit_history_list;

end