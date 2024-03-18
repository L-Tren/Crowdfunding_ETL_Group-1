select * from campaign;
select * from category;
select * from contacts;
select * from subcategory;

-- drop view sample_view;

create view sample_view as
	select con.first_name, con.last_name, cam.company_name, cat.category, subcat.subcategory
	from contacts as con
		join campaign as cam
			on cam.contact_id = con.contact_id
		join category as cat
			on cat.category_id = cam.category_id
		join subcategory as subcat
			on subcat.subcategory_id = cam.subcategory_id;

select * from sample_view;