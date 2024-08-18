Extension { #name : 'Integer' }

{ #category : '*StaticCallExp' }
Integer >> incd [

	<opalBytecodeMethod>
	^ IRBuilder buildIR: [ :builder |
		  builder
			  pushReceiver;
			  pushLiteral: 1;
			  sendStatic: SmallInteger >> #+;
			  pushLiteral: 1;
			  sendStatic: SmallInteger >> #+;
			  returnTop ]
]

{ #category : '*StaticCallExp' }
Integer >> staticBoundRecursiveFactorial [

	<opalBytecodeMethod>
	
	^ IRBuilder buildIR: [ :builder |
		  builder
			  pushReceiver;
			  pushLiteral: 1;
			  send: #'<=';
			  jumpAheadTo: #gogogo if: false;
			  "Base case"pushLiteral: 1;
			  returnTop;
			  "Recursive case"jumpAheadTarget: #gogogo;
			  pushReceiver;
			  pushReceiver;
			  pushLiteral: 1;
			  send: #-;
			  sendStatic: (StaticRecursiveMethodPlaceHolder new selector:
						   #staticBoundRecursiveFactorial);
			  send: #*;
			  returnTop ] 
]

{ #category : '*StaticCallExp' }
Integer >> staticBoundRecursiveFactorialHardcore [

	<opalBytecodeMethod>
	^ IRBuilder buildIR: [ :builder |
		  builder
			  pushReceiver;
			  pushLiteral: 1;
			  sendStatic: SmallInteger >> #'<=';
			  jumpAheadTo: #gogogo if: false;
			  
			  "Base case"
			  pushLiteral: 1;
			  returnTop;
			  
			  "Recursive case"
			  jumpAheadTarget: #gogogo;
			  pushReceiver;
			  pushReceiver;
			  pushLiteral: 1;
			  sendStatic: (SmallInteger >> #-);
			  sendStatic: (StaticRecursiveMethodPlaceHolder new selector:
						   #staticBoundRecursiveFactorialHardcore);
			  sendStatic: SmallInteger >> #*;
			  returnTop ]
]

{ #category : '*StaticCallExp' }
Integer >> staticPlus [

	<opalBytecodeMethod>
	^ IRBuilder buildIR: [ :builder |
		  builder
			  pushReceiver;
			  pushLiteral: 1;
			  sendStatic: SmallInteger >> #+;
			  returnTop ]
]
