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
