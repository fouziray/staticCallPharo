Class {
	#name : 'PolymorphicCallSitesTests',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> methodWithPolymorphicCallSites [

	{ Object new. 3. 4.0 } do: [:each | each class ]
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testFalsePolymorphicIsMonoMorphic [

| traceRecordTree targetMethodsDict targetMethodAssociationWithTypes |	
traceRecordTree := ScpExecutionRecorder recordBlock: [ 

	self methodWithPolymorphicCallSites
  
] as: ScpExecutionRecordTree.

targetMethodsDict := self visitRecord: traceRecordTree.
targetMethodAssociationWithTypes :=(targetMethodsDict at: (self class >> #methodWithPolymorphicCallSites) ast sendNodes last ) associations first.
self assert: targetMethodAssociationWithTypes value size equals: 3.

self assert:  targetMethodAssociationWithTypes key equals: ProtoObject >> #class
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> visitRecord: aSCPRecord [

	^ self visitorClass new
		  visitExecutionRecord: aSCPRecord;
		  messageExecutionsDictionary
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> visitorClass [
	^ PolymorphicCallSitesVisitor 
]
