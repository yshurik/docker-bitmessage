#!/bin/sh
#diff -ru notbit.orig/ notbit > notbit-alpine.patch
docker build . -t yshurik/bitmessage

