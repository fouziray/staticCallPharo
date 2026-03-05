Class {
	#name : 'IcSiteType',
	#superclass : 'Object',
	#instVars : [
		'caller',
		'suite',
		'receivers'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'instance creation' }
IcSiteType class >> with: aSuite [

	^ self new suite: aSuite
]

{ #category : 'accessing' }
IcSiteType >> caller [

	^ suite caller
]

{ #category : 'accessing' }
IcSiteType >> receivers [

	^ receivers
]

{ #category : 'accessing' }
IcSiteType >> receivers: anObject [

	receivers := anObject
]

{ #category : 'running' }
IcSiteType >> reinitCaller [

	suite reinitCaller.
	caller := suite caller
]

{ #category : 'running' }
IcSiteType >> setUp [

	self subclassResponsibility
]

{ #category : 'accessing' }
IcSiteType >> suite: aSuite [

	suite := aSuite
]
