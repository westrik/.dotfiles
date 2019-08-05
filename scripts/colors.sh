#/bin/bash

# unset format modifiers
UFALL="\e[0m"
UFBOLD="\e[21m"
UFDIM="\e[22m"
UFEMPH="\e[23m"
UFUNDER="\e[24m"
UFBLINK="\e[25m"
UFINVERT="\e[27m"

# color modifiers
_CMOD_DEFAULT='39'
_CMOD_BLACK='30'
_CMOD_RED='31'
_CMOD_GREEN='32'
_CMOD_YELLOW='33'
_CMOD_BLUE='34'
_CMOD_MAGENTA='35'
_CMOD_CYAN='36'
_CMOD_WHITE='37'

# set format modifiers
_FMOD_BOLD="1"
_FMOD_DIM="2"
_FMOD_EMPH="3"
_FMOD_UNDER="4"
_FMOD_BLINK="5"
_FMOD_INVERT="7"
_FMOD_NO_OP=""

declare -a COLOR_MODIFIERS=("DEFAULT" "BLACK" "RED" "GREEN" "YELLOW" "BLUE" "MAGENTA" "CYAN" "WHITE")
declare -a FORMAT_MODIFIERS=("BOLD" "DIM" "EMPH" "UNDER" "BLINK" "INVERT")

# Exports `F[FORMAT][COLOR]` for each combination
for color in "${COLOR_MODIFIERS[@]}"; do
	color_modifier_name="_CMOD_$color"
	color_modifier=$(eval "echo \$$color_modifier_name")

	declare C$color="\e[${color_modifier}m"
	export "C${color}"

	for format in "${FORMAT_MODIFIERS[@]}"; do
		format_modifier_name="_FMOD_$format"
		format_modifier=$(eval "echo \$$format_modifier_name")

		export_name="F${format}${color}"
		declare $export_name="\e[${format_modifier};${color_modifier}m"
		export "$export_name"
	done
done

add_format() {
	# example: `add_format blink red "hello world"`
	format=$1
	input=$2
	color=default
	if [ "$#" -eq 3 ]; then
		color=$2
		input=$3
	fi

	color_name=$(echo $color | awk '{ print toupper($0) }')
	color_modifier_name="_CMOD_$color_name"
	color_modifier=$(eval "echo \$$color_modifier_name")

	format_modifier_name="_FMOD_$(echo $format | awk '{ print toupper($0) }')"
	format_modifier=$(eval "echo \$$format_modifier_name")

	printf "\e[${format_modifier};${color_modifier}m${input}${UFALL}\n"
}

# helpers
color() {
	# example: `color red "hello world"`
	add_format no_op $1 $2
}
blink() {
	# example: `blink red "hello world"`
	# example: `blink "hello world"`
	add_format blink $1 $2
}
bold() {
	# example: `bold red "hello world"`
	# example: `bold "hello world"`
	add_format bold $1 $2
}
invert() {
	# example: `invert red "hello world"`
	# example: `invert "hello world"`
	add_format invert $1 $2
}
dim() {
	# example: `dim red "hello world"`
	# example: `dim "hello world"`
	add_format dim $1 $2
}
warn() {
	# example: `warn "check in on this"`
	if [ "$#" -ge 1 ]; then
		add_format bold red $1
	fi
}
err() {
	# example: `err "it failed!"`
	if [ "$#" -ge 1 ]; then
		add_format invert red $1
	fi
}
success() {
	# example: `success "it finished"`
	if [ "$#" -ge 1 ]; then
		add_format invert green $1
	fi
}
