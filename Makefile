.PHONY: help test clean dockerbuild dockerserve dockershell dockerprod geoip

GEOIP_UPDATE = geoipupdate
GEOIP_DIR = geoip
GEOIP_CONF_FILE = $(GEOIP_DIR)/GeoIP.conf

DOCKER_CONFIG=docker-compose-local.yml
DOCKER_IMAGE_NAME=ethicaladserver

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  test           Run the full test suite"
	@echo "  clean          Delete assets processed by webpack"
	@echo "  dockerprod     Build a single-container ad server for production (this can take a while)"
	@echo "  dockerbuild    Build the multi-container ad server (this can take a while)"
	@echo "  dockerserve    Run the docker containers for the ad server"
	@echo "  dockershell    Connect to a shell on the Django docker container"
	@echo "  dockerstart    Start all services in the background"
	@echo "  dockerstop     Stop all services started by dockerstart"
	@echo "  geoip          Download the GeoIP database from MaxMind"

test:
	tox

clean:
	rm -rf assets/dist/*

# Build the production single-container application
# This command can take a while the first time
dockerprod:
	docker build -t $(DOCKER_IMAGE_NAME) -f docker-compose/production/django/Dockerfile  .

# Build the local multi-container application
# This command can take a while the first time
dockerbuild: clean
	docker-compose -f $(DOCKER_CONFIG) build

# You should run "dockerbuild" at least once before running this
# It isn't a dependency because running "dockerbuild" can take some time
dockerserve:
	docker-compose -f $(DOCKER_CONFIG) up

# This is similar to dockerserve, but it doesn't build the containers
# and start all services in the background.
dockerstart:
	docker-compose -f $(DOCKER_CONFIG) start

# Stop all services that were started by "dockerstart"
dockerstop:
	docker-compose -f $(DOCKER_CONFIG) stop

# Use this command to inspect the container, run management commands,
# or run anything else on the Django container
dockershell:
	docker-compose -f $(DOCKER_CONFIG) run --rm django /bin/ash

# Get the GeoIP database from MaxMind
# This command will probably fail unless you have "geoipupdate" installed
geoip:
	$(GEOIP_UPDATE) -f $(GEOIP_CONF_FILE) -d $(GEOIP_DIR) --verbose
