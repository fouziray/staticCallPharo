Class {
	#name : 'MockSCDTest',
	#superclass : 'StaticCallDetectionTest',
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'as yet unclassified' }
MockSCDTest class >> sampleMethodWithSuperReceiver [

	^ super sampleMethodWithLiteralReceiver .
]
