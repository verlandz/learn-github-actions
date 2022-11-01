package dummy_go

import "fmt"

func getString() string {
	res := "Hello World"
	fmt.Println(res)
	return res
}

func getInt() int {
	res := 123
	fmt.Println(res)
	return res
}
