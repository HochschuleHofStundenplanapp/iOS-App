create database apns_user
	use apes_user
	create table apns_user(
		id int NOT NULL AUTO_INCREMENT,
		token varchar(255),
		lecture_id varchar(255) NOT NULL,
		PRIMARY KEY (id)
	);}