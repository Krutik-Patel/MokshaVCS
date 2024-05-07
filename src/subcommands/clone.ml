(* Command Usage : moksha clone dir_name*)
open FileHandler
open Unix
open Global

module Clone = struct
  let copy_file src_file dest_file =
    let command = Printf.sprintf "cp %s %s" src_file dest_file in
    let exit_status = system command in
    match exit_status with
    | WEXITED 0 ->
      Printf.printf "Configuration file %s Cloned successfully.\n" dest_file
    | _ ->
      failwith "Failed to Clone configuration file.";;

  let file_exists_in_directory directory file =
    let full_path = Filename.concat directory ("/" ^ file) in
    Sys.file_exists full_path;;

  let directory_exists dir =
    Sys.file_exists dir && Sys.is_directory dir ;;

  let copy_directory src_dir dest_dir =
    let command = Printf.sprintf "cp -r %s %s" src_dir dest_dir in
    let exit_status = Unix.system command in
    match exit_status with
    | Unix.WEXITED 0 ->
      Printf.printf "Directory %s cloned successfully.\n" dest_dir
    | _ ->
      failwith "Failed to Clone." ;;

  let parse_args (args_list : string list) = 
    let global_dir = List.nth args_list 0 in
    begin
      if directory_exists global_dir then
        copy_directory global_dir "./"
      else
        Printf.printf "Directory %s does not found\n" global_dir
      (* if file_exists_in_directory global_dir ".config" then
        begin
          copy_file global_dir _CONFIG_PATH;
          if directory_exists (global_dir ^ "/" ^ ".commits") then
            copy_directory (global_dir ^ "/" ^ ".commits") _COMMIT_DIR 
          else 
            Printf.printf "Directory %s does not found in directory %s\n" ".commits" global_dir
        end
      else
        Printf.printf "File %s does not found in directory %s\n" ".config" global_dir *)
    end
      
  ;;

end
