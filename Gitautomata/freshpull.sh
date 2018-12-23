printstep(){
        BLUE='\033[0;34m'
        NC='\033[0m' # No Color

        echo -e "${BLUE} ${1} ${NC}"
}

# Config
# --------------------------------
MAINWEBSITE='konishi.pcmrhub.com'
FRONTEND='higala'
FRONTENDPORT=8080
BACKEND='zimmerman'
BACKENDPORT=4000
MAINFOLDER="/var/www"     # Webfolder housing all the websites
DEVFOLDER="/var/www/dev"  # Webfolder where sites are compiled

# Stop zimmerman and higala
# --------------------------------
printstep "Stopping Higala and Zimmerman"
fuser -k {/tcp
fuser -k 4000/tcp
printstep "Done"

# Get most recent code from github
# --------------------------------
printstep "Getting most recent code from origin/master"
cd $MAINFOLDER/${BACKEND}
git fetch --all
git reset --hard origin/master

cd $DEVFOLDER/${FRONTEND}
git fetch --all
git reset --hard origin/master
printstep "Done"

# Copy config files back
# --------------------------------
printstep "Copying config files back (need to separate config still)"
cp -a $MAINFOLDER/gitautomata/${BACKEND}/. $MAINFOLDER/${BACKEND}/
cp -a $MAINFOLDER/gitautomata/${FRONTEND}/. $DEVFOLDER/${FRONTEND}/


#Start zimmerman
# --------------------------------
printstep "Starting Zimmerman..."
cd $MAINFOLDER/${BACKEND}
source konishienv/bin/activate
python3 app.py &

# Start higala
# --------------------------------
printstep "Compiling Higala..."
cd ${DEVFOLDER}/${FRONTEND}
npm run build --fix

printstep "Copying dist files over..."
cp -rf {DEVFOLDER}/${FRONTEND}/dist/* {MAINFOLDER}/${MAINWEBSITE}/


