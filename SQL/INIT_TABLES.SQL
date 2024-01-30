--create Database
  create database woof;

--use database 
  use woof;

CREATE TABLE images (
  id            INT AUTO_INCREMENT,
  size          INT NULL,
  imgData       VARCHAR(1000) NULL,
  imgName       VARCHAR(200) NOT NULL,
  imgType       ENUM('user', 'business', 'review', 'event') NOT NULL,
  dateCreated   DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT images_pk PRIMARY KEY (id)
);
 
 create table user(
    userID int auto_increment,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    accountType varchar(30) not null,
    imgID int null,     
    constraint user_pk primary key(userID),
    constraint user_fk_img foreign key(imgID) references images(id)
  );

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
    dataLocation ENUM('foreign','internal') NOT NULL,
    imgID int null,
    petSizePref ENUM('small','medium','large') NOT NULL,
    leashPolicy BOOLEAN NOT NULL,
    disabledFriendly BOOLEAN NOT NULL,
    constraint business_pk primary key(businessID),
    constraint business_fk foreign key(OwnerUserID) references user(userID),
    constraint business_fk_img foreign key(imgID) references images(id)
);

CREATE TABLE reviews (
    reviewID INT AUTO_INCREMENT,
    userID INT NOT NULL,
    businessID INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(300) NULL,
    dateCreated DATE DEFAULT (CURRENT_DATE()) NOT NULL,
    dataLocation ENUM('foreign','internal') NOT NULL,
    imgID int null,
    CONSTRAINT reviews_pk PRIMARY KEY (reviewID),
    CONSTRAINT reviews_fk_user FOREIGN KEY (userID) REFERENCES user(userID),
    CONSTRAINT reviews_fk_business FOREIGN KEY (businessID) REFERENCES businesses(businessID),
    constraint review_fk_img foreign key(imgID) references images(id)
);

create table savedBusinesses(
    saveID int auto_increment,
    userID int not null,
    businessID int not null,
    constraint savedBusinesses_pk primary key(saveID),
    constraint savedBusinesses_fk_user foreign key(userID) references user(userID),
    constraint savedBusinesses_fk_business foreign key(businessID) references businesses(businessID)
  );

CREATE TABLE events (
    eventID int AUTO_INCREMENT,
    businessID int NOT NULL,
    eventName varchar(100) NOT NULL,
    eventDescription varchar(400) NULL,
    eventDate date NOT NULL,
    location varchar(300) NOT NULL,
    contactInfo varchar(300) NOT NULL,
    dataLocation ENUM('foreign', 'internal') NOT NULL,
    imgID int NULL,
    petSizePref ENUM('small', 'medium', 'large') NOT NULL,
    leashPolicy BOOLEAN NOT NULL,
    disabledFriendly BOOLEAN NOT NULL,
    attendance_count int DEFAULT 0 NOT NULL,
    CONSTRAINT events_pk PRIMARY KEY (eventID),
    CONSTRAINT events_fk FOREIGN KEY (businessID) REFERENCES businesses (businessID),
    CONSTRAINT events_fk_img FOREIGN KEY (imgID) REFERENCES images (id)
);


CREATE TABLE attendance(
  id int auto_increment,
  userID int not null,
  eventID int not null,
  constraint attendance_pk primary key (id),
  constraint attendence_fk_user foreign key (userID) references user(userID),
  constraint attendence_fk_event foreign key (eventID) references events(eventID)
);


CREATE TABLE `ADMIN` (
  `id` 		int 			NOT NULL AUTO_INCREMENT,
  `name` 	varchar(100) 	NOT NULL,
  `token` 	varchar(500) 	NOT NULL,
  PRIMARY KEY (`id`)
)