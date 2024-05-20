open Test
open Parser

let testerFunc x = Parser.parser x

let test_list1 = [
  ("add hello.txt", testerFunc, "add hello.txt", Test.Output ());
  ("add hello3.txt", testerFunc, "add hello3.txt", Test.Error "Path hello3.txt does not exist.");
];; 

Test.testSuite "Test for moksha commands" test_list1;;
