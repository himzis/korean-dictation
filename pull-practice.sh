#!/bin/bash
# Pull Wayne's practice events from ntfy (cached ~12h) into practice-log.jsonl, deduped. Prints a summary.
cd "$(dirname "$0")"
T=$(cat .ntfy-topic)
touch practice-log.jsonl
curl -s "https://ntfy.sh/$T/json?poll=1&since=all" | python3 -c '
import sys,json
seen=set()
for l in open("practice-log.jsonl"):
  try: seen.add(json.loads(l)["_id"])
  except: pass
new=0
with open("practice-log.jsonl","a") as f:
  for l in sys.stdin:
    m=json.loads(l)
    if m.get("event")!="message" or m["id"] in seen: continue
    try: evs=json.loads(m["message"])
    except: continue
    if not isinstance(evs,list): continue
    for i,e in enumerate(evs):
      e["_id"]=m["id"] if i==0 else m["id"]+"#"+str(i); seen.add(m["id"])
      f.write(json.dumps(e,ensure_ascii=False)+"\n"); new+=1
print(new,"new events")
'
python3 summarize-practice.py "$@"
