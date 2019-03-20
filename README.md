Example SQLite app using FMDB written in Swift. FDBM is an Objective-C wrapper around Apple's C-Style API for SQLite. The app was built as part of a blog post on SQLite and illustrates the basic concepts of using FDMB as on device storage. The app implements the basic transactions of creating a table, inserting records, quering a table, and deleting records using FMDB. 

Create a table by specifying the table name, column names and their respective types (see FDMB repo for details)

Insert a record into a table by specificying the table name and column values. All columns for the table must have a value

Query a table by specificying the table name, a column name in the Search By field, and the value in the Where field

Delete records by specifying the table name, column names and column values


Note: The app uses a single generic model to represent table row data. The generic model is struct with four properties of type Any