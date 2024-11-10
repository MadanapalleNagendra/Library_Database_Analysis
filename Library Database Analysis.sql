--  Library Database Analysis

create database  Library_Database_Analysis;

use Library_Database_Analysis;


-- tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(100) PRIMARY KEY,  
    publisher_PublisherAddress VARCHAR(255) NOT NULL,
    publisher_PublisherPhone VARCHAR(255)
);
select * from tbl_publisher;
   
-- tbl_book
CREATE TABLE tbl_book(
    book_BookID INT AUTO_INCREMENT PRIMARY KEY,
    book_Title VARCHAR(255) NOT NULL,
    book_PublisherName VARCHAR(50),  
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

select * from tbl_book;


-- tbl_book_authors
CREATE TABLE tbl_book_authors(book_authors_AuthorID SMALLINT AUTO_INCREMENT PRIMARY KEY,
                              book_authors_BookID INT NOT NULL ,
	                          book_authors_AuthorName VARCHAR(100) NOT NULL,
							  FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE
);

select * from  tbl_book_authors;



--  tbl_borrower
CREATE TABLE tbl_borrower (borrower_CardNo  INT AUTO_INCREMENT PRIMARY KEY,
						   borrower_BorrowerName VARCHAR(100) NOT NULL,
                           borrower_BorrowerAddress	VARCHAR(255),
                           borrower_BorrowerPhone VARCHAR(20)

);

select * from tbl_borrower;


-- tbl_library_branch
CREATE TABLE tbl_library_branch (library_branch_BranchID TINYINT AUTO_INCREMENT PRIMARY KEY,
                                 library_branch_BranchName VARCHAR(100) NOT NULL,
                                 library_branch_BranchAddress VARCHAR(255)

);


select * from tbl_library_branch ;
-- TBL_BOOK_LOANS

CREATE TABLE tbl_book_loans(
    book_loans_LoansID INT AUTO_INCREMENT PRIMARY KEY,
    book_loans_BookID INT NOT NULL,
    book_loans_BranchID TINYINT NOT NULL, 
    book_loans_CardNo  INT NOT NULL,
    book_loans_DateOut VARCHAR(255),
    book_loans_DueDate VARCHAR(255),
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID ) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) ON DELETE CASCADE ON UPDATE CASCADE
);


select * from tbl_book_loans;


select * from tbl_book_loans;





--  tbl_book_copies
CREATE TABLE tbl_book_copies (book_copies_CopiesID INT AUTO_INCREMENT PRIMARY KEY, 
                             book_copies_BookID	INT NOT NULL,
                             book_copies_BranchID	TINYINT NOT NULL,
                             book_copies_No_Of_Copies INT NOT NULL,
                             FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID) ON DELETE CASCADE ON UPDATE CASCADE,
                             FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID) ON DELETE CASCADE ON UPDATE CASCADE
                             
);



select * from tbl_book_copies;





                                                   -- Task Questions
                                                   
                                                   
-- 1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?



SELECT tbl_book.book_Title, tbl_book_copies.book_copies_No_Of_Copies,tbl_library_branch.library_branch_BranchName
FROM tbl_book
INNER JOIN tbl_book_copies
ON tbl_book.book_BookID = tbl_book_copies.book_copies_BookID
INNER JOIN tbl_library_branch
ON tbl_book_copies.book_copies_BranchID=tbl_library_branch.library_branch_BranchID
WHERE book_Title="The Lost Tribe" and library_branch_BranchName="Sharpstown"
;




-- 2  How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT tbl_book.book_Title,  tbl_book_copies.book_copies_No_Of_Copies,tbl_library_branch.library_branch_BranchName
FROM tbl_book
INNER JOIN tbl_book_copies
ON tbl_book.book_BookID = tbl_book_copies.book_copies_BookID
INNER JOIN tbl_library_branch
ON tbl_book_copies.book_copies_BranchID=tbl_library_branch.library_branch_BranchID
WHERE book_Title="The Lost Tribe";






-- 3 Retrieve the names of all borrowers who do not have any books checked out

SELECT tbl_borrower.borrower_BorrowerName
FROM tbl_borrower
LEFT JOIN tbl_book_loans
    ON tbl_borrower.borrower_CardNo = tbl_book_loans.book_loans_CardNo
	WHERE tbl_book_loans.book_loans_CardNo IS  NULL;



-- 4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.

SELECT tbl_book_loans.book_loans_LoansID,tbl_library_branch.library_branch_BranchName,tbl_book_loans.book_loans_DueDate,tbl_borrower.borrower_borrowerName,tbl_borrower.borrower_borrowerAddress
FROM tbl_book_loans
LEFT JOIN tbl_library_branch 
    ON tbl_book_loans.book_loans_BranchID = tbl_library_branch.library_branch_BranchID
    RIGHT JOIN tbl_borrower
    ON tbl_book_loans.book_loans_CardNo= tbl_borrower.borrower_CardNo
	WHERE tbl_library_branch.library_branch_BranchName ="Sharpstown" AND tbl_book_loans.book_loans_DueDate="2/3/18" ;
    

 
-- 5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.



SELECT  tbl_library_branch.library_branch_BranchName,COUNT(tbl_book_loans.book_loans_branchID) as total
FROM  tbl_library_branch
RIGHT JOIN tbl_book_loans
on tbl_library_branch.library_branch_BranchID=tbl_book_loans.book_loans_branchID
GROUP BY tbl_library_branch.library_branch_BranchName
;


-- 6  Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

SELECT  tbl_borrower.borrower_borrowerName,tbl_borrower.borrower_borrowerAddress ,COUNT(tbl_book_loans.book_loans_BookID) AS more_than_five_books
FROM tbl_borrower
LEFT JOIN tbl_book_loans
    ON tbl_borrower.borrower_CardNo = tbl_book_loans.book_loans_CardNo
    GROUP BY tbl_borrower.borrower_borrowerName,tbl_borrower.borrower_borrowerAddress
	HAVING more_than_five_books > 5;


-- 7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select book_authors_AuthorName ,tbl_book.book_Title,tbl_book_copies.book_copies_No_Of_Copies,tbl_library_branch.library_branch_BranchName
from tbl_book_authors
INNER join tbl_book
on tbl_book_authors.book_authors_BookID=tbl_book.book_BookID
LEFT join tbl_book_copies
on tbl_book.book_BookID=tbl_book_copies.book_copies_BookID
INNER JOIN tbl_library_branch
on tbl_book_copies.book_copies_BranchID=tbl_library_branch.library_branch_BranchID
WHERE tbl_book_authors.book_authors_AuthorName = "Stephen King" AND tbl_library_branch.library_branch_BranchName = "Central" ;
