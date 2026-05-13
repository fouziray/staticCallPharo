Extension { #name : 'ScpExecutionRecorder' }

{ #category : '*StaticCallsFinder' }
ScpExecutionRecorder >> message: aNode sender: aSender receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
	| method class |

	execution message: (ScpMessageTrace new
		timestamp: self timestamp;
		node: aNode;
		object: aSender;
		receiver: aReceiver;
		arguments: aArguments;
		yourself).

   class := aNode isSuperSend
		ifTrue: [ aNode methodNode methodClass superclass ]
  		ifFalse: [ aReceiver class ].

   method := self lookup: aNode selector in: class.

   ^ self recordMethod: method onReceiver: aReceiver withArguments: aArguments withNode: aNode.

]

{ #category : '*StaticCallsFinder' }
ScpExecutionRecorder >> recordMethod: aCompiledMethod onReceiver: aReceiver withArguments: aArguments withNode: aNode [

	<noInstrumentation>
   | trace arguments |

  arguments := aArguments.

	(aCompiledMethod selector = #doesNotUnderstand:) ifTrue: [ 
			arguments := { (MessageSend
						receiver: aReceiver
                 selector: aCompiledMethod selector 
                 arguments: aArguments) }
   	].
  trace := aCompiledMethod isInstrumented 
		ifTrue: [ ScpMethodTrace new ] 
		ifFalse: [ ScpMethodUntrackedTrace new ].

	trace timestamp: self timestamp.
   trace node: aCompiledMethod sourceNode.
   trace object: aReceiver.
	trace callSite: aNode. 
   trace arguments: arguments.

	[  
		execution method: trace.
		trace result: (aReceiver withArgs: arguments executeMethod: aCompiledMethod)
	] ensure: [ execution pop ]. 
	self flag: 'I have no idea why I need the above ensure block.'
		, 'To investigate, remove the ensure block and test with ScpExecutionRecorderTest >> #testMethodThatRequiresAnEnsureBlock'.

   ^ trace result
]
