#!/bin/bash

# READ AUTH
if [ -f "/root/TELEXWRT/AUTH" ]; then
  IFS=$'\n' read -d '' -r -a lines < "/root/TELEXWRT/AUTH"
  if [ "${                         
    BOT_TOKEN="${lines[0]}"
    USER_ID="${lines[1]}"
  else
    echo "Berkas token.txt harus memiliki setidaknya 2 baris (token dan chat ID Anda)."
    exit 1
  fi
else
  echo "Berkas token tidak ditemukan."
  exit 1
fi

             
SERVER=("www.google.com")
while true
do
  messages=()
  failed=0
  for server in "${SERVER[@]}"
  do
    result=$(httping -c 1 $server)
    if [ $? -eq 0 ]; then
      ping=$(echo "$result" | awk -F'/' 'END {printf "%.0f", $5}')
      messages+=("ping $server 📈 $ping ms")
    else
      messages+=("Failed ❌")
      failed=$((failed + 1))
    fi
  done

  MSG=""
  for msg in "${messages[@]}"
  do
    MSG+="$msg "
  done

                  
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$USER_ID&text=$MSG"

  sleep 30
done
