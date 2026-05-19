Class {
	#name : 'CopyDownResult',
	#superclass : 'Object',
	#instVars : [
		'runtime',
		'jitCompilationOverhead',
		'insertedMethodsSizs'
	],
	#category : 'PolymorphicCallSites-CopyDowner',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDowner'
}

{ #category : 'initialize' }
CopyDownResult class >> runtimePerformance: anInteger compilationInJitTime: anInteger2 [

	^ self new
		runtimePerformance: anInteger
		compilationInJitTime: anInteger2
]

{ #category : 'converting' }
CopyDownResult >> asPointInGraph [

	^ {
		self runtime.
		self jitCompilationOverhead }
]

{ #category : 'as yet unclassified' }
CopyDownResult >> insertedMethodsSize [
	^ insertedMethodsSizs
]

{ #category : 'as yet unclassified' }
CopyDownResult >> insertedMethodsSize: aNumber [
	 insertedMethodsSizs:= aNumber asString
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
