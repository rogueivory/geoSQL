# geoSQL

This project contains (as of initial commit) SQL code related to address data quality and matching. Initially, I attempted to stay within the SQL "domain" as much as possible, meaning the SQL could be run directly as an ad-hoc query or series of queries. This was originally done as a result of having few tools and fewer permissions available in the development environment during a project, so I didn't have many other options besides raw SQL queries. 

Much of the original code was written in Teradata, and as such some Teradata-exclusive extensions exist in the code, particularly related to the use of regular expressions. 

Going forward, I hope to update this project for use in a MS SQL Server/T-SQL environment. Due to the reliance on the aforementioned Teradata-exclusive functions (where no function exists within T-SQL as a 1:1 conversion), this will likely require developing within the broader .NET/C# scripting environment. I hope to expand my knowledge of the .NET environment within SQL Server, as well as expand my overall knowledge of geodata principles and practices. 

Many of the hard-coded values in the initial code are specific to the dataset I was working on at the time.  Some steps were implemented specifically to address quality concerns on specific items within the dataset. I will be examining these specific implementations to determine how applicable they are to other datasets and if they can be set up in a more "generalized" form to fit other datasets. 

In some cases, address formats were coded to go against the USPS standard. This was due to project requirements at the time to allow the data to be ingested by downstream applications and reports. As I update and convert the code, I will seek to adhere to the published USPS standards as closely as possible in order to ensure maximum compatibility with other datasets and tools. (https://pe.usps.com/text/pub28/welcome.htm)
