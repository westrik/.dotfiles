#!/bin/sh
# TODO: report total uploaded size

source $HOME/.dotfiles/env_scripts/folders.sh
source $HOME/.dotfiles/env_scripts/colors.sh

backup_log="$LOGS_FOLDER/b2_backup.log"
tmplog=$(mktemp)
today=$(date '+%Y-%m-%d')
echo "\n\n\nRunning backup.sh, and it's $(date)" >> $tmplog

cd $WORK_FOLDER
for folder in $NOTES_FOLDER $GITHUB_FOLDER $LOGS_FOLDER $DESIGN_FOLDER; do
	folder_name="$(basename $folder)"
	archive="$folder_name-$today.tar.gz"
	printf "${CGREEN}Compressing${FBOLDGREEN} ${folder_name}${UFALL}\n"
	tar -czvf $archive ./$folder_name >> $tmplog 2>&1
	printf "${CGREEN}Encrypting & uploading${FBOLDGREEN} ${folder_name}${UFALL}\n"
	./b2encrypt $archive >> $tmplog 2>&1
	rm -f $archive*
done

touch $backup_log
cat $tmplog >> $backup_log
