open Test;;

let testerFunc x = x;;

let test_list1 = [
  ("test1", testerFunc, 1, Test.Output 1);
  ("test2", testerFunc, 2, Test.Output 1);
  ("test3", testerFunc, 1, Test.Output 1);
  ("test4", testerFunc, 4, Test.Output 1);
  ("test5", testerFunc, 1, Test.Output 1);
];; 

Test.testSuite "Test for moksha commands" test_list1;;
