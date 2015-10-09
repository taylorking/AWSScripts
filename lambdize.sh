#!/bin/bash


read -p "Function name? " name
echo "Available Roles:"
aws iam list-roles > .roles
cat .roles | grep "RoleName" | cut -d'"' -f4
read -p "Role? " role

role=$(cat .roles | grep $role | grep Arn |cut -d'"' -f4)
if [ "$1" = "" ]; then
  read -p "Do you need a skeleton? " answer
  if [ $answer == 'y' ]; then
    read -p "What do you want me to call the file? " fileName
    cat ~/.scripts/.skeleton.lambda > $(pwd)/$fileName
  else
    read -p "I need a file to create the function, give me the name of a file: " fileName
  fi
else 
  fileName=$1
fi
echo "I will now zip the file ($fileName) and prepare for upload.. " 
cp $(pwd)/$fileName $(pwd)/index.js  
zip $(pwd)/upload.zip $(pwd)/index.js
aws lambda create-function --function-name $name --runtime nodejs --role $role --handler index.handler --zip-file fileb://$(pwd)/upload.zip > .lambda.orig
rm upload.zip
