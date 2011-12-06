SRC_DIR = src
THEMES_DIR = themes
BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist

JS_ENGINE ?= `which node nodejs 2>/dev/null`
COMPILER = ${JS_ENGINE} ${BUILD_DIR}/uglify.js --unsafe
POST_COMPILER = ${JS_ENGINE} ${BUILD_DIR}/post-compile.js

BASE_FILES = ${SRC_DIR}/LabeledScrollbar.js

MODULES = ${SRC_DIR}/intro.js\
	${BASE_FILES}\
	${SRC_DIR}/outro.js

JQLS = ${DIST_DIR}/jquery.labeledscrollbar.js
JQLS_MIN = ${DIST_DIR}/jquery.labeledscrollbar.min.js

JQLS_VER = $(shell cat version.txt)
VER = sed "s/@VERSION/${JQLS_VER}/"

DATE=$(shell git log -1 --pretty=format:%ad)

all: core

core: jquery_labeledscrollbar min
	@@echo "jQuery LabeledScrollbar Plugin build complete."

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

jquery_labeledscrollbar: ${JQLS}
	@@cp -R ${THEMES_DIR} ${DIST_DIR}

${JQLS}: ${MODULES} | ${DIST_DIR}
	@@echo "Building" ${JQLS}

	@@cat ${MODULES} | \
		sed 's/.function..jQuery...{//' | \
		sed 's/}...jQuery..;//' | \
		sed 's/@DATE/'"${DATE}"'/' | \
		${VER} > ${JQLS};

min: jquery_labeledscrollbar ${JQLS_MIN}

${JQLS_MIN}: ${JQLS}
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Minifying jQuery LabeledScrollbar Plugin" ${JQ_MIN}; \
		${COMPILER} ${JQLS} > ${JQLS_MIN}.tmp; \
		${POST_COMPILER} ${JQLS_MIN}.tmp > ${JQLS_MIN}; \
		rm -f ${JQLS_MIN}.tmp; \
	else \
		echo "You must have NodeJS installed in order to minify jQuery LabeledScrollbar Plugin."; \
	fi

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

distclean: clean

.PHONY: all jquery_labeledscrollbar min clean distclean core