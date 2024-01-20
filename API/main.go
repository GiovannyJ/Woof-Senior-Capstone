package main

import (
	r "API/rest"
	"flag"
)


func main(){
	// fmt.Println(r.GenerateToken("1"))
	// fmt.Println(r.GenerateToken("2"))
	// fmt.Println(r.GenerateToken("3"))
	inputFlag := flag.String("t", "type", "Run the API in test or prod mode")

	flag.Parse()

	flagValue := *inputFlag

	r.API(flagValue)
}