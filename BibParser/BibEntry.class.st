Class {
	#name : #BibEntry,
	#superclass : #Dictionary,
	#instVars : [
		'type',
		'id'
	],
	#category : #BibParser
}

{ #category : #'as yet unclassified' }
BibEntry class >> type: aTypeString id: anIdString fields: anArrayOfAssociations [
	^ self new
		type: aTypeString;
		id: anIdString;
		fields: anArrayOfAssociations.
]

{ #category : #comparing }
BibEntry >> = anObject [
	(anObject species = self species)
		ifFalse: [ ^ false ].
		
	(anObject type = self type)
		ifFalse: [ ^ false ].
		
	(anObject id = self id)
		ifFalse: [ ^ false ].
		
	^ anObject fields = self fields
]

{ #category : #accessing }
BibEntry >> fields [
	^ self asDictionary
]

{ #category : #accessing }
BibEntry >> fields: anArrayOfAssociations [
	self keys copy do: [ :k | self removeKey: k ].
	self addAll: anArrayOfAssociations asDictionary.
]

{ #category : #accessing }
BibEntry >> id [
	^ id
]

{ #category : #accessing }
BibEntry >> id: anObject [
	id := anObject
]

{ #category : #accessing }
BibEntry >> type [
	^ type
]

{ #category : #accessing }
BibEntry >> type: anObject [
	type := anObject
]
