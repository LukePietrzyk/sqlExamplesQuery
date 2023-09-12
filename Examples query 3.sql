-- Sql queries /////////////////////////////////////////////////////////////////////////////////////////

SELECT 
    CONCAT(borrowers.first_name,
            ' ',
            borrowers.last_name) AS FullNameBorrower,
    CONCAT(authors.first_name,
            ' ',
            authors.last_name) AS AutorFullName,
    books.title,
    books.publisher,
    books.publication_year,
    if(loans.return_date is null, 'Brak oddania' ,'Tak') as 'Czy oddano książkę?'
FROM
    borrowers
        inner JOIN
    loans ON borrowers.borrower_id = loans.borrower_id
        INNER JOIN
    books ON books.book_id = loans.book_id
        INNER JOIN
    authors ON authors.author_id = books.book_id;
    
-- Sprawdzenie unikalnych nazwisk w tabeli library /////////////////////////////////////////////////////////////////

SELECT last_name FROM library.borrowers group by last_name having count(last_name) = 1;

-- Sortowanie po długości nazwiska autora /////////////////////////////////////////////////////////////////////////

SELECT last_name, length(last_name) AS ilosc_znaków_nazwisko FROM library.authors order by length(last_name)desc;

-- Znalezienie autorów, którzy napisali wiecej niż jedną książkę //////////////////////////////////////////////////
SELECT 
    Concat(authors.first_name, ' ',
    authors.last_name) as Author,
    COUNT(books.book_id) AS 'Ilość ksiązek'
FROM
    authors
        JOIN
    books ON books.author_id = authors.author_id
GROUP BY authors.author_id
Having count(books.book_id) > 1;

-- Sortowanie książek po liczbie wypożyczeń ////////////////////////////////////////////////////////////////////////
SELECT 
    books.title as Tytuł,
    CONCAT(authors.last_name,
            ' ',
            authors.first_name) AS Autor,
            count(*) as Liczba
FROM
    authors
        INNER JOIN
    books ON authors.author_id = books.author_id
        INNER JOIN
    loans ON books.book_id = loans.book_id
    group by books.book_id
    order by liczba desc;
    
-- Sprawdzenie liczby wypożyczeń //////////////////////////////////////////////////////////////////////////////////

SELECT 
    CONCAT(borrowers.first_name,
            ' ',
            borrowers.last_name) AS 'Imie i nazwisko',
    COUNT(*) as 'Liczba wypożyczeń'
FROM
    authors
        INNER JOIN
    books ON authors.author_id = books.author_id
        INNER JOIN
    loans ON books.book_id = loans.book_id
        INNER JOIN
    borrowers ON borrowers.borrower_id = loans.borrower_id
GROUP BY borrowers.borrower_id
Order by COUNT(*) desc;    

-- Sprawdzenie, które ksiązki zostały wypożyczone w danym przedziale czasu  /////////////////////////////////////
SELECT 
    books.book_id,
    books.title,
    CONCAT(authors.last_name,
            ' ',
            authors.first_name) AS Autor
FROM
    books
      inner join authors on authors.author_id = books.author_id
where books.book_id in (select loans.book_id from loans where loans.loan_date between '2020-01-01' and '2021-03-20');

-- Sprawdzenie czy ksiązka była kiedykolwiek wypożyczona (tak/nie)          /////////////////////////////////////

SELECT 
   books.book_id,
   books.title,
    case
		when loans.loan_id is null then "Nie"
        else "Tak"
        end as 'Czy była wypożyczona?'
FROM
    books
        LEFT JOIN
    loans ON loans.book_id = books.book_id;

-- Update wraz z zapytaniem zagnieżdżonym w celu zmiany daty wydania 
UPDATE books 
SET 
    books.publication_year = 2000
WHERE
    books.author_id IN (SELECT 
            authors.author_id
        FROM
            authors
        WHERE
            authors.first_name = 'J.K.'
                AND authors.last_name = 'Rowling');
                
                
-- # Zamiana wielkosci liter w imieniu i nazwisku -- (lukasZ pietrzyK)
SELECT 
    CONCAT(SUBSTR(LOWER(klienci.imie_klienta),
                1,
                LENGTH(klienci.imie_klienta) - 1),
            UPPER(SUBSTR(klienci.imie_klienta, - 1)),
            ' ',
           SUBSTR(LOWER(klienci.nazwisko_klienta),
                1,
                LENGTH(klienci.nazwisko_klienta) - 1),
            UPPER(SUBSTR(klienci.nazwisko_klienta, - 1))) AS fullName
FROM
    klienci;
    
-- Zamiana końcówki emailu z com na pl oraz z pl na com -- Uzycie pętli warunkowej

SELECT 
    klienci.email_klienta,
    IF(klienci.email_klienta LIKE '%@gmail.com%',
        REPLACE(klienci.email_klienta,
            '.com',
            '.pl'),
        IF(klienci.email_klienta LIKE '%@wp.pl%',
            REPLACE(klienci.email_klienta,
                '.pl',
                '.com'),
            klienci.email_klienta)) as Zmieniony
FROM
    klienci;  