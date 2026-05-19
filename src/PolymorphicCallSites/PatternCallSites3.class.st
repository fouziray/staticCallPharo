"
![TEst](```st self iceRepository```)
"
Class {
	#name : 'PatternCallSites3',
	#superclass : 'Object',
	#instVars : [
		'block',
		'instrumentation',
		'methods',
		'callsites',
		'devirtualize',
		'inlinedMethods',
		'typePatterns'
	],
	#classInstVars : [
		'recorders',
		'methods',
		'aScpExecutionClass'
	],
	#category : 'PolymorphicCallSites-Model',
	#package : 'PolymorphicCallSites',
	#tag : 'Model'
}

{ #category : 'benchs' }
PatternCallSites3 class >> benchMarksToExecute [

	^ self roassalBenchs , self honneyGingerBenchs 
]

{ #category : 'benchs' }
PatternCallSites3 class >> benchRoassalProgram [

	^ self roassalBenchs  
]

{ #category : 'benchs' }
PatternCallSites3 class >> blocBenchs [

^ {
'Bloc VeritasBloc' -> [  VeritasBloc new run   ].
 }	
]

{ #category : 'benchs' }
PatternCallSites3 class >> executeBenchmarks [

	<script>
	| programs simulator devirtualizableNodes result |
	programs := self benchMarksToExecute asDictionary.

	programs associations
		do: [ :assoc |
			| key value blockReturn |
			key := assoc key.
			value := assoc value.

			simulator := self new. 
			simulator block: value.
			blockReturn := simulator execute.

			(blockReturn isKindOf: Morph) ifTrue: [
				blockReturn containingWindow ifNotNil: #close ].

			devirtualizableNodes := simulator getAllCallSites.
			result := ProgramModel new
				          name: key
				          fromRaw: value -> devirtualizableNodes.
			('NI_' , key asFileReference withExtension: 'ston') writeStreamDo: [
				:s | STON put: result onStream: s ] ]
		displayingProgress: [ :assoc | assoc key ]
]

{ #category : 'benchs' }
PatternCallSites3 class >> executeHGV [

	<script>
	| programs simulator devirtualizableNodes result |
	programs := self honneyGingerVeritas asDictionary.

	programs associations
		do: [ :assoc |
			| key value blockReturn  transformer|
			key := assoc key.
			value := assoc value.

			simulator := self new.
			simulator block: value.

			blockReturn := simulator execute.
			[blockReturn containingWindow ifNotNil: #close.
] onErrorDo: [  ].
			devirtualizableNodes := simulator getAllCallSites.
			result := ProgramModel new
				          name: 'NI_' , key
				          fromRaw: value -> devirtualizableNodes.

			transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes asDictionary ;
		               yourself.
			transformer	getNewMethodOfDevirtualizingAll.
			]
]

{ #category : 'benchs' }
PatternCallSites3 class >> executeMRoassalFiltered [

<script>
	
| programs simulator devirtualizableNodes result |

programs := self roassalBenchs asDictionary.

programs associations do: [ :assoc | 
 	| key value blockReturn |. 
	key := assoc key.
	value := assoc value.

	simulator := self new.
	simulator block: value.
	blockReturn := simulator execute.		
	
	(blockReturn isKindOf: Morph) ifTrue: [ 
		blockReturn containingWindow ifNotNil: #close
	].
			
	devirtualizableNodes := simulator getAllCallSites.
	result := ProgramModel new name: 'NI_',key fromRaw: value -> devirtualizableNodes.
	(('NI2_',key) asFileReference withExtension: 'ston')
		writeStreamDo: [:s | STON put: result onStream: s].
] displayingProgress: [:assoc | assoc key].

]

{ #category : 'benchs' }
PatternCallSites3 class >> executeMooseFiltered [

<script>
	
| programs simulator devirtualizableNodes result |

programs := self mooseBenchs asDictionary.

programs associations do: [ :assoc | 
 	| key value blockReturn |. 
	key := assoc key.
	value := assoc value.

	simulator := self new.
	simulator block: value.
	blockReturn := simulator execute.		
	
	(blockReturn isKindOf: Morph) ifTrue: [ 
		blockReturn containingWindow ifNotNil: #close
	].
			
	devirtualizableNodes := simulator getAllCallSites.
	result := ProgramModel new name: 'NI_',key fromRaw: value -> devirtualizableNodes.
	(('NI2_',key) asFileReference withExtension: 'ston')
		writeStreamDo: [:s | STON put: result onStream: s].
] displayingProgress: [:assoc | assoc key].

]

{ #category : 'benchs' }
PatternCallSites3 class >> executeSingHGFiltered [

	<script>
	| programs simulator devirtualizableNodes result |
	programs := self honneyGingerBenchsSingle asDictionary.

	programs associations
		do: [ :assoc |
			| key value blockReturn |
			key := assoc key.
			value := assoc value.

			simulator := self new.
			simulator block: value.

			blockReturn := simulator execute.
			blockReturn containingWindow ifNotNil: #close.

			devirtualizableNodes := simulator getAllCallSites.
			result := ProgramModel new
				          name: 'NI_' , key
				          fromRaw: value -> devirtualizableNodes.
			(('NI2_' , key) asFileReference withExtension: 'ston')
				writeStreamDo: [ :s | STON put: result onStream: s ] ]
		displayingProgress: [ :assoc | assoc key ]
]

{ #category : 'benchs' }
PatternCallSites3 class >> executeSingHGFiltered2 [

	<script>
	| programs simulator devirtualizableNodes result |
	programs := self honneyGingerBenchsSingle asDictionary.

	programs associations
		do: [ :assoc |
			| key value blockReturn |
			key := assoc key.
			value := assoc value.

			simulator := ScpExecutionRecorder new.
			simulator block: value.
			blockReturn := simulator execute.

			(blockReturn isKindOf: Morph) ifTrue: [
				blockReturn containingWindow ifNotNil: #close ].

			1 halt.
			devirtualizableNodes := simulator getAllCallSites.
			result := ProgramModel new
				          name: 'NI_' , key
				          fromRaw: value -> devirtualizableNodes.
			(('NI2_' , key) asFileReference withExtension: 'ston')
				writeStreamDo: [ :s | STON put: result onStream: s ] ]
		displayingProgress: [ :assoc | assoc key ]
]

{ #category : 'benchs' }
PatternCallSites3 class >> floatBenchs [
	<script>
	| programs simulator devirtualizableNodes result |
	programs := {  'asfloat' -> [ true ifTrue:[2 isNil . 2 asFloat]. ]  } asDictionary.

	programs associations do: [ :assoc | 
 		| key value blockReturn | 
		key := assoc key.
		value := assoc value.

		simulator := DevirtualizableCallSites new.
		simulator block: value.
		blockReturn := simulator execute.		
	
		(blockReturn isKindOf: Morph) ifTrue: [ 
			blockReturn containingWindow ifNotNil: #close
		].
				
	devirtualizableNodes := simulator getAllCallSites.
	result := ProgramModel new name: key fromRaw: value -> devirtualizableNodes.
	('NI_',key asFileReference withExtension: 'ston')
		writeStreamDo: [:s | STON put: result onStream: s].
] displayingProgress: [:assoc | assoc key].

]

{ #category : 'parameters' }
PatternCallSites3 class >> from: aBlock [

	<noInstrumentation>
	
	^ self new
		block: aBlock;
		record;
		calls
]

{ #category : 'benchs' }
PatternCallSites3 class >> honneyGingerBenchs [
	
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

{ #category : 'benchs' }
PatternCallSites3 class >> honneyGingerBenchsSingle [

	^ { ('HGSimulator impossibeRiverPressureMap' -> [
	   [
	   | simulator |
	   simulator := HGSimulator impossibeRiverPressureMap.
	   0 timesRepeat: [ World doOneCycle ].
	   simulator ] value ]) }
]

{ #category : 'benchs' }
PatternCallSites3 class >> honneyGingerVeritas [

	^ { ('33VeritasHoneyGinger new run' -> [
	   [
	   | simulator |
	   simulator := VeritasHoneyGinger new run.
	   5 timesRepeat: [ World doOneCycle ].
	   simulator ] value ]) }
]

{ #category : 'benchs' }
PatternCallSites3 class >> microSendRateCalculation [

	<script>
	| programs simulator devirtualizableNodes result |
	programs := { ('microSendSetClass'
	             -> [ CallerStaticInterpreter new microSendSetClass ]) }
		            asDictionary.

	programs associations do: [ :assoc |
		| key value blockReturn |
		key := assoc key.
		value := assoc value.

		simulator := DevirtualizableCallSites new.
		simulator block: value.
		blockReturn := simulator execute.

		(blockReturn isKindOf: Morph) ifTrue: [
			blockReturn containingWindow ifNotNil: #close ].

		devirtualizableNodes := simulator getAllCallSites.
		result := ProgramModel new
				          name: key
				          fromRaw: value -> devirtualizableNodes
				].

		1 halt.
]

{ #category : 'benchs' }
PatternCallSites3 class >> mooseBenchs [

^ {
'Moose VeritasMoose' -> [  VeritasMoose new run   ].
 }	
]

{ #category : 'benchs' }
PatternCallSites3 class >> rewriterBenchs [

^ {
'Rewriter VeritasRewriter' -> [  VeritasRewriterTransformer new run   ].
 }	
]

{ #category : 'benchs' }
PatternCallSites3 class >> roassalBenchs [

^ {
'Roassal RSAlpharoExample example01Basic' ->[  RSAlpharoExample new example01Basic  ].
'Roassal RSKiviatExample example01Basic'->[  RSKiviatExample new example01Basic   ].
'Roassal RSLegendExamples example01Basic' -> [  RSLegendExamples new example01Basic   ].
'Roassal RSPieExamples example01Basic ' -> [  RSPieExamples new example01Basic   ].
 }	
]

{ #category : 'accessing' }
PatternCallSites3 >> block: aBlock [

	block := aBlock
]

{ #category : 'testing' }
PatternCallSites3 >> canInstrument: aMethod [

	aMethod isInstrumented ifTrue: [ ^ false ].
	aMethod isPrimitive ifTrue: [ ^ false ].
	
	(inlinedMethods includes: aMethod selector) ifTrue: [ ^ false ].
	(aMethod hasPragmaNamed: #noInstrumentation) ifTrue: [ ^ false ].

	aMethod methodClass = UndefinedObject ifFalse: [
		aMethod isFFIMethod ifTrue: [ ^ false ].
		((aMethod name endsWith: #initialize) or: [
			 aMethod name endsWith: #new ]) ifFalse: [
			(aMethod package name beginsWith: #Kernel) ifTrue: [ ^ false ].
			(aMethod package name beginsWith: #FreeType) ifTrue: [ ^ false ].
			(aMethod package name beginsWith: #UnifiedFFI) ifTrue: [ ^ false ].
			(aMethod package name beginsWith: #Collection) ifTrue: [ ^ false ] ] ].

	^ true
]

{ #category : 'api actions' }
PatternCallSites3 >> execute [

	| method receiver |	
	
	method := (block home compiler compile: '^ ' , block sourceNode body formattedCode).
	receiver := block home receiver.
	
	instrumentation compiler: block home compiler.
	method := instrumentation applyOn: method.
	instrumentation compiler: nil.
	
	^ self message: nil method: method receiver: receiver arguments: #()
]

{ #category : 'api actions' }
PatternCallSites3 >> getAllCallSites [

	^ callsites
]

{ #category : 'api actions' }
PatternCallSites3 >> getDevirtualizableCallSites [

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
PatternCallSites3 >> initialize [

	methods := Dictionary new.
	inlinedMethods := #( #isNil
								#ifTrue: #ifFalse:
								#ifTrue:ifFalse: #ifFalse:ifTrue:
								
								#ifNotNil: #ifNil:
								#ifNil:ifNotNil: #ifNotNil:ifNil:
								
								#or: #and:
								#not #'==' ) asSet.
	instrumentation := ScpMethodInstrumentation new.
	instrumentation addIndirection: (ScpMessageIndirection new
			 reifyNode;
			 reifySender;
			 reifyReceiver;
			 reifyArguments;
			 handler: self;
			 handlerSelector:
				 (self class lookupSelector: #message:sender:receiver:arguments:)
					 selector;
			 yourself).

	callsites := IdentityDictionary new
]

{ #category : 'accessing' }
PatternCallSites3 >> inlinedMethods [

	^ inlinedMethods
]

{ #category : 'accessing' }
PatternCallSites3 >> inlinedMethods: anObject [

	inlinedMethods := anObject
]

{ #category : 'testing' }
PatternCallSites3 >> isPartOfInstrumentation [

	^ true
]

{ #category : 'private - execution' }
PatternCallSites3 >> lookup: aSelector in: aClass [

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

{ #category : 'private - execution' }
PatternCallSites3 >> message: aNode method: aMethod receiver: aReceiver arguments: aArguments [

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
	aNode ifNotNil: [ 
		(inlinedMethods includes: aNode selector) 
			ifTrue: [ ^ aReceiver withArgs: arguments executeMethod: aMethod
    ].

	typePatterns at: aNode 
		ifPresent: [ :m |  m add: aReceiver class ]
		ifAbsentPut: [ "Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself"
			OrderedCollection newFrom: { aReceiver }
		].
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
	
	
	].
	^ aReceiver withArgs: arguments executeMethod: aMethod
   
]

{ #category : 'private - execution' }
PatternCallSites3 >> message: aNode sender: aSender receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
	
	| method class |
	
	class := aNode isSuperSend
		ifTrue: [ aNode methodNode methodClass superclass ]
  		ifFalse: [ aReceiver class ].

	method := self lookup: aNode selector in: class.
	
   ^ self message: aNode method: method receiver: aReceiver arguments: aArguments

]
