set -x

rm -f /var/tmp/pids/*

cd lobsters
./bin/rails server -p 10000 -e production

