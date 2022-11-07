# Sample

(broken, need fix) invalid1.ini
```
    [h e l l o   ]
a=b b= c
[db "a" db "b" db "c"]
    host="aaa"
    d
=g
```

(non-broken, need format) invalid2.ini
```
    [hello]
a=b
        b= "b  "

 b    =1
    c=   c


[db "a" ]
    host="aaa"
        [db "   b"]
host="bbb"
    [db    "c"]
        host="ccc"

[numbers]
n=1

    n=2
        n=3
            n=4
        n=5
    n=6

n=7

```

(non-broken, no need format) valid.ini
```
[hello]
a=b
b="b"
b=1
c=c

[db "a"]
host="aaa"
[db "b"]
host="bbb"
[db "c"]
host="ccc"

[numbers]
n=1
n=2
n=3
n=4
n=5
n=6
n=7

```

# References
- [prettier-plugin-ini](https://www.npmjs.com/package/prettier-plugin-ini)