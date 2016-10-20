set -e
STEP=$1
# Step 1: configure ssh auto login
rsa_pub="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEAAu5HS0e88s2+O1eXtC9McbgvqQIrGuPeCCGBiO413TyLU6A3/nHLqF9jkrjd62UO4ATWMJNp6Z8qGKIkdDu2r/rUpupSMJA8Um5+t3ZIUgmDq4asgyf6p6nPG8AcpV4zQgvdpGrvpyBSWPxNPypBg5heVzLCJwQbn4BVUrDFx2V1DuexdlQUfoh7AmHOYaiROlcdQwXLycAal0uQbUNjDg4KkwrTGx3SosPpTvFT7SPeZJlJAdpY2jR/jcb+l/BlpO9r1q4Ar4ozr/vu/1DgAOHOMmJgVAmvLYbmnXYMhxEXA43W4Sl7yvs8GVeDkl6sBf+7JEd96OZANMx7BM/ wuyulong@localhost\n\
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAt42E6SaLEU5SQlsNyAvHbTig1dwmMEskiAdAr1bFAmn0+6uMokHxWKvuTKpPz2/Kai1x1svr99R7c2r3jV0GBIHwPtXFURS4jerbQntCx5Mev/xekAgattIUVE9SAIkPIOggHogS+7kTRiLMY9yjFtNt7Yx3riKd/Pqm/0cPnwqckqQ0mUryPfdde02LuAiuJcTESKiVr8chgFnnzE4agpKH2HL/RVxeIo1NBPn3B4BWmjfhiyw1V4fhGWGd/GsJoB/hFbTqicEQY5NZXoHZrWHmZyOcBCxckJdXJyg/IGkpIdCNMI7miRdGptrA7WosX7JgtSAc28VDg7csr0qgKQ== wuyulong@gateway"

config_source='wuyulong@10.111.0.141'
cd ~
if ! [ -d .ssh ]
then
    # Step 1: configure ssh auto login
    echo 'Step 1: configure ssh auto login'
    mkdir .ssh
    echo -e "Host *\nServerAliveInterval 120" > .ssh/config # for perserve the connection
    chmod 700 .ssh
    chmod 600 .ssh/config
fi
if ! [ -e .ssh/authorized_keys ]
then
    echo -e $rsa_pub > .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
fi

if ! [ -e ~/.bashrc ]
then
# Step 2: copy bash configuration
echo 'Step 2: copy bash configuration'
scp $config_source:~/.bashrc .
fi

if ! [ -e .vimrc ]
then
# Step 3: copy vi configuration
echo 'Step 3: copy vi configuration'
scp $config_source:~/.vimrc .
fi
if ! [ -d .vim ]
then
    echo 'copy vi plugins...'
    mkdir .vim
    cd .vim
    scp -r $config_source:~/.vim/* .
    cd -
fi

if ! [ -e .profile ]
then
# Step 4: copy profile (which include http_proxy configuration)
echo 'Step 4: copy profile (which include http_proxy configuration)'
scp $config_source:~/.profile  ~
fi

#if zsh is not installed, install zsh
if [ "$(grep /zsh$ /etc/shells)" == "" ]
then
    yum install zsh
fi

# Step 5: config git
if [ $STEP == *'5'* ]; then
    git config --global user.email "wuyulong@yidian-inc.com"
    git config --global user.name "wuyulong"
    git config --global push.default simple
    cd ~
    echo "Generate ssh key, pls type enter within the command..."
    ssh-keygen -t rsa
    echo "TODO: please enter the git site and copy the content of .ssh/id_rsa.pub to the setting of your profile."
    cd -
fi

if [[ ($? -eq 0) && !(-d ~/.oh-my-zsh) ]]
then
# Step 6: install oh-my-zsh and copy its configuration
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [[ ($? -eq 0) || ($STEP == *'6'*) ]]
then
    echo "Install successfully! copying configuration..."
    scp $config_source:~/.zshrc .
    scp $config_source:~/.oh-my-zsh/themes/blinks.zsh-theme ~/.oh-my-zsh/themes/blinks.zsh-theme
    cd ~/.oh-my-zsh/
    git update-index --assume-unchanged ~/.oh-my-zsh/themes/blinks.zsh-theme
    cd -
fi

# Step 7: clone my git repositories
GIT_LIBS=('https://git.yidian-inc.com:8021/wuyulong/DocKeywordClickFetcher.git' \
    'https://git.yidian-inc.com:8021/wuyulong/YulongUtils.git')
GIT_LIBS_HTTPS=('git@git.yidian-inc.com:wuyulong/DocKeywordClickFetcher.git' \
    'git@git.yidian-inc.com:wuyulong/YulongUtils.git')
index=0
for git in $GIT_LIBS; do
    git clone $GIT_LIBS
    git remote set-url origin ${GIT_LIBS_HTTPS[$index]}
    index+=1
done
if [[ ($STEP == *'7'*) ]]; then
    cd ~
    mkdir gitsvnlib; cd gitsvnlib
    git clone
fi
