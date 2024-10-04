Class {
	#name : 'BaselineOfStaticCallExp',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfStaticCallExp',
	#package : 'BaselineOfStaticCallExp'
}

{ #category : 'baselines' }
BaselineOfStaticCallExp >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			baseline: 'VMMaker' with: [
				spec repository:
						'github://pharo-project/pharo-vm:pharo-10/smalltalksrc' ];
			package: 'StaticCallExp-Tests';
			package: 'StaticCallExp' with: [ spec requires: #( 'VMMaker' 'StaticCallExp-Tests') ] ]
]
