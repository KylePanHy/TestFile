#! /bin/bash

targetFile="token_validation_sh.json"

targetPath="${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}/${targetFile}"

getLicense=""

function CheckXcodeEnv {

  if [ -z "$BUILT_PRODUCTS_DIR" ] ; then
	  echo "Lose 'BUILT_PRODUCTS_DIR' setting."
	  exit 1
  fi

  if [ -z "$FULL_PRODUCT_NAME" ] ; then
	  echo "Lose 'FULL_PRODUCT_NAME' setting."
	  exit 1
  fi

}

function CheckCmd {
	curlCmd=$(command -v curl)
	if [ -z "$curlCmd" ] ; then
	  echo "Install curl first."
		exit 1
	fi
}

function RequestLicense {

  local request="curl -X 'GET' \
               'https://hra2-api-dev.hylink.io/sdk_license?user_id=$1' \
               -H 'accept: application/json'
               "

	token=$(eval "$request")

	if [ -e "$token" ]; then
	    echo "This token $1 was invalid."
	    exit 1
	fi

	echo "$token"
}

function CreateFile {

	if [ -e "$targetPath" ] ; then
		rm -f "$targetPath"
		echo "Remove the exist license file, refreshing."
	fi

	echo '{"tokenInfo": '"$getLicense"'}' > "$targetPath"
}

echo "=========== license request start. =========="

userToken=$HYENA_TOKEN

if [ -z "$userToken" ] ; then 
	echo "Please entry your token."
	exit 1
fi

CheckXcodeEnv

CheckCmd

getLicense=$(RequestLicense "$userToken")

CreateFile

echo "=========== license request finish. =========="

