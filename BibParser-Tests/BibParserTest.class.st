Class {
	#name : #BibParserTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'BibParser-Tests'
}

{ #category : #running }
BibParserTest >> setUp [ 
	super setUp.
	parser := BibParser new.
]

{ #category : #running }
BibParserTest >> testExtractEntryId [
	| str expected actual |
	str := '@inproceedings{Demer95a'.
	expected := 'Demer95a'.
	actual := parser extractEntryId: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testExtractEntryType [
	| str expected actual |
	str := '@inproceedings{Demer95a,'.
	expected := 'inproceedings'.
	actual := parser extractEntryType: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testParseBibEntry [
	| str expected actual |
	str := '@inproceedings{Demer95a, title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author={Demers, Francois-Nicola and Malenfant, Jacques}, year ={1995} }'.
	
	expected := BibEntry
		type: 'inproceedings'
		id: 'Demer95a'
		fields: {
			'title' -> 'Reflection in logic, functional and object-oriented programming: a Short Comparative Study' .
			'booktitle' -> 'IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI' .
			'author' -> 'Demers, Francois-Nicola and Malenfant, Jacques' .
			'year' -> '1995'
		}.
		
	actual := parser parseBibEntry: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testParseBibEntryDuplicateFieldsDifferentValues [
	| str |
	str := '@inproceedings{Demer95a, title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author={Demers, Francois-Nicola and Malenfant, Jacques}, year={2000}, year ={1995} }'.
	
	self should: [ parser parseBibEntry: str ] raise: Error.
]

{ #category : #running }
BibParserTest >> testParseBibEntryDuplicateFieldsSameValue [
	| str expected actual |
	str := '@inproceedings{Demer95a, title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author={Demers, Francois-Nicola and Malenfant, Jacques}, year={1995}, year ={1995} }'.
	
	expected := BibEntry
		type: 'inproceedings'
		id: 'Demer95a'
		fields: {
			'title' -> 'Reflection in logic, functional and object-oriented programming: a Short Comparative Study' .
			'booktitle' -> 'IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI' .
			'author' -> 'Demers, Francois-Nicola and Malenfant, Jacques' .
			'year' -> '1995'
		}.
		
	actual := parser parseBibEntry: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testParseBibField [
	| str expected actual |
	str := 'title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}'.
	expected := 'title' -> 'Reflection in logic, functional and object-oriented programming: a Short Comparative Study'.
	actual := parser parseBibField: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testParseBibFieldWithSpaces [
	| str expected actual |
	str := 'title	 =   {Reflection in logic, functional and object-oriented programming: a Short Comparative Study}'.
	expected := 'title' -> 'Reflection in logic, functional and object-oriented programming: a Short Comparative Study'.
	actual := parser parseBibField: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testParseBibFieldWithoutBraces [
	| str expected actual |
	str := 'year = 1996'.
	expected := 'year' -> '1996'.
	actual := parser parseBibField: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testSplitBibEntries [
	| str expected actual |
	str := '@inproceedings{Demer95a, title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author={Demers, Francois-Nicola and Malenfant, Jacques}, year ={1995} } @inproceedings{Bier08a, author={Bierman G. and Parkinson M. and Noble J.}, booktitle={ECOOP''08}, title={UpgradeJ: Incremental Typechecking for Class Upgrades}, doi ={10.1007/978-3-540-70592-5_11}, publisher={Springer}, year={2008} } @article{Soet17a, author={Soetens, Quinten David and Robbes, Romain and Demeyer, Serge}, title={Changes as first-class citizens: a research perspective on modern software tooling}, journal={ACM Computing Surveys}, volume={50}, doi = {10.1145/3038926}, publisher={ACM}, year={2017} }'.
	
	expected := {
		'@inproceedings{Demer95a, title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author={Demers, Francois-Nicola and Malenfant, Jacques}, year ={1995} }' .
		
		'@inproceedings{Bier08a, author={Bierman G. and Parkinson M. and Noble J.}, booktitle={ECOOP''08}, title={UpgradeJ: Incremental Typechecking for Class Upgrades}, doi ={10.1007/978-3-540-70592-5_11}, publisher={Springer}, year={2008} }' .
		
		'@article{Soet17a, author={Soetens, Quinten David and Robbes, Romain and Demeyer, Serge}, title={Changes as first-class citizens: a research perspective on modern software tooling}, journal={ACM Computing Surveys}, volume={50}, doi = {10.1145/3038926}, publisher={ACM}, year={2017} }' }.
		
	actual := parser splitBibEntries: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testSplitBibFields [
	| str expected actual |
	str := 'title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author={Demers, Francois-Nicola and Malenfant, Jacques}, year={1995}'.
	
	expected := {
		'title={Reflection in logic, functional and object-oriented programming: a Short Comparative Study}' .
		'booktitle={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}' .
		'author={Demers, Francois-Nicola and Malenfant, Jacques}' .
		'year={1995}' }.
		
	actual := parser splitBibFields: str.
	self assert: actual equals: expected.
]

{ #category : #running }
BibParserTest >> testSplitBibFieldsWithSpaces [
	| str expected actual |
	str := 'title = {Reflection in logic, functional and object-oriented programming: a Short Comparative Study}, booktitle ={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}, author= {Demers, Francois-Nicola and Malenfant, Jacques}, year		=   {1995}'.
	
	expected := {
		'title = {Reflection in logic, functional and object-oriented programming: a Short Comparative Study}' .
		'booktitle ={IJCAI''95 Workshop on Reflection and Metalevel Architectures and their Applications in AI}' .
		'author= {Demers, Francois-Nicola and Malenfant, Jacques}' .
		'year		=   {1995}' }.
		
	actual := parser splitBibFields: str.
	self assert: actual equals: expected.
]
