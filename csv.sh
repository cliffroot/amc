#!/bin/bash
cat /home/artem/Projects/amc_ruby/db/csv_add | sqlite3 /home/artem/Projects/amc_ruby/db/development.sqlite3
