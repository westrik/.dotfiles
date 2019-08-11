#!/bin/sh

source $HOME/.dotfiles/env_scripts/folders.sh
source $HOME/.dotfiles/env_scripts/colors.sh

ENCRYPTION_KEY="$WORK_FOLDER/.backup_pubkey.pem"
BACKUP_BUCKET="mwestrik-documents"

backup_log=/dev/stdout
if [ $# -ge 1 ]; then
	backup_log=$(realpath $1)
	touch $backup_log
fi
printf "${FBOLDBLUE}―――――――――――――――――――――――――――――――――――――――――――――――\n${UFALL}"\
"${CBLUE}Running backup.sh, and it's $(date '+%Y-%m-%d') at $(date '+%H:%M')\n${UFALL}" >> $backup_log

# $LOGS_FOLDER backed up implicitly
folders_to_backup=($NOTES_FOLDER $DESIGN_FOLDER $GITHUB_FOLDER $READING_FOLDER)
# to re-upload archive: folders_to_backup=($ARCHIVE_FOLDER)

backup_folder() {
	folder=$1
	logfile=$2

	folder_name="$(basename $folder)"
	archive="$folder_name-$(date '+%Y-%m-%d_%H-%M').tar.gz"

	printf "${CGREEN}Compressing${FBOLDGREEN} ${folder_name}${UFALL}\n" >> $logfile
	tar --use-compress-program=pigz -czvf $archive ./$folder_name >> $logfile 2>&1
	printf "${CGREEN}Encrypting & uploading${FBOLDGREEN} ${folder_name}${UFALL}\n" >> $logfile
	b2encrypt $archive $BACKUP_BUCKET $ENCRYPTION_KEY >> $logfile 2>&1
	du -sh $archive* >> $logfile 2>&1
	rm -f $archive* >> $logfile 2>&1
}

cd $WORK_FOLDER

# Back up logs folder, redirecting output to a tmp file so we aren't modifying logs as we back them up.
tmplog=$(mktemp)
backup_folder $LOGS_FOLDER $tmplog
cat $tmplog >> $backup_log

# Back up everything else (ok to modify log now)
for folder in ${folders_to_backup[@]}; do
	backup_folder $folder $backup_log
done

printf "${FBOLDGREEN}Done backing up for now.\n${UFALL}" >> $backup_log
