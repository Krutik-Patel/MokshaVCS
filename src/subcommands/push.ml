(* Command Usage : moksha push dir_name*)
open FileHandler
open Global
open Unix

module Push = struct
  let copy_file (src_name : file) (dest_dir : file) = 
    let Path src = src_name in
    let Path dest = dest_dir in
    let _ = mkdir_p (Filename.dirname (Filename.concat dest src)) in
    let src_path = Filename.concat _CURRENT_DIR src in
    let dest_path = Filename.concat dest src in
    let ic = open_in_bin src_path in 
    let oc = open_out_bin dest_path in
    let rec copy_chars ic oc = 
        try
            output_char oc (input_char ic);
            copy_chars ic oc
        with End_of_file ->
            close_in ic;
            close_out oc
        in copy_chars ic oc ;;

  let directory_exists dir =
    Sys.file_exists dir && Sys.is_directory dir ;;

  let file_exists_in_directory directory file =
    let full_path = Filename.concat directory ("/" ^ file) in
    Sys.file_exists full_path;;

  let copy_directory src_dir dest_dir =
    let command = Printf.sprintf "cp -r %s %s" src_dir dest_dir in
    let exit_status = Unix.system command in
    match exit_status with
    | Unix.WEXITED 0 ->
      Printf.printf "%s Pushed to %s successfully.\n" src_dir dest_dir
    | _ ->
      failwith "Failed to Push." ;;


  let checkSync local_commit_history_list global_commit_history_list =
    let rec contains_all lst1 lst2 =
      match lst1 with
      | [] -> true (* All elements from lst2 have been found in lst1 *)
      | x :: rest ->
        if List.mem x lst2 then
          contains_all rest lst2
        else
          false (* If x is not found in lst2, return false *)
    in
    contains_all global_commit_history_list local_commit_history_list;;


  let delete_all_content directory =
    let command = Printf.sprintf "rm -rf %s/*" directory in
    let exit_status = system command in
    match exit_status with
    | WEXITED 0 ->
      Printf.printf "Syncing conditions for Push are satisfied.\n"
    | _ ->
      failwith "Failed to match Syncing conditions";;
    


  let parse_args (args_list : string list) = 
    let global_dir = List.nth args_list 0 in
      if directory_exists global_dir then
        begin
          if Sys.file_exists _CONFIG_PATH then
            begin
              let _ = FileHandler.load_var config_global _CONFIG_PATH in
              let local_commit_history_list = !(config_global).commit_history in
              if file_exists_in_directory global_dir ".config" then
                begin
                  let _ = FileHandler.load_var config_global (Filename.concat global_dir ".config") in
                  let global_commit_history_list = !(config_global).commit_history in
                  let sync = checkSync local_commit_history_list global_commit_history_list in
                  (* Printf.printf "%b \n" sync *)
                  if sync then
                    begin
                      delete_all_content global_dir;
                      copy_file (Path _CONFIG_PATH) (Path global_dir);
                      if directory_exists _COMMIT_DIR then
                        begin
                          copy_directory _COMMIT_DIR global_dir;
                          let CommitDir(h, Path fname, _) = List.hd local_commit_history_list in
                          copy_directory (Filename.concat fname "*") global_dir
                        end
                      else failwith ("Directory " ^ _COMMIT_DIR ^ " does not found")
                    end
                  else failwith ("Commit History is Out of Sync! Push is aborted!")
                end
              else failwith ("File " ^ (Filename.concat global_dir ".config") ^ " does not found")
            end
          else failwith ("File " ^ _CONFIG_PATH ^ " does not found") 
      
        end
      else failwith ("Directory " ^ global_dir ^ " does not exist") ;;

end




(* copy_file (Path _CONFIG_PATH) (Path global_dir);
  if directory_exists _COMMIT_DIR then
    begin
      copy_directory _COMMIT_DIR global_dir;
      (* Now add last commited version to global_dir *)
      let _ = FileHandler.load_var config_global _CONFIG_PATH in
      let commit_history_list = !(config_global).commit_history in
      (* Printf.printf "Size of commit history list: %d\n" (List.length commit_history_list) *)
      let CommitDir(h, Path f, _) = List.hd commit_history_list in
      copy_directory (Filename.concat f "*") global_dir;
    end
  else
    Printf.printf "Directory %s does not found\n" _COMMIT_DIR *)