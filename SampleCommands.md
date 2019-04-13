GET * FROM Employee WHERE ename = "Rutuja Betgeri";
GET * FROM Employee WHERE ename = "Rutuja Betgeri" AND eage > 21;
GET indexNumber, ename FROM Employee WHERE ename = "Broot Fos";
GET * FROM Employee WHERE salary > 200 AND eage > 21

INSERT RECORD "Bran Sand",52,"Ohio",100 INTO Employee;
DELETE RECORD FROM Employee WHERE ename = "Rutuja Betgeri";
UPDATE RECORD IN Employee SET eage TO 200 WHERE ename = "Shreya Gupta";
UPDATE RECORD IN Department SET dnum TO 200 WHERE dname = "EEE";