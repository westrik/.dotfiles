source $HOME/.dotfiles/env_scripts/folders.sh

# If there are changes in _/notes, commit them and push.
# TODO: stash changes, pull, then re-apply
cd $NOTES_FOLDER
git diff --quiet && git diff --staged --quiet \
	|| (git add --all\
		&& git commit --no-gpg-sign -am '[hourly-job] update with recent changes'\
		&& git push\
		&& terminal-notifier\
			-message "committed + pushed updates in notes" -title "hourly-job")

# Fetch all branches of all of my GitHub repos.
mkdir -p $LOGS_FOLDER
ghsync_log=$LOGS_FOLDER/ghsync.log
touch $ghsync_log
echo "[$(date)] running ghsync from westrik-job.hourly" >> $ghsync_log
ghsync --fetch-all 2>&1 >> $ghsync_log
