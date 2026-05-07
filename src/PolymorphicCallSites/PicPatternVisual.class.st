Class {
	#name : 'PicPatternVisual',
	#superclass : 'Object',
	#category : 'PolymorphicCallSites-CopyDowner',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDowner'
}

{ #category : 'as yet unclassified' }
PicPatternVisual class >> visualize: aDictionary [
	^ self new visualize: aDictionary.
]

{ #category : 'visual' }
PicPatternVisual >> getTransitionTriggerCounter: aCallSiteModel forPattern: aCollection [ 
		
	| y  previousTypes|
	
	y:= OrderedCollection newFrom: {0}.

	previousTypes := Dictionary newFrom: { aCollection first -> 0 }.
 	aCollection allButFirst inject: aCollection first into:[ :e :c |  (e = c )ifTrue:[ y add: y last] ifFalse: [
			previousTypes at: c ifPresent:[ y add: (previousTypes at: c) ] ifAbsentPut: [ y add: y last + 1 . y last + 1 ].
		].	
 	c].
	
	^ y

]

{ #category : 'as yet unclassified' }
PicPatternVisual >> visualize: anAssociation [

	| plt p x |
	anAssociation key. anAssociation value.
	
	^ self visualizeSingleCallSite: anAssociation key forPattern: anAssociation value.
	
]

{ #category : 'visual' }
PicPatternVisual >> visualizeSingleCallSite: aCallSiteModel forPattern: aCollection [

	|x y plt p |

	y:= self getTransitionTriggerCounter: aCallSiteModel forPattern: aCollection. 
	x := 1 to:  aCallSiteModel  numberOfCalls.
	plt := RSCompositeChart new.
	
	p := RSLinePlot new x: x y: y.
	plt add: p.

"	p := RSLinePlot new x: x y: (x raisedTo: 3).
	plt add: p.

	p := RSLinePlot new x: x y: (x raisedTo: 4).
	plt add: p.
"
	plt xlabel: 'Number Of Calls'.
	plt ylabel: 'Site class'.
	plt title: 'PIC Properties'.
	^ plt


]
