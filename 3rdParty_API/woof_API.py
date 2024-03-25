"""
This is a class that is used to send data to the WOOF API
"""
import requests
import models

class WoofAPI:
    def __init__(self):
        self.url = "http://localhost:8080/"

    def sendBusiness(self, businessObj):
        url = self.url + "businesses"
        data = {
            "BusinessName": businessObj.businessName,
            "OwneruserID": businessObj.ownerUserID,
            "BusinessType": businessObj.businessType,
            "Location": businessObj.location,
            "Contact": businessObj.contact,
            "Description": businessObj.description,
            "DataLocation": businessObj.dataLocation,
            "PetSizePref": businessObj.petSizePref,
            "LeashPolicy": businessObj.leashPolicy,
            "DisabledFriendly": businessObj.disabledFriendly,
            "GeoLocation": businessObj.geolocation
        }

        response = requests.post(url, json=data)
        
        if response.status_code == 201:
            print(f"[+] upload business {businessObj.businessName} successful")
            return response.json()[0]["businessID"]
        else:
            print(f"[-] Error uploading {businessObj.businessName}: {response.status_code} {response.text}")
            return None

    def sendReview(self, reviewObj):
        url = self.url + f"reviews/user/{reviewObj.currentuserID}/businesses/{reviewObj.businessID}"
        data = {
               "rating": reviewObj.rating,
                "comment": reviewObj.comment,
                "datalocation": reviewObj.datalocation
        }

        response = requests.post(url, json=data)
        
        if response.status_code == 201:
            print(f"[+] review for business:{reviewObj.businessID} uploaded successfully")
            return response.json()[0]["reviewID"]
        else:
            print(f"[-] Error uploading review for business:{reviewObj.businessID}: {response.status_code} {response.text}")
            return None

    def sendEvent(self, eventObj):
        url = self.url + f"events/businesses/{eventObj.businessID}"
        data =     {
            "eventName": eventObj.eventName,
            "eventDescription": eventObj.eventDescription,
            "eventDate": eventObj.eventDate,
            "location": eventObj.location,
            "contactInfo": eventObj.contactInfo,
            "petSizePref": eventObj.petSizePref,
            "leashPolicy": eventObj.leashPolicy,
            "disabledFriendly": eventObj.disabledFriendly,
            "datalocation": eventObj.datalocation,
            "geolocation": eventObj.geolocation,
        }

        response = requests.post(url, json=data)
        
        if response.status_code == 201:
            print(f"[+] event {eventObj.eventName} upload successful")
            return response.json()[0]["eventID"]
        else:
            print(f"[-] Error uploading event {eventObj.eventName}: {response.status_code} {response.text}")
            return None

    def sendImg(self, imgObj):
        url = self.url + "imageInfo"
        
        data = {
            "size":imgObj.size,
            "imgData": imgObj.imgData,
            "imgName": imgObj.imgName,
            "imgType": imgObj.imgType,
            "dateCreated": imgObj.dateCreated
        }
        response = requests.post(url, json=data)
        
        if response.status_code == 201:
            print("[+] image upload successful")
            return response.json()[0]["imgID"]
        else:
            
            print(f"[-] Error uploading image: {response.status_code} {response.text}")
            return None

    #SEND ACCOUNT TO API AND RETURN ACCOUNT ID
    def sendAccount(self, accObj):
        url = self.url + "users"
        # Prepare the data to be sent in the request body
        data = {
            "username": accObj.userName,
            "password": accObj.password,
            "email": accObj.email,
            "accountType": accObj.accountType
        }
        # Make the POST request to the API
        response = requests.post(url, json=data)
        
        if response.status_code == 201:
            print(f"[+] Account for {accObj.userName} upload successful")
            return response.json()[0]["userID"]
        else:
            print(f"[-] Error uploading account {accObj.userName}: {response.status_code} {response.text}")
            return None
    
    #RETURNS ACCOUNT IF FULL CONTEXT PARSE WITH ["PROPERTY"]
    def getAccountNames(self):
        url = self.url + "users?accountType=foreign business"
        response = requests.get(url).json()
        return response

    #RETURNS ALL foreign BUSINESSES IN THE API
    def getBusinesses(self, userID):
        if userID != "":
            url = self.url + f"businesses?dataLocation=foreign&ownerUserID={userID}"
        else:
            url = self.url + f"businesses?dataLocation=foreign"

        response = requests.get(url).json()
        return response
    
    
    def updateBusiness(self, businessID, column, newValue):
        url = self.url + "businesses"
        data = {
            "tablename": "businesses",
            "columns_old": ["businessID"],
            "values_old": [businessID],
            "columns_new": [column],
            "values_new": [newValue]
        }
        
        try:
            response = requests.patch(url, json=data)
            
            if response.status_code == 200:
                print(f"[+] Business {businessID} updated successfully.")
            else:
                print("[-] Failed to update business. Status code:", response.status_code)
        except requests.exceptions.RequestException as e:
            print("[-] Error:", e)

    def __updateAccount(self, accountID, column, newValue):
        url = self.url + "users"
        data = {
            "tablename": "user",
            "columns_old": ["userID"],
            "values_old": [accountID],
            "columns_new": [column],
            "values_new": [newValue]
        }
        
        try:
            response = requests.patch(url, json=data)
            
            if response.status_code == 200:
                print(f"[+] Account {accountID} updated successfully.")
            else:
                print(f"[-] Failed to update account {accountID}. Status code:", response.status_code)
        except requests.exceptions.RequestException as e:
            print(f"[-] Error:", e)

    def send_defaults(self):
        gio = models.Account(
            userName="gio",
            email="gio@gmail.com",
            password="g",
            accountType="regular"
            )
        bo = models.Account(
            userName="bo",
            email="bo@gmail.com",
            password="b",
            accountType="regular"
            )
        martin = models.Account(
            userName="martin",
            email="martin@gmail.com",
            password="m",
            accountType="regular"
            )
        yelp = models.Account(
            userName="Yelp Reviewer",
            email="yelper@yelp.com",
            password="y",
            accountType="yelp reviewer"
            )
        g = models.Account(
            userName="g",
            email="g@gmail.com",
            password="g",
            accountType="business"
            )
        accounts_list = [gio, bo, yelp, martin, g]
        
        for i in accounts_list:
            accountID = self.sendAccount(accObj=i)
            if i.userName == "Yelp Reviewer":
                self.__updateAccount(accountID=accountID, column="userID", newValue=0)
        

