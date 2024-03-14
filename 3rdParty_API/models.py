"""
This package will hold our dataclasses basically structs used to 
shape data in an ordered way
"""

from dataclasses import dataclass

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