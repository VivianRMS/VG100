**a)** 

*Tuples*:

A tuple can hold two or three values, and each value can have **any** **type**.

Tuples can be used if more than one value need to be returned from a function.

```elm
Tuple.pair 1 2 == (1,2)
Tuple.first (1,2) == 1
Tuple.second (1,2) == 2
Tuple.mapFirst String.reverse ("stressed", 16) == ("desserts",16) 
Tuple.mapSecond sqrt   ("stressed", 16) == ("stressed", 4)
Tuple.mapBoth String.reverse sqrt ("stressed", 16) == ("desserts", 4)
```

*Records*

A **record** can hold many values, and each value is associated with a name.

Records can be used to hold complex data, e.g. to hold three or more values of different types.

```elm
rkl = { age = 19 , name = "Vivian" }
rkl.name == "Vivian"
.name rkl == "Vivian"
```

*Lists*

A **list** can hold many values of the same type.

Lists are especially useful when one wants to iterate through a mass of values and apply same operations to them with the help of the function map.

```elm
List.indexedMap Tuple.pair ["Tom","Sue","Bob"] == [ (0,"Tom"), (1,"Sue"), (2,"Bob") ]
List.filterMap String.toInt ["3", "hi", "12", "4th", "May"] == [3,12]
```



**c)** Change the age field in the record:

```elm
rkl = { age = 19 , name = "Vivian" }
rkl1 = { rkl | age = rkl.age+1 }
rkl == { age = 19 , name = "Vivian" }
rkl1 == { age=20 , name = "Vivian" }
```
