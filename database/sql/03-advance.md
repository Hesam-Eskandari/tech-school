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


