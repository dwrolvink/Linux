printstep(){
        BLUE='\033[0;34m'
        REEE='\033[0;31m'
        NC='\033[0m' # No Color

        ERROR=1

        if [[ $2 -eq $ERROR ]];
        then
              echo -e "${REEE} ${1} ${NC}"
        else
              echo -e "${BLUE} ${1} ${NC}"
        fi
}

