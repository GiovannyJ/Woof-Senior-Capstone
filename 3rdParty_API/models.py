"""
This package will hold our dataclasses basically structs used to 
shape data in an ordered way
"""

from dataclasses import dataclass, field
from datetime import datetime

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
    imgID: int
    ownerUserID: int = 2
    dataLocation: str = "foreign"


@dataclass
class Account:
    userName: str
    email: str
    password: str = "p"
    accountType: str = "foreign business"

@dataclass
class Event():
    businessID: int
    eventName: str
    eventDescription: str
    eventDate: str
    location: str
    contactInfo: str
    petSizePref: str #CAN ONLY BE small, medium, large (maybe update to include any -> backend)
    leashPolicy: bool 
    disabledFriendly: bool 
    geolocation: str
    datalocation: str = "foreign" #Default to foreign
    imgID: int = 0

@dataclass
class Review():
    rating: int
    comment: str
    businessID: int
    currentuserID: int = 0 #default to 0
    datalocation: str = "foreign"#Default to foreign
    imgID: int = 0 #Default to 0

@dataclass
class ImageInfo():
    imgName: str
    size: int = 0
    imgData: str = " "
    imgType: str = "business" 
    dateCreated: str = field(default_factory=lambda: datetime.now().strftime('%Y-%m-%d %H:%M:%S'))