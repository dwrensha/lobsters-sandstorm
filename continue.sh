set -x

export PATH="/usr/local/share/rbenv/versions/1.9.3-p429/bin:$PATH"

cd lobsters

./bin/rails server -p 10000 -e production

