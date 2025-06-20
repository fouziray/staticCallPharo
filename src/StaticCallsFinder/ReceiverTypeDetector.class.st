Class {
	#name : 'ReceiverTypeDetector',
	#superclass : 'Object',
	#instVars : [
		'receiverTypes'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ReceiverTypeDetector >> captureReceiverType: aNode [

    | receiver receiverType |
    receiver := aNode receiver.
    receiverType := receiver class name.
    receiverTypes add: receiverType.
]

{ #category : 'initialization' }
ReceiverTypeDetector >> getReceiverTypes [

	^ receiverTypes copy
]

{ #category : 'initialization' }
ReceiverTypeDetector >> initialize [
    super initialize.
    receiverTypes := OrderedCollection new
]

{ #category : 'initialization' }
ReceiverTypeDetector >> installOn: aMethod [

	| link |
	link := MetaLink new
		        metaObject: self;
		        selector: #captureReceiverType:;
		        control: #before.
	aMethod ast link: link
]
