#/usr/bin/env sh
# Repos Setup
# Mostly taken from the wonderful PuPHPet project

# CentOS release we're using
OS=centos
RELEASE=6


# Start of PuPHPet Initial Setup <<<
echo 'Installing curl'
yum -y install curl >/dev/null
echo 'Finished installing curl'

echo 'Installing git'
yum -y install git >/dev/null
echo 'Finished installing git'

echo 'Installing Development Tools'
yum -y groupinstall 'Development Tools' >/dev/null
echo 'Finished installing Development Tools'
# >>> End of PuPHPet Initial Setup

echo 'Installing Python 3.3'
yum -y install python33 >/dev/null
echo 'Finished installing Python 3.3'
