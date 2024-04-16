type command =
  | Init
  | Add of string
  | Commit of string
  | Status
  | Log
  | Checkout of string
  | Branch of string
  | Merge of string
  | Push
  | Pull
  | Clone of string

let parse_command (input : string) : command option =
  let tokens = String.split_on_char ' ' input in
  match tokens with
  | ["init"] -> Some Init
  | "add" :: file :: [] -> Some (Add file)
  | "commit" :: "-m" :: message :: [] -> Some (Commit message)
  | ["status"] -> Some Status
  | ["log"] -> Some Log
  | "checkout" :: commit :: [] -> Some (Checkout commit)
  | "branch" :: name :: [] -> Some (Branch name)
  | "merge" :: branch :: [] -> Some (Merge branch)
  | ["push"] -> Some Push
  | ["pull"] -> Some Pull
  | "clone" :: url :: [] -> Some (Clone url)
  | _ -> None

(* Example usage *)
let command = parse_command "commit -m \"Initial commit\""
match command with
| Some cmd -> print_endline ("Parsed command: " ^ (match cmd with
  | Init -> "init"
  | Add file -> "add " ^ file
  | Commit message -> "commit -m \"" ^ message ^ "\""
  | Status -> "status"
  | Log -> "log"
  | Checkout commit -> "checkout " ^ commit
  | Branch name -> "branch " ^ name
  | Merge branch -> "merge " ^ branch
  | Push -> "push"
  | Pull -> "pull"
  | Clone url -> "clone " ^ url))
| None -> print_endline "Invalid command"
