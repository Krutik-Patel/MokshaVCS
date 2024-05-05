open FileHandler
open Global
open Unix

(* for now, no commit message
    command usage: moksha commit
*)

module Commit = struct
    let copy_file (src_name : file) (dest_dir : file) = 
        let Path src = src_name in
        let Path dest = dest_dir in
        let _ = if not (Sys.file_exists _COMMIT_DIR) then Unix.mkdir _COMMIT_DIR 0o777 in
        let _ = if not (Sys.file_exists dest) then Unix.mkdir dest 0o777 in
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
            in copy_chars ic oc


    let copy_files_to_commit_dir (dir_path : file) = 
        let current_dirs_files_list = !(config_global).tracked_files in
        let _ = List.map (fun f -> copy_file f dir_path) current_dirs_files_list in
        ()


    let make_commit () = 
        let Hash str = !(config_global).latest_add_hash in
        let new_commit_dir = Path(_COMMIT_DIR^str) in
        let commit_el = CommitDir(!(config_global).latest_add_hash, new_commit_dir) in
        let () = config_global := { !config_global with commit_history = commit_el :: !(config_global).commit_history } in
        let _ = copy_files_to_commit_dir (new_commit_dir) in 
        ()
    

    let parse_args (args_list : string list) = 
        let _ = FileHandler.load_var config_global _CONFIG_PATH in 
        let success = make_commit () in
        let _ = FileHandler.save_var !config_global _CONFIG_PATH in
        success;;
end