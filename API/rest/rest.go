package rest

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

//router driver make all requests here
func API(mode string){
	router := gin.Default()
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"}  // You might want to limit this to specific origins in production
	router.Use(cors.New(config))
	
	// gin.SetMode(gin.ReleaseMode)
	
	if(mode != "test"){
		router.Use(Authenticate())
	}

	// fmt.Println(GenerateToken("2"))
	
	/*
	*=========================DATA BASE ROUTES================================
	*/

	/*
	no params = all values
	options, base, grip, position, rotation, impact, muscle
	? ex: http://localhost:8080/data/workout?base=barbell%20bench%20press&impact=8
	*/
	router.GET("/data/workout", PlaceHolder)


	/*
	*TESTED WORKING
	JSON body: shaped like account struct
	*/
	router.POST("push/account", PlaceHolder)
	

	/*
	*TESTED WORKING
	JSON body: shaped like patch_account struct
	*/
	router.PATCH("update/account", PlaceHolder)

	
	/*
	*=========================FILE HANDLER ROUTES================================
	*/

	/*
	*WORKING
	!NEEDS MORE TESTS
	upload files in JSON FORMAT
	*/
	router.POST("/uploads", PlaceHolder)

	/*
	*WORKING
	retrieve file in JSON
	*/
	router.GET("/uploads/:file", PlaceHolder)


	/*
	*=========================EMAIL ROUTES================================
	*/
	

	/*
	*=========================PHONE AUTH ROUTES================================
	*/
	

	/*
	*=========================FORUM ROUTES ROUTES================================
	*/
	// router.GET("/forum", handleForum)
	// router.POST("/forum", handleForum)


	//*activate the server
	router.Run("localhost:8080")
}