"
This class helps gather data on:
	- number of classes per package.
	- number of methods per package.
	- number of lines found in the package.
"
Class {
	#name : 'TableOfAppsCharac',
	#superclass : 'Object',
	#category : 'PaperWritePack-Objects',
	#package : 'PaperWritePack',
	#tag : 'Objects'
}

{ #category : 'as yet unclassified' }
TableOfAppsCharac class >> getBlocLine [

<script>
	| packages numberOfMethods numberOfLines numberOfClasses |
	packages := ((IceRepository registry select: [ :p |
		             p name = 'Bloc' ]) first workingCopy packages) select:#isLoaded.
	numberOfClasses := packages sum:[:p | p getPackage
 classes size ] . 
	numberOfMethods := packages sum: [ :p | p getPackage methods size ].
	numberOfLines :=  packages sum: [ :p |
		                 p getPackage methods sum: [ :m | m linesOfCode ] ].
	^ { numberOfClasses . numberOfMethods . numberOfLines  } inspect
	
]

{ #category : 'as yet unclassified' }
TableOfAppsCharac class >> getHoneyGingerLine [
<script>
	| packages numberOfMethods numberOfLines numberOfClasses |
	packages := ((IceRepository registry select: [ :p |
		             p name = 'HoneyGinger' ]) first workingCopy packages) select:#isLoaded.
	numberOfClasses := packages sum:[:p | p getPackage
 classes size ] . 
	numberOfMethods := packages sum: [ :p | p getPackage methods size ].
	numberOfLines :=  packages sum: [ :p |
		                 p getPackage methods sum: [ :m | m linesOfCode ] ].
	^ { numberOfClasses . numberOfMethods . numberOfLines  } inspect
	
]

{ #category : 'as yet unclassified' }
TableOfAppsCharac class >> getMooseLine [

<script>

	| packages numberOfMethods numberOfLines numberOfClasses |
	packages := ((IceRepository registry select: [ :p | { 'Fame' . 'Famix' .  'FamixQueries' . 'FamixReplication' . 'FamixTagging' . 'MooseIDE' . 'moose' . 'ClassBlueprint'}
		             includes: p name  ]) first workingCopy packages) select:#isLoaded.
	numberOfClasses := packages sum:[:p | p getPackage
 classes size ] . 
	numberOfMethods := packages sum: [ :p | p getPackage methods size ].
	numberOfLines :=  packages sum: [ :p |
		                 p getPackage methods sum: [ :m | m linesOfCode ] ].
	^ { numberOfClasses . numberOfMethods . numberOfLines  } inspect
	
]

{ #category : 'as yet unclassified' }
TableOfAppsCharac class >> getRoassalLine [
<script>
	| packages numberOfMethods numberOfLines numberOfClasses |
	packages := ((IceRepository registry select: [ :p |
		             p name = 'Roassal' ]) first workingCopy packages) select:#isLoaded.
	numberOfClasses := packages sum:[:p | p getPackage
 classes size ] . 
	numberOfMethods := packages sum: [ :p | p getPackage methods size ].
	numberOfLines :=  packages sum: [ :p |
		                 p getPackage methods sum: [ :m | m linesOfCode ] ].
	^ { numberOfClasses . numberOfMethods . numberOfLines  } inspect
	
]
