Class {
	#name : 'ScpMethodTrace',
	#superclass : 'ScpInvocationTrace',
	#instVars : [
		'sender',
		'result',
		'callSite'
	],
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'visiting' }
ScpMethodTrace >> accept: aScpExecutionRecordVisitor [

	^ aScpExecutionRecordVisitor visitMethodTrace: self
]

{ #category : 'visiting' }
ScpMethodTrace >> accept: aScpExecutionRecordVisitor and: anOtherTraceForComparision [

	^ aScpExecutionRecordVisitor visitMethodTrace: self and: anOtherTraceForComparision
]

{ #category : 'as yet unclassified' }
ScpMethodTrace >> callSite [

	^ callSite
]

{ #category : 'as yet unclassified' }
ScpMethodTrace >> callSite: aCallSiteNode [

	callSite := aCallSiteNode
]

{ #category : 'accessing' }
ScpMethodTrace >> icon [

	^ self iconNamed: #collection
]

{ #category : 'testing' }
ScpMethodTrace >> isMethod [

	^ true
]

{ #category : 'testing' }
ScpMethodTrace >> isTracked [

	^ true
]

{ #category : 'presenters' }
ScpMethodTrace >> presenterForDetails [

	^ ScpMethodTraceDetailsPresenter on: self
]

{ #category : 'printing' }
ScpMethodTrace >> printOn: aStream [

	aStream << 'Method(' << self stringForProperties << ')'
]

{ #category : 'accessing' }
ScpMethodTrace >> receiver [

	^ self object
]

{ #category : 'accessing' }
ScpMethodTrace >> result [

	^ result
]

{ #category : 'accessing' }
ScpMethodTrace >> result: anObject [

	result := anObject
]

{ #category : 'accessing' }
ScpMethodTrace >> sender [

	^ sender
]

{ #category : 'accessing' }
ScpMethodTrace >> sender: anObject [

	sender := anObject
]
