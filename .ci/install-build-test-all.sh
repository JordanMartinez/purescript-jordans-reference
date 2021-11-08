#!/bin/sh

# This script performs all the steps to install, build, and test
# the example programs for this project.
#
# Run this from the root of this project:
#
#   source .ci/install-build-test-all.sh

source .ci/spago--install.sh
source .ci/spago--build-and-test.sh
