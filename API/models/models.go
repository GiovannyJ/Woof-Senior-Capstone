package models


type User struct{
	UserID       	int    	`json:"userID"`
	Username 		string 	`json:"username"`
	Pwd 	 		string 	`json:"pwd"`
	Email    		string 	`json:"email"`
	AccountType 	string	`json:"accountType"`
}

type Business struct{
	BusinessID      	int    	`json:"businessID"`
	BusinessName		string	`json:"businessName"`
	OwnerID      		int    	`json:"ownerID"`
	BusinessType		string	`json:"businessType"`
	BusinessLocation	string	`json:"businessLocation"`
	Contact	 			string 	`json:"contact"`
	Descr 				string	`json:"descr"`
	Events 				string	`json:"events"`
	Rating 				string	`json:"rating"`
}

type SavedBusiness struct{
	UserID       	int    	`json:"userID"`
	BusinessID      int    	`json:"businessID"`
}

type Event struct{
	EventID       	int    	`json:"eventID"`
	BusinessID      int    	`json:"businessID"`
	EventName	 	string	`json:"eventName"`
	EventDescr 		string	`json:"eventDescr"`
	EventDate 		string	`json:"eventDate"`
	Location 		string	`json:"location"`
	Contact	 		string 	`json:"contact"`
}

type Review struct{
	ReviewID       	int    	`json:"reviewID"`
	UserID       	int    	`json:"userID"`
	BusinessID      int    	`json:"businessID"`
	Rating  		int 	`json:"rating"`
	Comment	 		string 	`json:"comment"`
	DateCreated 	string	`json:"dateCreated"`
}