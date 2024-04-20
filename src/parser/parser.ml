let command = [
    "moksha add";
    "moksha commit";
];;


(* command_args_list takes in a single string and breaks it into a list with command and args *)
let command_args_list str = 
    let cmd_list = String.split_on_char ' ' str in
        cmd_list;;        


let main_parser cmd_list = 
    let cmd = List.hd cmd_list in
    match cmd with    
    | "moksha" -> print_string "Keyword works!!"
    | nt_cmd -> failwith (Printf.sprintf "(\"%s\") is not a recognizable command" nt_cmd);;


let command_parser sub_cmd_list = 
    let sub_cmd = List.hd sub_cmd_list in
    match sub_cmd with
    | "add" -> print_string "Add command"
    | "commit" -> print_string "Add command"
    | nt_sub_cmd -> failwith (Printf.sprintf "(\"%s\") is not a recognizable sub-command" nt_sub_cmd);;



