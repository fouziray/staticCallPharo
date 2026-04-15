Class {
	#name : 'CopyDownResult',
	#superclass : 'Object',
	#instVars : [
		'runtime',
		'jitCompilationOverhead'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'initialize' }
CopyDownResult class >> runtimePerformance: anInteger compilationInJitTime: anInteger2 [ 
	self new runtimePerformance: anInteger compilationInJitTime: anInteger2 
]

{ #category : 'accessing' }
CopyDownResult >> jitCompilationOverhead [

	^ jitCompilationOverhead
]

{ #category : 'accessing' }
CopyDownResult >> jitCompilationOverhead: anObject [

	jitCompilationOverhead := anObject
]

{ #category : 'accessing' }
CopyDownResult >> runtime [

	^ runtime
]

{ #category : 'accessing' }
CopyDownResult >> runtime: anObject [

	runtime := anObject
]

{ #category : 'initialize' }
CopyDownResult >> runtimePerformance: anInteger compilationInJitTime: anInteger2 [ 
	runtime:= anInteger.
	jitCompilationOverhead:= anInteger2
]
