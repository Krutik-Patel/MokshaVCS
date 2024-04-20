
let testSuite test_list = 
  let rec forEachTest test_list = 
    match test_list with
    | [] -> ()
    | (x, y, z) :: t -> 
        let _ = runTest x y z in 
        forEachTest t
  in 
    try 
        forEachTest test_list;
        printEnd 
    with _ -> failwith "Test Suite not setup properly "
