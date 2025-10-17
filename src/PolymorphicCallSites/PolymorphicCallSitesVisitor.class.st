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
			  messageTargetAndReceiver value values first size > 1 ] ]
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
