#!/bin/bash

catch_error() {
  echo "ERROR: Unexpected failure!"
  exit 1
}

### upgrade to 4.0
echo -e "\nINFO: Starting migration to 4.0..."

# run repair on db to upgrade
/tmp/mongod-4.0.28 --dbpath ../data/db -pidfilepath ../data/mongo.pid --bind_ip 127.0.0.1 --journal --repair || catch_error

# start db
/tmp/mongod-4.0.28 --dbpath ../data/db -pidfilepath ../data/mongo.pid --bind_ip 127.0.0.1 --journal &

# set compatibility version to 4.0
while ! echo 'db.adminCommand( { setFeatureCompatibilityVersion: "4.0" } )' | /tmp/mongo-4.0.28
do
  echo "Sleeping! MongoDB isn't running yet"
  sleep 1
done

# stop mongodb
kill -2 "$(cat ../data/mongo.pid)"

# wait for mongodb to stop
echo -n "INFO: Waiting for mongod to stop..."
while pgrep mongod > /dev/null
do
  echo -n "."
  sleep 1
done
echo "done"

# remove pidfile
rm ../data/mongo.pid


# migration complete
echo -e "\nINFO: Migration to 4.0 complete!\n"

### upgrade to 4.2
echo -e "\nINFO: Starting migration to 4.2..."

# run repair on db to upgrade
/tmp/mongod-4.2.23 --dbpath ../data/db -pidfilepath ../data/mongo.pid --bind_ip 127.0.0.1 --journal --repair || catch_error

# start db
/tmp/mongod-4.2.23 --dbpath ../data/db -pidfilepath ../data/mongo.pid --bind_ip 127.0.0.1 --journal &

# set compatibility version to 4.2
while ! echo 'db.adminCommand( { setFeatureCompatibilityVersion: "4.2" } )' | /tmp/mongo-4.2.23
do
  echo "Sleeping! MongoDB isn't running yet"
  sleep 1
done

# stop mongodb
kill -2 "$(cat ../data/mongo.pid)"

# wait for mongodb to stop
echo -n "INFO: Waiting for mongod to stop..."
while pgrep mongod > /dev/null
do
  echo -n "."
  sleep 1
done
echo "done"

# remove pidfile
rm ../data/mongo.pid

# migration complete
echo -e "\nINFO: Migration to 4.2 complete!\n"


### upgrade to 4.4
echo -e "\nINFO: Starting migration to 4.4..."

# run repair on db to upgrade
/tmp/mongod-4.4.18 --dbpath ../data/db -pidfilepath ../data/mongo.pid --bind_ip 127.0.0.1 --journal --repair || catch_error

# # start db
/tmp/mongod-4.4.18 --dbpath ../data/db -pidfilepath ../data/mongo.pid --bind_ip 127.0.0.1 --journal &

# set compatibility version to 4.4
while ! echo 'db.adminCommand( { setFeatureCompatibilityVersion: "4.4" } )' | /tmp/mongo-4.4.18
do
  echo "Sleeping! MongoDB isn't running yet"
  sleep 1
done

# stop mongodb
kill -2 "$(cat ../data/mongo.pid)"

# wait for mongodb to stop
echo -n "INFO: Waiting for mongod to stop..."
while pgrep mongod > /dev/null
do
  echo -n "."
  sleep 1
done
echo "done"

# remove pidfile
rm ../data/mongo.pid

# migration complete
echo -e "\nINFO: Migration to 4.4 complete!\n"

# set ownership
echo -ne "\nINFO: Fixing ownership of database files..."
chown -R "$(stat -c "%u:%g" ../data)" ../data
echo "done"
