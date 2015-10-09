#!/bin/bash
read -p "Function name? " name
echo "Available Roles:"
aws iam list-roles | grep RoleName | cut -d'"' -f 4
read -p "Role? " role
read -p "Do you need a skeleton? " answer
if [ $answer -eq 'y' ]; then
  read -p "What do you want me to call the file?" fileName
  cat ~/.scripts/.skeleton.lambda > $fileName
  aws lambda create-function --function-name $name --runtime nodejs --role $role --handler index.handler --code=$fileName
else; then
  if [ -n $1 ]; then 
    fileName = $1
  else; then
  read -p "I need a file to create the function, give me the name of a file" fileName
  fi
  aws lambda create-function --function-name $name --runtime nodejs --role $role --handler index.handler --code=$fileName
fi
