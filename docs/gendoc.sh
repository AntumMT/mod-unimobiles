#!/bin/bash

DOCS="$(dirname $(readlink -f $0))"
ROOT="$(dirname ${DOCS})"
CONFIG="${DOCS}/config.ld"

SCRIPTS="api.lua init.lua"

cd "${ROOT}"

# Clean old files
rm -rf "${DOCS}/api.html" "${DOCS}/scripts" "${DOCS}/modules"
# Create new files
ldoc -i -O -c "${CONFIG}" -d "${DOCS}" -o "api" ${SCRIPTS}

