(* Function to add a file to the staging area *)
let add_file (filename : string) : unit =
  (* Code to add the file to the staging area *)
  print_endline ("Added file '" ^ filename ^ "' to staging area.")

(* Example usage *)
add_file "example.txt"
