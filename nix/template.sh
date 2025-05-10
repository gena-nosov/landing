set -euo pipefail
set -a
. $1
set +a
envsubst -no-unset -i $2
