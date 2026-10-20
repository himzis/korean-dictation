import json,sys,collections,datetime
days=int(sys.argv[1]) if len(sys.argv)>1 else 7
cut=datetime.datetime.now(datetime.timezone.utc)-datetime.timedelta(days=days)
S=collections.defaultdict(lambda:collections.Counter())
heard=collections.defaultdict(list)
for l in open("practice-log.jsonl"):
  e=json.loads(l)
  if datetime.datetime.fromisoformat(e["t"].replace("Z","+00:00"))<cut: continue
  k=e["ko"]
  if e["ev"] in ("try","sound"):
    S[k]["tries"]+=1;S[k]["ok"]+=e["ok"]
    if not e["ok"]: heard[k].append(e["heard"])
  else: S[k][e["ev"]]+=1
print(f"Last {days} days, per phrase:")
for k,c in S.items():
  print(f"- {k}: tries {c['tries']}, correct {c['ok']}, mastered {c['mastered']}, hints {c['hint']}, skips {c['skip']}"+(f"; misheard as: {', '.join(heard[k][-3:])}" if heard[k] else ""))
