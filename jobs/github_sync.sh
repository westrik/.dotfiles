#!/bin/sh

# Sync all repositories in the account associated with a GitHub API token to a local folder.

CHUNK_SIZE=100

source $HOME/.dotfiles/env_scripts/colors.sh
# load $SRC_FOLDER
source $HOME/.dotfiles/env_scripts/folders.sh
# load $GITHUB_API_TOKEN
source $HOME/.localrc

get_repo_data() {
	query="{\
		 \"query\": \"query { viewer { repositories(first: $CHUNK_SIZE, $1) { nodes { name, sshUrl, }, pageInfo { endCursor, hasNextPage, } } } }\"\
	}"
	curl --silent -H "Authorization: bearer $GITHUB_API_TOKEN" -X POST -d "$query" https://api.github.com/graphql
}

fetch_repo_for_url() {
	output_buffer=$(mktemp)
	name=$(echo $1 | perl -n -e'/git\@github.com:[A-Za-z0-9]+\/(.+).git/ && print $1')

	if [ -d $name ]; then
		if [ "$2" == "--fetch-all" ]; then
			printf "${CGREEN}Updating ${name}${UFALL}\n" >> $output_buffer 2>&1
		fi
	else
		printf "${CGREEN}$name is new, cloning...${UFALL}\n" >> $output_buffer
		git clone --recurse-submodules $1 "$name" >> $output_buffer 2>&1
	fi

	if [ "$2" == "--fetch-all" ]; then
		cd $name
		git fetch --all >> $output_buffer 2>&1
		cd - >> /dev/null
	fi
	cat $output_buffer
}

fetch_repos_for_data() {
	for sshUrl in $(echo $1 | jq -r '.[] | .viewer | .[] | .nodes | .[] | .sshUrl'); do
		fetch_repo_for_url $sshUrl $2 &
	done
	wait
}

# ----

mkdir -p $SRC_FOLDER
cd $SRC_FOLDER

cursor=""
while true; do
	repo_data=$(get_repo_data $cursor)
	fetch_repos_for_data $repo_data $1

	continue=$(echo $repo_data | jq -r '.[] | .viewer | .[] | .pageInfo | .hasNextPage')
	if [[ $continue == "true" ]]; then
			cursor="after:\\\"$(echo $repo_data | jq -r '.[] | .viewer | .[] | .pageInfo | .endCursor')\\\""
	else
			break
	fi
done
