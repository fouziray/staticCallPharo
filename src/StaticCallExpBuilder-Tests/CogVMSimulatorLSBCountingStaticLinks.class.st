Class {
	#name : 'CogVMSimulatorLSBCountingStaticLinks',
	#superclass : 'CogVMSimulatorLSB',
	#instVars : [
		'staticSendCounter'
	],
	#category : 'StaticCallExpBuilder-Tests',
	#package : 'StaticCallExpBuilder-Tests'
}

{ #category : 'as yet unclassified' }
CogVMSimulatorLSBCountingStaticLinks >> basicInitialize [

	super basicInitialize.
	staticSendCounter := 0
]

{ #category : 'as yet unclassified' }
CogVMSimulatorLSBCountingStaticLinks >> ceStaticSend: a to: b numArgs: c [

	staticSendCounter := staticSendCounter + 1.
	super ceStaticSend: a to: b numArgs: c
]

{ #category : 'accessing' }
CogVMSimulatorLSBCountingStaticLinks >> staticCallLinkCounter [
	
	^ staticSendCounter
]
