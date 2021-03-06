#/usr/bin/env sh
# Additional packages setup

BUILD_FOLDER=/build
CACHE_FOLDER=/environment/cache/packages

# Start of Additional Packages Setup
echo 'Installing additional packages'
yum -y --enablerepo=scl install python27 python27-runtime python27-devel python27-pip >/dev/null

yum -y install python34u python34u-runtime python34u-libs python34u-devel python34u-pip >/dev/null

yum -y install autoconf automake libtool >/dev/null

yum -y install libtool-ltdl-devel >/dev/null

yum -y install jansson jansson-devel >/dev/null

yum -y install lua-devel >/dev/null

yum -y install libxslt-devel >/dev/null

yum -y install mysql-devel >/dev/null

yum -y install rrdtool >/dev/null
echo 'Finished installing additional packages'
# End of Additional Packages Setup

# Start of GCC 4.8 Setup
echo 'Installing GCC 4.8'
DEVTOOLS2='http://people.centos.org/tru/devtools-2/devtools-2.repo'
DEVTOOLS2_CACHE="${CACHE_FOLDER}/$(echo ${DEVTOOLS2} | awk -F/ '{print $NF}')"

mkdir -p "$CACHE_FOLDER"
if [ ! -e "${DEVTOOLS2_CACHE}" ]; then
    wget "${DEVTOOLS2}" -O "${DEVTOOLS2_CACHE}"
fi

cp "${DEVTOOLS2_CACHE}" /etc/yum.repos.d

yum -y install devtoolset-2-gcc devtoolset-2-gcc-c++
yum -y install devtoolset-2-binutils devtoolset-2-binutils-devel

if [[ -f '/root/.bashrc' ]] && ! grep -q 'export PATH="/opt/rh/devtoolset-2/root/usr/bin/:$PATH"' /root/.bashrc; then
    echo 'export PATH="/opt/rh/devtoolset-2/root/usr/bin/:$PATH"' >> /root/.bashrc
fi
if [[ -f '/etc/profile' ]] && ! grep -q 'export PATH="/opt/rh/devtoolset-2/root/usr/bin/:$PATH"' /etc/profile; then
    echo 'export PATH="/opt/rh/devtoolset-2/root/usr/bin/:$PATH"' >> /etc/profile
fi
echo 'Finished installing GCC 4.8'
# End of GCC 4.8 Setup

# Start of Autotools Setup
echo 'Installing autoconf 2.69'
AUTOCONF='http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz'
AUTOCONF_CACHE="${CACHE_FOLDER}/$(echo ${AUTOCONF} | awk -F/ '{print $NF}')"

mkdir -p "$CACHE_FOLDER"
if [ ! -e "${AUTOCONF_CACHE}" ]; then
    wget "${AUTOCONF}" -O "${AUTOCONF_CACHE}"
fi

AUTOCONF_BUILD="${BUILD_FOLDER}/$(echo ${AUTOCONF} | awk -F/ '{print $NF}' | awk -F. 'sub(FS $NF,x)' | awk -F. 'sub(FS $NF,x)')"

mkdir -p "$BUILD_FOLDER"
if [ ! -e "${AUTOCONF_BUILD}" ]; then
    cd "${BUILD_FOLDER}"
    tar xvfvz "${AUTOCONF_CACHE}"

    cd "${AUTOCONF_BUILD}"

    ./configure
    make
    make install
fi

echo 'Finished installing autoconf 2.69'
# End of Autotools Setup

# Start of JDK Setup
echo 'Installing JDK 1.8.0'
yum -y install java-1.8.0-openjdk >/dev/null
yum -y install java-1.8.0-openjdk-devel >/dev/null

if [[ -f '/root/.bashrc' ]] && ! grep -q 'export JAVA_HOME="/usr/lib/jvm/java"' /root/.bashrc; then
    echo 'export JAVA_HOME="/usr/lib/jvm/java"' >> /root/.bashrc
fi
if [[ -f '/etc/profile' ]] && ! grep -q 'export JAVA_HOME="/usr/lib/jvm/java"' /etc/profile; then
    echo 'export JAVA_HOME="/usr/lib/jvm/java"' >> /etc/profile
fi
echo 'Finished installing JDK 1.8.0'
# End of JDK Setup

# Start of Maven Initial Setup
echo 'Adding Maven'
MAVEN='http://apache.uberglobalmirror.com/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz'
MAVEN_CACHE="${CACHE_FOLDER}/$(echo ${MAVEN} | awk -F/ '{print $NF}')"
MAVEN_DIR_NAME="$(echo ${MAVEN} | awk -F/ '{print $NF}' | awk -F- 'sub(FS $NF,x)')"

mkdir -p "$CACHE_FOLDER"
if [ ! -e "${MAVEN_CACHE}" ]; then
    wget "${MAVEN}" -O "${MAVEN_CACHE}" >/dev/null
fi

mkdir -p "/tmp/maven"
cd /tmp/maven
tar -xzf "$MAVEN_CACHE"
cp -R "$MAVEN_DIR_NAME" /usr/local/maven

if [[ -f '/root/.bashrc' ]] && ! grep -q 'export PATH="$PATH:/usr/local/maven/bin"' /root/.bashrc; then
    echo 'export PATH="$PATH:/usr/local/maven/bin"' >> /root/.bashrc
fi
if [[ -f '/etc/profile' ]] && ! grep -q 'export PATH="$PATH:/usr/local/maven/bin"' /etc/profile; then
    echo 'export PATH="$PATH:/usr/local/maven/bin"' >> /etc/profile
fi

if [[ -f '/root/.bashrc' ]] && ! grep -q 'export M2_HOME="/usr/local/maven"' /root/.bashrc; then
    echo 'export M2_HOME="/usr/local/maven"' >> /root/.bashrc
fi
if [[ -f '/etc/profile' ]] && ! grep -q 'export M2_HOME="/usr/local/maven"' /etc/profile; then
    echo 'export M2_HOME="/usr/local/maven"' >> /etc/profile
fi
echo 'Finished adding Maven'
# End of Maven Initial Setup <<<
