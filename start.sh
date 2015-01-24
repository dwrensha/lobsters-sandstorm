set -x

mkdir -p /var/tmp
mkdir -p /var/sqlite3
cp initdb.sqlite3 /var/sqlite3/db.sqlite3

export PATH="/usr/local/share/rbenv/versions/1.9.3-p429/bin:$PATH"

cd lobsters

./bin/rails server -p 10000 -e production

