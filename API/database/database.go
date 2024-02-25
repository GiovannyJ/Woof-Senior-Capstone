package database

import (
	s "API/models"
	"database/sql"
	"errors"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"log"
	"reflect"
	"strings"
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
type updatequery = s.UpdateQuery
type deleteQuery = s.DeleteQuery
type pwdreset = s.PWDReset
type imgInfo = s.ImgInfo
type attendanceCount = s.AttendanceCount
type userAttendBusiness = s.UsersAttendEvent
type attendance = s.Attendance

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
	sql.WriteString("SELECT userID, username, email, accountType, imgID FROM user")
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
			&t.ImgID,
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
			&t.DataLocation,
			&t.ImgID,
			&t.PetSizePref,
			&t.LeashPolicy,
			&t.DisabledFriendly,
			&t.GeoLocation,
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
	sql.WriteString("SELECT eventID, businessID, eventName, eventDescription, eventDate, location, contactInfo, dataLocation, imgID, petSizePref, leashPolicy, disabledFriendly, (SELECT COUNT(userID) FROM attendance WHERE eventID = e.eventID) as num_attend, geolocation FROM events e ")

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
			&t.DataLocation,
			&t.ImgID,
			&t.PetSizePref,
			&t.LeashPolicy,
			&t.DisabledFriendly,
			&t.AttendanceCount,
			&t.GeoLocation,
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
			&t.DataLocation,
			&t.ImgID,
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
gets all image info from database
*/
func ImgInfo_GET(params map[string]interface{}) ([]imgInfo, error) {
	var sql strings.Builder
	sql.WriteString("SELECT * FROM images")

	sql.WriteString(GenSelectQuery(params, "", 0))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []imgInfo

	for result.Next() {
		var t imgInfo
		if err := result.Scan(
			&t.ImgID,
			&t.Size,
			&t.ImgData,
			&t.ImgName,
			&t.ImgType,
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

/*
*TESTED WORKING
gets count of all the userIDs attending an event
*/
func AttendanceCount_GET(params map[string]interface{}, eventID int) ([]attendanceCount, error) {
	var sql strings.Builder
	sql.WriteString("SELECT COUNT(userID) as attendanceCount FROM attendance")
	sql.WriteString(GenSelectQuery(params, "eventID", eventID))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []attendanceCount

	for result.Next() {
		var t attendanceCount
		if err := result.Scan(
			&t.Count,
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
Gets all the events that a user is attending in the database
*/
func Users_Attendance_GET(params map[string]interface{}, userID int) ([]userAttendBusiness, error) {
	var sql strings.Builder
	sql.WriteString("SELECT  u.userID, u.username, u.email, u.accountType, u.imgID, ")
	sql.WriteString("		b.businessID, b.businessName, b.businessType, b.location,")
	sql.WriteString("		b.ownerUserID, b.contact, b.description, b.rating, b.imgID,")
	sql.WriteString("		b.petSizePref, b.leashPolicy, b.disabledFriendly, b.dataLocation, b.geolocation,")
	sql.WriteString("		(SELECT COUNT(id) FROM attendance a2 WHERE e.eventID = a2.eventID) as attendanceCount,")
	sql.WriteString("		e.eventID, e.businessID, e.eventName , e.eventDescription, e.eventDate,")
	sql.WriteString("		e.location, e.contactInfo, e.dataLocation, e.imgID, e.petSizePref, e.leashPolicy,")
	sql.WriteString("		e.disabledFriendly, e.geolocation ")
	sql.WriteString("FROM user u ")
	sql.WriteString("JOIN attendance a ON u.userID = a.userID ")
	sql.WriteString("JOIN events e ON e.eventID = a.eventID ")
	sql.WriteString("JOIN businesses b ON e.businessID = b.businessID ")
	sql.WriteString(GenSelectQuery(params, "u.userID", userID))

	result, err := connect(sql.String())
	if err != nil {
		return nil, err
	}
	defer result.Close()

	var values []userAttendBusiness

	for result.Next() {
		var t userAttendBusiness
		var u user
		var b business
		var e event
		if err := result.Scan(
			&u.UserID,
			&u.Username,
			&u.Email,
			&u.AccountType,
			&u.ImgID,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.OwnerUserID,
			&b.Contact,
			&b.Description,
			&b.Rating,
			&b.ImgID,
			&b.PetSizePref,
			&b.LeashPolicy,
			&b.DisabledFriendly,
			&b.DataLocation,
			&b.GeoLocation,
			&e.AttendanceCount,
			&e.EventID,
			&e.BusinessID,
			&e.EventName,
			&e.EventDescription,
			&e.EventDate,
			&e.Location,
			&e.ContactInfo,
			&e.DataLocation,
			&e.ImgID,
			&e.PetSizePref,
			&e.LeashPolicy,
			&e.DisabledFriendly,
			&e.GeoLocation,
		); err != nil {
			return values, nil
		}
		t.U = u
		t.B = b
		t.E = e
		values = append(values, t)
	}

	if err = result.Err(); err != nil {
		return values, err
	}

	return values, nil
}

/*
*TESTED WORKING
gets all of a users saved businesses in full context
*/
func Users_SavedBusiness_GET(params map[string]interface{}, userID int) ([]usersSavedBusiness, error) {
	var sql strings.Builder
	sql.WriteString("SELECT  u.userID, u.username, u.email, u.accountType, u.imgID, ")
	sql.WriteString("    sb.businessID, b.businessName, b.businessType, b.location,")
	sql.WriteString("    b.ownerUserID, b.contact, b.description, b.rating, b.imgID,")
	sql.WriteString("    b.petSizePref, b.leashPolicy, b.disabledFriendly, b.dataLocation, b.geolocation ")
	sql.WriteString("FROM user u ")
	sql.WriteString("JOIN savedBusinesses sb ON u.userID = sb.userID ")
	sql.WriteString("JOIN businesses b ON sb.businessID = b.businessID ")

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
			&u.ImgID,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.OwnerUserID,
			&b.Contact,
			&b.Description,
			&b.Rating,
			&b.ImgID,
			&b.PetSizePref,
			&b.LeashPolicy,
			&b.DisabledFriendly,
			&b.DataLocation,
			&b.GeoLocation,
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
	sql.WriteString("SELECT  e.eventID, e.eventName, e.eventDescription, e.eventDate,")
	sql.WriteString("	e.location, e.contactInfo, e.imgID, e.petSizePref, e.leashPolicy, e.disabledFriendly,")
	sql.WriteString("	(SELECT COUNT(userID) FROM attendance WHERE eventID = e.eventID) as attendance_count, e.geolocation, ")
	sql.WriteString("	b.businessID, b.businessName, b.businessType, ")
	sql.WriteString("	b.location, b.contact, b.description, b.rating, b.OwnerUserID,")
	sql.WriteString("	b.imgID, b.petSizePref, b.leashPolicy, b.disabledFriendly, b.geolocation ")
	sql.WriteString("FROM events e ")
	sql.WriteString("JOIN businesses b ON e.businessID = b.businessID ")
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
			&e.ImgID,
			&e.PetSizePref,
			&e.LeashPolicy,
			&e.DisabledFriendly,
			&e.AttendanceCount,
			&e.GeoLocation,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.Contact,
			&b.Description,
			&b.Rating,
			&b.OwnerUserID,
			&b.ImgID,
			&b.PetSizePref,
			&b.LeashPolicy,
			&b.DisabledFriendly,
			&b.GeoLocation,
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
	// sql.WriteString("SELECT r.reviewID, r.rating, r.comment, r.dateCreated, u.userID, u.username, u.email, u.accountType, b.businessID, b.businessName, b.businessType, b.location, b.contact, b.rating AS businessRating, b.description, b.OwnerUserID")
	// sql.WriteString(" FROM reviews r JOIN businesses b ON r.businessID = b.businessID JOIN user u ON r.userID = u.userID")

	sql.WriteString("SELECT  r.reviewID, r.rating, r.comment, r.dateCreated, r.imgID,")
	sql.WriteString("	u.userID, u.username, u.email, u.accountType, u.imgID,")
	sql.WriteString("	b.businessID, b.businessName, b.businessType, ")
	sql.WriteString("	b.location, b.contact, b.rating AS businessRating, b.description, b.OwnerUserID,")
	sql.WriteString("	b.imgID, b.petSizePref, b.leashPolicy, b.disabledFriendly, b.dataLocation, r.dataLocation, b.geolocation ")
	sql.WriteString("FROM reviews r ")
	sql.WriteString("JOIN businesses b ON r.businessID = b.businessID ")
	sql.WriteString("JOIN user u ON r.userID = u.userID")

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
			&r.ImgID,
			&u.UserID,
			&u.Username,
			&u.Email,
			&u.AccountType,
			&u.ImgID,
			&b.BusinessID,
			&b.BusinessName,
			&b.BusinessType,
			&b.Location,
			&b.Contact,
			&b.Rating,
			&b.Description,
			&b.OwnerUserID,
			&b.ImgID,
			&b.PetSizePref,
			&b.LeashPolicy,
			&b.DisabledFriendly,
			&b.DataLocation,
			&r.DataLocation,
			&b.GeoLocation,
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

		if columnName == "id" || columnName == "pwd" || columnName == "imgID" {
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
	return execute(sql)
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
	return execute(sql)
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
	return execute(sql)
}

/*
*TESTED WORKING
POST TO: reviews table
DATA: model after POST.review.json
RETURN: Error when applicable nil if no error
*/
func CreateNewReview(data review) error {
	tableName := "reviews"

	ignoreColumns := []string{"reviewid", "reviewID", "datecreated", "dateCreated"}
	sql, err := GenInsertQuery(tableName, data, ignoreColumns)

	if err != nil {
		return err
	}
	return execute(sql)
}

/*
*TESTED WORKING
POST TO: event table
DATA: model after POST.event.json
RETURN: Error when applicable nil if no error (check if saved business exists)
*/
func CreateNewEvent(data event) error {
	tableName := "events"
	ignoreColumns := []string{"eventID", "eventid", "attendancecount"}

	sql, err := GenInsertQuery(tableName, data, ignoreColumns)
	if err != nil {
		return err
	}
	return execute(sql)
}

/*
*TESTED WORKING
POST TO: images table
DATA: must be form-data shaped like POST.uploads.json
RETURN: error when applicable nil if no error
*/
func CreateNewImgInfo(data imgInfo) error {
	tableName := "images"

	ignoreColumns := []string{"id", "imgID", "imgid"}

	sql, err := GenInsertQuery(tableName, data, ignoreColumns)
	fmt.Println(sql)
	if err != nil {
		return err
	}
	return execute(sql)
}

/*
*TESTED WORKING
creates new attendance in database if it does not exists already, updates attendance count
*/
func CreateNewAttendance(data attendance) error {
	if AttendanceExist(data.UserID, data.EventID) {
		return &s.AttendanceExistError{Message: "user is already attending event"}
	}
	tableName := "attendance"

	ignoreColumns := []string{"id"}

	sql, err := GenInsertQuery(tableName, data, ignoreColumns)
	if err != nil {
		return err
	}
	err = execute(sql)
	if err != nil {
		return err
	}
	sql = fmt.Sprintf("UPDATE events SET attendance_count = (SELECT COUNT(id) FROM attendance WHERE eventID = %d)", data.EventID)
	return execute(sql)
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

/*
*TESTED PASSING
GENERIC UPDATE METHOD WILL MATCH INTERFACE UPDATEQUERY STRUCT
RETURN: error if applicable
!NEED TO IMPLEMENT WAY TO CHECK IF CHANGES ARE MADE PROPERLY
*/
func UpdateData(data updatequery) error {
	var setValues []string
	var whereValues []string

	for i := 0; i < len(data.ColumnsNew); i++ {
		columnName := strings.ToLower(data.ColumnsNew[i])
		columnValue := data.ValuesNew[i]

		setValues = append(setValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
	}

	for i := 0; i < len(data.ColumnsOld); i++ {
		columnName := strings.ToLower(data.ColumnsOld[i])
		columnValue := data.ValuesOld[i]

		whereValues = append(whereValues, fmt.Sprintf("%s='%v'", columnName, columnValue))
	}

	sql := fmt.Sprintf("UPDATE %s SET %s WHERE %s", data.TableName, strings.Join(setValues, ","), strings.Join(whereValues, " AND "))

	return execute(sql)
}

/*
*TESTED PASSING
UPDATE METHOD TO CHANGE PWD MUST BE SHAPED LIKE PWDRESET STRUCT
RETURN: error if applicable
*/
func UpdatePassword(data pwdreset) error {
	if data.NewPwd == data.OldPwd {
		return &s.PWDResetError{Message: "password cannot be the same as old"}
	}

	checkoldPWd := fmt.Sprintf("SELECT password FROM user WHERE userID=%d", data.UserID)
	result, err := connect(checkoldPWd)
	if err != nil {
		return errors.New("error connecting to database")
	}
	defer result.Close()

	if result.Next() {
		var t pwdreset
		if err := result.Scan(
			&t.OldPwd,
		); err != nil {
			return err
		}
		if err := VerifyPassword([]byte(data.OldPwd), []byte(t.OldPwd)); err != nil {
			return &s.PWDResetError{Message: "password does not match"}
		}
	}

	hashedPwd, err := HashPassword(data.NewPwd)
	if err != nil {
		return err
	}

	sql := fmt.Sprintf("UPDATE user SET password = '%s' WHERE userID = %d", hashedPwd, data.UserID)
	return execute(sql)
}

// //**+++++++++++++++++++++DELETE QUERIES++++++++++++++++++++++++++++

/*
*TESTED WORKING
deletes data from tables, cascades across all tables when necessary
!THERE IS NO ERROR CHECKING THIS MIGHT BITE ME IN THE ASS LATER
*/
func DeleteData(data deleteQuery) error {
	user_deleteUser := fmt.Sprintf("DELETE FROM user WHERE userID = %d", data.ID)
	user_deleteSavedBusiness := fmt.Sprintf("DELETE FROM savedBusinesses WHERE userID = %d", data.ID)
	user_deleteReview := fmt.Sprintf("DELETE FROM reviews WHERE userID = %d", data.ID)
	user_deleteBusiness := fmt.Sprintf("DELETE FROM businesses WHERE OwnerUserID = %d", data.ID)
	user_deleteEvents := fmt.Sprintf("DELETE FROM events WHERE businessID = (SELECT businessID FROM businesses b WHERE OwnerUserID = %d)", data.ID)
	user_deleteAttendance := fmt.Sprintf("DELETE FROM attendance WHERE eventID = (SELECT e.eventID FROM events e JOIN businesses b on b.OwnerUserID = %d AND e.businessID = b.businessID)", data.ID)

	business_deleteBusiness := fmt.Sprintf("DELETE FROM businesses WHERE businessID = %d", data.ID)
	business_deleteSavedBusinesses := fmt.Sprintf("DELETE FROM savedBusinesses WHERE businessID = %d", data.ID)
	business_deleteReviews := fmt.Sprintf("DELETE FROM reviews WHERE businessID = %d", data.ID)
	business_deleteEvents := fmt.Sprintf("DELETE FROM events WHERE businessID = %d", data.ID)
	business_deleteAttendance := fmt.Sprintf("DELETE FROM attendance WHERE eventID = (SELECT eventID from events WHERE businessID = %d)", data.ID)

	event_deleteAttendance := fmt.Sprintf("DELETE FROM attendance WHERE eventID = %d", data.ID)

	genericSQL := fmt.Sprintf("DELETE FROM %s WHERE %s = %d", data.TableName, data.Column, data.ID)

	switch data.TableName {
	case "user":
		execute(user_deleteAttendance)
		execute(user_deleteEvents)
		execute(user_deleteReview)
		execute(user_deleteSavedBusiness)
		execute(user_deleteBusiness)
		execute(user_deleteUser)

	case "businesses":
		execute(business_deleteAttendance)
		execute(business_deleteEvents)
		execute(business_deleteReviews)
		execute(business_deleteSavedBusinesses)
		execute(business_deleteBusiness)
	case "reviews":
		execute(genericSQL)
	case "savedBusiness":
		execute(genericSQL)
	case "events":
		execute(event_deleteAttendance)
		execute(genericSQL)
	}

	return nil
}

/*
*TESTED WORKING
deletes attendance from database AND updates attendance count in events table
!THERE IS NO TRUE ERROR CHECKING THIS WILL HAUNT ME LATER
*/
func DeleteAttendanceData(data attendance) error {
	delete_attendance := fmt.Sprintf("DELETE FROM attendance WHERE userID=%d AND eventID=%d", data.UserID, data.EventID)
	update_attendance := fmt.Sprintf("UPDATE events SET attendance_count = (SELECT COUNT(id) FROM attendance WHERE eventID = %d)", data.EventID)
	execute(delete_attendance)
	execute(update_attendance)
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

		if err := result.Scan(
			t.Id,
			t.Name,
			t.Token,
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
