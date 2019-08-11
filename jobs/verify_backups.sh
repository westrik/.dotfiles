#!/bin/sh

source $HOME/.dotfiles/env_scripts/folders.sh
source $HOME/.dotfiles/env_scripts/colors.sh

BACKUP_BUCKET="mwestrik-documents"
DECRYPTION_KEY="$WORK_FOLDER/.backup_privkey.pem"

download_from_b2_and_unpack() {
	archive_name=$1

	printf "${CGREEN}Downloading & decrypting${FBOLDGREEN} ${archive_name}${UFALL}\n"
	b2decrypt $archive_name $BACKUP_BUCKET $DECRYPTION_KEY
	printf "${CGREEN}Uncompressing${FBOLDGREEN} ${archive_name}${UFALL}\n"
	tar -xzvf $archive_name
}

cd $WORK_FOLDER
restore_dir=$(realpath "backup_restore_$(date '+%Y-%m-%d')")
mkdir -p $restore_dir
cd $restore_dir

for archive_name in "$@"
do
	printf "${FBOLDCYAN}Downloading and unpacking $archive_name:\n${UFALL}"
	download_from_b2_and_unpack $archive_name
done

printf "${FBOLDGREEN}Unpacked backup archives in $restore_dir.\n${UFALL}"
