lobsters_repo = https://github.com/dwrensha/lobsters.git
lobsters_repo_branch = sandstorm-app

.PHONY: all clean

all: lobsters/.git lobsters/.bundle initdb.sqlite3 lobsters/read-only-cache/assets

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
