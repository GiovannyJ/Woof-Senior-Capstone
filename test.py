import requests

# Define the API key and endpoint
API_KEY = 'BPMNX6-KSFj6M8Yw4BFTGD48QlWenlvwnms89H60vasoEIIhNZ2lqpMjpnnElRZUtBqPV4tgQgwtrYMIY8W0ZYo830fMhmTZbhjymNyp_-EpeE08FG5zmeE7_4HCZXYx'
ENDPOINT = 'https://api.yelp.com/v3/businesses/search'
# "https://api.yelp.com/v3/businesses/search?term=dog+friendly&categories=restaurants,bars&open_now=true&sort_by=distance&location=${window.searchText}"

# Define the parameters for the search
params = {
    'term': 'pet friendly',
    'location': 'Long Island',  # Specify the location you want to search in
    'categories': 'restaurants,bars,businesses,hotel,parks',  # Specify the category of businesses you want to search for
    'limit': 10  # Limit the number of results
}

# Define the headers with the API key
headers = {
    'Authorization': f'Bearer {API_KEY}'
}

# Make the API call
response = requests.get(ENDPOINT, params=params, headers=headers)

# Check if the request was successful
if response.status_code == 200:
    # Print the names of the businesses
    businesses = response.json()['businesses']
    #format
    for i in businesses:
        # bind to structure that looks like BODY_JSON
        # call to POST ENDPOINT 
    print(businesses)
else:
    print(f"Error: {response.status_code}")
