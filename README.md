## Week 07 SQL HW

What is autoincrementing?

Auto-increment is a field in a relational database table. It holds a number associated with each record. This can be (but is not necessarily) the primary key. Every time a new record is inserted into a database table, that record is labeled with a unique number id. The autoincrementing feature has a default starting value of 1, and a default increment unit of 1. The keyword is dialect-dependent; for MySQL it is AUTO_INCREMENT. Autoincrementation allows for the consistent labeling of records with unique numerical identifiers. Consequently, query speed is increased. Unique IDs also facilitate data-independence, thus improving reliability of queries.

What is the difference between a join and a subquery?

In both joins and subqueries, data are combined from different tables into a single result. 

A subquery, by definition, is a nested query with a main outer query. As such, it is a stand-alone piece of code – you could paste it into a query window and run it. Subqueries can be simple (no reliance on columns of outer query) or correlated (refers to data from outer query). Subqueries can return a single value (scalar) or row(s).

In a join, rows from two or more tables are combined based on a match condition. Joins return row sets and this result is available for further use by the select statement. Thus, joins cannot be extracted from select statements. Joins are more efficient and readable that subqueries. For this reason, it can be worth rewriting subqueries as joins where possible.

<img width="586" alt="Screen Shot 2021-11-17 at 9 16 20 AM" src="https://user-images.githubusercontent.com/79848763/142231388-9974ade8-b2be-48c3-8b27-a89eafee0181.png">
