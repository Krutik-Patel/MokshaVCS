open Add
open Init
open Commit


(* Functionality to add: Make a new type called errors, which has all the types of errors *)

(* helper functions *)
(* let print_args_list lst = 
    let rec print_list lst = 
        match lst with
        | [] -> ()
        | h :: t -> let _ = print_string h in print_list t in
    
    print_list (List.tl lst);;
     *)


(* command_args_list takes in a single string and breaks it into a list with command and args *)

let command_parser cmd_list = 
    let sub_cmd_args = List.tl cmd_list in
    match List.hd sub_cmd_args with
    | "init" ->         Init.parse_args (List.tl sub_cmd_args)
    | "add" ->          Add.parse_args (List.tl sub_cmd_args)
    | "commit" ->       Commit.parse_args (List.tl sub_cmd_args)
    (*| "push" ->         Push.parse_args (List.tl sub_cmd_args)                                                                                                              
    | "status" ->       Status.parse_args (List.tl sub_cmd_args)
    | "checkout" ->     Checkout.parse_args (List.tl sub_cmd_args)
    | "merge" ->        Merge.parse_args (List.tl sub_cmd_args)
    | "pull" ->         Pull.parse_args (List.tl sub_cmd_args)
    | "log" ->          Log.parse_args (List.tl sub_cmd_args)
    | "clone" ->        Clone.parse_args (List.tl sub_cmd_args)
    | "force-revert" -> ForceRevert.parse_args (List.tl sub_cmd_args) *)
    | nt_sub_cmd -> failwith (Printf.sprintf "(\"%s\") is not a recognizable sub-command" nt_sub_cmd);;


command_parser (Array.to_list Sys.argv);;