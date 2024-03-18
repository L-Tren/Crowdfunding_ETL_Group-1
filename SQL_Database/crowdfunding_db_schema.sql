-- DROP TABLE campaign;
-- DROP TABLE category;
-- DROP TABLE subcategory;
-- DROP TABLE contacts;


create table category(
	category_id	varchar(255) primary key,
	category varchar(255) NOT NULL
);

create table subcategory(
	subcategory_id varchar(255) primary key,
	subcategory varchar(255) NOT NULL
);

create table contacts(
	contact_id int primary key,
	first_name varchar(255) NOT NULL,
	last_name varchar(255) NOT NULL,
	email varchar(255) NOT NULL
);


create table campaign(
	cf_id int primary key,
	contact_id int,
	foreign key (contact_id) references contacts(contact_id),
	company_name varchar(255) NOT NULL,
	description varchar(255) NOT NULL,
	goal float(10) NOT NULL,
	pledged float(10) NOT NULL,
	outcome varchar(255) NOT NULL,
	backers_count int NOT NULL,
	country varchar(255) NOT NULL,
	currency varchar(255) NOT NULL,
	launched_date date NOT NULL,
	end_date date NOT NULL,
	category_id	varchar(255),
	foreign key (category_id) references category(category_id),
	subcategory_id varchar(255),
	foreign key (subcategory_id) references subcategory(subcategory_id)
);