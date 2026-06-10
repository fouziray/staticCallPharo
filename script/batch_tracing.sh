#!/bin/bash
set -x;

#benches=("DataFrame")
benches=("HoneyGinger" "DataFrame" "Bloc" "Microdown")

for bench in "${benches[@]}"; do
	mkdir temp
	cd temp

	#Load a Pharo12 image and patch it to allow loading of packages such as Moose
	wget -O - get.pharo.org/120+vm | bash
	./pharo Pharo.image eval --save "IceTipRepositoriesModel class compile: 'addTag: t priority: p'"

	./pharo Pharo.image metacello install github://fouziray/staticCallPharo:traceWithTypePattern BaselineOfStaticCallExp  --groups=mintracing`echo ${bench} | tr "[:upper:]" "[:lower:]"`
	
	if [ "$bench" = "Moose" ]; then
		cp pharo-local/iceberg/fouziray/PharoVeritasBenchSuite/files/sbscl.json .
	fi
	
	if [ "$bench" = "DataFrame" ]; then
		cp pharo-local/iceberg/fouziray/PharoVeritasBenchSuite/files/tiny_dataset.csv .
	fi
	
	if [ "$bench" = "Microdown" ]; then
		git clone --quiet --depth=1 https://github.com/SquareBracketAssociates/BuildingApplicationWithSpec2.git Spec2Book
	fi
	
	./pharo Pharo.image eval "PatternCallSites tracePatternsOf${bench}"

	cp *.ston *.csv ..
	cd ..
	rm -rf temp
done
