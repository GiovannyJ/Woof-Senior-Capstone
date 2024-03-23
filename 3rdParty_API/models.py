"""
This package will hold our dataclasses basically structs used to 
shape data in an ordered way
"""

from dataclasses import dataclass

@dataclass
class Business:
    businessName: str
    businessType: str
    location: str
    contact: str
    description: str
    petSizePref: str
    leashPolicy: bool
    disabledFriendly: bool
    geolocation: str
    ownerUserID: int = 2
    dataLocation: str = "foreign"
    imgID: int = 0


@dataclass
class Account:
    userName: str
    email: str
    password: str = "p"
    accountType: str = "business"

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
    datalocation: str = "foreign" #Default to foreign
    imgID: int = 0

@dataclass
class review():
    currentuserID: int #default to 0
    rating: int
    comment: str
    datalocation: str = "foreign"#Default to foreign
    imgID: int = 0 #Default to 0