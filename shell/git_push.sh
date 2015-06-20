#! /bin/zsh
RCol='\e[0m'
Yel='\e[0;33m'
Cya='\e[0;36m'
set -o nounset
cd $(pwd)
git add --all
git status
while true; do
    if [ "$1" = "" ]; then
        printf "$Yel \bWarning: There is no comment defined!$RCol\n\n"
    fi
    printf "$Cya \b%s\n  \"$Yel \b%s$Cya\"? \n(y/n): $RCol" \
        "Do you want to commit these changes with following comment?" \
        $1
    read input
    case "$input" in 
        [Yy] | YES | [Yy]es )
            git commit -m "$1"
            git push -u origin master
            break;;
        [Nn] | NO | [Nn]o )
            echo "As you wish, quiting script..."
            break;;
    esac
done
