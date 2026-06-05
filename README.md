# Installation
## Requirements
  We run this project in Pharo 12.
  The external libraries we use are automatically handleded by the baseline. And include: (HoneyGinger, and Scopeo tracing)
  
## Load the program tracing tool, its dependency to HoneyGinger, and launch the tracing script:
  
``` Smalltalk
Metacello new
baseline: 'StaticCallExp';
repository: 'github://fouziray/staticCallPharo:traceWithTypePattern';load: 'mintracing'.
```

Next, for a strange reason, we have to manually load the package `PolymorphicCallSites`.

To get a CSV with the shape:
`callsite_id,call_number,type_observed,depth,selector,callerMethod,callercallsite`
run in a playground:
``` PatternCallSites tracePatternsOfHgWithGraph```
This launches a specific honeyginger program you can tweak it.
You get a csv file at your local directory.
And an extra trace model saved into the relative path to your local directory:
`'pharo-local' /'iceberg'/'fouziray'/'staticCallPharo'/'patternTrace'`

We have the following script to reproduce the instructions above :

```wget -O - get.pharo.org/120+vm | bash
./pharo Pharo.image metacello install github://fouziray/staticCallPharo:traceWithTypePattern BaselineOfStaticCallExp  --groups=mintracing
./pharo Pharo.image eval “PatternCallSites tracePatternsOfHgWithGraph”
```
## Load the full project using: 
This version is used to compile the new bytecode for static calls implementation. (Unless you want to go through new vm generation steps use the upper baseline it is simpler and serves the purpose of doing estimations on traces)

``` Smalltalk
Metacello new
baseline: 'StaticCallExp';
repository: 'github://fouziray/staticCallPharo:statisticsStatic';
load: 'buildAVM'.

```

