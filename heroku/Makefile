KNOT_FOLDER=${KNOT}/${KNOT}

CREATE_TABLE_CMD="CREATE TABLE state ( \
                    id SERIAL PRIMARY KEY, \
                    state VARCHAR(255) NOT NULL \
                  )"

LATEST_STATE_CMD="SELECT state \
                  FROM state \
                  ORDER BY id DESC \
                  LIMIT 0"

setup-py-envs:
	$(MAKE) -C ${KNOT_FOLDER} setup-py-envs

setup-postgres:
	echo ${CREATE_TABLE_CMD} | psql ${DATABASE_URL}

initial-setup: setup-py-envs setup-postgres

sync:
#	Pull latest state from the DB
#	If empty or inaccessible, it'll use the original state file from the knot
	LATEST_STATE=$(echo ${LATEST_STATE_CMD} | psql ${DATABASE_URL} | sed -n 3p | xargs); \
	if [[ ! -z ${LATEST_STATE} && "${LATEST_STATE}" != "(0 rows)" ]] ; then \
		echo ${LATEST_STATE} > ./tap/state.json \
	fi

	$(MAKE) -C ${KNOT_FOLDER} py-sync

#	Save the latest state to the DB
	LATEST_STATE=$(head -1 "$(CURDIR)/tap/state.json"); \
	INSERT_CMD="INSERT INTO state (state) \
		VALUES ('${LATEST_STATE}')"; \
	echo ${INSERT_CMD} | psql ${DATABASE_URL}
