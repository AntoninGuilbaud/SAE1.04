/* Relation PORT dérivée de l'entité PORT du SEA -App. R0 */
CREATE TABLE PORT (
  PortId char(1) primary key CHECK (PortId IN ('C','Q','S')),
  PortName varchar NOT NULL,
  Country varchar NOT NULL
);
/*
Relation PASSENGER dérivée de l'entité PASSENGER du SEA - App. R0
complétée par :
  - l'identifiant de l'entité CLASS (non conservée) - App. R1
  - l'identifiant de l'entité PORT (conservée) - App. R1
*/
CREATE TABLE PASSENGER (
  PassengerId int primary key,
  Name varchar NOT NULL,
  Sex varchar NOT NULL CHECK (Sex IN ('male','female')),
  Age int CHECK(Age >= 0),
  Survived int NOT NULL CHECK (Survived IN (0,1)),
  PClass int NOT NULL CHECK (PClass BETWEEN 1 and 3),
  PortId char(1) references PORT(PortId)
);
/* Relation OCCUPATION dérivée de l'assoication Occupation - App. R3 */
CREATE TABLE OCCUPATION (
  PassengerId int References PASSENGER(PassengerId),
  CabinCode varchar,
  Primary key (PassengerId, CabinCode)
);
/* Relation SERVICE dérivée de l'association service - App. R2 */
CREATE TABLE SERVICE (
  PassengerId_Dom int primary key references PASSENGER(PassengerId),
  PassengerId_Emp int NOT NULL,
  foreign key (PassengerId_Emp) references PASSENGER(PassengerId),
  Role varchar NOT NULL,
  CHECK (PassengerId_Dom != PassengerID_Emp)
);
/* REALTION CATEGORY dérivée de l'entité CATEGORY du SEA - App. R0 */
CREATE TABLE CATEGORY (
  LifeBoatCat varchar primary key CHECK (LifeBoatCat IN ('standard','secours','radeau')),
  Structure varchar NOT NULL CHECK (Structure IN ('bois', 'bois et toile')),
  Places int NOT NULL CHECK (Places > 0)
);
/*
Relation LIFEBOAT dérivée de l'entite LIFEBOAT du SEA - APP. R0
complétée par :
  - l'identifiant de l'entité CATEGORY (conservée) - App. R1
  - L'identifiant de l'entité TIME (non consevée) - App. R1
*/
CREATE TABLE LIFEBOAT (
  LifeBoatId varchar primary key,
  LifeBoatCat varchar NOT NULL references CATEGORY(LifeBoatCat),
  Side varchar NOT NULL CHECK (Side IN ('babord','tribord')),
  Position varchar NOT NULL CHECK (Position IN ('avant','arriere')),
  Location varchar NOT NULL DEFAULT 'Pont', -- pour dire
  Launching_Time Time NOT NULL
);
/*
Relation RECOVERY dérivée de l'assocation recovery (non conservée) - App. R2
*/
CREATE TABLE RECOVERY (
  LifeBoatId varchar references LIFEBOAT(LifeBoatId) primary key,
  Recovery_time time NOT NULL
);
/* Relation RESCUE dériveé de lassociation rescue - App. R2 */
CREATE TABLE RESCUE (
  PassengerID int references PASSENGER(PassengerId) primary key,
  LifeBoatId varchar NOT NULL references LIFEBOAT(LifeboatId)
);
