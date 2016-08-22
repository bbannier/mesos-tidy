#!/bin/bash

SRCDIR=/tmp/SRC

echo '############################## PREPARING SOURCES ##############################'
git clone --depth 1 file:///SRC ${SRCDIR}
(cd ${SRCDIR} && ./bootstrap)

echo '############################## CONFIGURING SOURCES ##############################'
${SRCDIR}/configure "${CONFIGURE_FLAGS}"

echo '############################## BUILDING SOURCES ##############################'
bear -- make -j$(nproc) check GTEST_FILTER=''

echo '############################## CHECKING SOURCES ##############################'
TIDY_ARGS="--extra-arg=-Wno-unused-command-line-argument -header-filter=$SRCDIR'/(include|src|3rdparty/stout|3rdparty/libprocess).*'"
DEFAULT_CHECKS='-*,mesos-*'
CHECKS=${CHECKS:-$DEFAULT_CHECKS}

cat compile_commands.json \
	| jq '.[].file' \
	| sed 's/"//g' \
	| sed 's/^\ //g' \
	| grep '^'${SRCDIR} \
	| parallel -j $(nproc) clang-tidy -p $PWD "${TIDY_ARGS}" -checks="${CHECKS}" \
  1> /OUT/clang-tidy.log 2> /dev/null
