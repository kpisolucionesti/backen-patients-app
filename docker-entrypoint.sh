#!/bin/sh
set -e

until rails runner "ActiveRecord::Base.connection" > /dev/null 2>&1; do
  sleep 2
done

rails db:migrate

if [ "$(rails runner "puts ActiveRecord::Base.connection.table_exists?('legacy.patients')" 2>/dev/null)" = "true" ]; then
  if [ "$(rails runner "puts Patient.count" 2>/dev/null)" = "0" ]; then
    echo ">> Importando datos legacy..."
    rails import_legacy_data:import
  else
    echo ">> Datos legacy ya importados, saltando..."
  fi
else
  echo ">> Schema legacy no encontrado, saltando importación..."
fi

exec "$@"
