# Sample

(broken, need fix) invalid1.go
```
package dummy_go

import "fmt"

func  {
	
}



```

(non-broken, need format) invalid2.go
```
package dummy_go

import (
			"fmt"
"log"
)

func 		getA() string {
	res :=    "A"
	fmt.Println(res)
log.Println(res)
	return   res
}

func getB() int {
	res := 2



		fmt.Println(res)
	

	log.Println(res)

return res
}

```


(non-broken, no need format) valid.go
```
package dummy_go

import (
	"fmt"
	"log"
)

func getString() string {
	res := "Hello World"
	fmt.Println(res)
	log.Println(res)
	return res
}

func getInt() int {
	res := 123
	fmt.Println(res)
	log.Println(res)
	return res
}

```


# References
- [golang](https://go.dev/)