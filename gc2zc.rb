require 'nokogiri'
require 'open-uri'
require 'csv'

ZIMBRA_CSV_FIELDS = ["Title","FirstName","MiddleName","LastName","Suffix","Company","Department","JobTitle","BusinessStreet","BusinessCity","BusinessState","BusinessPostalCode","BusinessCountry","HomeStreet","HomeCity","HomeState","HomePostalCode","HomeCountry","OtherStreet","OtherCity","OtherState","OtherPostalCode","OtherCountry","AssistantsPhone","BusinessFax","BusinessPhone","BusinessPhone2","Callback","CarPhone","CompanyMainPhone","HomeFax","HomePhone","HomePhone2","ISDN","MobilePhone","OtherFax","OtherPhone","Pager","PrimaryPhone","RadioPhone","TTYTDDPhone","Telex","Account","Anniversary","AssistantsName","BillingInformation","Birthday","Categories","Children","DirectoryServer","EmailAddress","EmailDisplayName","Email2Address","Email2DisplayName","Email3Address","Email3DisplayName","Gender","GovernmentIDNumber","Hobby","Initials","InternetFreeBusy","Keywords","Language1","Location","ManagersName","Mileage","Notes","OfficeLocation","OrganizationalIDNumber","POBox","Priority","Private","Profession","ReferredBy","Sensitivity","Spouse","User 1","User 2","User 3","User 4","Web Page"]

Z2G_DICTIONARY = {
  "FirstName" => {"gd:name" => "gd:givenName"},
  "MiddleName" => {"gd:name" => "gd:additionalName"},
  "LastName" => {"gd:name" => "gd:familyName"},
  "BusinessPhone" => "gd:phoneNumber",
  "EmailAddress" => "gd:email#address"
}


class GmailXMLParser
  attr_reader :contacts
  
  def initialize(gmail_xml_contact_data)
    contacts = Nokogiri.XML(open(gmail_xml_contact_data))
  end
  
  private
  def parse_and_return_entries
    document = Nokogiri.XML(open(gmail_xml_contact_data))
    document.xpath('//xmlns:feed/xmlns:entry')
  end
  
end

class GmailContact
  attr_accessor :contact_xml
  
  def initialize(contact_xml)
    contact_xml = contact_xml
  end
  
  def email
    contact_xml.xpath(".//gd:email").first["address"]
  end
  
  def phoneNumber
    contact_xml.xpath(".//gd:phoneNumber").text
  end
  
  def givenName
    contact_xml.xpath(".//gd:name/gd:givenName").text
  end
  
  def familyName
    contact_xml.xpath(".//gd:name/gd:givenName").text
  end
  
end