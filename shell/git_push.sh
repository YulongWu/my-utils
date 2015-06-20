#! /bin/zsh
#set color code
RCol='\e[0m'
BIYel='\e[1;93m'
Cya='\e[0;36m'
#set -o nounset
cd $(pwd)
git add --all
if [ "$?" != "0" ]; then
    exit 1
fi
git status
while true; do
    if [ "$1" = "" ]; then
        printf "$BIYel \bWarning: There is no comment defined!$RCol\n"
        1="empty comment."
    fi
    printf "$Cya \b%s\n  \"$BIYel \b%s$Cya\"? \n(y/n): $RCol" \
        "Do you want to commit these changes with following comment?" \
        $1
    read input
    case "$input" in 
        [Yy] | YES | [Yy]es )
            git commit -m "$1"
            git push -u origin master
            break;;
        [Nn] | NO | [Nn]o )
            echo "As you wish, quiting push..."
            break;;
    esac
done
