# README

* Ruby version

  ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]


* Rails version

  Rails 7.0.6


* Database creation

  `$ rails db:create`


* Database initialization

  `$ rails db:migrate`

  `$ rails import_data:movies_and_reviews`


* How to run the test suite

  N/A


### This assignment is about writing a small Ruby On Rails application. Use a methodology that works for you or that you are used to.

1. Create a new application with Ruby on Rails

2. Study the content of movies.csv and reviews.csv

3. Define a database schema and add it to your application

4. Write an import task to import both CSV-files

5. Show an overview of all movies in your application

6. Make a search form to search for an actor

7. Sort the overview by average stars (rating) in an efficient way

### Design CSV importer/application for heavy data processing

  This depends on the nature of the imported data, do I need to do processing on it or not?
  
  This can be done by different ways, using batches/chunks [I've developed that feature for different data sources not just CSV files at incorta.]
  
  Also, can be done using streams to read line by line instead of loading the whole file to memory.

