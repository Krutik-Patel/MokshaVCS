open FileHandler
open Global

module ConfigInterface = struct
  let open_config () = let _ = FileHandler.load_var config_global _CONFIG_PATH in config_global

  let close_config config = let _ = FileHandler.save_var !(config) _CONFIG_PATH in ()
  
  let get_user_credentials () = 
    let config = open_config () in
    !(config).user_credentials
  
  let set_user_credentials user_credentials_ = 
    let config = open_config () in
    let () = config := { !(config) with user_credentials = user_credentials_ } in
    close_config config 

  let get_commit_history () = 
    let config = open_config () in
    !(config).commit_history

  let set_commit_history commit_history_ = 
    let config = open_config () in
    let () = config := { !(config) with commit_history = commit_history_ } in
    close_config config

  let get_latest_add_hash () = 
    let config = open_config () in
    !(config).latest_add_hash

  let set_latest_add_hash latest_add_hash_ = 
    let config = open_config () in
    let () = config := { !(config) with latest_add_hash = latest_add_hash_ } in
    close_config config

  let get_tracked_files () = 
    let config = open_config () in
    !(config).tracked_files
  
  let set_tracked_files tracked_files_ = 
    let config = open_config () in
    let () = config := { !(config) with tracked_files = tracked_files_ } in
    close_config config

  let get_uncommitted_changes_count () = 
    let config = open_config () in
    !(config).uncommitted_changes_count
    
  let set_uncommitted_changes_count uncommitted_changes_count_ = 
    let config = open_config () in
    let () = config := { !(config) with uncommitted_changes_count = uncommitted_changes_count_ } in
    close_config config
end