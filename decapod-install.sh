keys="[hostfingerprints]\ngenpdf.decapod.googlecode.com = fb:5e:a9:2b:52:35:25:c8:05:be:b1:19:41:d2:0f:1a:00:9f:56:a5\nserver.decapod.googlecode.com = fb:5e:a9:2b:52:35:25:c8:05:be:b1:19:41:d2:0f:1a:00:9f:56:a5\nui.decapod.googlecode.com = fb:5e:a9:2b:52:35:25:c8:05:be:b1:19:41:d2:0f:1a:00:9f:56:a5"
if [ -z $1 ] || [ ! -d $1 ]; then
    echo "Please specify a parent directory"
    exit 1
else
  if [ ! $(hash hg 2>/dev/null) ]; then
    sudo apt-get -y install mercurial
  fi
  if [ ! -f /etc/mercurial/hgrc ] || (
    ! grep "genpdf\.decapod" /etc/mercurial/hgrc >/dev/null 2>&1 &&
    ! grep "server\.decapod" /etc/mercurial/hgrc >/dev/null 2>&1 &&
    ! grep "ui\.decapod" /etc/mercurial/hgrc >/dev/null 2>&1 ); then
    echo "$keys" | sudo tee -a /etc/mercurial/hgrc >> /dev/null
  fi
  cd $1
  hg clone https://decapod.googlecode.com/hg/ -r decapod-0.7 decapod-0.7
  if [ -d $1/decapod-0.7/install-scripts ]; then
    cd $1/decapod-0.7/install-scripts/
    sudo ./decapod-all.sh
  else
    echo "Unable to clone decapod"
  fi
fi
