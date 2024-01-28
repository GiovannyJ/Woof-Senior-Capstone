--create Database
  create database woof;

--use database 
  use woof;

create table images(
  id            int auto_increment,
  size          int null,
  imgData       varchar(1000) null,
  imgName       varchar(200) not null,
  imgType ENUM('user', 'business', 'review', 'event') NOT NULL
  dateCreated   DATETIME DEFAULT(CURRENT_DATE()) NOT NULL,
  contraint images_pk primary key(id)
  );


--create table user
  create table user(
    userID int auto_increment,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    accountType varchar(30) not null,
    imgID int null,     
    constraint user_pk primary key(userID),
    constraint img_fk foreign key(imgID) references images(id)
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
    dataLocation ENUM('foreign','internal') NOT NULL,
    imgID int null,
    petSizePref ENUM('small','medium','large') NOT NULL,
    leashPolicy BOOLEAN NOT NULL,
    disabledFriendly BOOLEAN NOT NULL,
    constraint business_pk primary key(businessID),
    constraint business_fk foreign key(OwnerUserID) references user(userID),
    constraint img_fk foreign key(imgID) references images(id)
);

--create table reviews
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
    constraint img_fk foreign key(imgID) references images(id)
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
    dataLocation ENUM('foreign','internal') NOT NULL,
    imgID int null,
    petSizePref ENUM('small','medium','large') NOT NULL,
    leashPolicy BOOLEAN NOT NULL,
    disabledFriendly BOOLEAN NOT NULL,
    attendance_count int DEFUALT (0) NOT NULL,
    constraint events_pk primary key(eventID),
    constraint events_fk foreign key(businessID) references businesses(businessID),
    constraint img_fk foreign key(imgID) references images(id)
);

CREATE TABLE attendence(
  id int auto_increment,
  userID int not null,
  eventID int not null,
  constraint attendance_pk primary key (id),
  constraint userID_fk foreign key (userID) references user(userID),
  constraint eventID_fk foreign key (eventID) references events(eventID)
)


CREATE TABLE `ADMIN` (
  `id` 		int 			NOT NULL AUTO_INCREMENT,
  `name` 	varchar(100) 	NOT NULL,
  `token` 	varchar(500) 	NOT NULL,
  PRIMARY KEY (`id`)
)