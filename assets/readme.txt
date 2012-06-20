This is a storage for different application assets. Directory is not added into the exceptions
of CFWheels rewrite, so any access attempts through the web will throw 404 error.

Current directory contents:

data/ -- misc data files storage

files/ -- standard uploads storage

fonts/ -- custom fonts storage

images/ -- layout images storage

javascripts/ -- application JavaScript storage

sql/ -- database schema scripts storage
sql/changes/yyyy/mm/dd_xyz.sql -- alter scripts to apply on existing database
sql/changes/_.sql -- this is change script stub, includes FK restrictions workaround
sql/maintenance/xyz.sql -- cleanup, fixes, lookups and other scripts used from time to time
sql/schema/xyz.sql -- cumulative scripts for deploying application or data (re-)load

stylesheets/ -- application CSS storage
