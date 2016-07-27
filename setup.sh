#!/usr/bin/env bash
set -e
set -u
set -o pipefail
set -o errtrace
shopt -s shift_verbose
set -o noclobber

trap 'err_handler $?' ERR

err_handler() {
	trap - ERR
	let i=0 exit_status=$1
	builtin echo "Aborting on error $exit_status:"
	builtin echo "--------------------"
	while caller $i; do ((i++)); done
	builtin exit $?
}

read -e -p "Choose a packagename: " PACKAGECHOICE
read -e -p "Author name: " OWNERCHOICE
YEAR=`date +"%Y"`
DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
grep -rl 'PACKAGENAME' $DIR | xargs sed -i "" "s/PACKAGENAME/$PACKAGECHOICE/g"
grep -rl 'OWNER' $DIR | xargs sed -i "" "s/OWNER/$OWNERCHOICE/g"
grep -rl 'YEAR' $DIR | xargs sed -i "" "s/YEAR/$YEAR/g"
mv "$DIR/packagename" "$DIR/$PACKAGECHOICE"
rm "$DIR/setup.sh"
rm "$DIR/README.md"
git init $DIR
