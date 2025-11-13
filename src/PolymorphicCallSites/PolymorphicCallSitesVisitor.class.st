Class {
	#name : 'PolymorphicCallSitesVisitor',
	#superclass : 'CallSitesFrequencyVisitor',
	#instVars : [
		'messageExecutionsDictionary'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

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
