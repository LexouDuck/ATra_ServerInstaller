#############################################################

#   This script is used to launch and configure AvesTerra
#   and should only be run once; if run multiple times,
#   the /AvesTerra/Data directory should be deleted, and
#   then this script should be run again.

#   NOTE: This script should not be moved away from where
#   it is; I wrote this script assuming it wouldn't move
#   away from where I put it.

#   NOTE 2.0: You can run this script before the formal ATra
#   test, however, if you run it/practice setting up the server,
#   you should completely delete the /AvesTerra/Data folder
#   once you have practiced with it.

#   NOTE 3.0: The configuration files are key to a successful
#   deployment of AvesTerra, so make sure to use J's
#   stable/confirmed configuration files when the time comes
#   for a formal test.

#############################################################

# Clean out old /AvesTerra/Data folder
sudo rm -rf /AvesTerra/Data

# Move to /AvesTerra/Executables
cd /AvesTerra/Executables

# ---------- LAUNCH AVESTERRA SERVER(BEGIN) -----------
sudo systemctl enable avesterra
sudo systemctl start avesterra
sleep 5
# ---------- LAUNCH AVESTERRA SERVER(END) -----------

# ---------- CONFIGURE SERVER(BEGIN) -----------
sudo /AvesTerra/Executables/./avu run /AvesTerra/Local/configure.txt 0
# ---------- CONFIGURE SERVER(END) -----------

# ---------- START ADAPTERS ON BOOT -----------
sudo systemctl enable avial_compartments
sudo systemctl enable avial_files
sudo systemctl enable avial_folders
sudo systemctl enable avial_objects
sudo systemctl enable avial_registries
sudo systemctl enable avial_trash
sudo systemctl enable avial_generals
sudo systemctl enable avial_boost
# ---------- START ADAPTERS ON BOOT(END) -----------

# ---------- LAUNCH UNIVERSAL ADAPTERS(BEGIN) -----------
sudo systemctl start avial_registries
sudo systemctl start avial_objects
sudo systemctl start avial_folders
sudo systemctl start avial_files
sudo systemctl start avial_generals
sudo systemctl start avial_compartments
sudo systemctl start avial_trash
sudo systemctl start avial_boost
sleep 5
# ---------- LAUNCH UNIVERSAL ADAPTERS(END) -----------

# ---------- START ATRA EXECUTABLES(BEGIN) -----------
sudo systemctl enable atra
sudo systemctl start atra
sleep 5
# ---------- START ATRA EXECUTABLES(END) -----------
