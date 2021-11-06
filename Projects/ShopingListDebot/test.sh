if [[ $1 == ""  ]] ; then 
    echo "Error: contract address required!"
    echo "Usage: ${0} <address>"
    exit 1
fi
DEBOT_ADDRESS=${1}
NETWORK="http://127.0.0.1"

echo "Run bot on address: $DEBOT_ADDRESS"
tonos-cli --url $NETWORK debot fetch $DEBOT_ADDRESS