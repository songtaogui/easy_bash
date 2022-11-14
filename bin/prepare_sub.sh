#!/usr/bin/env bash
set -e

gst_log () {
  local info=$1
  echo -e "\033[36m[$(date +'%y-%m-%d %H:%M')]\033[0m $info" >&2
}
gst_rcd () {
  local info=$1
  echo -e "\033[32m>>>------------>\033[0m $info" >&2
}
gst_err () {
  local info=$1
  echo -e "\033[31m\033[7m[ERROR]\033[0m --> $info" >&2
}
gst_warn () {
  local info=$1
  echo -e "\033[35m[WARNING]\033[0m --> $info" >&2
}

NAME="$1"
if [ -z "$NAME" ]; then
  echo "usage: prepare.sh NAME_OF_YOUR_SUB" >&2
  exit 1
fi

SUBNAME=$(echo $NAME | tr '[A-Z]' '[a-z]')
ENVNAME="$(echo $NAME | tr '[a-z-]' '[A-Z_]')_ROOT"

gst_log "Preparing your '$SUBNAME' sub!"

export LIBSUB=$(dirname $0)
LIBSUB="${LIBSUB%%/bin}/lib/sub"

if [ ! -s "${LIBSUB}/prepare.sh" ]; then
  gst_err "Cannot find sub source in $LIBSUB"
  exit 1
else
  cp -r ${LIBSUB} ${SUBNAME} &&\
  cd ${SUBNAME}
  if [ $? -ne 0 ];then gst_err "create source dir for ${SUBNAME} failed: Non-zero exit"; exit 1;fi
fi

if [ "$NAME" != "sub" ]; then
  rm bin/sub
  mv share/sub share/$SUBNAME

  for file in **/sub*; do
    sed "s/sub/$SUBNAME/g;s/SUB_ROOT/$ENVNAME/g" "$file" > $(echo $file | sed "s/sub/$SUBNAME/")
    rm $file
  done

  for file in libexec/*; do
    chmod a+x $file
  done

  ln -s ../libexec/$SUBNAME bin/$SUBNAME
fi

rm README.md
rm prepare.sh

gst_rcd "Done! Enjoy your new sub! If you're happy with your sub, run:"
gst_rcd
gst_rcd "    rm -rf .git"
gst_rcd "    git init"
gst_rcd "    git add ."
gst_rcd "    git commit -m 'Starting off $SUBNAME'"
gst_rcd "    ./bin/$SUBNAME init"
gst_rcd
gst_rcd "Made a mistake? Want to make a different sub? Run:"
gst_rcd
gst_rcd "    git add ."
gst_rcd "    git checkout -f"
gst_rcd
gst_rcd "Thanks for making a sub!"
