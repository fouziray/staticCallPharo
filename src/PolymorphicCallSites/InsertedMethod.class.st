Class {
	#name : 'InsertedMethod',
	#superclass : 'Object',
	#instVars : [
		'method',
		'callSite',
		'benchmarkResult'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'initialization' }
InsertedMethod class >> withMethod: aCollection associatedTo: aCallSiteModel [ 
	^ self new withMethod:aCollection associatedTo:aCallSiteModel.
]

{ #category : 'accessing' }
InsertedMethod >> callSite [

	^ callSite
]

{ #category : 'accessing' }
InsertedMethod >> callSite: anObject [

	callSite := anObject
]

{ #category : 'accessin' }
InsertedMethod >> compilationVsPerformance: aClass [ 
	benchmarkResult := aClass
]

{ #category : 'accessing' }
InsertedMethod >> method [

	^ method
]

{ #category : 'accessing' }
InsertedMethod >> method: anObject [

	method := anObject
]

{ #category : 'initialization' }
InsertedMethod >> withMethod: aCollection associatedTo: aCallSiteModel [

	method := aCollection.
	callSite := aCallSiteModel
]
