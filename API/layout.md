# Layout for backend of Woof
## Requirements
- Golang

### Folders:
- 📁 database: database driver
- 📁 json_templates: documentation for shape of data in requests
- 📁 models: shape of data structs
- 📁 rest: API routers

### Files:
- 📄 main.go: main driver of the API

# How to use

## How to run
```
cd API
go run main.go
```

### AUTHENTICATION
Authentication is not yet implemented but, this API will need JWT to interact with for security reasons. Only admins (us swag beasts) have access to token to make requests. This token must be part of the header for each request.

### GET REQUESTS
These are endpoints to retrieve data from the database. They can be queried with parameters and in order of ascending or descending. The endpoints are:
+ [http://localhost:8080/users](#)
  - Retrieve a list of all users.
  - Query parameters available: `userID`, `username`, `email`, `accountType`, `order`
  - ex: http://localhost:8080/users?userID=2 will return all the data for userID = 2 in the database
  
+ [http://localhost:8080/users/#USERID/savedbusinesses](#)
  - Retrieve the list of businesses saved by a specific user.
  - Query parameters available: `businessID`, `order`
  - ex: http://localhost:8080/users/2/savedbusinesses?businessID=3
  
+ [http://localhost:8080/businesses](#)
  - Retrieve a list of all businesses.
  - Query parameters available: `businessID`, `businessName`, `ownerUserID`, `businessType`, `location`, `contact`, `rating`, `order`.
  - ex: http://localhost:8080/businesses?businessName=Doggy
  
+ [http://localhost:8080/businesses/#BUSINESSID/reviews](#)
  - Retrieve reviews for a specific business.
  - Query parameters available: `reviewID`, `reviewRating`, `dateCreated`, `userID`, `username`, `email`, `accountType`, `order`
  - ex: http://localhost:8080/businesses/1/reviews?reviewRating=5
  
+ [http://localhost:8080/businesses/#BUSINESSID/events](#)
  - Retrieve events associated with a specific business.
  - Query parameters available: `eventID`, `eventName`, `eventDate`, `order` 
  - ex: http://localhost:8080/businesses/1/events?eventName=doggy%20disco
  
+ [http://localhost:8080/events](#)
  - Retrieve a list of all events.
  - Query parameters available: `eventID`, `eventName`, `eventDate`, `order`
  - ex: http://localhost:8080/events?eventName=doggy%20disco

[Sample JSON Responses](json_templates/GET_REQUESTS)

### POST REQUESTS
These are endpoints to send data to the database. In the request body you must shape them a particular way so that the API can parse through them properly. The endpoints are:
+ [http://localhost:8080/users](#)
  - Create a new user
  - passwords are hashed in database
  - checks for if user exists already
  
+ [http://localhost:8080/savedbusinesses/users/#USERID](#)
  - Create a new saved business for user
  
+ [http://localhost:8080/businesses](#)
  - Create a new business
  - Checks if business exists already (if it has the same name and location)
  
  
+ [http://localhost:8080/reviews/user/#USERID/businesses/#BUSINESSID](#)
  - Create a review for a business as a user
  
+ [http://localhost:8080/events/businesses/#BUSINESSID](#)
  - Create an event for a business using its ID
  
  
+ [http://localhost:8080/login](#)
  - Login using username and password
  

[Sample JSON Body for Requests](json_templates/POST_REQUESTS)

### PATCH REQUESTS
These are endpoints to update data in the database. The endpoints are: 
+ [http://localhost:8080/users](#)
  - Update user data (not passwords)

+ [http://localhost:8080/users/password](#)
  - Update password for user (NOT IMPLEMENTED)

+ [http://localhost:8080/businesses](#)
  - Update business information
  
+ [http://localhost:8080/reviews](#)
  - Update review information
  
+ [http://localhost:8080/events](#)
  - Update event information

[Sample JSON Body for Requests](json_templates/PATCH_REQUESTS)

### DELETE REQUESTS
These are endpoints to delete data from the database. 
+ [http://localhost:8080/users](#)
  - Delete user from database
  - Cascades and deletes all businesses, reviews, savedbusinesses, events (belonging to business) as well

+ [http://localhost:8080/businesses](#)
  - Delete business from database
  - Cascades and deletes all reviews, savedbusinesses, events as well

+ [http://localhost:8080/savedbusinesses](#)
  - Delete saved business from database
  
+ [http://localhost:8080/reviews](#)
  - Delete review from database
  
+ [http://localhost:8080/events](#)
  - Delete event from database

[Sample JSON Body for Requests](json_templates/DEL_REQUESTS)


### Notes
In the future this API may be deployed to my production server as a stand alone service rather than a exe that runs on disc. There may also be attempts to transition this API to a cloud service. This must be done in order to have the API constantly serve data when needed.
