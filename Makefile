DATE = $(shell date +%I:%M\ %p)
CHECK = \033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

#
# DEPLOY TO MASTER
#

deploy:
	@echo "\n${HR}"
	@echo "Deploying website..."
	@echo "${HR}\n"
	@jekyll build
	@echo "Generating files...                ${CHECK} Done"
	@git checkout master
	@echo "Switch to master...                ${CHECK} Done"
	@cp -rf _site/* .
	-rm -rf _site/
	-git rm -rf _posts/
	-git rm -rf Makefile
	@echo "Updating files...                  ${CHECK} Done"
	@git add --all . && git commit -m "Regenerate files (jekyll deployment)"
	@echo "Committing files...                ${CHECK} Done"
	@git checkout gh-pages && git clean -f -d
	@echo "Switch back to develop...          ${CHECK} Done"
	@echo "Deployed successfully completed at ${DATE}."
	@echo "${HR}\n"
	@echo "Script by @nicoespeon"
