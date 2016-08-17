# Importer Exporter

Below are details about the Importer Exporter solution I (Michael Telford) developed in Ruby on my 
Mac using TextMate and the command line. 

Firstly I set up a public Bitbucket repository, ran `bundle gem importer_exporter` on my local machine 
and added the Bitbucket repo as a remote (origin). Now that the project scaffolding was in place and 
under source control I was ready to commence with the actual engineering steps which are listed below. 

See the Usage section (at the bottom) for running the software. 

## Requirements

The first step was to derive the following requirements from the specification. The requirements 
would serve as a way of asserting the completed system and are listed against certain tests to show 
that they have been met. 

### Functional Requirements

**FUNC_REQ_1** : Convert Product CSV to JSON.

### Non-Functional Requirements

**NON_FUNC_REQ_1** : Easily support other formats (both input and output).

**NON_FUNC_REQ_2** : Easily support other types (of input) such as Customer and Transaction.

### Additional Requirements

I've taken the liberty of documenting and implementing some additional requirements which weren't 
explictely listed in the spec but made sense to implement. See below. 

**ADD_REQ_1** : Calculate product total prices (or current total prices for 'open' items) and total_margins taking into account price, cost and modifiers (if applicable). This total should 
be persisted through into the output format when converted. 

## Assumptions

Below are some assumptions that I feel are acceptable based on the specification that have played a 
part in the design and/or development of the system. In a real life scenario I would seek to confirm 
such assumptions as part of the design prior to development. 

- It is assumed that adding additional fields to the JSON that aren't in example.json won't be an issue  later on or for other systems, for example the additional fields from ADD_REQ_1. Equally so it is 
	assumed that the order of the JSON fields is unimportant. 
- It is assumed that all modifier monetary values will begin with a minus for negative values, otherwise 
	it is assumed a positive value. This logic is used to fulfil ADD_REQ_1 (listed above). 
- It is assumed that the CSV columns will follow a consistent naming convention e.g. the modifier 
	columns will all look like 'modifier_N_name' etc. It is also assumed that each modifier will appear 
	as first a name and then followed by a price column. 
- It is assumed that the monetary values in the output format e.g. JSON will be sufficient as 0.7 
	instead of 0.70 etc as it's the same value as far as the Float is concerned. 
- It is assumed that rounding monetary values to 2 decimal place is sufficient, this can be changed 
	very easily in the use of the Utils.round method if not. 
-	It is assumed that the input format/type will always come from a file e.g. example.csv or .txt. 
	This could be easily changed if necessary however. 

## Design

Since multiple input and output formats should be supported in the future it made sense to convert 
the input into a neutral language format before converting it into the output format. This way 
you can easily extend the format capability with a smaller changeset being required. The neutral 
language format that made the most sense was the Ruby Hash because nearly all kinds of data 
interchange formats are key/value based, as is a Hash. 

An 'input type' in this system is the entity type of the data being converted. For example a Person 
Customer or Transaction. By creating a specific class for each input type, we have a container for 
business logic specific to that type. This business logic can be to do with the conversion, or not. 
A good example of additional business logic used in the Person class is the total price or total 
margins methods (see ADD_REQ_1 above). 

The main classes that make up the design and components of the system are:

**Modifier** - Used to provide logic for manipulating prices and margins in Products. Uses 
the Utils.to_h functionality to convert itself into a Hash which is used in the conversion of 
the input to output data. 

**Product** - Used to provide logic and data handling of the Product input type. Is a subclass of 
*InputType* (used for generic input type behaviour). Product uses the Utils.to_h functionality to 
convert itself into a Hash which is used in the conversion of the input data. Contains zero or more Modifiers which have their modifications applied to determine the range of total costs and margins 
for the product. The Utils logic should be used in any input type extension classes e.g. 
Transaction. For example, a Product can be initialised using a Hash with each key value pair being 
setup as an instance var with a getter method for convience. Since this logic is reusable it 
should further reduce the amount of work needed to further extend the system. 

**Utils** - Provides static/module functionality for generic behaviour such as initializing an 
instance dynamically from a Hash. Used by several classes to DRY up the code where possible. 

**FormatConverter** - The main conversion class which has a 'plugable' design offering easy 
extendability of the input and output data formats as well as the range of input types such as 
Product or Customer etc. To extend either the input format, output format or the input type 
a developer should add a new case statement and method to process the new functioanlity. For 
example: 

To support a new input format you should create a new process_input_* method whose job it is to 
pass a row of input (as as Array) to process_input_type. Developers should be mindful of the 
size of the input/file and its effect on resources. For example the csv file handling 
deliberately processes one line at a time so to reduce the resources required for processing. 
To support a new input type you should create a new process_type_* method whose job it is to 
build a hash to represent the input row/instance. This creates the neutral model data 
to act as the middle ground between conversions. 
To support a new output format you should create a new process_output_* method whose job it is 
to turn the neutral Hash data into the output format. 
All new methods should be added to the corresponding switch cases to be called. 

There is also a main.rb script which takes user inputs and uses them to initialise an instance 
of FormatConverter before saving the output to a file in the project root directory. This creates 
a CLI for the system. 

### Dependancies

Below are the dependancies for the main classes in the system. Understanding the dependancies 
between the different system components aids the development of isolated and atomic services. 
In general the fewer and simpler the dependancies the better. 

- main.rb 				-> FormatConverter 	- 1:1
- FormatConverter -> Product 					- 1:M
- Product 				-> Modifier 				- 1:M

## Development

During the development of any solution I try to achieve the following:

- 1 Make it correct (so it meets the requirements). 
- 2 Make it readable (and therefore maintainable).
- 3 Make it fast (and efficient).

With the design and dependancies in place I began an Agile test driven development approach of Red, 
Green, Refactor. I firstly created the classes and method stubs thinking about the parameters and 
return type for each. Once the stubs were in place I began writing tests for the units. Obviously the 
tests all failed the first time they were run (Red). I then began writing the code to fill in the method 
stubs and re-ran the tests making minor changes as needed until they passed (Green). Once done, I 
took the opportunity to re-evaluate the solution double checking the requirements had been met and 
refactoring the code to either increase its readability or efficiency (Refactor). During the 
refactoring of the code, I followed the "little and often" mantra whilst running my tests after 
each (small) changeset for regression testing purposes. 

## Documentation

The documentation of the code is currently mimimal for these reasons:

- This README.md file covers much of the design including each classes responsibilities and 
dependancies etc.
- In a real life scenario I would expect some form of code reviewal to be performed which may 
necessitate a refactor or change in logic prior to the completion of the code documentation. 
- The Ruby language when written with care and discipline is in many ways self documenting. 
Therefore I've mostly commented as to 'why' something is done a certain way, because the code 
in most cases can be read to determine 'what' is being done. 

## Usage

For the following steps please open a command line and `cd` into the project root directory having 
cloned the repository. 
Note: My machine uses Ruby 2.2.2 and is enforced in the Gemfile.  This can be commented out so that 
other versions of Ruby can be used, however I can't garentee the behaviour in such a scenario. 

### Running the Code

Run `bundle install` to install the dependancies. 
Run `ruby main.rb ./example.csv product json` to produce an example.json file in the root directory.

### Running the Tests

Run `rake test`. The minitest library is used for unit testing for it's simplicity and ease of use. 

### Viewing the Documentation

To update the docs run `yard`.
To view the docs run `yard server` and browse to http://localhost:8808 (check the yard output). 
