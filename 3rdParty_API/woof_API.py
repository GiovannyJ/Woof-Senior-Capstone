"""
This is a class that is used to send data to the WOOF API
"""

class WoofAPI:
    def __init__(self):
        self.url = "localhost:8080/"

    def sendBusiness(self, businessObj):
        url = self.url + "businesses"
        pass

    def sendReview(self, reviewObj):
        url = self.url + f"/user/{reviewObj.userID}/business/{reviewObj.businessID}"
        pass

    def sendEvent(self, eventObj):
        url = self.url + f"events/businesses/{eventObj.businessID}"
        pass

    def sendImg(self, imgObj):
        url = self.url + "uploads"
        pass

