source $HOME/.dotfiles/env_scripts/folders.sh

# Archive the current _log.md and create a new one.
cd $NOTES_FOLDER
while true; do
	if $(git diff --quiet && git diff --staged --quiet); then
		date=$(date '+%Y-%m-%d')
		log_file="dev_log_until_$date.md"
		mv "_log.md" $log_file
		echo "# Week of ${date}" > _log.md
		cat templates/log.md >> _log.md
		git add _log.md $log_file && git commit -m '[weekly-job] create new dev log file' && git push
		break
	fi

	# Wait for hourly job to commit changes
	sleep 2
done