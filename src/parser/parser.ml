open Add
open Commit

(* helper functions *)
let print_args_list lst = 
    let rec print_list lst = 
        match lst with
        | [] -> ()
        | h :: t -> let _ = print_string h in print_list t in
    
    print_list (List.tl lst);;
    


(* command_args_list takes in a single string and breaks it into a list with command and args *)

let command_parser sub_cmd_list = 
    let sub_cmd_args = List.tl sub_cmd_list in
    match List.hd sub_cmd_args with
    | "add" -> Add.add_cmd ()
    | "commit" -> Commit.commit_cmd ()
    | nt_sub_cmd -> failwith (Printf.sprintf "(\"%s\") is not a recognizable sub-command" nt_sub_cmd);;


command_parser (Array.to_list Sys.argv);;