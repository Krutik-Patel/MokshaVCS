open Global
open Unix
open ConfigInterface

(* for now, no commit message
    command usage: moksha commit
    or             moksha commit -m "your message here"
*)

module Commit = struct
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
            in copy_chars ic oc

    let print_committed_file_message (f : file) = 
        let Path str = f in
        print_endline ("Committed " ^ str)


    let copy_files_to_commit_dir (dir_path : file) = 
        let current_dirs_files_list = ConfigInterface.get_tracked_files () in
        let _ = List.map (fun f -> let _ = copy_file f dir_path in print_committed_file_message f) current_dirs_files_list in
        ()


    let make_commit msg = 
        let Hash str = ConfigInterface.get_latest_add_hash () in
        let new_commit_dir = Path(_COMMIT_DIR^str) in
        let commit_el = CommitDir(ConfigInterface.get_latest_add_hash (), new_commit_dir, CommitMsg(msg)) in
        let () = ConfigInterface.set_commit_history (commit_el :: ConfigInterface.get_commit_history ()) in
        let () = ConfigInterface.set_uncommitted_changes_count 0 in
        let _ = copy_files_to_commit_dir (new_commit_dir) in 
        ()
    

    let parse_args (args_list : string list) = 
        let CommitDir (last_commit_hash, _, _) = List.hd (ConfigInterface.get_commit_history ()) in
        let success = if ConfigInterface.get_latest_add_hash () = last_commit_hash 
                    then print_endline "Nothing to commit."
                else
                    let msg = if (List.length args_list > 0) && (List.nth args_list 0 = "-m") then (List.nth args_list 1) else "NA" in
                    let success = make_commit msg in
                    success 
                in success;;
end