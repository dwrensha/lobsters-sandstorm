lobsters_repo = https://github.com/dwrensha/lobsters.git
lobsters_repo_branch = sandstorm-app

all: lobsters/.git lobsters/.bundle initdb.sqlite3

lobsters/.git:
	git clone ${lobsters_repo} lobsters && cd lobsters && git checkout ${lobsters_repo_branch}

lobsters/.bundle:
	cd lobsters && bundle install --path .bundle --without test development --jobs 4 --standalone

initdb.sqlite3: lobsters/.bundle
	rm -rf db
	mkdir db
	cd lobsters && RAILS_ENV=production bundle exec rake db:schema:load populate_tags
	mv db/db.sqlite3 initdb.sqlite3
	rm -rf db
	ln -s /var/sqlite3 db
