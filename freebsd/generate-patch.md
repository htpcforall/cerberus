# generate patch

create patch for asmc

```
cd /usr/src; diff -u -N sys/dev/asmc/asmc.orig sys/dev/asmc/asmc.c >/tmp/patch.txt \
&& diff -u -N sys/dev/asmc/asmcvar.orig sys/dev/asmc/asmcvar.h >> /tmp/patch.txt                                              
```
