#!/bin/bash

wget -O - get.pharo.org/120+vm | bash
./pharo Pharo.image metacello install github://fouziray/staticCallPharo:traceWithTypePattern BaselineOfStaticCallExp  --groups=mintracingveritas



benches=("HoneyGinger" "DataFrame")

for bench in "${benches[@]}"; do
    ./pharo Pharo.image eval “PatternCallSites tracePatternsOf${bench}"
done