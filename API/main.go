package main

import (
	"flag"
	r "API/rest"
)


func main(){
	inputFlag := flag.String("t", "type", "Run the API in test or prod mode")

	flag.Parse()

	flagValue := *inputFlag

	r.API(flagValue)
}