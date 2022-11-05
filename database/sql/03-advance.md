# Advanced SQL

## Transaction
- A transaction is a collection of queries that are treated as one unit of work.
- A transaction starts with `BEGIN` and finishes with `COMMIT`.
- `ROLLBACK` is undoing the transaction process.
- Usually transactions are used to change and modify data. However, there are read only transactions as well.
- Example of read only transaction: generating a report and getting a consistent snapshot based at the time of transaction.
- Note: If you care about the time of transaction, then it needs to be isolated if there are concurrent transactions in effect.
- Example of a transaction: bank account fund transfer
  1. Begin
  2. Check available funds of the sender
  3. Take money from first account to move it to the second account
  4. Commit

### ACID Transaction
A transaction that has four properties:
1. Atomicity
2. Consistency
3. Isolation
4. Durability

#### Atomicity
- It was a belief that an atom is the smallest unit of matter
- Atomicity is when a transaction as a unit of logical process contains the following behaviours:
  1. All queries in a transaction must succeed
  2. If one query fails next queries should not run and all prior queries must roll back.
  3. If a database goes down prior to commit of a transaction, all the successful queries in the transactions should roll back.
- An atom should be considered as a unit which cannot be split.

#### Isolation
- Can an inflight transaction see changes made by other transactions?
  - It technically can unless we isolate the transaction.
- Read phenomenas:
    1. Dirty reads: reading something that another transaction has written but didn't really commit it yet. It may get committed but we don't know.
    2. Non-repeatable reads: when a query reads a value and another query in the same transaction reads the same value when it's changed and committed by another transaction.
    3. Phantom reads: when two queries of a single transaction runs aggregate functions on multiple rows and read different values because one or more rows are added or removed between the two queries by another transaction.
    4. Lost updates: trying to read a written value in the same transaction but the value is altered by another transaction. 
- Isolation levels for inflight transactions:
    1. Read uncommitted: No isolation, any change fromm the outside is visible to the transaction, committed or not. Any read phenomena may happen.
    2. Read committed: Each query in a transaction only sees committer changes by other transactions. Default isolation level for most databases. Most popular level. Dirty read is prevented.
    3. Repeatable read: The transaction that when a query reads a row, that row will remain unchanged while the transaction is running.  
       Dirty read, lost updates, and non-repeatable reads are prevented. It does not create a snapshot of all database. It cannot solve the phantom read problem.
    4. Snapshot: each query in a transaction only sees changes that have been committed up to the start of the transaction.  
       It is a solution to all read problems. It is like a snapshot of the database at the beginning of the transaction.
    5. Serializable: synchronize transactions. It is a solution to all read problems.
- How database systems implement isolation?
- Each DBMS implements isolation level differently
    1. Pessimistic: row level locks, table locks, page locks to avoid lost updates. Not preferred, because locking is expensive.
    2. Optimistic: No locks, just track if things have changed and fail the transaction if so.
    3. Repeatable read: locks the rows it reads, but it can be expensive if transaction reads a lot of rows. It is not a solution to phantom read.
       Postgres implements RR as snapshot. That is why you don't get phantom reads with postgres in repeatable read.
    4. Serializable. True serializable is very slow. It is usually implemented with optimistic concurrency control.  
       It can also be implemented pessimistically (lock resources) with select for update.
- In Postgres, repeatable read isolation level gets rid of Phantom read as well. In other databases, serializable is the level to avoid Phantom read.

#### Consistency
- Consistency in data. The one resource for data. The true state of data.
- Consistency in reads. Both relational and NoSQL suffer from it. Eventual consistency will happen.

- Consistency in data:
  1. Defined by the user
  2. Referential integrity (foreign keys)
  3. Atomicity
  4. Isolation

- Consistency in reads:
  - If a transaction commits a change, will a new transaction immediately see the change?
  - Affects the system as a whole. When there are replicas such as multiple worker databases. While the primary database is updating and syncing replicas, old values might be selected from replicas.
  - Both relational and NoSQL databases suffer from it when we want to scale horizontally or introduce caching
  - Eventual consistency

#### Durability

- If a transaction is committed, no shutdown and crash can corrupt data.
- Changes made by committed transactions must be persisted in a durable non-volatile storage.
- Disk storage is more durable than memory, but it's slower.
- Some DBMS might write to memory at first and the occasionally updates the disk.
- Durability techniques:
    1. WAL: write ahead log. Write in WAL to recover data in memory that was not written to disk in case of crashing. Only logs changes.
       Writing a lot of data to disk is expensive. DBMSs persist a compressed version of changes as WAL (write-ahead-log segments)
    2. Asynchronous snapshot: keep everything in memory and snapshot them to disk asynchronously at once on background.
    3. AOF (Append Only Files). Only appends changes.
- Redis uses WAL and asynchronous snapshot.
- OS Cache: A write request in OS usually goes to the OS cache. Less I/O for performance reasons.
- If data is written in OS cache and OS crashes, machine restart could lead to loss of data.
- Fsync OS command forces writes to always go to disk.
- Fsync can be expensive and slows down commits.

## Indexing
#### Index Only Scan
- Scan the indexed attribute itself. 
- No need to fetch anything from heep. 
#### Seq Scan
- Equivalent to full table scan. Sometimes Postgres uses multithreading (workers) to scan a large table.
#### Index Scan
- Scan table by indexes. see the indexed by running `\d <table-name>;`

#### Bitmap Index Scan
- Consider the following select statement:
- `SELECT name from grades where grade > 80;`  
- Assume the column `grade` is indexed.
- Postgres runs Bitmap heep scan at first. It searches the indexes first to find the page numbers where condition applies.
- Next, Postgres rechecks the condition and select proper rows in each page that matches the condition.
- Next, Postgres runs bitmap heap scan to fetch the target pages and rows.  


### Explain
- `explain analyze select name from eployees;` 
- The `explain` command explains how DBMS plans and executes queries.
- Cost: contains two numbers
  - First: the time in milliseconds it takes to fetch the first page. This duration can increase if there is some preparation before fetching such as aggregating, ordering, etc.  
  - Second: an estimated time it thinks it can finish the query in milliseconds.
- Rows: contains an estimated number of rows that will be affected by the query. It is not accurate but it is fast. Use it instead of count(*) if accurate results is not needed.
- Width: the average row size in bytes. This can give an estimate of the network traffic requirement for each query. Try to avoid `select *` and limit-less queries.
- Explain with buffers: `explain (analyze, buffers) select name from employees where id > 4500000;`

### Create Index
- Create index based on a single column (key database indexing): `CREATE INDEX <index-name> ON <table-name>(<column-name>);`  
- Create index based on multiple columns (non-key database indexing): `CREATE INDEX <index-name> ON <table-name>(column-name>) INCLUDE (<second-column>);`  
- Example: `CREATE INDEX name_idx ON employees(name);`
- Example: `CREATE INDEX id_name_idx ON employees(id) INCLUDE (name);`
- In the example above, `id` is key column and `name` is non-key column.
- Remove an index: `DROP INDEX <index-name>;`
- Note: creating index blocks write to table. This can cause issue in production databases.
- Create index concurrently in Postgres: `CREATE INDEX CONCURRENTLY name_idx ON employees(name);`
- Creating indexes concurrently pause index creation if there is a `write` query. It will also start the process when there is no ongoing write query.
- Creating an index concurrently takes more memory and CPU
- Creating an index concurrently can fail if at the time of creating an index, a duplicate value gets inserted. It would invalidate index state. Index needs to be dropped and recreated.
- 

### B-Tree Index

### B+-Tree Index

## Partitioning
- The best way to query a table with a billion rows is to avoid querying the table with a billion rows.  
- Partitioning is breaking a table to multiple tables.  
- There is metadata about partitions that helps to query only a sub-table that contains the targeted data based on the query condition.  

### Horizontal Partitioning vs Vertical Partitioning
- Horizontal partitioning splits rows into partitions
  - Partitioning is normally referred to horizontal partitioning. 
  - Can partition horizontally by range, list, or hash.
  - The column which a tables gets partitioned by must not be nullable.  
- Vertical partitioning splits columns into partitions.  
  - Large column (blob) that you can store in a slow access drive in its own tablespace.  

### Partitioning Types  
- Types of horizontal partitioning: range, list, or hash
- Range partitioning: how many rows go into each partition.
  - Example: sort rows by the incremental id and split by each 400 million.
  - Example: sort rows by date which means a range of dates. For example logs based on date.
  - New data goes to the last partition which has fewer rows.
  - Partition splits when data grows more than a threshold.
- List partitioning: partition based on specific (and discrete) values of a column or values of a tuple.
  - Example: one partition for each zip code.
  - New data goes to proper partition.
  - Partition splits when new category is added to the partitioned feature.
- Hash: partition based on a hash function.  

### Partitioning vs Sharding  
- By partitioning we mean horizontal partitioning (HP)  
- Partitioning (HP) splits a big table into multiple tables in the same database.  
- It is client agnostic. Client does not query a specific partition directly. Queries are handled automatically.  
- Sharding splits a big table into multiple tables across multiple database servers (distributed processing).  
- Sharding can address latency issues related to large distances. 
  - Example: Users within a region (based on IP address or prior acknowledgment) get faster access to data that is physically closer to them.  
- In partitioning table names or schemas of different partitions or different.  
- In sharding the naming are the same except for the server itself.  


### Hands ON Practice
- Create a single table with 1 million rows.
```
psql -U postgres;
CREATE TABLE scores (id SERIAL NOT NULL, score  INT NOT NULL);
INSERT INTO scores(score) SELECT FLOOR(RANDOM()*100) FROM generate_series(0, 10000000);
CREATE INDEX score_idx ON scores(score); 
\d scores;  -- describe the table
EXPLAIN ANALYZE SELECT COUNT(*) FROM scores WHERE score = 75;
```

- Create a partitioned table with 1 million rows.
```
CREATE TABLE scores_parts (id SERIES NOT NULL, score INT NOT NULL) PARTITION BY RANGE(score);
CREATE TABLE score_0025 (LIKE scores_parts INCLUDING INDEXES);
CREATE TABLE score_2550 (LIKE scores_parts INCLUDING INDEXES);
CREATE TABLE score_5075 (LIKE scores_parts INCLUDING INDEXES);
CREATE TABLE score_75100 (LIKE scores_parts INCLUDING INDEXES);
ALTER TABLE scores_parts ATTACH PARTITION score_0025 FOR VALUES FROM (0) TO (25);
ALTER TABLE scores_parts ATTACH PARTITION score_2550 FOR VALUES FROM (25) TO (50);
ALTER TABLE scores_parts ATTACH PARTITION score_5075 FOR VALUES FROM (50) TO (75);
ALTER TABLE scores_parts ATTACH PARTITION score_75100 FOR VALUES FROM (75) TO (100);
\d scores_parts;
\d score_0025;
INSERT INTO scores_parts SELECT * FROM  scores;  -- insertion is managed by DBMS automatically
\d score_0025
SELECT COUNT(*) FROM scores_parts;
SELECT COUNT(*) FROM score_5075;
SELECT MAX(*) FROM score_5075;
SELECT MAX(*) FROM score_5075;
CREATE INDEX scores_parts_score_idx ON scores_parts(score);  -- only on the big table from Postgres 11 and later 
\d scores_parts;
\d score_2550;
EXPLAIN ANALYZE SELECT COUNT(*) FROM scores_parts WHERE score = 75;
-- compare tables and indexes sizes
SELECT pg_relation_size(oid), relname FROM pg_class ORDER BY pg_relation_size(oid) DESC;
```

### Enable Partition Pruning
Syntax: `SET enable_partition_pruning = off;`
- This command would disable all advantages and purpose of partitioning.
- Any query would run on all partitions
- `EXPLAIN ANALYZE SELECT COUNT(*) FROM scores_parts WHERE score = 75;`
- Make sure this setting is always set to `on` if using partitioning

### Pros & Cons
Pros:
- Improve query performance for big data
- Sequential scan vs scattered index scan. 
  - Planner decides to use index or just scan the table.
  - If query wants to return every single record, using index can make the process slower.
  - Partitioning makes planning easier for the DBMS
- Easy bulk loading
  - It is faster to bulk load data to attached partitions.
  - MySQL can bulk load CSV files fast to the partitions.
- Archive old data that are less frequently needed into cheaper storages.

Cons:
- Updates that move rows from one partition to another (slow or fail sometimes)
- Inefficient queries can scan many partitions resulting in lower performance.
- Schema changes can be challenging (DBMS usually manages it)
- 