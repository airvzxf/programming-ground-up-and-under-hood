#!/bin/sh

for i in ../../*.xml; do 
	po4a-gettextize -f docbook -m $i  -p po/`basename $i|sed -e 's/xml/po/'`;
done       
