open FileHandler
open Global


module Status = struct
  let print_file (f : file) = 
    let Path str = f in
    print_endline str;;


  let rec print_first_n (lst : file list) (n : int) = 
    match n with
    | 0 -> ()
    | x -> let _ = print_file (List.hd lst) in
            print_first_n (List.tl lst) (n - 1) 


  let parse_args (args_list : string list) = 
    let _ = FileHandler.load_var config_global _CONFIG_PATH in
    let tracked_files = !(config_global).tracked_files in
    let count = !(config_global).uncommitted_changes_count in
    let _ = print_endline "<---- The following files are added, not staged for commit ---->" in
    let success = print_first_n tracked_files count in
    success;;
end