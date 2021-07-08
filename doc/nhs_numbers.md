## NHS Number

The NHS number is a 10 digit number that conforms to the modulus 11 algorightm
where the 10th digit is a check digit. NHS guidelines specify it should be displayed with spaces
e.g. "943 476 5919", but we store it internally as a string without spaces eg "9434765919".


### Test numbers

The following useful numbers are valid:

- 0000000000
- 1111111111
- ...
- 9999999999
- 0123456789

There are also some very helpful [online NHS Number generators](http://danielbayley.uk/nhs-number/).

There are about 38000 valid test nhs_numbers in ./example_nhs_numbers.txt and also some test numbers
in spec/factories/patients/patients.rb or in the demo data patient seeds file.

### References
- [Wikipedia](https://en.wikipedia.org/wiki/NHS_number)
- [NHS](https://www.nhs.uk/using-the-nhs/about-the-nhs/what-is-an-nhs-number/)
- [Specification](https://digital.nhs.uk/data-and-information/information-standards/information-standards-and-data-collections-including-extractions/publications-and-notifications/standards-and-collections/isb-0149-nhs-number)
