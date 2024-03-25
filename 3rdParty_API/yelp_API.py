"""
This script will pass yelp data to our internal API
"""

import requests
import models
import woof_API

api = woof_API.WoofAPI()

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
        if self.datatype == "reviews":
            for i in api.getAccountNames():
                username = i["username"]
                self.ENDPOINT = f"https://api.yelp.com/v3/businesses/{username}/reviews"
                response = requests.get(self.ENDPOINT, headers=self.headers)
                if response.status_code == 200:
                    self.data = response.json().get(self.datatype, [])
                    self.tempOwnerUserID = i["userID"]
                    self.cleanData()
        
        else:
            response = requests.get(self.ENDPOINT, params=self.params, headers=self.headers)

            if response.status_code == 200:
                self.data = response.json().get(self.datatype, [])
                return self.cleanData()
            else:
                print(f"[-] Error collecting data: {response.status_code} {response.text}")
                # return []

    
    def cleanData(self):
        cleaned_data = []
        
        def sanitize_string(text):
            sanitized_text = text.replace("'", "")
            return sanitized_text

        if self.datatype == "businesses":
            #parse through data -> find account info -> send to API and get back id
            #parse though data w accID -> send business data
            for item in self.data:
                account = models.Account(
                    userName=sanitize_string(item["id"].replace(" ", "")),
                    email=sanitize_string(item['name'].replace(" ", "")) + '@gmail.com'
                )

                # Send the account object to the API RETURNS THE ACCOUNTID
                accountID = api.sendAccount(accObj=account)

                
                #if there is an image upload it and if not then keep as 0
                imgID = 0
                if 'image_url' in item:
                    img = models.ImageInfo(
                        imgName=item['image_url']
                    )

                    imgID = api.sendImg(imgObj=img)
                
                # Create a business object with sanitized attributes
                business = models.Business(
                    businessName=sanitize_string(item['name']),
                    businessType=', '.join([category['title'] for category in item['categories']]),
                    location=', '.join(item['location']['display_address']),
                    contact=item.get('phone', ''),
                    description=', '.join([category['title'] for category in item['categories']]),  # Combine all category titles as description
                    ownerUserID=accountID,
                    geolocation=f"{item['coordinates']['latitude']}, {item['coordinates']['longitude']}",
                    petSizePref='small',  # You can add logic to determine pet size preference
                    leashPolicy=False,  # You can add logic to determine leash policy
                    disabledFriendly=False,  # You can add logic to determine disabled friendliness
                    imgID=imgID
                )
                
                businessID = api.sendBusiness(businessObj=business)
                api.updateBusiness(businessID=businessID, column="imgID", newValue=imgID)


                cleaned_data.append(businessID)

        elif self.datatype == "reviews":
            businessID = api.getBusinesses(self.tempOwnerUserID)[0]["businessID"]
            for item in self.data:
                review = models.Review(
                    rating=item['rating'],
                    comment=item['text'],
                    businessID=businessID
                )

                api.sendReview(reviewObj=review)

                cleaned_data.append(review)


        elif self.datatype == "events":
            businessID = api.getBusinesses(self.tempOwnerUserID)[0]["businessID"]
            for item in self.data:
                event = models.Event(
                    businessID=businessID,
                    eventName=item[""],
                    eventDescription=item[""],
                    eventDate=item[""],
                    location=item[""],
                    contactInfo=item[""],
                    geolocation=item[""],
                    petSizePref="small",
                    leashPolicy=False,
                    disabledFriendly=False
                )
                
                api.sendEvent(eventObj=event)
                cleaned_data.append(event)

        return cleaned_data

