package database

import (
	"log"
	"os"
  "github.com/joho/godotenv"
)

/*
*TESTED WORKING
loads .env file
differentiates between running in container or not by looking at value DOCKER_CONTAINER
returns .env variable
*/
func EnvVar(key string) string {

  if _, runningInsideContainer := os.LookupEnv("DOCKER_CONTAINER"); !runningInsideContainer {
    // load .env file
    err := godotenv.Load(".env")
  
    if err != nil {
      log.Fatalf("Error loading .env file")
    } 
  }
  
  return os.Getenv(key)
}