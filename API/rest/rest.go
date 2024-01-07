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


	// /*
	// *=========================POST ROUTES================================
	// */
	router.POST("new/user", NewUser)
	router.POST("new/business", NewBusiness)
	router.POST("new/review/user/:userid/business/:businessid", NewReview)
	router.POST("new/savedbuisiness/user/:userid/", NewSavedBusiness)
	router.POST("new/event/business/:businessid", NewEvent)
	router.POST("login", Login)
	

	// /*
	// *=========================PATCH ROUTES================================
	// */
	router.PATCH("update/users", Update)
	router.PATCH("update/users/password", )
	router.PATCH("update/business", Update)
	router.PATCH("update/review", Update)
	router.PATCH("update/event", Update)
	// router.PATCH("users/:userid/savedbusiness/:savedbusinessid", )


	// /*
	// *=========================DELETE ROUTES================================
	// */
	// router.DELETE("users", )
	// router.DELETE("businesses", )
	// router.DELETE("businesses/:businessid/reviews", )
	// router.DELETE("businesses/:businessid/event", )
	// router.DELETE("users/:userid/savedbusiness/:savedbusinessid", )

	
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