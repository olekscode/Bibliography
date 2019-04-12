Class {
	#name : #BibStringCleanerTest,
	#superclass : #TestCase,
	#instVars : [
		'cleaner'
	],
	#category : #'BibParser-Tests'
}

{ #category : #running }
BibStringCleanerTest >> setUp [ 
	super setUp.
	cleaner := BibStringCleaner new.
]

{ #category : #tests }
BibStringCleanerTest >> testCleanup [
	| str expected actual |
	str := '
	%Comment
	
	hello,			 world
	%% Another comment	   
				'.
	
	expected := 'hello, world'.
	actual := cleaner cleanup: str.
	
	self assert: actual equals: expected.
]

{ #category : #tests }
BibStringCleanerTest >> testCleanupSpaces [
	| str expected actual |
	str := '
	hello, 			world	
						
	    '.
	
	expected := 'hello, world'.
	actual := cleaner cleanup: str.
	
	self assert: actual equals: expected.
]

{ #category : #tests }
BibStringCleanerTest >> testRemoveEmptyLinesAndComments [
	| str expected actual |
	str := '%Comment
	hello, world
	%% Another comment'.
	
	expected := 'hello, world'.
	actual := cleaner cleanup: str.
	
	self assert: actual equals: expected.
]
