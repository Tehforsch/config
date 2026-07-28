#!/usr/bin/env bash

# Address completion script for aerc using notmuch and synced CardDAV vcards.

search_term="$1"
contacts_dir="$HOME/.local/share/dav/contacts/personal"

if [ -z "$search_term" ]; then
    exit 0
fi

{
    notmuch address '*' 2>/dev/null | grep -i "$search_term" || true

    if [ -d "$contacts_dir" ]; then
        find "$contacts_dir" -type f -name '*.vcf' -print0 |
            while IFS= read -r -d '' card; do
                awk -v query="$search_term" '
                    function unescape_vcard(value) {
                        gsub(/\\,/, ",", value)
                        gsub(/\\;/, ";", value)
                        gsub(/\\n/, " ", value)
                        return value
                    }

                    BEGIN {
                        query = tolower(query)
                    }

                    tolower($0) ~ /^fn[;:]/ {
                        name = $0
                        sub(/^[Ff][Nn][^:]*:/, "", name)
                        name = unescape_vcard(name)
                    }

                    tolower($0) ~ /^email[;:]/ {
                        email = $0
                        sub(/^[Ee][Mm][Aa][Ii][Ll][^:]*:/, "", email)
                        emails[++email_count] = email
                    }

                    END {
                        for (i = 1; i <= email_count; i++) {
                            line = name ? name " <" emails[i] ">" : emails[i]
                            if (index(tolower(line), query) > 0) {
                                print line
                            }
                        }
                    }
                ' "$card"
            done
    fi
} | awk '!seen[tolower($0)]++'
