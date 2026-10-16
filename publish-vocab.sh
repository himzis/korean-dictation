#!/bin/bash
# Validate and publish vocab.json to the live site.
set -e
cd "$(dirname "$0")"
python3 -c "import json;d=json.load(open('vocab.json'));assert all({'ko','rom','en','current'}<=set(w) for w in d['words']);print(sum(w['current'] for w in d['words']),'current words')"
git add vocab.json
git diff --cached --quiet && { echo "No changes"; exit 0; }
git -c user.name=himzis -c user.email=himzis@users.noreply.github.com commit -qm "Update vocab"
git push -q && echo "Published; live in about a minute."
