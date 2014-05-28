amc
===

Ruby on Rails service, which allows to import data from differently formatted CSV and to search in it.

The service is intended for insurance companies. It allows them to keep all the dissorted data they have in CSV in one unified database. It allows them to search through the item, and to use specific formulae to compute the price.

The problem with the CSV is that it has all the columns in random order. So the service lets a customer to choose what each column stands for, and thus the data is saved correctly into the DB.

The most complicated part is rearranging the columns in the way, that the data can be imported into DB. The ruby is too slow for such data manipulations (there are millions of rows in that csv files), so the program in C++ is launched from Rails app. That program is responsible for rearranging the columns in the right order (it's getting app. 8 times win in comparison with ruby). 

