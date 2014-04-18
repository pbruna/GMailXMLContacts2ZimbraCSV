require 'nokogiri'
require 'open-uri'
require 'csv'
require 'pp'

ZIMBRA_CSV_FIELDS = ["Title","FirstName","MiddleName","LastName","Suffix","Company","Department","JobTitle","BusinessStreet","BusinessCity","BusinessState","BusinessPostalCode","BusinessCountry","HomeStreet","HomeCity","HomeState","HomePostalCode","HomeCountry","OtherStreet","OtherCity","OtherState","OtherPostalCode","OtherCountry","AssistantsPhone","BusinessFax","BusinessPhone","BusinessPhone2","Callback","CarPhone","CompanyMainPhone","HomeFax","HomePhone","HomePhone2","ISDN","MobilePhone","OtherFax","OtherPhone","Pager","PrimaryPhone","RadioPhone","TTYTDDPhone","Telex","Account","Anniversary","AssistantsName","BillingInformation","Birthday","Categories","Children","DirectoryServer","EmailAddress","EmailDisplayName","Email2Address","Email2DisplayName","Email3Address","Email3DisplayName","Gender","GovernmentIDNumber","Hobby","Initials","InternetFreeBusy","Keywords","Language1","Location","ManagersName","Mileage","Notes","OfficeLocation","OrganizationalIDNumber","POBox","Priority","Private","Profession","ReferredBy","Sensitivity","Spouse","User 1","User 2","User 3","User 4","Web Page"]

Z2G_DICTIONARY = {
  "FirstName" => "givenName",
  "MiddleName" => "additionalName",
  "LastName" => "familyName",
  "BusinessPhone" => "phoneNumber",
  "EmailAddress" => "email"
}


class GmailXMLParser
  attr_reader :contacts_xml
  
  def initialize(gmail_xml_contact_data)
    @contacts_xml = parse_and_return_entries(gmail_xml_contact_data)
  end
  
  def contacts
    contacts = Array.new
    @contacts_xml.each do |contact_xml|
      contacts << GmailContact.new(contact_xml)
    end
    return contacts
  end
  
  private
  def parse_and_return_entries(gmail_xml_contact_data)
    document = Nokogiri.XML(open(gmail_xml_contact_data))
    document.xpath('//xmlns:feed/xmlns:entry')
  end
  
end

class GmailContact
  attr_accessor :contact_xml
  
  def initialize(contact_xml)
    @contact_xml = contact_xml
  end
  
  def additionalName
    ""
  end
  
  def email
    return "" if @contact_xml.xpath(".//gd:email").first.nil?
    @contact_xml.xpath(".//gd:email").first["address"]
  end
  
  def phoneNumber
    @contact_xml.xpath(".//gd:phoneNumber").text
  end
  
  def givenName
    @contact_xml.xpath(".//gd:name/gd:givenName").text
  end
  
  def familyName
    @contact_xml.xpath(".//gd:name/gd:familyName").text
  end
  
end

# main program

# Parse the XML with the contacts
# ARGV[0] is the file
contacts = GmailXMLParser.new(ARGV[0]).contacts

# build a hash with the values of the ZIMBRA_CSV_FIELDS constant ARRAYS as keys
# Remember that from Ruby 1.9 Hash are ordered, nice!!
zimbra_csv_hash = Hash.new
ZIMBRA_CSV_FIELDS.each do |el|
  zimbra_csv_hash[el] = ""
end

# Lets build the Array of contacts for the CSV File
contacts_array = []
contacts.each do |contact|
  Z2G_DICTIONARY.each do |key,value|
    zimbra_csv_hash[key] = contact.send(value)
  end
  contacts_array << zimbra_csv_hash.values
end

# Lets write the CSV file with the same name of the original file + .csv
filename = File.basename(ARGV[0], ".*")
CSV.open("#{filename}.csv", "wb", {force_quotes: true} ) do |csv|
  csv << ZIMBRA_CSV_FIELDS
  contacts_array.each do |hash|
    csv << hash
  end
end

