set -x

export SECRET_KEY_BASE=`base64 /dev/urandom | head -c 30`

cd lobsters
./bin/rails server -p 10000 -e production

