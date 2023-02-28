**t4**

Answers for *ex1* is written in this *README*.

The folder *ex2* is for exercise 2.

The folder *ex3* is for exercise 3.

The foldr *ex4* is for exercise 4.



**Ex1**

**1(a)** Unlike Elm, in Javascript has a lot of side-effects. It can cause runtime errors, mutations of values and package flooding.

**1(b)** Javascript Interop is a method programmers use to integrate Elm with Javascript. It helps the interaction between the browser and Elm, with help of Javascript. By comparison, commands and subscriptions are the interaction between the server and Elm. So data of JSON type can be returned by server due to cmd and sub and then Javascript Interop helps browser to present data.

**1(c)** In Tetris, in *onTouchStart* and *onTouchEnd* function, Javascript Interop is used. The *Json.succed* msg produces a Decoder msg and decodes a JSON message into an Elm message.



**Ex2**

**1.** The limitation is that if size of list is smaller than the index, then which number will be the output ? 

**2.** Considering the limitation explained above, I change the type of output to Maybe Int so that if there are not enough elements, then *Nothing* will be the output. In this case, the limitation is overcome.



**Ex3**

This time, the fruit generated each time has probability of 20% to be apple. And the function *fruit_kindGen* is added to generate random kind of fruit.



**Ex4**

**1.** The *pause* and *resume* buttom is removed. And during the game the button will still be *New game* and after pressing it, the game is restarted by clearing fixed tetriminos and scores.

**2.** The function *randomColor* is added to generate random colors for each newly generated tetrimino.

**3.** In function *fullLine*,the judgement of a full line now also judges an almost full line as a full line. Then, in function *clearLines*, when deciding whether to also clear the line below the "full" line, we use *checkfullLine* to know whether the "full" line is truly full. If yes, then clear the line below it and adding scores for another line. Else, don't clear the line below it.

