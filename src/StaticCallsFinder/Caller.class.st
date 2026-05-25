Class {
	#name : 'Caller',
	#superclass : 'CallerStaticInterpreter',
	#instVars : [
		'object'
	],
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'as yet unclassified' }
Caller >> fullPrintString64TimesTo: x [

	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.


	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.


	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.

	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.

	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.

	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.


	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString.
	x fullPrintString
]

{ #category : 'bench - object new' }
Caller >> initialize [ 
	super initialize.
	object:= Object new.
]

{ #category : 'as yet unclassified' }
Caller >> microPrintStringOnByteStringSt [
	"self new microPrintStringOnByteString iterations"

	self warmupSend.
	^ [ self performFullPrintStringBytestringSt ] bench
]

{ #category : 'as yet unclassified' }
Caller >> microPrintStringOnByteStringStatic [
	"self new microPrintStringOnByteString iterations"

	self warmupSend.
	^ [ self performFullPrintStringBytestringStatic ] bench
]

{ #category : 'as yet unclassified' }
Caller >> microPrintStringOnObject [
	"self new microPrintStringOnObject iterations"

	self warmupSend.
	^ [ self performFullPrintStringOnObject ] bench
]

{ #category : 'as yet unclassified' }
Caller >> microSendByteString [
	"self new micro2 iterations"

	self warmupSend.
	^ [ self performMicroBytestring ] bench
]

{ #category : 'as yet unclassified' }
Caller >> microSendSetClass [
	"self new micro1 iterations"

	" 3011"

	self warmupSend.
	^ [ self performMicroSet ] bench
]

{ #category : 'as yet unclassified' }
Caller >> performFullPrintStringBytestringSt [ 

	1 to: 2000 do:[:e | self fullPrintString64TimesTo: 'toto' ].

]

{ #category : 'as yet unclassified' }
Caller >> performFullPrintStringOnObject [ 

	1 to: 2000 do:[:e | self fullPrintString64TimesTo: Object ].

]

{ #category : 'as yet unclassified' }
Caller >> performMicroBytestring [

	1 to: 20000 do: [ :e | self sending64TimeMessageTo: 'toto' ]
]

{ #category : 'bench - object new' }
Caller >> performMicroObjectInstance [

	1 to: 20000 do: [ :e | self sending64TimeMessageTo: object ]
]

{ #category : 'as yet unclassified' }
Caller >> performMicroSet [

	1 to: 20000 do: [ :e | self sending64TimeMessageTo: Set ]
]

{ #category : 'as yet unclassified' }
Caller >> performMicroSetStatic [

	1 to: 20000 do: [ :e | self sending64TimeMessageToSt: Set ]
]

{ #category : 'as yet unclassified' }
Caller >> performMicroSetStaticObjectInstance [

	1 to: 20000 do: [ :e | self sending64TimeMessageToSt: object ]
]

{ #category : 'as yet unclassified' }
Caller >> send: x [ 

	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.


	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
	
	
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
	
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
	
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
	
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
	
	
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.x yourself.
		
]

{ #category : 'as yet unclassified' }
Caller >> sendSStatic: x [ 

	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.


	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
	
	
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
	
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
	
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
	
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
	
	
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.x _Object_yourself.
		
]

{ #category : 'instructions' }
Caller >> sending64TimeMessageTo: x [

	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.


	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.


	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.

	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.

	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.

	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.


	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself.
	x yourself
]

{ #category : 'as yet unclassified' }
Caller >> warmupPrintString [

	3 timesRepeat: [
		self
			fullPrintString64TimesTo: Set;
			fullPrintString64TimesTo: 1;
			fullPrintString64TimesTo: OrderedCollection new;
			fullPrintString64TimesTo: 1.0;
			fullPrintString64TimesTo: 'toto';
			fullPrintString64TimesTo: Object ]
]

{ #category : 'as yet unclassified' }
Caller >> warmupSend [
	3 timesRepeat: [
          self
          	sending64TimeMessageTo: Set;
	 	sending64TimeMessageTo: 1;
	  	sending64TimeMessageTo: OrderedCollection new;
          	sending64TimeMessageTo: 1.0;
		sending64TimeMessageTo: 'toto';
		sending64TimeMessageTo: Object ]
]

{ #category : 'warmup -  poly' }
Caller >> warmupSendAsMegaMorphic [
	3 timesRepeat: [
          self
          	sending64TimeMessageTo: Set;
	 	sending64TimeMessageTo: 1;
	  	sending64TimeMessageTo: Object new;
          	sending64TimeMessageTo: 1.0;
		sending64TimeMessageTo: 'toto';
		sending64TimeMessageTo: Object;
		sending64TimeMessageTo: {2. 5};
		sending64TimeMessageTo: Set new;
		sending64TimeMessageTo: 1->5 ]
]

{ #category : 'warmup -  poly' }
Caller >> warmupSendAsPolyMorphic [
	3 timesRepeat: [
          self
          	sending64TimeMessageTo: Set;
	 	sending64TimeMessageTo: 1;
	  	sending64TimeMessageTo: Object new;
          	sending64TimeMessageTo: 1.0;
		sending64TimeMessageTo: 'toto';
		sending64TimeMessageTo: Object ]
]

{ #category : 'warmup - mono' }
Caller >> warmupSendMonoMorphic [
	3 timesRepeat: [
          self
          	sending64TimeMessageTo: Object new ]
]
