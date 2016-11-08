wvdial >/dev/null 2>&1 &
route add -net x.x.x.x/x dev ppp0 #to be finished

###########copied from the internet, will need some work
MODEM_STORAGE="12d1:14fe"
MODEM_MODEM="12d1:1506"

# 0 = storage, 1= modem
MODEM_MODE=0

check_modem_mode () {
 echo -n "Checking modem presence... "

 lsusb | grep --quiet "$MODEM_STORAGE"

 if [ $? -eq 0 ]; then
  MODEM_MODE=0
  echo "OK: modem in mass storage mode"
 else
  lsusb | grep --quiet "$MODEM_MODEM"
  if [ $? -eq 0 ]; then
   MODEM_MODE=1
   echo "OK: modem in modem mode"
  else
   echo "ERROR: modem not found"
   exit 1
  fi
 fi
}

set_modem_mode () {
 while [ $MODEM_MODE -eq 0 ]
 do
  echo -n "Setting modem mode... "
  usb_modeswitch -s 15 -I -H -c /etc/usb_modeswitch.conf >/dev/null 2>&1
  lsusb | grep --quiet "$MODEM_MODEM"
  if [ $? -eq 0 ]; then
   MODEM_MODE=1
   echo "OK"
  else
   echo "FAILED"
  fi
 done
}
