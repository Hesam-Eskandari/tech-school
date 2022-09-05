# SQL 

## Introduction

### Database
#### Definition 
- A system made of hardware to store and process data, and software to access and manage data
#### DBMS
- Short for database management system. 
- A software that manages databases by storing and accessing data in a hardware.
#### Types of databases
1. Relational
   - MS SQL, MySQL, Postgres, etc. 
   - It supports ACID transactions.
   - It is made of tables (rows and columns).
2. Document
   - MongoDB, CouchDM, Fire Base.
   - Data is in big documents that contains related documents.
3. Key-Value
   - Fast
   - A candidate for caching data
4. Graph
   - Neo4j, AWS Neptune.
   - Suitable if data are connected in different ways.
   - Such as social network data.
5. Wide Columnar
   - Pioneered by Google’s big table databases like Apache Cassandra.

#### RDBMS
- Short for relational database management system.
- A DBMS that is specified for relational databases
- SQL is an RDBMS programming language that stores and retrieves data.
- SQL Online Playground: [db-fiddle.com](https://www.db-fiddle.com/)
- Each row is a separate entity called a record.
  - Each column is a specific feature of an entity. For example: age, address, name.
    - Example of a table named **Employees** in a relational database:

| firstname | lastname | age |
|:---------:|:--------:|:---:|
|   John    |  Smith   | 28  |
|   Jane    |  Smith   | 26  |
|   John    |   Doe    | 31  |

#### Sample Query
- Query is also known as SQL statement
- Syntax: `SELECT <column-name> FROM <table-name>;`
- Example: `SELECT firstname from Employees;`
- The words `SELECT` and `FROM` are SQL reserved keywords.
- SQL keywords are case-insensitive.
- Example: `select firstname from Employees;`
- Note: Using uppercase for SQL reserved keywords is a better practice. It makes statements more readable.
- Column and table names are also case-insensitive as long as it is not wrapped in double quotes
- Example: `SELECT firstname from Employees;`
- Example: `SELECT Firstname from EMPLOYEES;`
- Example: `SELECT "firstname" from "Employees";`
- Query statement does not necessarily end at the end of a line
  - A query ends where SQL sees a semicolon.

### Declarative VS Imperative

#### Declarative Language
- User specifies **what** should happen
- How it's happening is not obvious
- SQL is a declarative language

#### Imperative Language
- User must specify how exactly something should happen
- Example: Java

### SQL VS SEQUEL

#### SEQUEL 
- The original name for SQL language
- Short for **Structured English Query Language**
- It had to be changed because of copyright conflict

#### SQL
- Is the true, official, and current name of this language
- Short for **Structured Query Language**
- It is made by IBM scientists in the 1970s.
- SQL is a standardized language.
- <img alt="sql-flow-01.svg" src="images/sql-flow-01.svg" width=800>


## History Of Database

### File Processing Systems
- It was similar to keeping files in a cabinet
- No correlation (=relationship) between files
- It was not possible for different system to communicate with each other. Hence, data had to be copied into different systems.

### Database Models

#### Hierarchical Model
- Old and deprecated
- Primarily used by IBM in the 60s and 70s.
- It is not an efficient model for storing data
- It has a tree-like structure
- Each parent node can have multiple children
- A child node can only have one parent (a single root)
- It is a one-to-many relationship
- It is similar to XML structure:
- XML example:
    ```
    <Authur>
        <Marquez>
          <Country>Colombia</Country>
          <Book>100 Years of Solitude</Book>
        </Marquez>
        <JKR>
          <Country>UK</Country>
          <Book>Harry Potter</Book>
        </JKR>
    </Authur>
    ```
- Deleting a parent would delete all its children information as well.
- Hierarchical model example:
<img alt="hierarchical-model-01.svg" src="images/hierarchical-model-01.svg" width=800>

#### Networking Model
- Old and deprecated
- Fixes the lack of many-to-many relationships between nodes.
- Example: if multiple authors contribute in writing a book.
- If a parent gets deleted, all its children would be removed as well.
- Conclusion: the tree like structure does not provide a general model for storing data.
- One solution: relational model

#### Relational Model
- Have one table to store information about authors
- Have one table to store information about books
- Link the two tables with primary keys and foreign keys
- Example:
<img alt="relational-model-01.svg" src="images/relational-model-01.svg" width=800>
- To build the many-to-many relationship between books and authors:
  - Remove the `author_id` column from the `Book` table.
  - Create another table that maps author ids to book ids.
- Primary key: is a column with unique values in a table. It is referred as `id` in the example above.
- Foreign key: is another table's primary key. It is used to build relationship between tables.


