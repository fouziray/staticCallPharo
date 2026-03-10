"
![TEst](```st self iceRepository```)
"
Class {
	#name : 'DevirtualizableCallSites',
	#superclass : 'Object',
	#instVars : [
		'block',
		'instrumentation',
		'methods',
		'callsites',
		'devirtualize'
	],
	#classInstVars : [
		'recorders',
		'methods',
		'aScpExecutionClass'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'parameters' }
DevirtualizableCallSites class >> from: aBlock [

	<noInstrumentation>
	
	^ self new
		block: aBlock;
		record;
		calls
]

{ #category : 'as yet unclassified' }
DevirtualizableCallSites class >> honneyGingerBenchs [
	
^ { 
'HGSimulator impossibeRiverPressureMap' -> [ HGSimulator impossibeRiverPressureMap  ].
'HGSimulator lagoonRefractionWorld' -> [ HGSimulator lagoonRefractionWorld  ].
'HGSimulator sandbox4000' -> [ HGSimulator sandbox4000 ].
'HGSimulator sandbox4000' -> [ HGSimulator capuccinoPower ].
'HGSimulator rockAtMouse2' -> [ HGSimulator rockAtMouse2 ].
'HGSimulator rainyWindow' -> [ HGSimulator rainyWindow ].
'HGSimulator lagoonSmokeyWorld' -> [ HGSimulator lagoonSmokeyWorld ].
'HGSimulator sandtrap3D' -> [ HGSimulator sandtrap3D ].
'HGSimulator waterImageViewer' -> [ HGSimulator waterImageViewer ].
'HGSimulator splashPressureBorderline' -> [ HGSimulator splashPressureBorderline ].
'HGSimulator raftingDots' -> [ HGSimulator raftingDots ].
'HGSimulator arrestingWire5' -> [ HGSimulator arrestingWire5 ].""
'HGSimulator ramen' -> [ HGSimulator ramen ].
'HGSimulator watershowPressureMap'->[ HGSimulator watershowPressureMap ].
'HGSimulator impossibeRiverDots' -> [ HGSimulator impossibeRiverDots ].
'HGSimulator capuccino' -> [ HGSimulator capuccino ].
'HGSimulator nattoViewer' -> [ HGSimulator nattoViewer ].
 }
]

{ #category : 'as yet unclassified' }
DevirtualizableCallSites class >> roassalBenchs [

^ {
'Roassal RSAlpharoExample example01Basic' ->[  RSAlpharoExample new example01Basic  ].
'Roassal RSKiviatExample example01Basic'->[  RSKiviatExample new example01Basic   ].
'Roassal RSLegendExamples example01Basic' -> [  RSLegendExamples new example01Basic   ].
'Roassal RSPieExamples example01Basic ' -> [  RSPieExamples new example01Basic   ].
 }	
]

{ #category : 'accessing' }
DevirtualizableCallSites >> block: aBlock [

	block := aBlock
]

{ #category : 'testing' }
DevirtualizableCallSites >> canInstrument: aMethod [

	aMethod isInstrumented ifTrue: [ ^ false ].
	aMethod isPrimitive ifTrue: [ ^ false ].
	
	(aMethod hasPragmaNamed: #noInstrumentation) ifTrue: [ ^ false ].	

	aMethod methodClass = UndefinedObject ifFalse: [ 
		aMethod isFFIMethod ifTrue: [ ^ false ].
		((aMethod name endsWith: #initialize) or: [aMethod name endsWith: #new]) ifFalse: [
			(aMethod package name beginsWith: #Kernel) ifTrue: [ ^ false ].
			(aMethod package name beginsWith: #FreeType) ifTrue: [ ^ false ].
			(aMethod package name beginsWith: #UnifiedFFI) ifTrue: [ ^ false ].
			(aMethod package name beginsWith: #Collection) ifTrue: [ ^ false ].
		].
	].

	^ true
]

{ #category : 'api actions' }
DevirtualizableCallSites >> execute [

	| method receiver |	
	
	method := (block home compiler compile: block sourceNode body formattedCode).
	receiver := block home receiver.
	
	instrumentation compiler: block home compiler.
	method := instrumentation applyOn: method.
	instrumentation compiler: nil.
	
	^ self message: nil method: method receiver: receiver arguments: #()
]

{ #category : 'api actions' }
DevirtualizableCallSites >> getAllCallSites [

	^ callsites
]

{ #category : 'api actions' }
DevirtualizableCallSites >> getDevirtualizableCallSites [

	| devirtualizable |

	devirtualizable := callsites select: [ :association |
		(association value size = 1) and: [ association value values first size > 1 ]
	].

	devirtualizable := devirtualizable associations reject: [ :a | a key isNil ]. 
	devirtualizable collect: [ :a |	
		a key -> a value keys first 	
	] as: Dictionary.
	
	^ devirtualizable
	
]

{ #category : 'initialization' }
DevirtualizableCallSites >> initialize [

	methods := Dictionary new.
	
	instrumentation := ScpMethodInstrumentation new.	
	instrumentation addIndirection: (ScpMessageIndirection new
		reifyNode; reifySender; reifyReceiver; reifyArguments;
		handler: self;
		handlerSelector: (self class lookupSelector: #message:sender:receiver:arguments:) selector;
		yourself 
	).
	
	callsites := IdentityDictionary new.
]

{ #category : 'testing' }
DevirtualizableCallSites >> isPartOfInstrumentation [

	^ true
]

{ #category : 'private - execution' }
DevirtualizableCallSites >> lookup: aSelector in: aClass [

	| method |

	^ methods at: aClass at: aSelector ifAbsent: [

		method := aClass lookupSelector: aSelector. 
		method ifNil: [ 
			method := aClass lookupSelector: #doesNotUnderstand:	
		].

 	  ^ methods at: aClass at: aSelector put: (
			(self canInstrument: method) 
				ifTrue: [ instrumentation applyOn: method ] 
				ifFalse: [ method ]
		) 
	]
]

{ #category : 'private - recording' }
DevirtualizableCallSites >> message: aNode method: aMethod receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
   | arguments |

	arguments := aArguments.

	(aMethod selector = #doesNotUnderstand:) ifTrue: [ 
			arguments := { (MessageSend
						receiver: aReceiver
                 selector: aMethod selector 
                 arguments: aArguments) }
   	].


	(aNode isNotNil and: [ aNode methodNode isNil ]) 
		ifTrue: [ ^ aReceiver withArgs: arguments executeMethod: aMethod ].

	callsites at: aNode 
		ifPresent: [ :m | m at: aMethod 
			ifPresent: [ :r | r add: aReceiver class ]
			ifAbsentPut: [ Bag new
				add: aReceiver class;
				yourself ]
		]
		ifAbsentPut: [ Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself
		].

	^ aReceiver withArgs: arguments executeMethod: aMethod
   
]

{ #category : 'as yet unclassified' }
DevirtualizableCallSites >> message: aNode sender: aSender receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
	
	| method class |
	
	class := aNode isSuperSend
		ifTrue: [ aNode methodNode methodClass superclass ]
  		ifFalse: [ aReceiver class ].

	method := self lookup: aNode selector in: class.
	
   ^ self message: aNode method: method receiver: aReceiver arguments: aArguments

]
