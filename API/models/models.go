package models

import "fmt"

type User struct{
	UserID       	int    	`json:"userID"`
	Username 		string 	`json:"username"`
	Pwd 	 		string 	`json:"pwd"`
	Email    		string 	`json:"email"`
	AccountType 	string	`json:"accountType"`
}

type LogIn struct {
	UserID      int    	`json:"userID"`
	Username 	*string `json:"username"`
	Pwd      	*[]byte `json:"pwd"`
	Password 	*string `json:"password"`
	Email    	*string `json:"email"`
	AccountType *string `json:"accountType"`
}


type AccountExistsError struct {
	Username string
}
func (e *AccountExistsError) Error() string {
	return fmt.Sprintf("Account with username %s already exists", e.Username)
}

type Business struct{
	BusinessID      	int    	`json:"businessID"`
	BusinessName		string	`json:"businessName"`
	OwnerUserID      	int    	`json:"ownerUserID"`
	BusinessType		string	`json:"businessType"`
	Location			string	`json:"Location"`
	Contact	 			string 	`json:"contact"`
	Description 		string	`json:"description"`
	Events 				*string	`json:"event,omitempty"`
	Rating 				*string	`json:"rating,omitempty"`
}

type BusinessExistsError struct {
	Location string
}
func (e *BusinessExistsError) Error() string {
	return fmt.Sprintf("Business at this location %s already exists", e.Location)
}

type SavedBusiness struct{
	SavedID 		int		`json:"savedID"`
	UserID       	int    	`json:"userID"`
	BusinessID      int    	`json:"businessID"`
}
type SavedBusinessExistsError struct {
	Location string
}
func (e *SavedBusinessExistsError) Error() string {
	return "User already saved business"
}

type UsersSavedBusiness struct{
	U User 		`json:"userinfo"`
	B Business 	`json:"businessinfo"`
}

type Event struct{
	EventID       			int    	`json:"eventID"`
	BusinessID      		int    	`json:"businessID"`
	EventName	 			string	`json:"eventName"`
	EventDescription 		string	`json:"eventDescription"`
	EventDate 				string	`json:"eventDate"`
	Location 				string	`json:"location"`
	ContactInfo	 				string 	`json:"contactInfo"`
}

type BusinessEvents struct{
	B Business 	`json:"businessinfo"`
	E Event 	`json:"eventinfo"`
}

type Review struct{
	ReviewID       	int    	`json:"reviewID"`
	UserID       	int    	`json:"userID"`
	BusinessID      int    	`json:"businessID"`
	Rating  		int 	`json:"rating"`
	Comment	 		string 	`json:"comment"`
	DateCreated 	string	`json:"dateCreated"`
}



type BusinessReview struct{
	B Business 	`json:"businessinfo"`
	U User		`json:"userinfo"`	
	R Review 	`json:"reviewinfo"`
}

type Admin struct {
	Id     *string `json:"id"`
	Name   *string `json:"name"`
	Token  *string `json:"token"`
	Passwd *string `json:"passwd"`
}

type UpdateQuery struct {
	TableName  string        `json:"tablename"`
	ColumnsOld []string      `json:"columns_old"`
	ValuesOld  []interface{} `json:"values_old"`
	ColumnsNew []string      `json:"columns_new"`
	ValuesNew  []interface{} `json:"values_new"`
}

type DeleteQuery struct{
	TableName  	string      `json:"tablename"`
	Column		string		`json:"column"`
	ID			int			`json:"id"`
}

type PWDReset struct{
	UserID 		int		 `json:"userID"`
	OldPwd		string 	`json:"oldpwd"`
	NewPwd		string  `json:"newpwd"`
}
type PWDResetError struct{
	Message string
}
func (e *PWDResetError) Error() string {
	return e.Message
}
