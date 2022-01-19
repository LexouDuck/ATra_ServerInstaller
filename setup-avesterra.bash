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

# Move to /AvesTerra
cd /AvesTerra/Executables

# ---------- LAUNCH AVESTERRA SERVER(BEGIN) -----------
sudo systemctl start avesterra.service
sleep 5
# ---------- LAUNCH AVESTERRA SERVER(END) -----------

# ---------- CONFIGURE SERVER(BEGIN) -----------
MASTER_AUTH="$( ./avu run /AvesTerra/Local/configure.txt 0 | grep -E '^[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+$' )"
# ---------- CONFIGURE SERVER(END) -----------

# ---------- LAUNCH UNIVERSAL ADAPTERS(BEGIN) -----------
sudo systemctl start avial_authenticator.service
sudo systemctl start avial_files.service
sudo systemctl start avial_folders.service
sudo systemctl start avial_objects.service
sudo systemctl start avial_registries.service
sudo systemctl start avial_trash.service
sleep 5
# ---------- LAUNCH UNIVERSAL ADAPTERS(END) -----------

# ---------- START ATRA EXECUTABLES(BEGIN) -----------
sudo systemctl start atra.service
# ---------- START ATRA EXECUTABLES(END) -----------
