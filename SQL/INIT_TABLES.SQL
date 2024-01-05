--create Database
  create database woof;

--use database 
  use woof;

--create table user
  create table user(
    userID int auto_increment,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    accountType varchar(30) not null,     
    constraint user_pk primary key(userID)
  );

--create table businesses
  create table businesses(
    businessID int auto_increment,
    businessName varchar(200) not null,
    OwnerUserID int null,
    businessType varchar(100) not null, 
    location varchar(255) null, 
    contact varchar(255) null,
    description varchar(400) null,
    events varchar(255) null, 
    rating int null,
    constraint business_pk primary key(businessID),
    constraint business_fk foreign key(OwnerUserID) references user(userID)
);

--create table reviews
CREATE TABLE reviews (
    reviewID INT AUTO_INCREMENT,
    userID INT NOT NULL,
    businessID INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(300) NULL,
    dateCreated DATE DEFAULT (CURRENT_DATE()) NOT NULL,
    CONSTRAINT reviews_pk PRIMARY KEY (reviewID),
    CONSTRAINT reviews_fk_user FOREIGN KEY (userID) REFERENCES user(userID),
    CONSTRAINT reviews_fk_business FOREIGN KEY (businessID) REFERENCES businesses(businessID)
);

--create table for saved businesses
  create table savedBusinesses(
    saveID int auto_increment,
    userID int not null,
    businessID int not null,
    constraint savedBusinesses_pk primary key(saveID),
    constraint savedBusinesses_fk foreign key(userID) references user(userID),
    constraint savedBusinesses_fk foreign key(businessID) references businesses(businessID)
  );

--create table for events
  create table events(
    eventID int auto_increment,
    businessID int not null,
    eventName varchar(100) not null,
    eventDescription varchar(400) null,
    eventDate date not null,
    location varchar(300) not null,
    contactInfo varchar(300) not null,
    constraint events_pk primary key(eventID),
    constraint events_fk foreign key(businessID) references businesses(businessID)
);



