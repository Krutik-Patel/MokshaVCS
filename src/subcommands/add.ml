(* let parse_args args_list = 
    let tracking_files = List.hd args_list in    *)

(* Assumption: moksha add fileName
   later include directoryName and 
   recursively add all files in directory 
   for later, use get_directories function*)

(* let get_directories path =
    Sys.readdir path
    |> Array.to_list
    |> List.filter (fun name ->
        Sys.is_directory (Filename.concat path name))
 *)


 (* Funtionalitites to add: check whether the added file exists *)

open FileHandler
open Global


module Add = struct

    let add_to_tracked_files file_path = 
        let () = config_global := { !config_global with tracked_files = file_path :: !(config_global).tracked_files } in
        let hash = generateNewHash () in
        hash;;

    let add_hash hash = 
        config_global := { !config_global with latest_add_hash = hash }

    let parse_args (args_list : string list) = 
        let fpath = List.nth args_list 0 in
        if not (Sys.file_exists fpath) 
            then failwith (Printf.sprintf "Path " ^ fpath ^ " does not exists.\n")
        else
            let file_path = Path(fpath) in
            let _ = FileHandler.load_var config_global _CONFIG_PATH in
            let hash = add_to_tracked_files file_path in
            let success = add_hash hash in
            let _ = FileHandler.save_var !(config_global) _CONFIG_PATH in
            success;;
end
