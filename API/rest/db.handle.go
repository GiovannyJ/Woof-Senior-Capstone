package rest

import (
	db "API/conn"
	s "API/models"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type account = s.Account
type updateAcc = s.UpdateAccount
type post = s.Posts
type updatePost = s.UpdatePosts
type comment = s.Comment
type updateComment = s.UpdateComment

// type images = s.Images
// type updateImages = s.UpdateImages
type loginData = s.LogIn
type jsondata = s.JSONData

/*
*=================GET METHOD HANDLERS==================
 */

/*
*TESTED WORKING
GETS all accounts
can query by id, fname, lname, fullname, email, username, and order
*/
func GetAccounts(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"id":        c.Query("id"),
		"fname":     c.Query("fname"),
		"lname":     c.Query("lname"),
		"fullname":  c.Query("fullname"),
		"email":     c.Query("email"),
		"username":  c.Query("username"),
		"accesslvl": c.Query("accesslvl"),
		"order":     c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Accounts_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
GETS all posts:
can query by id, title, genre, authorID, numUp, numDown, postedDate, order
*/
func GetPosts(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"id":         c.Query("id"),
		"title":      c.Query("title"),
		"genre":      c.Query("genre"),
		"authorID":   c.Query("authorID"),
		"numUp":      c.Query("numUp"),
		"numDown":    c.Query("numDown"),
		"postedDate": c.Query("date"),
		"order":      c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Posts_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
GETS all posts with author info as well as image info
can query by, postID, authorID, fullname, username, title, numUp,
numDown, genre, date, order
*/
func GetPostsFullContext(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"p.id":       c.Query("postID"),
		"a.id":       c.Query("authorID"),
		"fullname":   c.Query("fullname"),
		"username":   c.Query("username"),
		"title":      c.Query("title"),
		"p.numUp":    c.Query("numUp"),
		"numDown":    c.Query("numDown"),
		"genre":      c.Query("genre"),
		"postedDate": c.Query("date"),
		"order":      c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.PostsFullContext_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
gets all comments under a post
*/
func GetPostsComments(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	id := c.Param("id")

	postID, err := strconv.Atoi(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid post ID"})
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"id":         c.Query("id"),
		"authorID":   c.Query("authorID"),
		"numUp":      c.Query("numUp"),
		"numDown":    c.Query("numDown"),
		"postedDate": c.Query("date"),
		"order":      c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.Comments_GET(query, postID)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.IndentedJSON(http.StatusOK, results)
}

/*
*TESTED WORKING
grabs all comments from post with comments full context
*/
func GetPostsCommentsFullContext(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	id := c.Param("id")

	postID, err := strconv.Atoi(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid post ID"})
		return
	}

	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"c.id":         c.Query("c.id"),        //comment id
		"c.numUp":      c.Query("c.numUp"),     //comment upvotes
		"c.numDown":    c.Query("c.numDown"),   //comment downvotes
		"c.postedDate": c.Query("c.posteDate"), //comment posted date
		"a2.id":        c.Query("a2.id"),       //comment author
		"order":        c.Query("order"),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.CommentsFullContext_GET(query, postID)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
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
func NewAccount(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	c.Header("Access-Control-Allow-Methods", "POST, OPTIONS")
	c.Header("Access-Control-Allow-Headers", "Content-Type")

	var newAcc account

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

	q := map[string]interface{}{
		"username": newAcc.Username,
	}

	results, err := db.Accounts_GET(q)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	c.IndentedJSON(http.StatusCreated, results)
}

/*
*TESTED WORKING
CREATES new post
Request body shaped like posts struct
*/
func NewPost(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var newPost post

	if err := c.BindJSON(&newPost); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.CreateNewPost(newPost)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	c.IndentedJSON(http.StatusCreated, "post created")
}

/*
*TESTED WORKING
Creates new comment when supplied with request body shaped like comment struct
*/
func NewComment(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var newComment comment

	if err := c.BindJSON(&newComment); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	if err := db.CreateNewComment(newComment); err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	data := jsondata{
		Data: "comment created",
	}
	c.IndentedJSON(http.StatusCreated, data)

}

/*
*TESTED WORKING
Allows user to login using email or username
Request body shaped like login struct: must have empty string for username or email if not used
returns limited version of account struct
Note: if username and password as passed as guest then its guest login
*/
func Login(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var login loginData

	if err := c.BindJSON(&login); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	logicCheck := func(param *string) bool {
		return param != nil && *param == ""
	}

	if (logicCheck(login.Username) || logicCheck(login.Email)) && logicCheck(login.Password) {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "fail logic check"})
		return
	}

	if login.Username != nil && *login.Username == "guest" && login.Password != nil && *login.Password == "guest" {
		result := db.GuestLogin()
		c.IndentedJSON(http.StatusOK, result)
		return
	}

	data, err := db.GetLoginInfo(login.Username, login.Password, login.Email)

	if err != nil {
		if err.Error() == "Invalid password" {
			c.IndentedJSON(http.StatusUnauthorized, gin.H{"error": err})
		} else {
			c.IndentedJSON(http.StatusNotFound, gin.H{"error": err})
		}
		return
	}

	if data != nil {
		userQ := map[string]interface{}{
			"id": data.ID,
		}
		userDetails, err := db.Accounts_GET(userQ)
		if err != nil {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
			return
		}

		c.IndentedJSON(http.StatusOK, userDetails)
	} else {
		c.IndentedJSON(http.StatusNotFound, nil)
	}
}

/*
*=================PATCH METHOD HANDLERS==================
 */

/*
*TESTED WORKING
updates account in database
request body shaped like updateAccount struct
*/
func UpdateAcc(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	var upACC updateAcc

	if err := c.BindJSON(&upACC); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.UpdateData(upACC.Old, upACC.New)

	if err != nil {
		if _, ok := err.(*s.UpdateNotCompleteError); ok {
			c.IndentedJSON(http.StatusFailedDependency, gin.H{"error": err})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
			return
		}
		return
	}
	c.IndentedJSON(http.StatusOK, upACC.New)
}

/*
*TESTED WORKING
Updates post in database
request body shaped like updatePost Struct
*/
func UpdatePost(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var upPOST updatePost

	if err := c.BindJSON(&upPOST); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.UpdateData(upPOST.Old, upPOST.New)

	if err != nil {
		if _, ok := err.(*s.UpdateNotCompleteError); ok {
			c.IndentedJSON(http.StatusFailedDependency, gin.H{"error": err})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
			return
		}
		return
	}
	c.IndentedJSON(http.StatusOK, upPOST.New)
}

/*
*TESTED WORKING
UPDATES comment in database
request must be shaped like updatecomment struct
*/
func UpdateComment(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	var upComment updateComment

	if err := c.BindJSON(&upComment); err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err := db.UpdateData(upComment.Old, upComment.New)

	if err != nil {
		if _, ok := err.(*s.UpdateNotCompleteError); ok {
			c.IndentedJSON(http.StatusFailedDependency, gin.H{"error": err})
		} else {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
			return
		}
		return
	}
	c.IndentedJSON(http.StatusOK, upComment.New)
}

/*
*=================DELETE METHOD HANDLERS==================
 */

/*
*TESTED WORKING
DELETES account from database using id as last tag
*/
func DelAccount(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	id := c.Param("id")

	intID, err := strconv.Atoi(id)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err = db.DeleteAccount(intID)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	data := jsondata{
		Data: fmt.Sprintf("account %d deleted", intID),
	}
	c.IndentedJSON(http.StatusOK, data)
}

/*
*TESTED WORKING
DELETES post from database using id as last tag
*/
func DelPost(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	id := c.Param("id")

	intID, err := strconv.Atoi(id)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err = db.DeletePost(intID)

	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	data := jsondata{
		Data: fmt.Sprintf("post %d deleted", intID),
	}
	c.IndentedJSON(http.StatusOK, data)
}

/*
*TESTED WORKING
deletes comment from database, need id of comment in path
*/
func DelComment(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	id := c.Param("id")
	intId, err := strconv.Atoi(id)
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": err})
		return
	}

	err = db.DeleteComment(intId)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	data := jsondata{
		Data: fmt.Sprintf("comment %d deleted", intId),
	}
	c.IndentedJSON(http.StatusOK, data)
}
