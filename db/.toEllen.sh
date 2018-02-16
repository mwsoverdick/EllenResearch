# UPDATE MATLAB CODE ON ELLENS FLASH DRIVE
echo "Updating db on /Volumes/Ellen"

# Dangerous delete function
read -p "Delete contents first? [y/N]: " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Deleting all contents before copying..."
  rm -r -f /Volumes/Ellen/EllenResearch/db/*
fi

echo "Copying files..."
cp -r ./* /Volumes/Ellen/EllenResearch/db/

echo "Done!"
