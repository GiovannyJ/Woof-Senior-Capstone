package main

import (
	r "API/rest"
	"flag"
)


func main(){
	inputFlag := flag.String("t", "type", "Run the API in test or prod mode")

	flag.Parse()

	flagValue := *inputFlag

	r.API(flagValue)
}