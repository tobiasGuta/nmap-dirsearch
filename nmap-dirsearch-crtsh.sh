#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <domain> <nmap-only|directory-only|crtsh-only|all>"
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
    crtsh-only)
        echo "Enumerating subdomains with crt.sh..."
        crtsh_enum=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u)
        echo "$crtsh_enum" > "$Directory/crtsh_subdomains"
        echo "Crt.sh enumeration results saved in $Directory/crtsh_subdomains."
        ;;
    all)
        nmap $EXTRA_ARGS "$DOMAIN" > "$Directory/nmap"
        echo "The results of nmap are stored in $Directory/nmap."
        dirsearch -u "$DOMAIN" $EXTRA_ARGS -o "$Directory/dirsearch"
        echo "The results of dirsearch are stored in $Directory/dirsearch"
        echo "Enumerating subdomains with crt.sh..."
        crtsh_enum=$(curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u)
        echo "$crtsh_enum" > "$Directory/crtsh_subdomains"
        echo "Crt.sh enumeration results saved in $Directory/crtsh_subdomains."
        ;;
    *)
        echo "Invalid option. Use 'nmap-only', 'directory-only', 'crtsh-only', or 'all'."
        exit 1
        ;;
esac
