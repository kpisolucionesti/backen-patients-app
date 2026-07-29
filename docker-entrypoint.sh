#!/bin/sh
set -e

until rails runner "ActiveRecord::Base.connection" > /dev/null 2>&1; do
  sleep 2
done

rails db:migrate

rails db:seed 2>/dev/null || echo "Seed skipped (already seeded or error)"

exec "$@"
