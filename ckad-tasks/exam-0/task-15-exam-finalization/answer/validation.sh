#!/bin/bash
set -e

CHECKLIST=prep/peer-review-checklist.md
README=answer/README.md

if ! [ -f "$CHECKLIST" ]; then
  echo "[FAIL] Checklist $CHECKLIST not found."
  exit 1
fi
if ! [ -f "$README" ]; then
  echo "[FAIL] README $README not found."
  exit 1
fi

UNCHECKED=$(grep -c '\[ \]' "$CHECKLIST")
if [ "$UNCHECKED" -eq 0 ]; then
  echo "[PASS] All checklist items are checked."
else
  echo "[FAIL] There are unchecked items in the checklist."
  exit 1
fi

if [ -s "$README" ]; then
  echo "[PASS] README exists and is not empty."
  exit 0
else
  echo "[FAIL] README is empty."
  exit 1
fi