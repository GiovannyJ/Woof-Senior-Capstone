"""
This script will pass yelp data to our internal API
"""

import requests
from dataclasses import dataclass

class YelpScraper:
    def __init__(self, endpoint, params):
        self.API_KEY = 'BPMNX6-KSFj6M8Yw4BFTGD48QlWenlvwnms89H60vasoEIIhNZ2lqpMjpnnElRZUtBqPV4tgQgwtrYMIY8W0ZYo830fMhmTZbhjymNyp_-EpeE08FG5zmeE7_4HCZXYx'
        self.ENDPOINT = f"https://api.yelp.com/v3/{endpoint}/search"
        self.headers = {'Authorization': f'Bearer {self.API_KEY}'}
        self.params = params
        self.data = ""
        self.datatype = endpoint
    # "https://api.yelp.com/v3/businesses/search?term=dog+friendly&categories=restaurants,bars&open_now=true&sort_by=distance&location=${window.searchText}"

    """
    method to collect data from the endpoint
    """
    def getData(self):
        response = requests.get(self.ENDPOINT, params=self.params, headers=self.headers)

        if response.status_code == 200:
            data = response.json()[self.datatype]
            print(data)
            self.data = data
        else:
            print(f"Error: {response.status_code}")
    
    """
    method to clean the data to our liking
    if there is an image send it to the img downloader script
    package the data as one of the data classes and return it
    """
    def cleanData(self):
        if self.datatype == "businesses":
            pass
        elif self.datatype == "events":
            pass
        elif self.datatype == "reviews":
            pass


@dataclass
class business():
    businessName : str
    businessType: str
    ownerUserID: int #DEFAULT TO 0 figure out problem later
    location: str
    contact: str
    description: str
    petSizePref: str #CAN ONLY BE small, medium, large (maybe update to include any -> backend)
    leashPolicy: bool #i think this is 0 or 1
    disabledFriendly: bool #i thnk this is 0 or 1
    dataLocation: str #Default to foreign
    imgID: int #Default to 0

@dataclass
class event():
    eventName: str
    eventDescription: str
    eventDate: str
    location: str
    contactInfo: str
    petSizePref: str #CAN ONLY BE small, medium, large (maybe update to include any -> backend)
    leashPolicy: bool #i think this is 0 or 1
    disabledFriendly: bool #i thnk this is 0 or 1
    datalocation: str #Default to foreign
    imgID: int #Default to 0

@dataclass
class review():
    currentuserID: int #default to 0
    rating: int
    comment: str
    datalocation: str #Default to foreign
    imgID: int #Default to 0