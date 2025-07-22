create table books(
			Book_id	serial primary key,
			title varchar(100),
			author	varchar(100),
			publisher varchar(100),
			year_published	int,
			quantity_available int


);
drop table book;
select * from books;
create table members(
			member_id serial primary key,
			name varchar(100),
			email varchar(100),
			phone varchar(15),
			join_date DATE


);
select * from members;
create table transactions(
			transaction_id serial primary key,
			member_id int,
			Book_id int,
			borrow_date DATE,
			return_date DATE,
			foreign key (member_id) references members(member_id),
			foreign key (Book_id) references books(Book_id)

);
select * from transactions;
-- queries
-- show all books
select * from books;
-- show all members;
select * from members;
-- show all transactions;
select * from transactions;
-- find books with quantity less than 3;
select * from books where quantity_available <3;
-- list all members who joined after jan 2024
select * from members where join_date > '01-01-2023';
--show books borrowed by a specific member;
select t.transaction_id,b.title from transactions t join books b 
on t.Book_id = b.Book_id where t.transaction_id = 10;
--list all currently borrowed books (not returned)
select t.transaction_id, m.name,b.title,t.borrow_date from transactions t
join members m on t.member_id = m.member_id 
join books b on t.Book_id = b.Book_id
where T.return_date IS NULL;

-- total number of books boorowed by each member
select m.name , count(t.transaction_id) as total_borrowed 
from members m
join transactions t 
on t.member_id = m.member_id
group by m.name
order by total_borrowed desc;

-- most borrowed books (top 5)
select b.title , count(t.transaction_id) as times_borrowed 
from books b
join transactions t 
on t.Book_id = b.Book_id
group by b.title
order by times_borrowed desc
limit 5;

-- books that were never borrowed
select title from books where Book_id not in(select Book_id from transactions);

-- members who have never borrowed a book
select name from members where member_id not in (select member_id from transactions);

-- average borrow duration (for returned book)
select avg(return_date-borrow_date) as average_days from transactions where return_date is NOT NULL;

-- total active borrowings (not yet returned)
select count(*) as active_boorowings from transactions where return_date is NULL;
-- books borrowed in the last 30 days;
select b.title,m.name,t.borrow_date
from transactions t join books b on t.Book_id = b.Book_id
join members m on t.member_id = m.member_id
where T.borrow_date>= current_date - Interval '30 days';

