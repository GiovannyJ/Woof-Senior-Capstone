package rest

import (
	db "API/database"
	s "API/models"
	// "fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
)

type imgInfo = s.ImgInfo

var path = db.EnvVar("IMG_PATH")

/*
*TESTED WORKING
POST - METHOD:
	request to send picture to uploads file
	FILE MUST BE IN BODY OF REQUEST AS FORM DATA: file=file.png, type=FILETYPE
*/
func UploadFile(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")

	// Parse multipart form for file upload
	err := c.Request.ParseMultipartForm(100 << 20) // 100 MB max file size
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "Failed to parse multipart form"})
		// fmt.Println("file too big " + err.Error())
		return
	}

	// Access form value for "type"
	imgType := c.Request.FormValue("type")

	file, header, err := c.Request.FormFile("file")
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, gin.H{"error": "Failed to get file from request"})
		// fmt.Println("failed to get file from request " + err.Error())
		return
	}
	defer file.Close()

	out, err := os.Create(path + imgType + "/" + header.Filename)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err.Error())
		// fmt.Println("failed to create" + err.Error())
		return
	}
	defer out.Close()

	_, err = io.Copy(out, file)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, err.Error())
		// ("failed to copy " + err.Error())
		return
	}

	// Creating ImgInfo struct
	fileInfo, err := os.Stat(out.Name())
	if err != nil {
		log.Fatal(err)
	}
	formattedTime := fileInfo.ModTime().Format("2006-01-02 15:04:05")
	imgInfo := s.ImgInfo{
		Size:         int(fileInfo.Size()),
		ImgData:      "", // You need to set ImgData based on your requirements
		ImgName:      fileInfo.Name(),
		ImgType:      imgType,
		DateCreated:  formattedTime,
	}

	// Saving ImgInfo to the database
	db.CreateNewImgInfo(imgInfo)

	var query = make(map[string]interface{})

	queryParams := map[string]string{	
		"imgName": 		imgInfo.ImgName,
		"imgType":		imgInfo.ImgType,
		"dateCreated":	imgInfo.DateCreated,
		"size":			strconv.Itoa(imgInfo.Size),
	}

	for key, value := range queryParams {
		if len(value) > 0 {
			query[key] = value
		}
	}

	results, err := db.ImgInfo_GET(query)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		// fmt.Println("failed to get info " + err.Error())
		return
	}
	c.IndentedJSON(http.StatusOK, results)
}




/*
*TESTED WORKING
GET - METHOD:
	retrieve photo from uploads folder
*/
func RetrieveFile(c *gin.Context) {
    c.Header("Content-Type", "img/png")
    c.Header("Access-Control-Allow-Origin", "*")

    filename := c.Param("file")
	filetype := c.Param("type")
	
    file, err := os.Open(path + filetype + "/" + filename)
    if err != nil {
        c.IndentedJSON(http.StatusNotFound, nil)
        return
    }
    defer file.Close()

    fileContents, err := io.ReadAll(file)
    if err != nil {
        c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": "Failed to read file"})
        return
    }

    if _, err := c.Writer.Write(fileContents); err != nil {
        c.IndentedJSON(http.StatusInternalServerError, nil)
        return
    }
}