(* Command Usage : moksha force-revert hash_of_previous_commit*)
open FileHandler
open Global
open Unix

module ForceRevert = struct
  let checkHash prev_hash commit_history_list= 
    let rec hash_exists_in_commits hash commits =
      match commits with
      | [] -> false
      | CommitDir (Hash h, _, _) :: rest ->
        if h = hash then
          true
        else
          hash_exists_in_commits hash rest
    in
    hash_exists_in_commits prev_hash commit_history_list ;;

  let delete_directory directory =
    let command = Printf.sprintf "rm -rf %s" directory in
    let exit_status = system command in
    match exit_status with
    | WEXITED 0 ->
      Printf.printf "Syncing conditions for Revert are satisfied.\n"
    | _ ->
      failwith "Failed to match Syncing conditions";;

  let list_files_and_directories directory =
    let command = Printf.sprintf "ls %s" directory in
    let ic = Unix.open_process_in command in
    let rec read_lines acc =
      try
        let line = input_line ic in
        read_lines (line :: acc)
      with End_of_file ->
        close_in ic;
        List.rev acc
    in
    read_lines [] ;;

  let delete_files_in_current_directory list_of_files =
    let current_directory = Sys.getcwd () in
    let delete_file_or_directory file_or_dir =
      let path = Filename.concat current_directory file_or_dir in
      Printf.printf "Path: %s\n" path;
      if Sys.file_exists path then
        Unix.unlink path
      else if Sys.is_directory path then
        Unix.rmdir path
      else
        ()
    in
    List.iter delete_file_or_directory list_of_files;;

  let subtract_lists list1 list2 =
    List.filter (fun x -> not (List.mem x list2)) list1;;
    
    
  let rec rem_commits hash commits = 
    match commits with 
    | [] -> []
    | CommitDir (Hash h, f, m) :: rest -> 
      if h = hash then CommitDir (Hash h, f, m) :: rest
      else rem_commits hash rest;;

  let rec revert_back hash commits list_of_latest_files =
    match commits with 
    | [] -> ()
    | CommitDir (Hash h, _, _) :: rest -> 
      if h = hash then () 
      else
        begin
          let list_of_files = list_files_and_directories (_COMMIT_DIR ^ h) in
          let remaining_files = subtract_lists list_of_files list_of_latest_files in
          begin
            delete_files_in_current_directory remaining_files;
            delete_directory (_COMMIT_DIR ^ h);
            revert_back hash rest list_of_latest_files
          end
        end;;

  let parse_args (args_list : string list) = 
    let prev_hash = List.hd args_list in
    let _ = FileHandler.load_var config_global _CONFIG_PATH in
    let commit_history_list = !(config_global).commit_history in
    if checkHash prev_hash commit_history_list then 
      begin
        let list_of_latest_files = list_files_and_directories (_COMMIT_DIR ^ prev_hash) in
        let _ = revert_back prev_hash commit_history_list list_of_latest_files in
        let rem_list = rem_commits prev_hash commit_history_list in
        config_global := {!config_global with commit_history = rem_list};
        FileHandler.save_var !(config_global) _CONFIG_PATH;
        ()
      end
    else
      failwith ("Given Hash does not exist!")
  ;;
end
