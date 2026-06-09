#!/bin/bash

git clone --quiet --depth=1 https://github.com/SquareBracketAssociates/BuildingApplicationWithSpec2.git Spec2Book

#benches=("HoneyGinger" "DataFrame" "Bloc" "Microdown")
benches=("Microdown")

for bench in "${benches[@]}"; do
	mkdir temp
	cd temp
	wget -O - get.pharo.org/120+vm | bash
	./pharo Pharo.image metacello install github://fouziray/staticCallPharo:traceWithTypePattern BaselineOfStaticCallExp  --groups=mintracing`echo ${bench} | tr "[:upper:]" "[:lower:]"`
    ./pharo Pharo.image eval "PatternCallSites tracePatternsOf${bench}"
	cp *.ston *.csv ..
	cd ..
	rm -rf temp
done
