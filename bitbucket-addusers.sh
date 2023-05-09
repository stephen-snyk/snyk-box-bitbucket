#!/bin/bash
ABORT="N"
case "$1" in
  "") echo "Usage: AddUsers.sh Admin_UserName Admin_Password"
      ABORT="Y";;
  * ) USERNAME=$1;;
esac

if [ "$ABORT" == 'N' ]; then
  case "$2" in
    "") echo "Usage: AddUsers.sh Admin_UserName Admin_Password"
        ABORT="Y";;
    * ) PASSWORD=$2;;
  esac
fi
 
if [ "$ABORT" == 'N' ]; then
  clear
  while read -r a b c d; do
    echo "User: $a"
    curl -u $USERNAME:$PASSWORD -X POST -H "Content-Type: application/json" "http://localhost:7990/bitbucket/rest/api/1.0/admin/users?name=$a&password=$b&displayName=$c&emailAddress=$d&addToDefualtGroup=true&notify=false"
  done < users.txt
fi
