### Introducction
This is a Ruby script that read and parse a GMail XML contact file and returns a CSV file to be imported with the Zimbra Webmail.

This is a 0.1 version, meaning it just do what I need it to do right now, nothing Fancy yet.

### Google Reference
The information needed to make the translation from Google to Zimbra is located here https://developers.google.com/gdata/docs/2.0/elements

This is what is used in the ``Z2G_DICTIONARY`` constant Hash.

### How to use it

####1 Clone this repo
```bash
git clone git@github.com:pbruna/GMailXMLContacts2ZimbraCSV.git
```

####2 Run bundle inside the new directory to install what you need
```bash
bundle
```

####3 Convert the #%%$! XML Google File
```bash
ruby gc2zc.rb contacts.xml
```

####4 You should get a new file called ```contacts.csv```

### TODOs
Here is what I should start working next:

1. Testing, yes, testing
2. Auto-write (Metaprograming) the methods of GmailContact with method_missing
3. Check that the file passed is actually a XML file
4. Ask for help

