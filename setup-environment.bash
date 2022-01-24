#######################################################################
#   Please run this install script from where it was found,
#   because when I designed this script, I made assumptions
#   as to where certain files and folders could be found, without
#   using the rigid structure of Absolute Paths, due to the fact
#   I do not understand the File/Folder permissions on the ATra
#   test/production servers.

#   NOTE: The Configuration files are still "In-Flux", meaning that
#   they are still being worked on by J at this point.  He or I will
#   provide you with the correct configuration files when the time
#   comes to actually launch a test.

#   NOTE 2.0: Please use the provided WolfSSL directory to install it.
#   If you want to know where to get your own copy, then look up
#   WolfSSL 4.8.0 on Google; you will be able to download it
#   from GitHub.  This is the newest version of WolfSSL that works
#   with J's AvesTerra server; newer versions have linking issues
#   which will be addressed once I talk to J about updating his
#   WolfSSL version for builds.
#######################################################################

# CHANGE THIS FOLDER PATH TO WHERE YOU ARE STORING
# THE avesterra.pem, server.key, and server.pem FILES
# Below is an example, where my script will look
# in the relative path of ~/ATra/Certificates
# for the key/cert files.  You should replace the
# path below with the path to the folder that stores
# the specified key/cert files.
AVESTERRA_CERT_KEY_DIR_PATH="$HOME/Certificates"

# ---------- DEPENDENCY INSTALLATION(BEGIN) -----------
echo "Started AvesTerra Dependency Installation Process"
# Yum package installs
sudo yum install -y unzip gcc make autoconf automake
echo "Completed AvesTerra Dependency Installation Process"
# ---------- DEPENDENCY INSTALLATION(END) -----------


# ---------- WOLFSSL INSTALLATION(START) --------
echo "Started WolfSSL Installation Process"
# Extract and install WolfSSL
cd wolfssl-4.8.0-stable/

# Autogen.sh
./autogen.sh

# Configure, build, and install
# (For more info, check the INSTALL file in the wolfssl-5.0.0 directory)
./configure --enable-tls13
make
sudo make install

# Add WolfSSL Install directory path to (The linker)'s
# configuration management directory
sudo touch /etc/ld.so.conf.d/wolfssl.conf
sudo bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/wolfssl.conf'

# Save changes to the linker config
sudo ldconfig

# Get out of wolfssl-5.0.0 directory for future relative path operations
cd ..
echo "Completed WolfSSL Installation Process"
# ---------- WOLFSSL INSTALLATION(END) --------


# ---------- AVESTERRA DIRECTORY SETUP(BEGIN) --------
echo "Started AvesTerra Directory Creation Process"
sudo mkdir -p /AvesTerra/
sudo mkdir -p /AvesTerra/Certificates
sudo mkdir -p /AvesTerra/Executables
sudo mkdir -p /AvesTerra/Local
sudo mkdir -p /AvesTerra/Templates

# Chown the directory, to remove root privileges
# from the Executables
sudo chown -R $USER:$USER /AvesTerra
echo "Completed AvesTerra Directory Creation Process"
# ---------- AVESTERRA DIRECTORY SETUP(END) --------


# ---------- AVESTERRA EXECUTABLE SETUP(BEGIN) --------
echo "Started AvesTerra Executable Loading Process"
sudo cp ./ATerra/Executables/* /AvesTerra/Executables
echo "Completed AvesTerra Executable Loading Process"
# ---------- AVESTERRA EXECUTABLE SETUP(END) --------


# ---------- SERVICE CREATION(BEGIN) --------
echo "Started AvesTerra Service Loading Process"
sudo cp ./ATerra/Services/* /etc/systemd/system
sudo systemctl daemon-reload
echo "Completed AvesTerra Service Loading Process"
# ---------- SERVICE CREATION(END) --------


# ---------- COPY AVESTERRA CONFIGS(BEGIN) --------
echo "Started AvesTerra Configuration File Loading Process"
cp ./ATerra/Config/* /AvesTerra/Local
echo "Completed AvesTerra Configuration File Loading Process"
# ---------- COPY AVESTERRA CONFIGS(END) --------

# ---------- COPY AVESTERRA TEMPLATES(BEGIN) --------
echo "Started AvesTerra Template File Loading Process"
cp ./ATerra/Templates/* /AvesTerra/Templates
echo "Completed AvesTerra Template File Loading Process"
# ---------- COPY AVESTERRA TEMPLATES(END) --------


# ---------- LINKING AVESTERRA (YOUR AVESTERRA GENERATED CERTIFICATES/KEYS)(BEGIN) --------
echo "Started AvesTerra CERT/KEY File Linking Process"

# Clean out the old links!
rm -f /AvesTerra/Certificates/*

# If avesterra.pem isn't in the source dir, then error, else link
if [ "$( ls -la $AVESTERRA_CERT_KEY_DIR_PATH | grep 'avesterra.pem')" ]; then
  ln -s $AVESTERRA_CERT_KEY_DIR_PATH/avesterra.pem /AvesTerra/Certificates/avesterra.pem
else
  printf "Error: The file $AVESTERRA_CERT_KEY_DIR_PATH/avesterra.pem doesn't exist" >&2
  exit -1
fi

# If server.pem isn't in the source dir, then error, else link
if [ "$( ls -la $AVESTERRA_CERT_KEY_DIR_PATH | grep 'server.pem')" ]; then
  ln -s $AVESTERRA_CERT_KEY_DIR_PATH/server.pem /AvesTerra/Certificates/server.pem
else
  printf "Error: The file $AVESTERRA_CERT_KEY_DIR_PATH/server.pem doesn't exist" >&2
  exit -1
fi

# If avesterra.key isn't in the source dir, then error, else link
if [ "$( ls -la $AVESTERRA_CERT_KEY_DIR_PATH | grep 'server.key')" ]; then
  ln -s $AVESTERRA_CERT_KEY_DIR_PATH/server.key /AvesTerra/Certificates/server.key
else
  printf "Error: The file $AVESTERRA_CERT_KEY_DIR_PATH/server.key doesn't exist" >&2
  exit -1
fi
echo "Completed AvesTerra CERT/KEY File Linking Process"
# ---------- LINKING AVESTERRA (YOUR AVESTERRA GENERATED CERTIFICATES/KEYS)(BEGIN) --------
