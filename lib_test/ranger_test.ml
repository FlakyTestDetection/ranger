open Kaputt.Abbreviations

module R = Ranger

let arr = [|1;2;3;4|]

let arr_gen = 
  let open Gen in
  array (make_int 0 10) (make_int 4 10)

let () = Test.add_simple_test ~title:"of_array"
    (fun () ->
       let rng = R.of_array arr ~start:1 ~stop:(`Inclusive 2) in
       let s1 = R.fold_left rng ~init:0 ~f:(+) in
       Assert.equal_int s1 5)

let () = Test.add_simple_test ~title:"reverse"
    (fun () ->
       let rev = R.rev (R.of_array arr) in
       let elems = R.to_list rev in
       Assert.equal arr (Array.of_list (List.rev elems)))

let () = Test.add_random_test ~title:"for_all" ~nb_runs:20 arr_gen
    (fun arr -> R.of_array arr)
    [
      Spec.always ==> (fun r -> R.for_all r ~f:(fun x -> x > 3))
    ]

let () = Test.add_random_test ~title:"length" ~nb_runs:20 arr_gen
    (fun arr -> (arr, R.of_array arr))
    [
      Spec.always ==> (fun (arr, range) -> 
          (R.length range) = (Array.length arr))
    ]

let () = Test.add_simple_test ~title:"takel empty"
    (fun () ->
       let range = R.of_array arr in
       let zero = R.takel range 0 in
       Assert.equal_int (List.length (R.to_list zero)) 0;
       Assert.equal_int 0 (R.length zero))

let () = Test.add_random_test ~title:"takel" ~nb_runs:20 arr_gen
    (fun arr -> 
       let range = R.of_array arr in
       let len  = Array.length arr in
       let take_n = if len = 0 then 0 else (Random.int len) in
       (R.takel range take_n, take_n, arr))
    [
      Spec.always ==> (fun (taken, l, _) -> (R.length taken) = l);
    ]

let () = Test.launch_tests ()


