# Sample

(broken, need fix) invalid1.json
```



    {
      "hello": "world",
  "world": "hello",         
  
  "ok1": true,"arr_hello": ["w", 
  "o",    
  "r","l",
          "d"],"ok2":     false   ,,,,,,
   } 
  
  
  
```

(non-broken, need format) invalid2.json
```



    {
      "hello": "world",
  "world": "hello",         
  
  "ok1": true,"arr_hello": ["w", 
  "o",    
  "r","l",
          "d"],"ok2":     false   ,

          

"arr": [
  {
      "hello": "world",
  "world": "hello",         
  
  "ok1": true,"arr_hello": ["w", 
  "o",    
  "r","l",
          "d"],"ok2":     false
   } 
  
      ,
      {
          "hello": "world",
      "world": "hello",         
      
      "ok1": true,"arr_hello": ["w", 
      "o",    
      "r","l",
              "d"],"ok2":     false
       } 
      
  ]
      
   } 
  
  
  
```

(non-broken, no need format) valid.json
```
{
    "hello":"world",
    "world":"hello",
    "ok1":true,
    "arr_hello":[
        "w",
        "o",
        "r",
        "l",
        "d"
    ],
    "ok2":false
}
```

# References
- [jq](https://stedolan.github.io/jq/)