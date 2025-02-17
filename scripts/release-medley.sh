#!/bin/sh

export MEDLEYDIR=`pwd`
if [ ! -x run-medley ] ; then
    echo run from MEDLEYDIR
    exit 1
fi

tag=$1

if [ -z "$tag" ] ; then
    tag=medley-`date +%y%m%d`
fi

cd ..

echo making $tag-loadups.tgz

tar cfz medley/tmp/$tag-loadups.tgz                       \
    medley/loadups/lisp.sysout                            \
    medley/loadups/full.sysout                            \
    medley/loadups/whereis.hash                           \
    medley/library/exports.all
	
echo making $tag-runtime.tgz

tar cfz medley/tmp/$tag-runtime.tgz                       \
    --exclude "*~" --exclude "*#*"                        \
    --exclude exports.all                                 \
    medley/docs/dinfo                                     \
    medley/doctools                                       \
    medley/greetfiles                                     \
    medley/rooms                                          \
    medley/run-medley                                     \
    medley/scripts                                        \
    medley/fonts/displayfonts  medley/fonts/altofonts     \
    medley/fonts/adobe                                    \
    medley/fonts/postscriptfonts                          \
    medley/library                                        \
    medley/lispusers                                      \
    medley/sources                                        \
    medley/internal

cd medley

echo making release
sed s/'$tag'/$tag/g < release-notes.md > tmp/release-notes.md
gh release create $tag -F tmp/release-notes.md -p -t $tag

echo uploading
gh release upload $tag tmp/$tag-loadups.tgz tmp/$tag-runtime.tgz --clobber

