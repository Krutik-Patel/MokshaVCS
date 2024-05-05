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


(* open FileHandler *)
open FileHandler
open Global


module Add = struct

    let add_to_tracked_files file_path = 
        let () = config_global := { !config_global with tracked_files = file_path :: !(config_global).tracked_files } in
        let hash = generateNewHash () in
        hash;;

    let add_hash hash = 
        config_global := { !config_global with latest_add_hash = hash }

    let parse_args args_list = 
        let file_path = List.nth args_list 0 in
        let _ = FileHandler.load_var config_global "./.config" in
        let hash = add_to_tracked_files file_path in
        let success = add_hash hash in
        success;;
end
