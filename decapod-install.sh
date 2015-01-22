if [ -z $1 ] || [ ! -d $1 ]; then
    echo "Please specify a parent directory"
    exit 1
else
  sudo apt-get update

  if [ ! $(hash hg 2>/dev/null) ]; then
    sudo apt-get -y install mercurial
  else
    sudo apt-get upgrade mercurial
  fi

  while read line; do
    INSTALLED=$(dpkg -L $line 2>&1) | grep "is not installed"
    if [ $? -eq 0 ]
    then
      echo "Installing: $line"
      sudo apt-get -y install $line
    fi
  done <dependencies.txt

  cd $1
  hg clone --insecure https://decapod.googlecode.com/hg/ -r decapod-0.7 decapod-0.7

  if [ -d $1/decapod-0.7/install-scripts ]; then
    cd $1/decapod-0.7/install-scripts/

    echo "Y" | sudo ./decapod-all.sh
  else
    echo "Unable to clone decapod"
  fi
fi
