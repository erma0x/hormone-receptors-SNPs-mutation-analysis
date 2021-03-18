# Connection to DB commands


# sudo service mysql start
# mysql -u root snpImpactResource -A

# DEBUG connection commands
# sudo mkdir /var/log/mariadb          # crea Directoryfile Log
# sudo chmod 777 /var/log/mariadb      # Modifica i permessi

import mysql.connector
import time
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import colors
import mysql

records=[]

print('+'*20+' START '+'+'*20)

def LogIn(): 
   print(' Start the connection to DataBase, please wait...')
   connection_ = mysql.connector.connect(
   host="localhost",
   database="snpImpactResource",
   user="root",
   passwd=""
   )
   time.sleep(1)
   return(connection_)

def queryTime(query="select;",file_directory='/home/user/Downloads/test.txt'):
  connection=LogIn()
  cursor = connection.cursor()
  cursor.execute(query)
  for record in cursor:
    records.append(parseRow(list(record)))
  cursor.close()
  connection.close()
  time.sleep(0.5)
  return(records)

def SaveRecords(file_directory_,records_): # open, read records with queryTime function and save it on file directory
  file = open(file_directory_,"w")
  records=queryTime()
  for i in range(len(records)):
    write_row(file_directory_,records[i])
  time.sleep(1)
  file.close()

  # do a query to the DB, parse and save into file .txt

def parseRow(row_):
    row_ = [x.strip('"').rstrip() for x in row_]
    row_[-1]=row_[-1].strip('"') # particular parsing at the last element

    for e in range(len(row_)): # transform string into numbers when possible
        try:
            row_[e]=float(row_[e])
        except:
            pass
    time.sleep(0.01)
    return(row_)

def write_obj(file_directory_,obj):
    list_of_strings=[str( obj[i]) for i in range(len(obj))]
    file = open(str(file_directory_), "a")
    for sting in list_of_strings:
        file.write(sting)
    time.sleep(1)
    file.close()

def write_row(file_directory_,row):
    file = open(str(file_directory_),"a")
    file.write(str(row))
    time.sleep(0.01)
    file.close()


# ESEMPIO DELLA FUNZIONE SaveRecords
# Crea un file prova.txt e ci inserisce dentro l'oggetto passato
# in questo caso l'oggetto e' una lista

SaveRecords('/home/ermano/Downloads/prova.txt',[1,2,3,4])
