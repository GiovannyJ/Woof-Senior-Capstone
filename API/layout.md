# Layout for backend of Woof
### Folders:
- 📁 database: database driver
- 📁 json_templates: documentation for shape of data in requests
- 📁 models: shape of data structs
- 📁 rest: API routers

### Files:
- 📄 main.go: main driver of the API

# How to use

### AUTHENTICATION
this API needs JWT to interact with for security reasons. Only admins (us swag beasts) have access to token to make requests. This token must be part of the header for each request.

### GET REQUESTS
These are endpoints to retrieve data from the database. They can be queried with parameters and in order of ascending or descending. The endpoints are:
thing: you can queyr eith thing
thing1: you can queyr eiht this
the sample returns for these endpoints can be found at (json_templates/GET_REQUESTS)



### POST REQUESTS
These are endpoints to send data to the database. In the request body you must shape them a particular way so that the API can parse through them properly. You can find the format of these request bodies here (json_templates/POST_REQUESTS)

### PATCH REQUESTS
These are endpoints to update data in the database. The request body you send must be shaped like the ones you find in (json_templates/PATCH_REQUESTS).

### DELETE REQUESTS
These are endpoints to delete data from the database. The request boyd must be shaped like the ones you find in (json_templates/DEL_REQUESTS)
