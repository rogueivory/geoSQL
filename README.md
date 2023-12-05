# geoSQL

SQL code related to address data quality and matching. Initially, I attempted to stay within the SQL "domain" as much as possible, meaning the SQL could be run directly as an ad-hoc query or series of queries. This was originally done as a result of having few tools and fewer permissions available in the development environment during a project, so I didn't have many other options besides raw SQL queries. 

Much of the original code was written in Teradata, and as such some Teradata-exclusive extensions exist in the code, particularly related to the use of regular expressions. 

Going forward, I hope to update this project for use in a MS SQL Server/T-SQL environment. Due to the reliance on the aforementioned Teradata-exclusive functions (where no function exists within T-SQL as a 1:1 conversion), this will likely require developing within the broader .NET/C# scripting environment. I hope to expand my knowledge of the .NET environment within SQL Server, as well as expand my overall knowledge of geodata principles and practices. 
