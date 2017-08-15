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
	-git rm -rf _posts/  Makefile
	@echo "Updating files...                  ${CHECK} Done"
	@git add --all . && git commit -m "Regenerate files (jekyll deployment)"
	@echo "Committing files...                ${CHECK} Done"
	@git checkout gh-pages && git clean -f -d
	@echo "Switch back to develop...          ${CHECK} Done"
	@mkdir _site/ && jekyll build
	@echo "Re-generating files...             ${CHECK} Done"
	@echo "You can run back jekyll server now to follow changes"
	@echo "\n${HR}"
	@echo "Deployed successfully completed at ${DATE}."
	@echo "${HR}\n"
	@echo "Script by @nicoespeon"
