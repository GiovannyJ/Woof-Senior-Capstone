package rest

import (
	db "API/database"
	s "API/models"
	"encoding/json"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type user = s.User
type login = s.LogIn
type business = s.Business
type savedBusiness = s.SavedBusiness
type review = s.Review
type event = s.Event
type updatequery = s.UpdateQuery
type deletequery = s.DeleteQuery
type pwdreset = s.PWDReset
type attendance = s.Attendance

/*
*=================GET METHOD HANDLERS==================
 */

/*
*TESTED WORKING
GETS all users
can query for userID, username, email, accountType, and order ASC or DESC
*/
func GetUsers(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"userID":      c.Query("userID"),
		"username":    c.Query("username"),
		"email":       c.Query("email"),
		"accountType": c.Query("accountType"),
		"order":       c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}
	cacheKey := generateCacheKey(queryParams, "getusers")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Users_GET(query, 0)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
Gets all the events a user is attending using userID
*/
func GetUserAttendance(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})
	userID := c.Param("userid")
	id, err := strconv.Atoi(userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	queryParams := map[string]string{
		"b.businessID":       c.Query("businessID"),
		"b.businessName":     c.Query("businessName"),
		"b.businessType":     c.Query("businessType"),
		"b.location":         c.Query("location"),
		"b.contact":          c.Query("contact"),
		"b.ownerID":          c.Query("ownerID"),
		"b.petSizePref":      c.Query("B_petSizePref"),
		"b.leashPolicy":      c.Query("B_leashPolicy"),
		"b.disabledFriendly": c.Query("B_disabledFriendly"),
		"b.rating":           c.Query("rating"),
		"b.geolocation":	  c.Query("B_geolocation"),
		"e.eventID":          c.Query("eventID"),
		"e.eventName":        c.Query("eventName"),
		"e.eventDate":        c.Query("eventDate"),
		"e.petSizePref":      c.Query("E_petSizePref"),
		"e.leashPolicy":      c.Query("E_leashPolicy"),
		"e.disabledFriendly": c.Query("E_disabledFriendly"),
		"e.attendance_count": c.Query("attendance_count"),
		"e.geolocation":	  c.Query("E_geolocation"),
		"order":              c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}
	cacheKey := generateCacheKey(queryParams, userID+"getuserattendance")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Users_Attendance_GET(query, id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all businesses
and query for businessID, businessName, ownerID, rating, order (ASC, DESC)
*/
func GetBusinesses(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"businessID":       c.Query("businessID"),
		"businessName":     c.Query("businessName"),
		"businessType":     c.Query("businessType"),
		"location":         c.Query("location"),
		"contact":          c.Query("contact"),
		"ownerUserID":      c.Query("ownerUserID"),
		"rating":           c.Query("rating"),
		"petSizePref":      c.Query("petSizePref"),
		"leashPolicy":      c.Query("leashPolicy"),
		"disabledFriendly": c.Query("disabledFriendly"),
		"geolocation":		c.Query("geolocation"),
		"order":            c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}
	cacheKey := generateCacheKey(queryParams, "getbusinesses")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Business_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all saved businesses in the database
requires a userID to view their saved businesses
can query for businessID and order (ASC DESC)
*/
func GetSavedBusiness(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})
	userID := c.Param("userid")
	id, err := strconv.Atoi(userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	queryParams := map[string]string{
		"b.businessID":       c.Query("businessID"),
		"b.businessName":     c.Query("businessName"),
		"b.businessType":     c.Query("businessType"),
		"b.location":         c.Query("location"),
		"b.contact":          c.Query("contact"),
		"b.ownerID":          c.Query("ownerID"),
		"b.petSizePref":      c.Query("B_petSizePref"),
		"b.leashPolicy":      c.Query("B_leashPolicy"),
		"b.disabledFriendly": c.Query("B_disabledFriendly"),
		"b.rating":           c.Query("rating"),
		"b.geolocation":	  c.Query("geolocation"),
		"order":              c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}
	cacheKey := generateCacheKey(queryParams, userID+"getsavedbusinesses")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Users_SavedBusiness_GET(query, id)
	/*
		! POSSIBLY MAKE ENDPOINT FOR THIS??
		! results, err := db.SavedBusiness_GET(query, id)
	*/
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all reviews for business based on businessID
can query by review(id/rating/date) user(id/name/email/accType) business(id/name/type/rating/descr) order(ASC/DESC)
*/
func GetBusinessReviews(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})
	businessID := c.Param("businessid")
	id, err := strconv.Atoi(businessID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid business ID"})
		return
	}

	queryParams := map[string]string{
		"r.reviewID":    c.Query("reviewID"),
		"r.rating":      c.Query("reviewRating"),
		"r.dateCreated": c.Query("dateCreated"),
		"u.userID":      c.Query("userID"),
		"u.username":    c.Query("username"),
		"u.email":       c.Query("email"),
		"u.accountType": c.Query("accountType"),
		"order":         c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}
	cacheKey := generateCacheKey(queryParams, businessID+"getbusinessreviews")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Businesses_Reviews_Users_GET(query, id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all events from database
and query by eventID, businessID, eventName, eventDate and order (ASC, DESC)
*/
func GetEvents(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"eventID":          c.Query("eventID"),
		"businessID":       c.Query("businessID"),
		"eventName":        c.Query("eventName"),
		"eventDate":        c.Query("eventDate"),
		"petSizePref":      c.Query("petSizePref"),
		"leashPolicy":      c.Query("leashPolicy"),
		"disabledFriendly": c.Query("disabledFriendly"),
		"attendance_count": c.Query("attendance_count"),
		"geolocation":		c.Query("geolocation"),
		"order":            c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}
	cacheKey := generateCacheKey(queryParams, "getevents")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Event_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all events for a business using businessID
can query by eventID, eventName, eventDate, businessID, businessName, businessType, rating, ownerUserID, order(ASC/DESC)
*/
func GetBusinessEvents(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})
	businessID := c.Param("businessid")
	id, err := strconv.Atoi(businessID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid business ID"})
		return
	}

	queryParams := map[string]string{
		"b.businessID":       c.Query("businessID"),
		"b.businessName":     c.Query("businessName"),
		"b.businessType":     c.Query("businessType"),
		"b.location":         c.Query("location"),
		"b.contact":          c.Query("contact"),
		"b.ownerID":          c.Query("ownerID"),
		"b.petSizePref":      c.Query("B_petSizePref"),
		"b.leashPolicy":      c.Query("B_leashPolicy"),
		"b.disabledFriendly": c.Query("B_disabledFriendly"),
		"b.rating":           c.Query("rating"),
		"b.geolocation":	  c.Query("B_geolocation"),
		"e.eventID":          c.Query("eventID"),
		"e.eventName":        c.Query("eventName"),
		"e.eventDate":        c.Query("eventDate"),
		"e.petSizePref":      c.Query("E_petSizePref"),
		"e.leashPolicy":      c.Query("E_leashPolicy"),
		"e.disabledFriendly": c.Query("E_disabledFriendly"),
		"e.attendance_count": c.Query("attendance_count"),
		"e.geolocation":	  c.Query("E_geolocation"),
		"order":              c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	cacheKey := generateCacheKey(queryParams, businessID+"getbusinessevents")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.Businesses_Events_GET(query, id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all img info from database
can query by: id, size, imgName, imgType, order(ASC/DESC)
*/
func GetImgInfo(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"id":      c.Query("id"),
		"size":    c.Query("size"),
		"imgName": c.Query("imgName"),
		"imgType": c.Query("imgType"),
		"order":   c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	cacheKey := generateCacheKey(queryParams, "getImgInfo")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.ImgInfo_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all attendance for an event using eventID
*/
func GetAttendanceCount(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})
	eventID := c.Param("eventid")
	id, err := strconv.Atoi(eventID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid event ID"})
		return
	}

	queryParams := map[string]string{
		"eventID": eventID,
	}

	cacheKey := generateCacheKey(queryParams, eventID+"getattendancecount")

	if data, err := getCacheData(cacheKey); err == nil {
		c.IndentedJSON(http.StatusOK, data)
		return
	}

	results, err := db.AttendanceCount_GET(query, id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	serializedData, err := json.Marshal(results)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to serialize data"})
		return
	}
	setCache(cacheKey, serializedData)
	c.IndentedJSON(http.StatusOK, results)
}

/*
*=================POST METHOD HANDLERS==================
 */

/*
*TESTED WORKING
Creates new account
Request body shaped like account struct without id and access level
*/
func NewUser(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	var newAcc login

	if err := c.BindJSON(&newAcc); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	err := db.CreateNewAccount(newAcc)
	if err != nil {
		if _, ok := err.(*s.AccountExistsError); ok {
			c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "account already exists"})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, nil)
		}
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"username": *newAcc.Username,
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Users_GET(query, 0)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	invalidateCache("getusers")
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
creates new business
Request body shaped like business struct without id, events, rating
*/
func NewBusiness(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	var newBusiness business

	if err := c.BindJSON(&newBusiness); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	err := db.CreateNewBusiness(newBusiness)
	if err != nil {
		if _, ok := err.(*s.BusinessExistsError); ok {
			c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "business already exists"})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, nil)
		}
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"businessName": newBusiness.BusinessName,
		"location":     newBusiness.Location,
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Business_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	invalidateCache("getbusinesses")
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
Creates new attendance entry in database
*/
func NewAttendance(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	var newAttendance attendance

	if err := c.BindJSON(&newAttendance); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	err := db.CreateNewAttendance(newAttendance)
	if err != nil {
		if _, ok := err.(*s.AttendanceExistError); ok {
			c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "user is already attending"})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, nil)
		}
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"e.eventID": strconv.Itoa(newAttendance.EventID),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Users_Attendance_GET(query, newAttendance.UserID)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	invalidateCache("getuserattendance")
	invalidateCache("getevents")
	invalidateCache("getbusinessevents")
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
creates new saved business for account
Request body shaped like saved business struct without savedID
*/
func NewSavedBusiness(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	userID := c.Param("userid")
	id, err := strconv.Atoi(userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	var newSavedBusiness savedBusiness

	if err := c.BindJSON(&newSavedBusiness); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	err = db.CreateNewSavedBusiness(newSavedBusiness)
	if err != nil {
		if _, ok := err.(*s.SavedBusinessExistsError); ok {
			c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "User already saved business"})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, nil)
		}
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"businessID": strconv.Itoa(newSavedBusiness.BusinessID),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.SavedBusiness_GET(query, id)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	invalidateCache("getsavedbusinesses")
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
creates new review for business using account
Request body shaped like review struct without reviewID, userID, businessID, dateCreated
*/
func NewReview(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	userID, err := strconv.Atoi(c.Param("userid"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}
	businessID, err := strconv.Atoi(c.Param("businessid"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid business ID"})
		return
	}

	var newReview review
	newReview.BusinessID = businessID
	newReview.UserID = userID

	if err := c.BindJSON(&newReview); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	err = db.CreateNewReview(newReview)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"businessID": c.Param("businessid"),
		"userID":     c.Param("userid"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Reviews_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	invalidateCache("getbusinessreviews")
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
creates new event for business using businessID
Request body shaped like event struct
*/
func NewEvent(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	businessID, err := strconv.Atoi(c.Param("businessid"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid business ID"})
		return
	}

	var newEvent event
	newEvent.BusinessID = businessID

	if err := c.BindJSON(&newEvent); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	err = db.CreateNewEvent(newEvent)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"eventName":  newEvent.EventName,
		"businessID": c.Param("businessid"),
		"userID":     c.Param("userid"),
		"eventDate": newEvent.EventDate,
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Event_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	invalidateCache("getevents")
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
Checks username and password to database, if they are good then returns account info (without pwd)
Request body shaped like Login struct without userID, pwd, email, and accountType
*/
func Login(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	var newLogin login

	if err := c.BindJSON(&newLogin); err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}

	u, err := db.GetLoginInfo(newLogin.Username, newLogin.Password)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"username": *u.Username,
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Users_GET(query, 0)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*=================PATCH METHOD HANDLERS==================
 */

/*
*TESTED WORKING
updates value in database based on table name
request body shaped like PATCH_REQUESTS/*.json files
*/
func Update(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var update updatequery

	if err := c.BindJSON(&update); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.UpdateData(update)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	switch update.TableName {
	case "user":
		invalidateCache("getusers")
	case "business":
		invalidateCache("getbusinesses")
		invalidateCache("getbusinessreviews")
		invalidateCache("getbusinessevents")
	case "reviews":
		invalidateCache("getreviews")
		invalidateCache("getbusinessreviews")
	case "events":
		invalidateCache("getevents")
		invalidateCache("getbusinessevents")
	}

	c.IndentedJSON(http.StatusOK, update)
}

/*
*TESTED WORKING
updates password in database
request body shaped like PATCH_REQUESTS/pwdreset.json files
*/
func UpdatePWD(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var update pwdreset

	if err := c.BindJSON(&update); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.UpdatePassword(update)

	if err != nil {
		switch e := err.(type) {
		case *s.PWDResetError:
			c.IndentedJSON(http.StatusBadRequest, gin.H{"error": e.Message})
		default:
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		}
		return
	}

	c.IndentedJSON(http.StatusOK, "update successful")
}

/*
*=================DELETE METHOD HANDLERS==================
 */
/*
*TESTED WORKING
deletes value in database based on table name cascades if necessary
request body shaped like DELETE_REQUESTS/*.json files
*/
func Delete(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var delete deletequery

	if err := c.BindJSON(&delete); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.DeleteData(delete)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	switch delete.TableName {
	case "user":
		invalidateCache("getusers")
	case "business":
		invalidateCache("getbusinesses")
		invalidateCache("getbusinessreviews")
		invalidateCache("getbusinessevents")
	case "reviews":
		invalidateCache("getreviews")
		invalidateCache("getbusinessreviews")
	case "events":
		invalidateCache("getevents")
		invalidateCache("getbusinessevents")
	}
}

/*
*TESTED WORKING
deletes attendance from database and updates the attendance count in events table
*/
func DeleteAttendance(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var delete attendance

	if err := c.BindJSON(&delete); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.DeleteAttendanceData(delete)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
}
