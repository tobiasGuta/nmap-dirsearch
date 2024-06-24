#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <domain> <nmap-only|directory-only|both> [additional-options]"
    exit 1
fi

DOMAIN=$1
OPTION=$2
shift 2  
EXTRA_ARGS="$@"

TODAY=$(date)
echo "This scan was created on $TODAY"

Directory="${DOMAIN//:/_}_recon"
echo "Creating directory $Directory"
mkdir -p "$Directory"

case $OPTION in
    nmap-only)
        nmap $EXTRA_ARGS "$DOMAIN" > "$Directory/nmap"
        echo "The results of nmap are stored in $Directory/nmap."
        ;;
    directory-only)
        dirsearch -u "$DOMAIN" $EXTRA_ARGS -o "$Directory/dirsearch"
        echo "The results of dirsearch are stored in $Directory/dirsearch"
        ;;
    both)
        nmap $EXTRA_ARGS "$DOMAIN" > "$Directory/nmap"
        echo "The results of nmap are stored in $Directory/nmap."
        dirsearch -u "$DOMAIN" $EXTRA_ARGS -o "$Directory/dirsearch"
        echo "The results of dirsearch are stored in $Directory/dirsearch"
        ;;
    *)
        echo "Invalid option. Use 'nmap-only', 'directory-only', or 'both'."
        exit 1
        ;;
esac
