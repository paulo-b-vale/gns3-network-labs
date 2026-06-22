#!/bin/bash
set -euo pipefail

USERNAME="${1:?Usage: $0 <username> <new-plan-groupname> <bras-ip>}"
NEW_PLAN="${2:?Usage: $0 <username> <new-plan-groupname> <bras-ip>}"
BRAS_IP="${3:?Usage: $0 <username> <new-plan-groupname> <bras-ip>}"

MYSQL_CONTAINER="radius-mysql"
MYSQL_USER="radius"
MYSQL_PASS="radiuspass-lab-2026"
MYSQL_DB="radius"

FREERADIUS_CONTAINER="freeradius"
COA_SECRET="lab-radius-secret-2026"
COA_PORT="3799"

echo "==> Step 1: looking up new plan's Mikrotik-Rate-Limit in MySQL"
RATE_LIMIT=$(docker exec -i "$MYSQL_CONTAINER" mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB" -N -B \
    -e "SELECT value FROM radgroupreply WHERE groupname = '${NEW_PLAN}' AND attribute = 'Mikrotik-Rate-Limit';")

if [ -z "$RATE_LIMIT" ]; then
    echo "ERROR: plan '${NEW_PLAN}' not found in radgroupreply"
    exit 1
fi
echo "    Plan '${NEW_PLAN}' = ${RATE_LIMIT}"

echo "==> Step 2: updating ${USERNAME}'s group assignment in radusergroup"
docker exec -i "$MYSQL_CONTAINER" mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB" \
    -e "UPDATE radusergroup SET groupname = '${NEW_PLAN}' WHERE username = '${USERNAME}';"
echo "    Done - this is now the permanent record."

echo "==> Step 3: pushing CoA to ${BRAS_IP}:${COA_PORT} to apply it live"
COA_OUTPUT=$(docker exec -i "$FREERADIUS_CONTAINER" radclient -x "${BRAS_IP}:${COA_PORT}" coa "$COA_SECRET" <<EOF
User-Name = ${USERNAME}
Mikrotik-Rate-Limit = "${RATE_LIMIT}"
EOF
)

echo "$COA_OUTPUT"

if echo "$COA_OUTPUT" | grep -q "CoA-ACK"; then
    echo "==> SUCCESS: ${USERNAME} is now on ${NEW_PLAN} (${RATE_LIMIT}), applied live without disconnecting."
else
    echo "==> WARNING: database updated, but CoA did not get an ACK."
fi
