CREATE_TABLE_CMD:="CREATE TABLE state ( \
                     id SERIAL PRIMARY KEY, \
                     state VARCHAR(255) NOT NULL \
                   )"

LATEST_STATE_CMD:="SELECT state \
                   FROM state \
                   ORDER BY id DESC \
                   LIMIT 1"

TABLE_EXISTS_CMD:="SELECT EXISTS ( \
                   SELECT * \
                   FROM information_schema.tables \
                   WHERE table_schema = 'public' \
                     AND table_name = 'state')"

INSERT_CMD='INSERT INTO state (state) VALUES ('\''${LATEST_STATE}'\'')'

LATEST_STATE:=$(shell echo "${LATEST_STATE_CMD}" | psql "${DATABASE_URL}" | sed -n 3p | tr -d "[:blank:]")
TABLE_EXISTS:=$(shell echo "${TABLE_EXISTS_CMD}" | psql "${DATABASE_URL}" | sed -n 3p | xargs)

setup-py-envs:
	$(MAKE) -C knot setup-py-envs

setup-postgres:
	echo $(CREATE_TABLE_CMD) | psql $(DATABASE_URL)

initial-setup: setup-py-envs

fetch-from-db:
ifneq ("$(LATEST_STATE)", "(0 rows)")
	echo '$(LATEST_STATE)' > knot/tap/state.json
endif

run-knot-sync: fetch-from-db
	$(MAKE) -C knot py-sync

save-to-db: run-knot-sync
	$(eval LATEST_STATE=$(shell tail -1 knot/tap/state.json))
	echo $(INSERT_CMD) | psql $(DATABASE_URL)

sync:
ifeq ("$(TABLE_EXISTS)", "f")
	$(MAKE) setup-postgres
endif
	$(MAKE) save-to-db
