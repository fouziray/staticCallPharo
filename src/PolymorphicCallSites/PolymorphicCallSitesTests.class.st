Class {
	#name : 'PolymorphicCallSitesTests',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> methodWithPolymorphicCallSiteNonDevirtualizable [

	{
		Object new.
		3.
		4.0 } do: [ :each | each defaultLabel ]
]

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

self assert: (targetMethodsDict associations select: [ :messageTargetAndReceiver | messageTargetAndReceiver value keys size = 1   ]) equals: targetMethodsDict associations .
self assert: targetMethodAssociationWithTypes value size equals: 3.

self assert:  targetMethodAssociationWithTypes key equals: ProtoObject >> #class
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testTruePolymorphic [

| traceRecordTree targetMethodsDict targetMethodAssociationWithTypes |	
traceRecordTree := ScpExecutionRecorder recordBlock: [ 

	self methodWithPolymorphicCallSiteNonDevirtualizable
  
] as: ScpExecutionRecordTree.

targetMethodsDict := self visitRecord: traceRecordTree.
targetMethodAssociationWithTypes :=(targetMethodsDict at: (self class >> #methodWithPolymorphicCallSiteNonDevirtualizable ) ast sendNodes last ) associations first.

self assert: (targetMethodsDict associations select: [ :messageTargetAndReceiver | messageTargetAndReceiver value keys size = 1   ]) size equals: targetMethodsDict size - 1 .
self assert: targetMethodAssociationWithTypes value size equals: 2.

self assert:  targetMethodAssociationWithTypes key equals: Number>>#defaultLabel.

targetMethodAssociationWithTypes :=(targetMethodsDict at: (self class >> #methodWithPolymorphicCallSiteNonDevirtualizable ) ast sendNodes last ) associations last.

self assert: targetMethodAssociationWithTypes value size equals: 1.

self assert:  targetMethodAssociationWithTypes key equals: Object>>#defaultLabel.
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
