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
			package: 'Faouzi' with: [ spec requires: #( 'VMMaker' ) ] ]
]
