Class {
	#name : 'CallerStaticInterpreter',
	#superclass : 'Object',
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> microSendByteString [
	"self new micro2 iterations"

	self warmupSend.
	^ [ self performMicroBytestring ] bench
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> microSendSetClass [
	"self new micro1 iterations"

	" 3011"

	self warmupSend.
	^ [ self performMicroSet ] bench
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> microSendSetClassBenchOneIteration [
	"self new micro1 iterations"

	" 3011"

	self warmupSend.
	^  self performMicroSet
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> microSendSetClassStatic [
	"self new micro1 iterations"

	" 3011"

	self warmupSendStatic.
	^ [ self performMicroSetStatic ] bench
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> microSendSetClassStaticBenchOneIteration [
	"self new micro1 iterations"

	" 3011"

	self warmupSendStatic.
	^ self performMicroSetStatic  
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> performMicroBytestring [

	1 to: 20000 do: [ :e | self sending64TimeMessageTo: 'toto' ]
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> performMicroSet [

	1 to: 20000 do: [ :e | self sending64TimeMessageTo: Set ]
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> performMicroSetStatic [

	1 to: 20000 do: [ :e | self sending64TimeMessageToSt: Set ]
]

{ #category : 'instructions' }
CallerStaticInterpreter >> sending64TimeMessageTo: x [

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

{ #category : 'instructions' }
CallerStaticInterpreter >> sending64TimeMessageToSt: x [

	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.


	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.


	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.

	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.

	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.

	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.


	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself.
	x _Object_yourself
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> warmupSend [
	3 timesRepeat: [
          self
          	sending64TimeMessageTo: Set;
	 	sending64TimeMessageTo: 1;
	  	sending64TimeMessageTo: OrderedCollection new;
          	sending64TimeMessageTo: 1.0;
		sending64TimeMessageTo: 'toto';
		sending64TimeMessageTo: Object ]
]

{ #category : 'as yet unclassified' }
CallerStaticInterpreter >> warmupSendStatic [

	3 timesRepeat: [
		self
			sending64TimeMessageToSt: Set;
			sending64TimeMessageToSt: 1;
			sending64TimeMessageToSt: OrderedCollection new;
			sending64TimeMessageToSt: 1.0;
			sending64TimeMessageToSt: 'toto';
			sending64TimeMessageToSt: Object ]
]
