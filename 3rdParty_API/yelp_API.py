"""
This script will pass yelp data to our internal API
"""

import requests
import models
import woof_API

class YelpScraper:
    def __init__(self, endpoint, params):
        self.API_KEY = 'BPMNX6-KSFj6M8Yw4BFTGD48QlWenlvwnms89H60vasoEIIhNZ2lqpMjpnnElRZUtBqPV4tgQgwtrYMIY8W0ZYo830fMhmTZbhjymNyp_-EpeE08FG5zmeE7_4HCZXYx'
        self.ENDPOINT = ""
        if endpoint == "businesses":
            self.ENDPOINT = f"https://api.yelp.com/v3/{endpoint}/search"
        elif endpoint == "events":
            self.ENDPOINT = f"https://api.yelp.com/v3/{endpoint}"
        self.headers = {'Authorization': f'Bearer {self.API_KEY}'}
        self.params = params
        self.data = ""
        self.datatype = endpoint
    
    def getData(self):
        response = requests.get(self.ENDPOINT, params=self.params, headers=self.headers)

        if response.status_code == 200:
            self.data = response.json().get(self.datatype, [])
            # return self.data
            return self.cleanData()
        else:
            print(f"Error: {response.status_code} {response.text}")
            # return []

    
    def cleanData(self):
        cleaned_data = []
        api = woof_API.WoofAPI()
        
        def sanitize_string(text):
            sanitized_text = text.replace("'", "")
            return sanitized_text

        if self.datatype == "businesses":
            #parse through data -> find account info -> send to API and get back id
            #parse though data w accID -> send business data
            for item in self.data:

                account = models.Account(
                    userName=sanitize_string(item["id"]),
                    email=sanitize_string(item['name'].replace(" ", "")) + '@gmail.com'
                )

                # Send the account object to the API RETURNS THE ACCOUNTID
                accountID = api.sendAccount(accObj=account)

                # Create a business object with sanitized attributes
                business = models.Business(
                    businessName=sanitize_string(item['name']),
                    businessType=', '.join([category['title'] for category in item['categories']]),
                    location=', '.join(item['location']['display_address']),
                    contact=item.get('phone', ''),
                    description=', '.join([sanitize_string(category['title']) for category in item['categories']]),  # Combine all category titles as description
                    ownerUserID=accountID,
                    geolocation=f"{item['coordinates']['latitude']}, {item['coordinates']['longitude']}",
                    petSizePref='small',  # You can add logic to determine pet size preference
                    leashPolicy=False,  # You can add logic to determine leash policy
                    disabledFriendly=False  # You can add logic to determine disabled friendliness
                )
                
                businessID = api.sendBusiness(businessObj=business)

                cleaned_data.append(businessID)

        elif self.datatype == "events":
            # Add cleaning logic for events if needed
            pass
        elif self.datatype == "reviews":
            # Add cleaning logic for reviews if needed
            pass

        return cleaned_data

