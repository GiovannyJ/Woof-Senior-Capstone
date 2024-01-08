package rest

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	// "fmt"
)

//router driver make all requests here
func API(mode string){
	router := gin.Default()
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"*"}  // You might want to limit this to specific origins in production
	router.Use(cors.New(config))
	
	// gin.SetMode(gin.ReleaseMode)
	
	// if(mode != "test"){
	// 	router.Use(Authenticate())
	// }

	// fmt.Println(GenerateToken("2"))
	
	/*
	*=========================GET ROUTES================================
	*/
	
	router.GET("users", GetUsers)
	router.GET("users/:userid/savedbusinesses", GetSavedBusiness)
	router.GET("businesses", GetBusinesses)
	router.GET("businesses/:businessid/reviews", GetBusinessReviews)
	router.GET("businesses/:businessid/events", GetBusinessEvents)
	router.GET("events", GetEvents)


	/*
	*=========================POST ROUTES================================
	*/
	router.POST("users", NewUser)
	router.POST("business", NewBusiness)
	router.POST("reviews/user/:userid/businesses/:businessid", NewReview)
	router.POST("savedbusinesses/user/:userid/", NewSavedBusiness)
	router.POST("events/businesses/:businessid", NewEvent)
	router.POST("login", Login)
	

	/*
	*=========================PATCH ROUTES================================
	*/
	router.PATCH("users", Update)
	router.PATCH("users/password", )
	router.PATCH("businesses", Update)
	router.PATCH("reviews", Update)
	router.PATCH("events", Update)
	// router.PATCH("savedbusinesses", Update)


	// /*
	// *=========================DELETE ROUTES================================
	// */
	router.DELETE("users", Delete)
	router.DELETE("businesses", Delete)
	router.DELETE("reviews", Delete)
	router.DELETE("events", Delete)
	router.DELETE("savedbusinesses", Delete)

	
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