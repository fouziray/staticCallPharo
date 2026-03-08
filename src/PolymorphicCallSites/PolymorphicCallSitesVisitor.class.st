Class {
	#name : 'PolymorphicCallSitesVisitor',
	#superclass : 'CallSitesFrequencyVisitor',
	#instVars : [
		'messageExecutionsDictionary'
	],
	#classInstVars : [
		'index'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'tests' }
PolymorphicCallSitesVisitor class >> boilDownToMonos: targetMethodsDict [

	^ targetMethodsDict associations select: [ :messageTargetAndReceiver |
		  messageTargetAndReceiver value keys size = 1 ]
]

{ #category : 'accessing' }
PolymorphicCallSitesVisitor class >> filter: aListOfMessageReceiversAssociations [

	^ self filterFakePoly: aListOfMessageReceiversAssociations
]

{ #category : 'tests' }
PolymorphicCallSitesVisitor class >> filterFakePoly: targetMethodsDict [

	^ targetMethodsDict associations select: [ :messageTargetAndReceiver |
		  messageTargetAndReceiver value keys size = 1 and: [
			  messageTargetAndReceiver value values first asIdentitySet size > 1 ] ]
]

{ #category : 'formatting' }
PolymorphicCallSitesVisitor class >> formatToCsv: resultOfRateDev [
	"use for argument rateOfDevirtualizableWith: on a trace you got using
	
[	simulator := DevirtualizableCallSites new.
	simulator block: [ RSAlpharoExample new example01Basic ].
	simulator execute.		

	devirtualizableNodes := simulator getAllCallSites.
	 "
	|a|
a:= resultOfRateDev collect:[:each | each key -> {each value first third value. each value first second value first. each value first fourth value first. each value first fifth value first . each value first sixth value first. each value first seventh value first. each value first eighth value first. each value first first value}].
index ifNil: [ index := 1 ] ifNotNil: [index:= 1 + index].
('statsTrace',index asString,'.csv') asFileReference writeStreamDo: [:s | s nextPutAll: (String  streamContents: [ :e |
(a collect:[:e | {e key . e value }flattened ]) do: [:row |
    e nextPutAll: ((row collect: [:cell | cell printString]) joinUsing: $,)].
	e nextPut: Character cr .
]) contents].
 
 ^ a collect:[:e | {e key . e value }flattened ]
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesVisitor class >> rateOfDevirtualizable: aCollection [ 
	| total devirtualizable |
	total :=(( aCollection values select:[:c | c size = 1]) collect: [:e | e values flattened size]) sum.
	devirtualizable:=
(((( self filterFakePoly: aCollection )collect:#value)  select:[:c | c size = 1]) collect: [:e | e values flattened size]) sum.
	
	^ (devirtualizable / total) * 100.
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesVisitor class >> rateOfDevirtualizableWith: aCollection [ 
	| total devirtualizable totalSites filtered staticSites monoStaticable polyStaticable singleImplementation singleImplementationBlock monoSingleImplementation polyStaticableSingleImplementation monoSingleImplementationStatic singleImplementationDynamicStatic megaStaticable |
	
	total :=(( aCollection values ) collect: [:e | e values flattened size]) sum.
	totalSites:= (aCollection keys reject: #isNil) size.
	
	devirtualizable:=
( ((( filtered:= self filterFakePoly: aCollection )collect:#value)  select:[:c | c size = 1]) collect: [:e | e values flattened size]) sum.
staticSites:= filtered collect: #key.


monoStaticable:= (filtered value) select:[ :e| e value asSet size=1 ].
singleImplementationBlock := [:e| e key selector implementors size=1].
monoSingleImplementationStatic := monoStaticable select: singleImplementationBlock.
polyStaticable := (filtered ) select:[ :e| (e value asSet size > 1) and: [ (e value asSet size) < 7 ] ].

megaStaticable := (filtered ) select:[ :e| (e value asSet size > 6) ].

polyStaticableSingleImplementation := (polyStaticable union: megaStaticable) select: singleImplementationBlock .

singleImplementationDynamicStatic := (polyStaticableSingleImplementation) select: singleImplementationBlock.


	^ {'Ratio of dev to total calls:'->(((devirtualizable / total) * 100 asFloat round:2) asString,'%'  ). 'static sites' ->{staticSites size. staticSites}.  'Total of sites:'-> totalSites . 'staticable mono'->{ monoStaticable size. monoStaticable }. 'staticable poly' -> { polyStaticable size . polyStaticable }. 'staticable mega '-> {megaStaticable size. megaStaticable}. 'staticable mono single'->{ monoSingleImplementationStatic size. monoSingleImplementationStatic} . 'staticable poly/mega single' -> { singleImplementationDynamicStatic size. singleImplementationDynamicStatic } }
]

{ #category : 'serialize' }
PolymorphicCallSitesVisitor class >> serializeMessage: aRBMessageNode [
aRBMessageNode ifNil: [ ^ 'nil'].
	^ aRBMessageNode methodNode compiledMethod classBinding value name
	  , '/' , aRBMessageNode methodNode selector , '/'
	  ,
	  (aRBMessageNode methodNode sendNodes indexOf: aRBMessageNode)
		  asString
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesVisitor class >> transformSummaryToBeSerializable: aSummaryDict [

	^ aSummaryDict associations collect: [ :a | (self serializeMessage: a key )-> (IdentityDictionary newFromKeys: (a value keys collect: [ :e | e className ,'/',e selector ] )  andValues: (a value values collect: [ :v | (Bag newFrom: (v collect:[:e | e className ]))])) ]
]

{ #category : 'initialization' }
PolymorphicCallSitesVisitor >> initialize [

	"message send node -> IdentityDictionary(executed compiled method -> Collection( method call receiver))"
	messageExecutionsDictionary := IdentityDictionary new
]

{ #category : 'accessing' }
PolymorphicCallSitesVisitor >> messageExecutionsDictionary [

	^ messageExecutionsDictionary
]

{ #category : 'visiting' }
PolymorphicCallSitesVisitor >> visitMethodTrace: aScpMethodTrace [

	aScpMethodTrace parent ifNotNil: [ :message |
		messageExecutionsDictionary
			at: message node
			ifPresent: [ :d |
				d
					at: aScpMethodTrace node compiledMethod
					ifPresent: [ :receivers |
					receivers add: aScpMethodTrace receiver ]
					ifAbsentPut: [
						ClassSet new
							add: aScpMethodTrace receiver;
							yourself ] ]
			ifAbsentPut: [
				Dictionary new
					at: aScpMethodTrace node compiledMethod put: (ClassSet new
							 add: aScpMethodTrace receiver;
							 yourself);
					yourself ] ].

	aScpMethodTrace children do: [ :m | m accept: self ]
]
