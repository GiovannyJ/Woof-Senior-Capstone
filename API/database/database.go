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
type login = s.LogIn
type business = s.Business
type savedBusiness = s.SavedBusiness
type usersSavedBusiness = s.UsersSavedBusiness
type event = s.Event
type businessEvents = s.BusinessEvents
type review = s.Review
type businessReview = s.BusinessReview
type admin = s.Admin

/*
*TEST PASSING
CONNECTION TO DATABASE
query: sql query to run
returns the sql values or error
*/
func connect(query string) (*sql.Rows, error) {
	username := EnvVar("DB_USERNAME")
	password := EnvVar("DB_PASSWORD")
	host := EnvVar("DB_HOST")
	port := EnvVar("DB_PORT")
	name := EnvVar("DB_NAME")

	configOS := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", username, password, host, port, name)

	db, err := sql.Open("mysql", configOS)
	if err != nil {
		log.Fatal()
	}
	defer db.Close()

	res, err := db.Query(query)

	if err != nil {
		panic(err.Error())
	}

	return res, err
}

//**+++++++++++++++++++++SELECT QUERIES++++++++++++++++++++++++++++

/*
*TESTED WORKING
returns: all users in database
*/
func Users_GET(params map[string]interface{}) ([]user, error) {
	var sql strings.Builder
	sql.WriteString("SELECT userID, username, email, accountType FROM user")
	sql.WriteString(GenSelectQuery(params, "", 0))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []user

	for result.Next() {
		var t user
		if err := result.Scan(
			&t.UserID,
			&t.Username,
			// &t.Pwd,
			&t.Email,
			&t.AccountType,
		); err != nil {
			return values, err
		}
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

/*
* TESTED WORKING
returns all businesses in database
*/
func Business_GET(params map[string]interface{}) ([]business, error) {
	var sql strings.Builder
	sql.WriteString("SELECT * FROM businesses")
	sql.WriteString(GenSelectQuery(params, "", 0))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []business

	for result.Next() {
		var t business
		if err := result.Scan(
			&t.BusinessID,
			&t.BusinessName,
			&t.OwnerUserID,
			&t.BusinessType,
			&t.Location,
			&t.Contact,
			&t.Description,
			&t.Events,
			&t.Rating,
		); err != nil {
			return values, nil
		}
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

/*
*TESTED WORKING
gets all saved business in database
*/
func SavedBusiness_GET(params map[string]interface{}, userID int) ([]savedBusiness, error) {
	var sql strings.Builder
	sql.WriteString("SELECT * FROM savedBusinesses")
	sql.WriteString(GenSelectQuery(params, "userID", userID))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []savedBusiness

	for result.Next() {
		var t savedBusiness
		if err := result.Scan(
			&t.SavedID,
			&t.UserID,
			&t.BusinessID,
		); err != nil {
			return values, nil
		}
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

/*
*TESTED WORKING
gets all events in database
*/
func Event_GET(params map[string]interface{}) ([]event, error) {
	var sql strings.Builder
	sql.WriteString("SELECT * FROM events")
	
	sql.WriteString(GenSelectQuery(params, "", 0))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []event

	for result.Next() {
		var t event
		if err := result.Scan(
			&t.EventID,
			&t.BusinessID,
			&t.EventName,
			&t.EventDescription,
			&t.EventDate,
			&t.Location,
			&t.ContactInfo,
		); err != nil {
			return values, nil
		}
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

/*
*TESTED WORKING
gets all reviews in database
*/
func Reviews_GET(params map[string]interface{}) ([]review, error) {
	var sql strings.Builder
	sql.WriteString("SELECT * FROM reviews")

	sql.WriteString(GenSelectQuery(params, "", 0))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []review

	for result.Next() {
		var t review
		if err := result.Scan(
			&t.ReviewID,
			&t.UserID,
			&t.BusinessID,
			&t.Rating,
			&t.Comment,
			&t.DateCreated,
		); err != nil {
			return values, nil
		}
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

//JOINED TABLES

/*
*TESTED WORKING
gets all of a users saved businesses in full context
*/
func Users_SavedBusiness_GET(params map[string]interface{}, userID int) ([]usersSavedBusiness, error) {
	var sql strings.Builder
	sql.WriteString("SELECT u.userID, u.username, u.email, u.accountType, sb.businessID, b.businessName, b.businessType, b.location, b.ownerUserID, b.contact, b.description, b.rating FROM user u\n")
	sql.WriteString("JOIN savedBusinesses sb ON u.userID = sb.userID\n")
	sql.WriteString("JOIN businesses b ON sb.businessID = b.businessID\n")
	sql.WriteString(GenSelectQuery(params, "u.userID", userID))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []usersSavedBusiness

	for result.Next() {
		var t usersSavedBusiness
		var u user
		var b business
		if err := result.Scan(
			&u.UserID,
			&u.Username,
			&u.Email,
			&u.AccountType,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.OwnerUserID,
			&b.Contact,
			&b.Description,
			&b.Rating,
		); err != nil {
			return values, nil
		}
		t.U = u
		t.B = b
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

//GET All events for business

/*
*TESTED WORKING
requires business id
gets all events for businesses in full context
*/
func Businesses_Events_GET(params map[string]interface{}, businessID int) ([]businessEvents, error) {
	var sql strings.Builder
	sql.WriteString("SELECT e.eventID, e.eventName, e.eventDescription, e.eventDate, e.location, e.contactInfo, b.businessID, b.businessName, b.businessType, b.location, b.contact, b.description, b.rating, b.OwnerUserID FROM events e ")
	sql.WriteString("JOIN businesses b ON e.businessID = b.businessID")
	sql.WriteString(GenSelectQuery(params, "b.businessID", businessID))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []businessEvents

	for result.Next() {
		var t businessEvents
		var e event
		var b business
		if err := result.Scan(
			&e.EventID,
			&e.EventName,
			&e.EventDescription,
			&e.EventDate,
			&e.Location,
			&e.ContactInfo,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.Contact,
			&b.Description,
			&b.Rating,
			&b.OwnerUserID,
		); err != nil {
			return values, nil
		}
		e.BusinessID = b.BusinessID
		t.E = e
		t.B = b
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

/*
*TESTED WORKING
gets all reviews for businesses and users who made review
*/
func Businesses_Reviews_Users_GET(params map[string]interface{}, businessID int) ([]businessReview, error) {
	var sql strings.Builder
	sql.WriteString("SELECT r.reviewID, r.rating, r.comment, r.dateCreated, u.userID, u.username, u.email, u.accountType, b.businessID, b.businessName, b.businessType, b.location, b.contact, b.rating AS businessRating, b.description, b.OwnerUserID")
	sql.WriteString(" FROM reviews r JOIN businesses b ON r.businessID = b.businessID JOIN user u ON r.userID = u.userID")
	sql.WriteString(GenSelectQuery(params, "b.businessID", businessID))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []businessReview

	for result.Next() {
		var t businessReview
		var r review
		var u user
		var b business
		if err := result.Scan(
			&r.ReviewID,
			&r.Rating,
			&r.Comment,
			&r.DateCreated,
			&u.UserID,
			&u.Username,
			&u.Email,
			&u.AccountType,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.Contact,
			&b.Rating,
			&b.Description,
			&b.OwnerUserID,
		); err != nil {
			return values, nil
		}
		r.UserID = u.UserID
		r.BusinessID = b.BusinessID
		t.B = b
		t.U = u
		t.R = r
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

//**+++++++++++++++++++++INSERT QUERIES++++++++++++++++++++++++++++

/*
*TESTED WORKING
POST TO: user table
DATA: model after POST.account.json
RETURN: error when applicable nil if no error (checks if account exits)
*/
func CreateNewAccount(data login) error {
	tableName := "user"

	valueType := reflect.TypeOf(data)
	value := reflect.ValueOf(data)

	var columns []string
	var values []string

	if AccountExist(*data.Username) {
		return &s.AccountExistsError{}
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
				columnName = "password"
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
*TESTED WORKING
POST TO: businesses table
DATA: model after POST.business.json
RETURN: Error when applicable nil if no error (check if business exists)
*/
func CreateNewBusiness(data business) error {
	if BusinessExist(data.BusinessName, data.Location) {
		return &s.BusinessExistsError{}
	}
	tableName := "businesses"

	ignoreColumns := []string{"businessID", "businessid", "events", "rating"}

	sql, err := GenInsertQuery(tableName, data, ignoreColumns)
	if err != nil {
		return err
	}
	result, err := connect(sql)

	if err != nil {
		return err
	}
	defer result.Close()

	return nil
}

/*
*TESTED WORKING
POST TO: savedbusinesses table
DATA: model after POST.savedBusiness.json
RETURN: Error when applicable nil if no error (check if saved business exists)
*/
func CreateNewSavedBusiness(data savedBusiness) error {
	if SavedBusinessExist(data.UserID, data.BusinessID) {
		return &s.SavedBusinessExistsError{}
	}
	tableName := "savedBusinesses"

	ignoreColumns := []string{"savedID", "savedid"}

	sql, err := GenInsertQuery(tableName, data, ignoreColumns)
	if err != nil {
		return err
	}
	result, err := connect(sql)

	if err != nil {
		return err
	}
	defer result.Close()

	return nil
}

/*
*TESTED WORKING
POST TO: reviews table
DATA: model after POST.review.json
RETURN: Error when applicable nil if no error
*/
func CreateNewReview(data review) error {
	tableName := "reviews"

	valueType := reflect.TypeOf(data)
	value := reflect.ValueOf(data)

	var columns []string
	var values []string

	for i := 0; i < valueType.NumField(); i++ {
		field := valueType.Field(i)
		columnName := strings.ToLower(field.Name)
		columnValue := value.Field(i).Interface()

		if columnName == "reviewid" || columnName == "reviewID" || columnName == "datecreated" || columnName == "dateCreated" {
			continue
		}

		if ptr, ok := columnValue.(*string); ok && ptr != nil {
			columnValue = *ptr
		} else if ptr, ok := columnValue.(*int); ok && ptr != nil {
			columnValue = *ptr
		}

		columns = append(columns, columnName)
		values = append(values, fmt.Sprintf("'%v'", columnValue))
	}

	sql := fmt.Sprintf("INSERT INTO %s(%s, dateCreated) VALUES(%s, CURDATE())", tableName, strings.Join(columns, ","), strings.Join(values, ","))
	result, err := connect(sql)

	if err != nil {
		return err
	}
	defer result.Close()

	return nil
}

/*
*TESTED WORKING
POST TO: event table
DATA: model after POST.event.json
RETURN: Error when applicable nil if no error (check if saved business exists)
*/
func CreateNewEvent(data event) error {
	tableName := "events"

	ignoreColumns := []string{"eventID", "eventid"}

	sql, err := GenInsertQuery(tableName, data, ignoreColumns)
	if err != nil {
		return err
	}
	result, err := connect(sql)

	if err != nil {
		return err
	}
	defer result.Close()

	return nil
}

/*
*TESTED WORKING
Using username, compares password to value in database
RETURNS account if password valid nil if not
*/
func GetLoginInfo(username *string, password *string) (*login, error) {
    var sql strings.Builder
	q := fmt.Sprintf("SELECT userID, username, password FROM user WHERE username='%s'", *username)
	sql.WriteString(q)

    result, err := connect(sql.String())
    if err != nil {
        return nil, errors.New("error connecting to database")
    }
    defer result.Close()

    if result.Next() {
        var t login
        if err := result.Scan(
            &t.UserID,
            &t.Username,
			&t.Pwd,
        ); err != nil {
            return nil, err
        }

		if err := VerifyPassword([]byte(*password), *t.Pwd); err != nil {
            return nil, errors.New("incorrect Password")
        }


        return &t, nil
    }
    return nil, errors.New("user Not found")
}




// //**+++++++++++++++++++++UPDATE QUERIES++++++++++++++++++++++++++++

// /*
// !NEEDS FIXING
// *TESTED PASSING
// GENERIC UPDATE METHOD WILL MATCH INTERFACE OF OLD AND NEW DATA
// RETURN: error if applicable
// !NEED TO IMPLEMENT WAY TO CHECK IF CHANGES ARE MADE PROPERLY
// */
// func UpdateData(oldData interface{}, newData interface{}) error {
//     var (
//         tableName   string
//         setValues   []string
//         whereValues []string
//     )

//     oldType := reflect.TypeOf(oldData)
//     oldValue := reflect.ValueOf(oldData)
//     newType := reflect.TypeOf(newData)
//     newValue := reflect.ValueOf(newData)

//     switch oldType {
//     case reflect.TypeOf(account{}):
//         tableName = "ACCOUNTS"
//     case reflect.TypeOf(posts{}):
//         tableName = "POSTS"
//     case reflect.TypeOf(comments{}):
//         tableName = "COMMENTS"
//     }

//     // Loop through fields of newType to construct SET part of the query
//     for i := 0; i < newType.NumField(); i++ {
//         field := newType.Field(i)
//         columnName := strings.ToLower(field.Name)
//         columnValue := newValue.Field(i).Interface()

//         setValues = append(setValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
//     }

//     // Only include id from oldType in WHERE clause
//     for i := 0; i < oldType.NumField(); i++ {
//         field := oldType.Field(i)
//         columnName := strings.ToLower(field.Name)
//         if columnName == "id" {
//             columnValue := oldValue.Field(i).Interface()
//             whereValues = append(whereValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
//         }
//     }

//     sql := fmt.Sprintf("UPDATE %s SET %s WHERE %s", tableName, strings.Join(setValues, ","), strings.Join(whereValues, " AND "))

//     result, err := connect(sql)
//     if err != nil {
//         return err
//     }
//     defer result.Close()

//     return nil
// }

// //**+++++++++++++++++++++DELETE QUERIES++++++++++++++++++++++++++++

// /*
// *TESTED WORKING
// DELETES ACCOUNT from database
// returns error if applicable
// */
// func DeleteAccount(user int) error{
// 	// sql := fmt.Sprintf("DELETE a, p, c FROM ACCOUNTS a LEFT JOIN POSTS p ON a.id = p.authorID LEFT JOIN COMMENTS c ON a.id = c.authorID WHERE a.id = %d;", user)
// 	deleteCommentsFromPostsSQL := fmt.Sprintf("DELETE FROM COMMENTS WHERE postID IN (SELECT id FROM POSTS WHERE authorID = %d)", user)
// 	deleteCommentsSQL := fmt.Sprintf("DELETE FROM COMMENTS WHERE authorID = %d", user)
// 	deletePostsSQL := fmt.Sprintf("DELETE FROM POSTS WHERE authorID = %d", user)

// 	deleteAccountSQL := fmt.Sprintf("DELETE FROM ACCOUNTS WHERE id = %d", user)

// 	execute(deleteCommentsFromPostsSQL)
// 	execute(deleteCommentsSQL)
// 	execute(deletePostsSQL)
// 	execute(deleteAccountSQL)

// 	return nil
// }

// /*
// *TESTED WORKING
// DELETES POST from database
// returns error if applicable
// */
// func DeletePost(user int) error{
// 	deletePostSQL := fmt.Sprintf("DELETE FROM POSTS WHERE id=%d", user)
// 	deleteCommentsSQL := fmt.Sprintf("DELETE FROM COMMENTS WHERE postID=%d", user)

// 	execute(deleteCommentsSQL)
// 	execute(deletePostSQL)
// 	return nil
// }

// func execute(sql string) error{
// 	result, err := connect(sql)
// 	if err !=nil{
// 		return err
// 	}
// 	defer result.Close()
// 	return nil
// }

// /*


// /*
// *----------------------------------------------------------UPDATING METHODS-----------------------------------------------
// */

// /*
// !NEEDS FIXING
// *TESTED PASSING
// UPDATING DATA ON THE health, pr_tracker, and account table
// old data must grab all values and be shaped like table struct
// new data must grab all values and be shaped like table struct
// note: make sure that columns are not empty bc then it will not work

// return bool- true if worked and false if not
// */
// func UpdateData(oldData interface{}, newData interface{}) error {
//     var (
//         tableName string
//         setValues []string
//         whereValues []string
//     )

//     oldType := reflect.TypeOf(oldData)
//     oldValue := reflect.ValueOf(oldData)
//     newType := reflect.TypeOf(newData)
//     newValue := reflect.ValueOf(newData)

//     switch oldType {
//         case reflect.TypeOf(account{}):
//             tableName = "ACCOUNT_INFO"
//         case reflect.TypeOf(healthdata{}):
//             tableName = "HEALTH_INFO"
//         case reflect.TypeOf(pr{}):
//             tableName = "PR_TRACKER"
//     }

//     for i := 0; i < newType.NumField(); i++ {
//         field := newType.Field(i)
//         columnName := strings.ToLower(field.Name)
//         columnValue := newValue.Field(i).Interface()

//         setValues = append(setValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
//     }

//     for i := 0; i < oldType.NumField(); i++ {
//         field := oldType.Field(i)
//         columnName := strings.ToLower(field.Name)
//         columnValue := oldValue.Field(i).Interface()

//         whereValues = append(whereValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
//     }

//     sql := fmt.Sprintf("UPDATE %s SET %s WHERE %s", tableName, strings.Join(setValues, ","), strings.Join(whereValues, " AND "))

//     result, err := connect(sql)
//     if err != nil {
//         return err
//     }
//     defer result.Close()

//     return nil
// }

// //*-------------------------------------------------------AUTH METHODS-------------------------------------------------------

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
