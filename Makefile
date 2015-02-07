lobsters_repo = https://github.com/dwrensha/lobsters.git
lobsters_repo_branch = sandstorm-app

.PHONY: all clean symlink

all: lobsters/.git lobsters/.bundle initdb.sqlite3 lobsters/read-only-cache/assets symlink

clean:
	rm -rf initdb.sqlite3 lobsters/.bundle lobsters/read-only-cache/assets lobsters/public/assets

lobsters/.git:
	git clone ${lobsters_repo} lobsters && cd lobsters && git checkout ${lobsters_repo_branch}

lobsters/.bundle: lobsters/.git
	cd lobsters && bundle install --path .bundle --without test development --jobs 4 --standalone

lobsters/read-only-cache/assets: lobsters/.bundle
	cd lobsters && RAILS_ENV=production ./bin/rake assets:precompile

initdb.sqlite3: lobsters/.bundle
	rm -rf db
	mkdir db
	cd lobsters && RAILS_ENV=production bundle exec rake db:schema:load populate_tags
	mv db/db.sqlite3 initdb.sqlite3
	rm -rf db
	ln -s /var/sqlite3 db

# yuck. We need to set up a symlink so that nokogiri.so can link with libexslt.so in the sandbox.
symlink:
	mkdir -p `pwd | xargs dirname | sed -e 's/^\///'`
	rm -f `pwd | sed -e 's/^\///'`
	ln -s / `pwd | sed -e 's/^\///'`
