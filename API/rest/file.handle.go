package rest

import (
	db "API/database"
	s "API/models"
	"io"
	"log"
	"net/http"
	"os"
	"strconv"
	"github.com/gin-gonic/gin"
)

// type fileinfo 	= s.FileUpload

var path = db.EnvVar("IMG_PATH")

/*
*TESTED WORKING
POST - METHOD:
	request to send picture to uploads file
	FILE MUST BE IN BODY OF REQUEST AS FORM DATA: file=filename
*/
func UploadFile(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", "*")
	
	err := c.Request.ParseMultipartForm(32 << 20) // 32 MB max file size
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}
	
	file, header, err := c.Request.FormFile("file")
	
	if err != nil {
		c.IndentedJSON(http.StatusBadRequest, nil)
		return
	}
	defer file.Close()

	out, err := os.Create(path + header.Filename)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, nil)
		return
	}
	defer out.Close()
	
	_, err = io.Copy(out, file)
	if err != nil {
		c.IndentedJSON(http.StatusInternalServerError, nil)
		return
	}
	
	fileInfo, err := os.Stat(out.Name())
	if err != nil {
		log.Fatal(err)
	}

	fileName := fileInfo.Name()
	fileSize := strconv.Itoa(int(fileInfo.Size())) + " bytes"
	fileDate := fileInfo.ModTime()
	
	newImg := s.Images{
		ImgName: fileName,
		Size: fileSize,
		Date: fileDate.String(),
	}
	
	db.CreateNewImage(newImg)

	var query = make(map[string]interface{})
	query["imgname"] = fileName

	imgInfo, err  := db.Images_GET(query)
	if err != nil{
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}
	
	c.IndentedJSON(http.StatusOK, imgInfo)
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
	
    file, err := os.Open(path + filename)
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

/*
*TESTED WORKING
gets all file information from database and returns as images struct
*/
func GetFileInfo(c *gin.Context){
	c.Header("Access-Control-Allow-Orgin", "*")
	var query = make(map[string]interface{})

	queryParams := map[string]string{
		"id": 		c.Query("id"),
		"imgname": 	c.Query("imgname"),
		"size": 	c.Query("size"),
		"date": 	c.Query("date"),
		"order": 	c.Query("order"),
	}

	queryKey := ""

	for key, value := range queryParams{
		if len(value) > 0{
			queryKey = key
			break
		}
	}

	if queryKey != ""{
		query[queryKey] = queryParams[queryKey]
	}

	results, err := db.Images_GET(query)
	if err != nil{
		c.IndentedJSON(http.StatusInternalServerError, gin.H{"error": err})
	}
	c.IndentedJSON(http.StatusOK, results)
}