**t2**

The file *Exercise1.md* is for exercise 1.

The folder *Exercise 2* is for exercise 2.

The foldr *snake* is for exercise 3.



**ex1**

In exercise 1, 4 sub-questions are answered.

*a)* Differences between tuples, records and lists are discussed. How to use them each is presented by short lines of Elm codes. When to use each or their advantages are discussed.

*b)* A picture of paradigm is presented demonstrating relationship between eight concepts.

*c)* Short lines of Elm codes are written to show how to change specific record fields while leaving other fields unchanged.

*d)* A picture of paradigm is presented demonstrating relationship between elm init, update and view.



**ex2**

In *Func.elm*, seven functions ( *func1 ~ func7* ) are defined to serve certain purposes as required.



**ex3**

In *snake/src* folder, the original *Main.elm* is splitted into *Main.elm, Fruit.elm, Snake.elm, Grid.elm.* 

A type alias *Snake* is defined in *Snake.elm*, and in the *Model* a new field       *snake : Snake* is used to replace previous several snake-related fields now included in *Snake*.

Also in the type alias *Snake*, the field *score : Int* is used to record the scores and update scores each time the snake gets a fruit and show scores on the top of the screen.

The type *Msg* is simplified with *Key Dir*. And correspondingly, the function *updateFruit* is simplified with further help of a new function *changeDir*.

In *Snake.elm*, the function *forward* is revised to change *snake_state* to *Dead* when the snake either collides with the wall or its body so that the game ends then.