Class {
	#name : 'PolymorphicCallSitesVisitor',
	#superclass : 'ScpExecutionRecordVisitor',
	#instVars : [
		'messageExecutionsDictionary'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'tests' }
PolymorphicCallSitesVisitor class >> filterFakePoly: targetMethodsDict [

	^ targetMethodsDict associations select: [ :messageTargetAndReceiver |
		  messageTargetAndReceiver value keys size = 1 and: [
			  messageTargetAndReceiver value values first asIdentitySet size > 1 ] ]
]

{ #category : 'tests' }
PolymorphicCallSitesVisitor class >> getCallFrequencyForMessages: targetMethodsDict [

	| dict |
	dict := Dictionary new.

	targetMethodsDict do: [ :messageTargetAndReceiver |
	dict at: messageTargetAndReceiver  put: (messageTargetAndReceiver value values inject:0 into:[:sum :each | 
		 (each isKindOf: Bag) ifTrue: [ sum + each  asDictionary values sum ] ifFalse: [ sum + 1 ] ]).
	].

	^ dict
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
