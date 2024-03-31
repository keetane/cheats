<< COMMENTOUT



COMMENTOUT

# update
apt-get -y update
apt-get -y upgrade
apt-get install -y libsm6 libxext6 libxrender-dev libglib2.0-0 sudo wget curl unzip vim 
apt-get install -y build-essential default-jre git

# prompt setting
# https://zenn.dev/melos/articles/043fc03789603c
cd /root
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
wget https://github.com/keetane/cheats/blob/main/bash_config
cat /root/bash_config >> /root/.bashrc

# miniconda
cd /opt
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
rm -r Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
conda config --add channels conda-forge
conda config --remove channels defaults