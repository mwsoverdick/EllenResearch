# UPDATE MATLAB CODE IN GOOGLE DRIVE
echo "Updating MATLAB on Google Drive"

# Dangerous delete function
read -p "Delete contents first? [y/N]: " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Deleting all contents before copying..."
  rm -r -f ~/Google\ Drive/Ellen\ Research/MATLAB/*
fi

echo "Copying files..."
cp -r ./* ~/Google\ Drive/Ellen\ Research/MATLAB/

echo "Done!"
