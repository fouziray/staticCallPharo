Class {
	#name : 'StaticCallSubclassRedefineTest',
	#superclass : 'CompilerStaticCallTest',
	#instVars : [
		'analyzer',
		'baseClass',
		'subClass1',
		'subClass2'
	],
	#category : 'StaticCallExp-Tests',
	#package : 'StaticCallExp-Tests'
}

{ #category : 'running' }
StaticCallSubclassRedefineTest >> createTestClassHierarchy [

	baseClass := Object classInstaller make: [ :builder |
		             builder
			             superclass: Object;
			             name: #StaticCallTestBase;
			             slotsFromString: '';
			             sharedVariablesFromString: '';
			             package: 'StaticCallsFinder-TestClasses';
			             environment: Object environment ].

	"Add method to base class"
	baseClass compile: 'processData
		^ ''base implementation'''.

	baseClass compile: 'callProcessor
		^ self processData'.

	"Create first subclass that overrides the method"
	subClass1 := baseClass classInstaller make: [ :builder |
		             builder
			             superclass: baseClass;
			             name: #StaticCallTestSub1;
			             slotsFromString: '';
			             sharedVariablesFromString: '';
			             package: 'StaticCallsFinder-TestClasses';
			             environment: baseClass environment ].

	subClass1 compile: 'processData
		^ ''subclass 1 implementation'''.

	"Create second subclass that also overrides the method"
	subClass2 := baseClass classInstaller make: [ :builder |
		             builder
			             superclass: baseClass;
			             name: #StaticCallTestSub2;
			             slotsFromString: '';
			             sharedVariablesFromString: '';
			             package: 'StaticCallsFinder-TestClasses';
			             environment: baseClass environment ].

	subClass2 compile: 'processData
		^ ''subclass 2 implementation'''
]

{ #category : 'running' }
StaticCallSubclassRedefineTest >> setUp [
	super setUp.
	analyzer := StaticCallAnalyzer new.
	self createTestClassHierarchy.
]

{ #category : 'running' }
StaticCallSubclassRedefineTest >> tearDown [
	"Clean up test classes"
	baseClass ifNotNil: [ baseClass removeFromSystem ].
	subClass1 ifNotNil: [ subClass1 removeFromSystem ].
	subClass2 ifNotNil: [ subClass2 removeFromSystem ].
	super tearDown
]

{ #category : 'running' }
StaticCallSubclassRedefineTest >> testAcceptsStaticCallWhenNoSubclassOverrides [

	| candidates method testClass |
	testClass := Object classInstaller make: [ :builder |
		             builder
			             superclass: Object;
			             name: #StaticCallTestNoSubs;
			             slotsFromString: '';
			             sharedVariablesFromString: '';
			             package: 'StaticCallsFinder-TestClasses';
			             environment: Object environment ].

	testClass compile: 'processData
		^ ''no subclass implementation'''.

	testClass compile: 'callProcessor
		^ self processData'.

	method := testClass >> #callProcessor.

	candidates := analyzer analyzeCompiledMethod: method.

	candidates := candidates select: [ :candidate |
		              candidate selector = #processData ].

	self
		deny: candidates isEmpty
		description:
		'Should accept static call candidate when no subclasses override the method'.

	testClass removeFromSystem
]

{ #category : 'running' }
StaticCallSubclassRedefineTest >> testRejectsStaticCallWhenSubclassesOverrideMethod [

	| candidates method |
	
	method := baseClass >> #callProcessor.
	
	candidates := analyzer analyzeCompiledMethod: method.
	
	candidates := candidates select: [ :candidate | 
		candidate selector = #processData ].
	
	self assert: candidates isEmpty
		description: 'Should reject static call candidate when subclasses override the method'.

]
