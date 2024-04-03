"""
This is a class that is used to send data to the WOOF API
"""
import requests
import models
import random
import string
from datetime import datetime, timedelta


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

    def getInternalAccountNames(self):
        url = self.url + "users?accountType=regular"
        response = requests.get(url).json()
        user_ids = [user["userID"] for user in response]
        return user_ids


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
        

    def populate_random(self):
        account1 = models.Account(
            userName="joey",
            email="joey@gmail.com",
            password="p",
            accountType="business"
        )

        account2 = models.Account(
            userName = "wooflover",
            email = "wooflover@gmail.com",
            password="p",
            accountType="regular"
        )

        account3 = models.Account(
            userName = "doggydaydreamer",
            email = "doggydaydreamer@gmail.com",
            password="p",
            accountType="regular"
        )

        account4 = models.Account(
            userName = "loyalpupfriend",
            email = "loyalpupfriend@gmail.com",
            password="p",
            accountType="regular"
        )

        account5 = models.Account(
            userName = "barkandplaytime",
            email = "barkandplaytime@gmail.com",
            password="p",
            accountType="business"
        )

        account6 = models.Account(
            userName = "furballfetcher",
            email = "furballfetcher@gmail.com",
            password="p",
            accountType="business"
        )

        account7 = models.Account(
            userName = "puppylovepal",
            email = "puppylovepal@gmail.com",
            password="p",
            accountType="regular"
        )

        account8 = models.Account(
            userName = "sarahsmith87",
            email = "sarahsmith87@gmail.com",
            password="p",
            accountType="business"
        )

        account9 = models.Account(
            userName = "davidjones22",
            email = "davidjones22@gmail.com",
            password="p",
            accountType="business"
        )

        account10 = models.Account(
            userName = "emilybrown56",
            email = "emilybrown56@gmail.com",
            password="p",
            accountType="regular"
        )

        account11 = models.Account(
            userName = "michaeljohnson39",
            email = "michaeljohnson39@gmail.com",
            password="p",
            accountType="regular"
        )
        
        businessNames = [
            "Paws and Play Pet Care",
            "Bark Avenue Boutique",
            "Whisker Wonders Veterinary Clinic",
            "Fetch n Fun Dog Park",
            "Fur-Ever Friends Pet Store",
            "Pawsitively Perfect Pet Grooming",
            "Tail Wagging Trails Dog Walking Service",
            "Snuggle Pups Doggy Daycare",
            "Meow Manor Cat Cafe",
            "Happy Tails Pet Training Academy",
            "Woofin Wags Doggy Spa",
            "Sunny Day Cleaning Services",
            "Golden Harvest Grocery",
            "Elite Fitness Club",
            "Natures Bounty Health Foods",
            "Fashion Forward Clothing Boutique",
            "Downtown Deli & Cafe",
        ]

        businessDescriptions = [
            "Offering top-notch pet care services including dog walking, pet sitting, and grooming. Your furry friends happiness is our priority!",
            "Treat your pup to luxury with our stylish collection of dog accessories, premium food, and grooming services. Your canine companion deserves the best!",
            "Providing compassionate and comprehensive veterinary care for your beloved pets. Our experienced team is dedicated to keeping your furry family members healthy and happy.",
            "Let your dog run free and socialize in our spacious off-leash dog park. With separate areas for small and large dogs, it is the ultimate playground for pups!",
            "Your one-stop shop for all your pets needs! From toys and treats to grooming supplies and health products, we have everything to keep your furry friend tail-waggingly happy.",
            "Transforming scruffy pups into pampered pooches! Our expert groomers provide gentle and professional grooming services to keep your pet looking and feeling their best.",
            "When you are busy, we are here to help! Our reliable dog walkers provide personalized walks tailored to your dogs needs, ensuring they get plenty of exercise and love.",
            "Give your dog a fun-filled day of play and socialization at our doggy daycare! With indoor and outdoor play areas, your pup will have a tail-waggin good time.",
            "Calling all cat lovers! Enjoy a purrfect cup of coffee while cuddling with our resident kitties. Our cat cafe is a cozy retreat for feline enthusiasts.",
            "Unlock your pets potential with our positive reinforcement training programs! From obedience training to behavioral modification, we help you build a strong bond with your furry companion.",
            "Indulge your pooch with a day of relaxation and pampering at our luxurious doggy spa! From soothing baths to rejuvenating massages, we provide the ultimate spa experience for dogs.",
            "Providing professional cleaning services for homes and businesses. Let us make your day brighter with our sparkling clean results!",
            "Your neighborhood grocery store offering a wide selection of fresh produce, meats, and pantry essentials. Quality and convenience at affordable prices.",
            "Get fit and stay healthy with our state-of-the-art fitness facilities and expert trainers. Join our community and achieve your fitness goals!",
            "Fuel your body with wholesome foods and supplements from our health food store. We are committed to helping you live your healthiest life.",
            "Stay ahead of the trends with our curated collection of stylish clothing and accessories. Elevate your wardrobe with our fashion-forward pieces.",
            "Serving up delicious sandwiches, salads, and coffee in a cozy atmosphere. Stop by for a tasty meal and friendly service!",
        ]

        
        BUSINESS_TYPES = ["Arts & Entertainment", "Active Life", "Hotels & Travel", "Local Flavor", "Restaurants", "Shopping", "Other"]
        businessTypes = [random.choice(BUSINESS_TYPES) for _ in range(11)]
        
        eventNames = [
            "Paws in the Park",
            "Tails & Trails",
            "Furry Fiesta",
            "Pet Parade Party",
            "Bark Bash Bonanza",
            "Whisker Wonderland",
            "Pawsitively Purrfect Picnic",
            "Tail Wagging Tailgate",
            "Fidos Fun Fair",
            "Puppy Playdate Picnic",
            "Meow Mixer Meetup"
        ]

        eventDescriptions = [
            "Join us for a fun-filled day out with your furry friends! Meet other pet lovers, enjoy games and activities, and win exciting prizes.",
            "Bring your pets and join the paw-ty! We  got treats, toys, and tail-wagging fun for everyone.",
            "Calling all pet owners! Spend quality time with your furry pals at our pet-friendly event. Its a purr-fect time you wont want to miss!",
            "Let your pets socialize and play in a safe and welcoming environment. With plenty of activities and treats, its guaranteed to be a paw-some day!",
            "Get ready for a paws-itively delightful event! Bring your pets and make new friends while enjoying games, contests, and giveaways.",
            "Looking for some animal-friendly fun? Join us for an exciting day out with your furry companions. Its bound to be a tail-wagging good time!",
            "Unleash the fun with your furry companions! From agility courses to treat stations, theres something for every pet at our pet-friendly event.",
            "Celebrate your love for pets at our pet-friendly gathering! Enjoy live music, delicious food, and a variety of animal-centric activities.",
            "Attention all pet lovers! Dont miss out on this tail-wagging event filled with furry friends, food trucks, and fabulous prizes.",
            "Get ready to wag and walk! Join us for a scenic pet walk followed by games, refreshments, and lots of animal love.",
            "Mark your calendars for a pet extravaganza! Bring your furry friends and enjoy a day filled with excitement, laughter, and plenty of wagging tails."
        ]

        # Generate random event dates from today till December
        start_date = datetime.now().date()
        end_date = datetime.now().replace(month=12, day=31).date()
        eventDates = [(start_date + timedelta(days=random.randint(0, (end_date - start_date).days))).strftime("%Y-%m-%d") for _ in range(11)]

        # Generate random phone numbers
        contacts = ["".join(random.choices(string.digits, k=10)) for _ in range(11)]
        
        geolocations = [
            "40.7207094,-73.650774",
            "40.70267005971583,-73.66853667686955",
            "40.7073672,-73.6772478",
            "40.7066986,-73.6608417",
            "40.7025823,-73.6786853",
            "40.7142026,-73.6682711",
            "40.7166513,-73.6612698",
            "40.7138693,-73.6611487",
            "40.7283358,-73.6602735",
            "40.7066045,-73.6680851"
        ]

        locations = [
                "1 South Ave, Garden City, NY  11530, United States",
                "Rintin St, Franklin Square, NY  11010, United States",
                "999 Hempstead Tpke, Franklin Square, NY 11010, United States",
                "580 Hempstead Tpke, West Hempstead, NY  11552, United States",
                "197 Franklin Ave, Franklin Square, NY  11010, United States",
                "230 Poppy Ave, Franklin Square, NY  11010, United States",
                "361 Nassau Blvd, Garden City, NY  11530, United States",
                "257 Nassau Blvd, Garden City, NY  11530, United States",
                "147 Nassau Blvd, Garden City, NY  11530, United States",
                "761 Hempstead Tpke, Franklin Square, NY  11010, United States"
            ]

        PetSizePrefs = ["small" , "small", "small", "medium", "medium", "large", "small", "large", "small", "medium", "large"]
        LeashPolicies = [True, True, False, False, False, True, False, True, True, True, False]
        DisabledFriendly = [True, False, True, False, True, True, False, True, True, True, False]

        total_comments = 33
        comments_per_business = total_comments // len(businessNames)

        reviewComments = []

        for name in businessNames:
            comments = [
                f"This {name} is amazing!",
                f"I love going to {name}! They always provide top-notch service.",
                f"Highly recommend {name} for all pet owners!",
                f"The staff at {name} are so friendly and knowledgeable.",
                f"Visited {name} last week and had a fantastic experience!",
                f"Great selection of products at {name}! Will definitely be back.",
                f"5 stars for {name}! My pets always come first here.",
                f"Had a great time at {name}! Cant wait to visit again.",
                f"{name} is my go-to spot for all things pet-related.",
                f"Best place in town for pet care! Thanks, {name}!",
                f"Always satisfied with the service at {name}. Highly recommend!",
                f"Stopped by {name} yesterday and left with a big smile!",
                f"{name} never disappoints! Such a great atmosphere.",
                f"Fantastic experience at {name}! The staff are always so helpful.",
                f"Thank you, {name}, for taking such good care of my furry friend!",
                f"Great prices and friendly staff at {name}. Will definitely return.",
                f"Ive been a loyal customer of {name} for years. Always satisfied!",
                f"Such a fun place to bring my pets! Thanks, {name}!",
                f"Had an awesome time at {name}! Highly recommend checking it out.",
                f"Couldnt be happier with the service at {name}.",
                f"Thanks to {name} for always going above and beyond!",
                f"Love the selection of products at {name}.",
                f"Ive heard great things about {name}, and they did not disappoint!",
                f"Always a pleasure visiting {name}! The staff are amazing.",
                f"Highly recommend {name} for all pet owners!",
                f"Had an amazing experience at {name}! Will definitely be back.",
                f"{name} is my go-to spot for pet supplies. Love it!",
                f"Thanks, {name}, for providing such excellent service.",
                f"Such a warm and welcoming atmosphere at {name}.",
                f"I always feel like family when I visit {name}.",
                f"Outstanding service at {name}! Will be recommending to all my friends.",
                f"Huge shoutout to {name} for their exceptional care and service!",
                f"Couldnt ask for a better experience at {name}.",
                f"Thank you, {name}, for being so pet-friendly and accommodating!"
            ]
            random.shuffle(comments)
            selected_comments = comments[:comments_per_business]
            reviewComments.extend(selected_comments)


        accounts_to_add_list = [account1, account2, account3, account4,
        account5, account6, account7, account8, account9, account10, account11]

        index = 0
        reviewCommentIndex = 0
        for i in accounts_to_add_list:
            accountID = self.sendAccount(accObj=i)
        
            if i.accountType == "business":
                business = models.Business(
                    businessName=businessNames[index],
                    businessType=businessTypes[index],
                    location=locations[index],
                    contact=contacts[index],
                    description=businessDescriptions[index],
                    ownerUserID=accountID,
                    geolocation=geolocations[index],
                    petSizePref=PetSizePrefs[index],
                    leashPolicy=LeashPolicies[index],
                    disabledFriendly=DisabledFriendly[index],
                    dataLocation="internal"
                )

                businessID = self.sendBusiness(businessObj=business)

                
                randAccountID = self.getInternalAccountNames()
                random.shuffle(randAccountID) 

                for i in range(3):
                    review = models.Review(
                        rating=random.randint(1, 5),
                        comment=reviewComments[reviewCommentIndex],
                        businessID=businessID,
                        currentuserID=randAccountID[i],
                        datalocation="internal"
                    )
                    reviewCommentIndex += 1
                    self.sendReview(reviewObj=review)

                for i in range(1):
                    event = models.Event(
                        businessID=businessID,
                        eventName=eventNames[index],
                        eventDescription=eventDescriptions[index],
                        eventDate=eventDates[index],
                        location=locations[index],
                        contactInfo=contacts[index],
                        geolocation=geolocations[index],
                        petSizePref=PetSizePrefs[index],
                        leashPolicy=LeashPolicies[index],
                        disabledFriendly=DisabledFriendly[index],
                        datalocation="internal"
                    )
                    self.sendEvent(eventObj=event)
            
            index += 1

