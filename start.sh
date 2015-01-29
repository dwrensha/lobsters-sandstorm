export SECRET_KEY_BASE=`base64 /dev/urandom | head -c 30`

set -x

mkdir -p /var/sqlite3
cp initdb.sqlite3 /var/sqlite3/db.sqlite3

cd lobsters
./bin/rails server -p 10000 -e production

