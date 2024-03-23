"""
This is a class that is used to send data to the WOOF API
"""
import requests

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
            return response.json()[0]["businessID"]
        else:
            print(f"Error: {response.status_code} {response.text}")
            return None

    def sendReview(self, reviewObj):
        url = self.url + f"/user/{reviewObj.userID}/business/{reviewObj.businessID}"
        pass

    def sendEvent(self, eventObj):
        url = self.url + f"events/businesses/{eventObj.businessID}"
        pass

    def sendImg(self, imgObj):
        url = self.url + "uploads"
        pass

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
            # If the request is successful, return the account ID
            return response.json()[0]["userID"]
        else:
            # If the request fails, print the error message and return None
            print(f"Error: {response.status_code} {response.text}")
            return None
    
    #RETURNS ALL foreign BUSINESSES IN THE API
    def getBusinesses(self):
        url = self.url + "businesses?dataLocation=foreign"
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
                    print("Business updated successfully.")
                else:
                    print("Failed to update business. Status code:", response.status_code)
            except requests.exceptions.RequestException as e:
                print("Error:", e)


