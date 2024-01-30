--GENERIC SELECT
SELECT userID, username, email, accountType, imgID FROM user

SELECT * FROM businesses

SELECT * FROM savedBusinesses WHERE userID = ?

SELECT * FROM events

SELECT * FROM reviews

SELECT * FROM images WHERE imgID = ? AND type = '?'

SELECT COUNT(userID) FROM attendance WHERE eventID = ?

--JOINED TABLES

--USER SAVED BUSINESSES IN FULL DETAIL
SELECT  u.userID, u.username, u.email, u.accountType, u.imgID, 
        sb.businessID, b.businessName, b.businessType, b.location,
        b.ownerUserID, b.contact, b.description, b.rating, b.imgID,
        b.petSizePref, b.leashPolicy, b.disabledFriendly, b.dataLocation
FROM user u
JOIN savedBusinesses sb ON u.userID = sb.userID
JOIN businesses b ON sb.businessID = b.businessID
WHERE u.userID = ?


--EVENTS FOR BUSINESS IN FULL CONTEXT
SELECT  e.eventID, e.eventName, e.eventDescription, e.eventDate,
        e.location, e.contactInfo, e.imgID, e.petSizePref, e.leashPolicy, e.disabledFriendly,
        (SELECT COUNT(userID) FROM attendance WHERE eventID = e.eventID) as attendence_count,
        b.businessID, b.businessName, b.businessType, 
        b.location, b.contact, b.description, b.rating, b.OwnerUserID,
        b.imgID, b.petSizePref, b.leashPolicy, b.disabledFriendly 
FROM events e
JOIN businesses b ON e.businessID = b.businessID
WHERE b.businessID = ?

--REVIEWS FOR BUSINESS AND THE USER WHO MADE THE REVIEW
SELECT  r.reviewID, r.rating, r.comment, r.dateCreated, r.imgID,
        u.userID, u.username, u.email, u.accountType, u.imgID,
        b.businessID, b.businessName, b.businessType, 
        b.location, b.contact, b.rating AS businessRating, b.description, b.OwnerUserID,
        b.imgID, b.petSizePref, b.leashPolicy, b.disabledFriendly
FROM reviews r 
JOIN businesses b ON r.businessID = b.businessID 
JOIN user u ON r.userID = u.userID
WHERE b.businessID = ?
