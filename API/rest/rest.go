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
	*=========================GET ROUTES================================
	*/
	
	router.GET("users", )
	router.GET("users/:userid/savedbusiness", )
	router.GET("businesses", )
	router.GET("businesses/:businessid/reviews", )
	router.GET("businesses/:businessid/events", )

	

	/*
	*=========================POST ROUTES================================
	*/
	router.POST("users", )
	router.POST("businesses", )
	router.POST("businesses/:businessid/reviews", )
	router.POST("businesses/:businessid/event", )
	router.POST("users/:userid/savedbusiness", )
	

	/*
	*=========================PATCH ROUTES================================
	*/
	router.PATCH("users", )
	router.PATCH("businesses", )
	router.PATCH("businesses/:businessid/reviews", )
	router.PATCH("businesses/:businessid/event", )
	router.PATCH("users/:userid/savedbusiness/:savedbusinessid", )


	/*
	*=========================DELETE ROUTES================================
	*/
	router.DELETE("users", )
	router.DELETE("businesses", )
	router.DELETE("businesses/:businessid/reviews", )
	router.DELETE("businesses/:businessid/event", )
	router.DELETE("users/:userid/savedbusiness/:savedbusinessid", )

	
	/*
	*=========================FILE HANDLER ROUTES================================
	*/

	// /*
	// *WORKING
	// !NEEDS MORE TESTS
	// upload files in JSON FORMAT
	// */
	// router.POST("/uploads", PlaceHolder)

	// /*
	// *WORKING
	// retrieve file in JSON
	// */
	// router.GET("/uploads/:file", PlaceHolder)


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