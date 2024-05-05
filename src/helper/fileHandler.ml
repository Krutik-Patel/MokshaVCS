module FileHandler = struct
  let load_var var file = 
    let ic = open_in_bin file in
    let data = Marshal.from_channel ic in
    let _ = close_in ic in
    var := data;;

  let save_var data file = 
    let oc = open_out_bin file in
    let _ = Marshal.to_channel oc data [] in
    close_out oc;;
end;;