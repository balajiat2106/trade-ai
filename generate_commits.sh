#!/bin/bash

# ---- CONFIG ----
start_date="2025-10-10"
end_date=$(date +%Y-%m-%d)

# Files to rotate (keeps repo looking realistic)
files=("data.json" "metrics.log" "notes.md" "pipeline.py" "config.yaml")

messages=(
  "feat: add feature engineering step"
  "perf: optimize inference latency"
  "feat: integrate model scoring"
  "refactor: modularize pipeline"
  "chore: update experiment logs"
  "fix: edge case in prediction flow"
)

current_date=$start_date

# ---- LOOP THROUGH DATES ----
while [ "$(date -d "$current_date" +%s)" -le "$(date -d "$end_date" +%s)" ]
do
  # Randomly skip some days (~20%)
  if [ $((RANDOM % 5)) -eq 0 ]; then
    current_date=$(date -I -d "$current_date + 1 day")
    continue
  fi

  # Random commits per day (1–4)
  commits=$(( (RANDOM % 4) + 1 ))

  for ((i=1; i<=commits; i++))
  do
    # Pick random file
    file=${files[$RANDOM % ${#files[@]}]}

    # Create/update content
    case $file in
      "data.json")
        echo "{ \"value\": $RANDOM, \"date\": \"$current_date\" }" >> $file
        ;;
      "metrics.log")
        echo "$current_date | accuracy=$((RANDOM % 100)) | latency=$((RANDOM % 300))ms" >> $file
        ;;
      "notes.md")
        echo "## Update on $current_date - iteration $i" >> $file
        ;;
      "pipeline.py")
        echo "# update $current_date iteration $i" >> $file
        ;;
      "config.yaml")
        echo "param_$RANDOM: $RANDOM" >> $file
        ;;
    esac

    git add $file

    # Random hour/min/sec
    hour=$(shuf -i 9-18 -n 1)
    min=$(shuf -i 10-59 -n 1)
    sec=$(shuf -i 10-59 -n 1)

    timestamp="$current_date $hour:$min:$sec"

    # Random commit message
    msg=${messages[$RANDOM % ${#messages[@]}]}

    GIT_AUTHOR_DATE="$timestamp" \
    GIT_COMMITTER_DATE="$timestamp" \
    git commit -m "$msg ($current_date)"
  done

  current_date=$(date -I -d "$current_date + 1 day")
done

echo "Done generating commits from $start_date to $end_date"