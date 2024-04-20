(* open Test *)

module Test = struct
  type 'a test_result = 
  | Output of 'a
  | Error of exn;;

  let runTest func arg expected = 
    let res = 
      try Output (func arg);
      with e -> Error e
    in res = expected;; 
    
  let showOutput test_suite_name out_list test_list = 
    let combined_res_test = List.combine test_list out_list in
    let failure_tests = List.filter (fun (result, x) -> not x) combined_res_test in
    let passed_cnt = List.length test_list - List.length failure_tests in
    Printf.printf "%s -> %d/%d passed\n" test_suite_name passed_cnt (List.length test_list);
    if passed_cnt != 0 then
      let printFailedTest tests = 
        let _ = List.map (fun (result, _) -> let (name, _, _, _) = result in Printf.printf "Failed: %s\n" name) tests in
        ()
      in printFailedTest failure_tests
    else 
      ();;
      
  (* use testSuite method only to run a test
     pass test suite's name and the tests which have each test's name/id and the function, its args and expected value *)
  let testSuite test_suite_name tests = 
    let out = List.map (fun (name, f, arg, expected) -> runTest f arg expected) tests in
    showOutput test_suite_name out tests;;
end

let testerFunc x = x;;

let test_list1 = [
  ("test1", testerFunc, 1, Test.Output 1);
  ("test2", testerFunc, 2, Test.Output 1);
  ("test3", testerFunc, 1, Test.Output 1);
  ("test4", testerFunc, 4, Test.Output 1);
  ("test5", testerFunc, 1, Test.Output 1);
];; 

Test.testSuite "Test for moksha commands" test_list1;;





