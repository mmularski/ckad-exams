#!/bin/bash
set -e

CHECKLIST=prep/peer-review-checklist.md
README=answer/README.md

if ! [ -f "$CHECKLIST" ]; then
  echo ""
  echo "❌ [FAIL] Checklist $CHECKLIST not found."
  echo ""
  exit 1
fi
if ! [ -f "$README" ]; then
  echo ""
  echo "❌ [FAIL] README $README not found."
  echo ""
  exit 1
fi

UNCHECKED=$(grep -c '\[ \]' "$CHECKLIST")
if [ "$UNCHECKED" -eq 0 ]; then
  echo "✅ [PASS] All checklist items are checked."
else
  echo ""
  echo "❌ [FAIL] There are unchecked items in the checklist."
  echo ""
  exit 1
fi

if [ -s "$README" ]; then
  echo ""
  echo "✅ [PASS] README exists and is not empty."
  echo ""
  exit 0
else
  echo ""
  echo "❌ [FAIL] README is empty."
  echo ""
  exit 1
fi