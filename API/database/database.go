package database

import (
	s "API/models"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"reflect"
	"strings"
	_ "github.com/go-sql-driver/mysql"
)

type user = s.User
type business = s.Business
type savedBusiness = s.SavedBusiness
type event = s.Event
type review = s.Review

/*
*TEST PASSING
CONNECTION TO DATABASE
query: sql query to run
returns the sql values or error
*/
func connect(query string) (*sql.Rows, error) {
	username    :=     EnvVar("DB_USERNAME")
    password    :=     EnvVar("DB_PASSWORD")
    host        :=     EnvVar("DB_HOST")
    port        :=     EnvVar("DB_PORT")
    name        :=     EnvVar("DB_NAME")

    configOS := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", username, password, host, port, name)
    
    db, err := sql.Open("mysql", configOS)
	if err != nil{
        log.Fatal()
	}
    defer db.Close()

	res, err := db.Query(query)

	if err != nil{
		panic(err.Error())
	}
	
	return res, err
}

//**+++++++++++++++++++++SELECT QUERIES++++++++++++++++++++++++++++

/*
*TESTED WORKING
getting all users query
returns: all users in database
*/
func Users_GET(params map[string]interface{}) ([]user, error) {
    var sql strings.Builder
    sql.WriteString("SELECT * FROM USER")

	if len(params) > 0 {
		var conditions []string
		var orderby string
        for name, value := range params {
			if name == "order"{
				orderby = fmt.Sprintf(" ORDER BY %s", value)
			}else{
				condition := fmt.Sprintf("%s='%v'", name, value)
				conditions = append(conditions, condition)
			}
        }
		if len(conditions) > 0{
			sql.WriteString(" WHERE ")
			sql.WriteString(strings.Join(conditions, " AND "))
		}
		sql.WriteString(orderby)
    }
	
    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    var values []user
    
    for result.Next(){
		var t user
		if err := result.Scan(
			&t.UserID,
            &t.Username,
            &t.Pwd,
            &t.Email,
            &t.AccountType,
		); err != nil {
			return values, err
		}
		values = append(values, t)
	}

    if err = result.Err(); err != nil{
		return values, err
    }

    return values, nil
}

/*
*TESTED WORKING
Gets all posts from table
*/
func Business_GET(params map[string]interface{}) ([]business, error) {
    var sql strings.Builder
    sql.WriteString("SELECT * FROM BUSINESSES")

	if len(params) > 0 {
		var conditions []string
		var orderby string
        for name, value := range params {
			if name == "order"{
				orderby = fmt.Sprintf(" ORDER BY %s", value)
				}else{
				condition := fmt.Sprintf("%s='%v'", name, value)
				conditions = append(conditions, condition)
			}
        }
		if len(conditions) > 0{
			sql.WriteString(" WHERE ")
			sql.WriteString(strings.Join(conditions, " AND "))
		}
		sql.WriteString(orderby)
    }
    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    var values []business
    
    for result.Next(){
		var t business
		if err := result.Scan(
            &t.BusinessID,
            &t.BusinessName,
            &t.OwnerID,      		
            &t.BusinessType,
            &t.BusinessLocation,
            &t.Contact,	 			
            &t.Descr,
            &t.Events,
            &t.Rating,
				); err != nil{
			return values, nil
		}
		values = append(values, t)
	}

    if err = result.Err(); err != nil{
		return values, err
    }
        
    return values, nil
}


/*
*TESTED WORKING
gets all comments associated with postID and query strings
*/
func SavedBusiness_GET(params map[string]interface{}) ([]savedBusiness, error) {
    var sql strings.Builder
    sql.WriteString("SELECT * FROM SAVEDBUSINESSES")

	if len(params) > 0 {
		var conditions []string
		var orderby string
        for name, value := range params {
			if name == "order"{
				orderby = fmt.Sprintf(" ORDER BY %s", value)
				}else{
				condition := fmt.Sprintf("%s='%v'", name, value)
				conditions = append(conditions, condition)
			}
        }
		if len(conditions) > 0{
			sql.WriteString(" WHERE ")
			sql.WriteString(strings.Join(conditions, " AND "))
		}
		sql.WriteString(orderby)
    }
    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    var values []savedBusiness
    
    for result.Next(){
		var t savedBusiness
		if err := result.Scan(
            &t.BusinessID,
            &t.UserID,
				); err != nil{
			return values, nil
		}
		values = append(values, t)
	}

    if err = result.Err(); err != nil{
		return values, err
    }
        
    return values, nil
}


func Event_GET(params map[string]interface{}) ([]event, error) {
    var sql strings.Builder
    sql.WriteString("SELECT * FROM EVENTS")

	if len(params) > 0 {
		var conditions []string
		var orderby string
        for name, value := range params {
			if name == "order"{
				orderby = fmt.Sprintf(" ORDER BY %s", value)
				}else{
				condition := fmt.Sprintf("%s='%v'", name, value)
				conditions = append(conditions, condition)
			}
        }
		if len(conditions) > 0{
			sql.WriteString(" WHERE ")
			sql.WriteString(strings.Join(conditions, " AND "))
		}
		sql.WriteString(orderby)
    }
    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    var values []event
    
    for result.Next(){
		var t event
		if err := result.Scan(
            &t.EventID,
            &t.BusinessID,
            &t.EventName,
            &t.EventDescr,
            &t.EventDate,
            &t.Location,
            &t.Contact,
				); err != nil{
			return values, nil
		}
		values = append(values, t)
	}

    if err = result.Err(); err != nil{
		return values, err
    }
        
    return values, nil
}

func Reviews_GET(params map[string]interface{}) ([]review, error) {
    var sql strings.Builder
    sql.WriteString("SELECT * FROM EVENTS")

	if len(params) > 0 {
		var conditions []string
		var orderby string
        for name, value := range params {
			if name == "order"{
				orderby = fmt.Sprintf(" ORDER BY %s", value)
				}else{
				condition := fmt.Sprintf("%s='%v'", name, value)
				conditions = append(conditions, condition)
			}
        }
		if len(conditions) > 0{
			sql.WriteString(" WHERE ")
			sql.WriteString(strings.Join(conditions, " AND "))
		}
		sql.WriteString(orderby)
    }
    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    var values []review
    
    for result.Next(){
		var t review
		if err := result.Scan(
            &t.ReviewID,
            &t.UserID,
            &t.BusinessID,
            &t.Rating,
            &t.Comment,
            &t.DateCreated,
				); err != nil{
			return values, nil
		}
		values = append(values, t)
	}

    if err = result.Err(); err != nil{
		return values, err
    }
        
    return values, nil
}



//JOINED TABLES
//GET saved business user relation
//GET All events for business
//Get All reviews for business

/*
*TESTED WORKING
gets all info from IMAGES table
*/
// func Images_GET(params map[string]interface{}) ([]images, error) {
//     var sql strings.Builder
//     sql.WriteString("SELECT * FROM IMAGES")

// 	if len(params) > 0 {
// 		var conditions []string
// 		var orderby string
//         for name, value := range params {
// 			if name == "order"{
// 				orderby = fmt.Sprintf(" ORDER BY %s", value)
// 				}else{
// 				condition := fmt.Sprintf("%s='%v'", name, value)
// 				conditions = append(conditions, condition)
// 			}
//         }
// 		if len(conditions) > 0{
// 			sql.WriteString(" WHERE ")
// 			sql.WriteString(strings.Join(conditions, " AND "))
// 		}
// 		sql.WriteString(orderby)
//     }
//     result, err := connect(sql.String())
//     if err != nil {
//         return nil, err
//     }
//     defer result.Close()

//     var values []images
    
//     for result.Next(){
// 		var t images
// 		if err := result.Scan(
// 				&t.ID, 
// 				&t.ImgName, 
// 				&t.Size,
// 				&t.Date,
// 				); err != nil{
// 			return values, nil
// 		}
// 		values = append(values, t)
// 	}

//     if err = result.Err(); err != nil{
// 		return values, err
//     }
        
//     return values, nil
// }


//**+++++++++++++++++++++INSERT QUERIES++++++++++++++++++++++++++++

/*
*TESTED WORKING
POST TO: ACCOUNTS table
DATA: model after account struct
RETURN: error when applicable nil if no error
*/
func CreateNewAccount(data account) error {
	if accountExist(data.Username) {
		return &s.AccountExistsError{Username: data.Username}
	}

	sql := fmt.Sprintf("INSERT INTO ACCOUNTS(fname, lname, fullname, email, pwd, pnum, username, accesslvl) VALUES('%s', '%s', '%s', '%s', '%s', %d, '%s', 'user')",
		data.Fname, data.Lname, data.Fullname, data.Email, data.Pwd, data.Pnum, data.Username)
	result, err := connect(sql)
	if err != nil {
	    return err
	}
	defer result.Close()

	return nil
}
//*HELPER METHOD: checks if the account exits already RETURNS true if account exits and false if not
func accountExist(id string) bool{
    exist_acc := map[string]interface{}{"username": id}

    exists, err := Accounts_GET(exist_acc)
	if err != nil{
		return false
	}
    
    return len(exists) > 0
}

/*
*TESTED WORKING
POSTS TO POSTS table
DATA: model after Posts struct
RETURN: error when applicable nil when not
*/
func CreateNewPost(data posts) error {
	sql := fmt.Sprintf("INSERT INTO POSTS(title, descr, genre, authorID, picID, postedDate) VALUES('%s', '%s', '%s', '%d', '%d', CURDATE())",
		 data.Title, data.Descr, data.Genre, data.AuthorID, data.PicID)
	result, err := connect(sql)
	if err != nil {
	    return err
	}
	defer result.Close()

	return nil
}

/*
*TESTED WORKING
creates new comment when body supplied with postID, authorId, and content
*/
func CreateNewComment(data comments) error {
	sql := fmt.Sprintf("INSERT INTO COMMENTS(postID, authorID, content, postedDate) VALUES('%d', '%d', '%s', CURDATE())",
		 data.PostID, data.AuthorID, data.Content)
	result, err := connect(sql)
	if err != nil {
	    return err
	}
	defer result.Close()

	return nil
}

/*
*TESTED WORKING
uploads image information into the database
*/
func CreateNewImage(data images) error{
	sql := fmt.Sprintf("INSERT INTO IMAGES(imgname, size, date) VALUES('%s', '%s', CURDATE())",
			data.ImgName, data.Size)
	result, err := connect(sql)
	if err != nil{
		return err
	}
	defer result.Close()
	return nil
}


/*
*TESTED WORKING
Using either email or username, compares password to value in database
RETURNS account if password valid nil if not
*/
func GetLoginInfo(username *string, password *string, email *string) (*account, error) {
    var sql strings.Builder
    q := "SELECT id, email, username, pwd FROM ACCOUNTS"

    switch {
    case username != nil:
        q += fmt.Sprintf(" WHERE username='%s'", *username)
    case email != nil:
        q += fmt.Sprintf(" WHERE email='%s'", *email)
    default:
        break
    }

    sql.WriteString(q)
    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    if result.Next() {
        var t account
        if err := result.Scan(
            &t.ID,
            &t.Email,
            &t.Username,
			&t.Pwd,
        ); err != nil {
            return nil, err
        }
        if password != nil && t.Pwd != *password {
            return nil, errors.New("invalid password")
        }
        return &t, nil
    }
    return nil, errors.New("user not found")
}

/*
*TESTED WORKING
Grabs guest account from database and returns its values
*/
func GuestLogin() ([]account){
    q := "SELECT * FROM ACCOUNTS WHERE username = 'guest' and pwd='guest'"
	result, err := connect(q)
	if err != nil{
		return nil
	}
	defer result.Close()
	var values []account
    
    for result.Next(){
		var t account
		if err := result.Scan(
			&t.ID,
			&t.Fname,
			&t.Lname,
			&t.Fullname,
			&t.Email,
			&t.Pwd,
			&t.Pnum,
			&t.Username,
			&t.Accesslvl,
		); err != nil {
			return values
		}
		values = append(values, t)
	}

    if err = result.Err(); err != nil{
		return values
    }

    return values
}


//**+++++++++++++++++++++UPDATE QUERIES++++++++++++++++++++++++++++


/*
!NEEDS FIXING
*TESTED PASSING
GENERIC UPDATE METHOD WILL MATCH INTERFACE OF OLD AND NEW DATA
RETURN: error if applicable
!NEED TO IMPLEMENT WAY TO CHECK IF CHANGES ARE MADE PROPERLY
*/
func UpdateData(oldData interface{}, newData interface{}) error {
    var (
        tableName   string
        setValues   []string
        whereValues []string
    )

    oldType := reflect.TypeOf(oldData)
    oldValue := reflect.ValueOf(oldData)
    newType := reflect.TypeOf(newData)
    newValue := reflect.ValueOf(newData)

    switch oldType {
    case reflect.TypeOf(account{}):
        tableName = "ACCOUNTS"
    case reflect.TypeOf(posts{}):
        tableName = "POSTS"
    case reflect.TypeOf(comments{}):
        tableName = "COMMENTS"
    }

    // Loop through fields of newType to construct SET part of the query
    for i := 0; i < newType.NumField(); i++ {
        field := newType.Field(i)
        columnName := strings.ToLower(field.Name)
        columnValue := newValue.Field(i).Interface()

        setValues = append(setValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
    }

    // Only include id from oldType in WHERE clause
    for i := 0; i < oldType.NumField(); i++ {
        field := oldType.Field(i)
        columnName := strings.ToLower(field.Name)
        if columnName == "id" {
            columnValue := oldValue.Field(i).Interface()
            whereValues = append(whereValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
        }
    }

    sql := fmt.Sprintf("UPDATE %s SET %s WHERE %s", tableName, strings.Join(setValues, ","), strings.Join(whereValues, " AND "))

    result, err := connect(sql)
    if err != nil {
        return err
    }
    defer result.Close()

    
    return nil
}

//**+++++++++++++++++++++DELETE QUERIES++++++++++++++++++++++++++++

/*
*TESTED WORKING
DELETES ACCOUNT from database
returns error if applicable
*/
func DeleteAccount(user int) error{
	// sql := fmt.Sprintf("DELETE a, p, c FROM ACCOUNTS a LEFT JOIN POSTS p ON a.id = p.authorID LEFT JOIN COMMENTS c ON a.id = c.authorID WHERE a.id = %d;", user)
	deleteCommentsFromPostsSQL := fmt.Sprintf("DELETE FROM COMMENTS WHERE postID IN (SELECT id FROM POSTS WHERE authorID = %d)", user)
	deleteCommentsSQL := fmt.Sprintf("DELETE FROM COMMENTS WHERE authorID = %d", user)
	deletePostsSQL := fmt.Sprintf("DELETE FROM POSTS WHERE authorID = %d", user)

	deleteAccountSQL := fmt.Sprintf("DELETE FROM ACCOUNTS WHERE id = %d", user)
	
	execute(deleteCommentsFromPostsSQL)
	execute(deleteCommentsSQL)
	execute(deletePostsSQL)
	execute(deleteAccountSQL)
	
	return nil
}


/*
*TESTED WORKING
DELETES POST from database
returns error if applicable
*/
func DeletePost(user int) error{
	deletePostSQL := fmt.Sprintf("DELETE FROM POSTS WHERE id=%d", user)
	deleteCommentsSQL := fmt.Sprintf("DELETE FROM COMMENTS WHERE postID=%d", user)

	execute(deleteCommentsSQL)
	execute(deletePostSQL)
	return nil
}

func execute(sql string) error{
	result, err := connect(sql)
	if err !=nil{
		return err
	}
	defer result.Close()
	return nil
}

/*
*TESTED WORKING
deletes comment from database
returns error if applicable
*/
func DeleteComment(commentID int) error{
	sql := fmt.Sprintf("DELETE FROM COMMENTS WHERE id= %d ", commentID)
	result, err := connect(sql)

	if err != nil{
		return err
	}
	defer result.Close()
	return nil
}





/*
*TESTED PASSING
used for log in getting all account data
params:
    username, password, email
    map like account struct if some
return account data
*/
func GetAccountDataSECURE(username *string, password *string, email *string) (*login, error) {
    // fmt.Println("--------------------------------\n", username, password, email, "\n--------------------------------")
	// fmt.Println("--------------------------------\n", *username, *password, *email, "\n-------------------------------")
    var sql strings.Builder
    q := "SELECT * FROM ACCOUNT_INFO WHERE "
    
    switch {
        // case username != nil && email != nil:
        //     q += fmt.Sprintf("(username='%s' OR email='%s')", *username, *email)
        case username != nil:
            q += fmt.Sprintf("username='%s'", *username)
        case email != nil:
            q += fmt.Sprintf("email='%s'", *email)
        default:
            break
    }

    sql.WriteString(q)

    result, err := connect(sql.String())
    if err != nil {
        return nil, err
    }
    defer result.Close()

    if result.Next() {
        var t login
        if err := result.Scan(
            &t.ID,
            &t.Fname,
            &t.Lname,
            &t.Fullname,
            &t.Email,
            &t.Pwd,
            &t.Pnum,
            &t.Age,
            &t.Username,
        ); err != nil {
            return nil, err
        }
       
        if err := VerifyPassword([]byte(*password), []byte(*t.Pwd)); err != nil {
            return nil, err
        }

        return &t, nil
    }

    return nil, nil
}




/*
*----------------------------------------------------POSTING METHODS-----------------------------------------------
*/

/*
*TESTED PASSING
POST TO: health and tracker tables
data: model after struct for table
note: id must be empty since auto populates

return true if worked and false if not
*/
func PostData(data interface{}) error {
    var (
        tableName string
        columns   []string
        values    []string
    )

    valueType := reflect.TypeOf(data)
    value := reflect.ValueOf(data)

    switch valueType {
    case reflect.TypeOf(healthdata{}):
        tableName = "HEALTH_INFO"
    case reflect.TypeOf(pr{}):
        tableName = "PR_TRACKER"
    }

    for i := 0; i < valueType.NumField(); i++ {
        field := valueType.Field(i)
        columnName := strings.ToLower(field.Name)
        columnValue := value.Field(i).Interface()

        // Dereference pointers if they are not nil
        if ptr, ok := columnValue.(*string); ok && ptr != nil {
            columnValue = *ptr
        } else if ptr, ok := columnValue.(*int); ok && ptr != nil {
            columnValue = *ptr
        }

        if columnName != "id"{
            columns = append(columns, columnName)
            values = append(values, fmt.Sprintf("'%v'", columnValue))
        }
    }

    sql := fmt.Sprintf("INSERT INTO %s(%s) VALUES(%s)", tableName, strings.Join(columns, ","), strings.Join(values, ","))

    result, err := connect(sql)
    if err != nil {
        return err
    }
    defer result.Close()

    return nil
}



/*
*TESTED WORKING
CREATE AN ACCOUNT
data: model after login struct

return error if applicable
*/
func NewAccount(data login) error {
    tableName := "ACCOUNT_INFO"

    valueType := reflect.TypeOf(data)
    value := reflect.ValueOf(data)

    var columns []string
    var values []string

    if(accountExist(*data.Username)){
        return &reflect.ValueError{}
    }

    for i := 0; i < valueType.NumField(); i++ {
        field := valueType.Field(i)
        columnName := strings.ToLower(field.Name)
        columnValue := value.Field(i).Interface()

        
        
        if columnName == "id" || columnName == "pwd" {
            continue
        }

        if columnName == "password" {
            if pwd, ok := columnValue.(*string); ok && pwd != nil {
                hashedPwd, err := HashPassword(*pwd)
                if err != nil {
                    return err
                }
                columnValue = hashedPwd
                columnName = "pwd"
            }
        }

        if ptr, ok := columnValue.(*string); ok && ptr != nil {
            columnValue = *ptr
        } else if ptr, ok := columnValue.(*int); ok && ptr != nil {
            columnValue = *ptr
        }

        columns = append(columns, columnName)
        values = append(values, fmt.Sprintf("'%v'", columnValue))
    }

    sql := fmt.Sprintf("INSERT INTO %s(%s) VALUES(%s)", tableName, strings.Join(columns, ","), strings.Join(values, ","))
    result, err := connect(sql)

    if err != nil {
        return err
    }
    defer result.Close()

    return nil
}




/*
*----------------------------------------------------------UPDATING METHODS-----------------------------------------------
*/


/*
!NEEDS FIXING
*TESTED PASSING
UPDATING DATA ON THE health, pr_tracker, and account table
old data must grab all values and be shaped like table struct
new data must grab all values and be shaped like table struct
note: make sure that columns are not empty bc then it will not work

return bool- true if worked and false if not
*/
func UpdateData(oldData interface{}, newData interface{}) error {
    var (
        tableName string
        setValues []string
        whereValues []string
    )

    
    oldType := reflect.TypeOf(oldData)
    oldValue := reflect.ValueOf(oldData)
    newType := reflect.TypeOf(newData)
    newValue := reflect.ValueOf(newData)

    switch oldType {
        case reflect.TypeOf(account{}):
            tableName = "ACCOUNT_INFO"
        case reflect.TypeOf(healthdata{}):
            tableName = "HEALTH_INFO"
        case reflect.TypeOf(pr{}):
            tableName = "PR_TRACKER"
    }

    for i := 0; i < newType.NumField(); i++ {
        field := newType.Field(i)
        columnName := strings.ToLower(field.Name)
        columnValue := newValue.Field(i).Interface()

        setValues = append(setValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
    }

    for i := 0; i < oldType.NumField(); i++ {
        field := oldType.Field(i)
        columnName := strings.ToLower(field.Name)
        columnValue := oldValue.Field(i).Interface()

        whereValues = append(whereValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
    }

    sql := fmt.Sprintf("UPDATE %s SET %s WHERE %s", tableName, strings.Join(setValues, ","), strings.Join(whereValues, " AND "))
    
    result, err := connect(sql)
    if err != nil {
        return err
    }
    defer result.Close()

    return nil
}

//*-------------------------------------------------------AUTH METHODS-------------------------------------------------------

/*
 * TESTED WORKING
 Gets the token from the user and compares it with the token string
 if the thing exists then return true
*/
func CheckToken(userID string, tokenString string) bool {
    var sql strings.Builder
    sql.WriteString("SELECT * FROM ADMIN WHERE ")
    condition := fmt.Sprintf("id='%v'", userID)
    sql.WriteString(condition)

    result, err := connect(sql.String())
    if err != nil {
        fmt.Println(err)
        return false
    }

    defer result.Close()

    var values []admin

    for result.Next() {
        var t admin
        t.Id = new(string)
        t.Name = new(string)
        t.Token = new(string)
        t.Passwd = new(string)

        if err := result.Scan(
            t.Id,
            t.Name,
            t.Token,
            t.Passwd,
        ); err != nil {
            fmt.Println(err)
            return false
        }
        values = append(values, t)
    }

    if err = result.Err(); err != nil {
        fmt.Println(err)
        return false
    }

    for _, val := range values {
        if *val.Token == tokenString {
            return true
        }
    }

    return false
}

//*-------------------------------------------------HELPER METHODS----------------------------------------------------------------------
func accountExist(id string) bool{
    exist_acc := map[string]interface{}{"username": id}

    exists := GetAccountData(exist_acc)
    
    return len(exists) > 0
}