echo "What files change the most? (last year)"
jj log --no-graph -r 'ancestors(trunk()) & committer_date(after:"1 year ago")' \
  -T 'self.diff().files().map(|f| f.path() ++ "\n").join("")' \
  | sort | uniq -c | sort -nr | head -30

echo "What files change the most? (all time)"
jj log --no-graph -r 'ancestors(trunk())' \
  -T 'self.diff().files().map(|f| f.path() ++ "\n").join("")' \
  | sort | uniq -c | sort -nr | head -30

echo "Who built this?"
jj log --no-graph -r 'ancestors(trunk()) & ~merges()' \
  -T 'self.author().name() ++ "\n"' \
  | sort | uniq -c | sort -nr

echo "Where do bugs cluster?"
jj log --no-graph -r 'ancestors(trunk()) & description(regex:"(?i)fix|bug|broken")' \
      -T 'self.diff().files().map(|f| f.path() ++ "\n").join("")' \
      | sort | uniq -c | sort -nr | head 

echo "Accelerating or dying?"
jj log --no-graph -r 'ancestors(trunk())' \
      -T 'self.committer().timestamp().format("%Y") ++ "\n"' \
      | sort | uniq -c
