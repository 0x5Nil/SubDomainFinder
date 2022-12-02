#!/bin/bash

if [ $# -eq 0 ]
then
  echo "How to use : $0 <DOMAIN>"
  echo "Example : $0 www.google.com"
else
  rm ips.txt sub_domains.txt index* 2>/dev/null

  domain_name=$(echo $1 | cut -d"." -f2)
  wget $1 2>/dev/null && cat index.html | grep "href=" | cut -d":" -f2 | cut -d"/" -f3 | grep $domain_name | grep -v "$1" | cut -d'"' -f1 | uniq >  sub_domains.txt
  # check if the file not empty
  if [ -s sub_domains.txt ] 
  then
      # loop throught sub dominas to get the ip's
      for domain in $(cat sub_domains.txt)
      do
	 if [[ $(ping -c 1 $domain 2>/dev/null) ]]
	 then
	     echo -e "\e[1A\e[KDealing with: $domain"
	     host $domain | cut -d" " -f4 >> ips.txt
	 fi
      done
      echo "\e[1A\e[DONE!"
  else
     echo "sub_domains.txt is Empty!"
  fi
fi
