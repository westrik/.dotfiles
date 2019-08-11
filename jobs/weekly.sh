source $HOME/.dotfiles/env_scripts/folders.sh

# Archive the current _log.md and create a new one.
echo "Archiving _log.md"
cd $NOTES_FOLDER
while true; do
	if $(git diff --quiet && git diff --staged --quiet); then
		date=$(date '+%Y-%m-%d')
		log_file="dev_log_until_$date.md"
		mv "_log.md" $log_file
		echo "# Week of ${date}" > _log.md
		cat templates/log.md >> _log.md
		git add _log.md $log_file && git commit -m '[weekly-job] create new dev log file' && git push
		terminal-notifier -message "made a new _log.md" -title "[weekly-job] janitor"
		break
	fi

	# Wait for hourly job to commit changes
	sleep 2
done

# Run B2 backups
echo "Running B2 backups"
bash $HOME/.dotfiles/jobs/backup.sh $LOGS_FOLDER/b2_backup.log
terminal-notifier -message "B2 backup succeeded" -title "[weekly-job] b2 backup"
