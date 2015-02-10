repo = https://github.com/dwrensha/lobsters.git
repo_branch = sandstorm-app
repo_dir = lobsters

.PHONY: all clean symlink

all: ${repo_dir}/.git ${repo_dir}/.bundle initdb.sqlite3 ${repo_dir}/read-only-cache/assets symlink

clean:
	rm -rf initdb.sqlite3 ${repo_dir}/.bundle ${repo_dir}/read-only-cache/assets ${repo_dir}/public/assets

${repo_dir}/.git:
	git clone ${repo} ${repo_dir} && cd ${repo_dir} && git checkout ${repo_branch}

${repo_dir}/.bundle: ${repo_dir}/.git
	cd ${repo_dir} && bundle install --path .bundle --without test development --jobs 4 --standalone

${repo_dir}/read-only-cache/assets: ${repo_dir}/.bundle
	cd ${repo_dir} && RAILS_ENV=production ./bin/rake assets:precompile

initdb.sqlite3: ${repo_dir}/.bundle
	rm -rf db
	mkdir db
	cd ${repo_dir} && RAILS_ENV=production bundle exec rake db:schema:load populate_tags
	mv db/db.sqlite3 initdb.sqlite3
	rm -rf db
	ln -s /var/sqlite3 db

# Yuck. We need to set up a symlink so that nokogiri.so can link with libexslt.so in the sandbox.
# It seems that this is only necessary for older versions of nokogiri. (Lobsters uses nokogiri 1.6.1)
symlink:
	mkdir -p `pwd | xargs dirname | sed -e 's/^\///'`
	rm -f `pwd | sed -e 's/^\///'`
	ln -s / `pwd | sed -e 's/^\///'`
