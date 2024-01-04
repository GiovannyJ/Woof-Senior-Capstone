package rest

import (
	"net/http"
	"strings"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	db "API/database"
)

var key = db.EnvVar("TOKEN_KEY")

/*
*TESTED WORKING
Generates token for authenticated uses of the API 
Used for ADMINS (Gio, Yigit)
returns: string version of token, error if applicable
*/
func GenerateToken(userID string) (string, error) {

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user": userID,
	})

	tokenString, err := token.SignedString([]byte(key))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
/*
*TESTED WORKING
Middleware for API, checks to see if request is authorized
NEEDS:
	-auth header
	-Bearer in value
	-valid token after Bearer
	-token to exist in db
*/
func Authenticate() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")

		if authHeader == "" {
			c.IndentedJSON(http.StatusUnauthorized, gin.H{"error": "Requires Authorization header"})
			c.Abort()
			return
		}

		// Split the Authorization header into two parts: the scheme and the token
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.IndentedJSON(http.StatusUnauthorized, gin.H{"error": "Invalid Authorization header format"})
			c.Abort()
			return
		}

		tokenString := parts[1]

		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			return []byte(key), nil
		})

		if err != nil || !token.Valid {
			c.IndentedJSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
			c.Abort()
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to extract token claims"})
			c.Abort()
			return
		}

		userID, ok := claims["user"].(string)
		if !ok {
			c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to extract user ID from token claims"})
			c.Abort()
			return
		}

		if !db.CheckToken(userID, tokenString) {
			c.IndentedJSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		c.Set("user", userID)
		c.Next()
	}
}
