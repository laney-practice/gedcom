require 'gedcom_all.rb'

#Transmission subclasses TransmissionBase, providing a cleaner view for public consumption.
#
#TransmissionBase is a subclass of GEDCOMBase, and contains methods used by the parsing process
#to build the other Gedcom classes, instantiate instances for each GEDCOM record type, and populate
#the fields based on the parsed GEDCOM file.
#
#
#A Transmission object is encapsulating a LINEAGE_LINKED_GEDCOM. From the GEDCOM 5.5 standard:
#=LINEAGE_LINKED_GEDCOM:=
#  This is a model of the lineage-linked GEDCOM structure for submitting data to other lineage-linked
#  GEDCOM processing systems. A header and a trailer record are required, and they can enclose any
#  number of data records. Tags from Appendix A (see page 67) must be used in the same context as
#  shown in the following form. User defined tags (see <NEW_TAG> on page 46) are discouraged but
#  when used must begin with an under-score.
#    0 <<HEADER>>               {1:1}
#    0 <<SUBMISSION_RECORD>>    {0:1}
#    0 <<FAM_RECORD>>           {0:M}
#    0 <<INDIVIDUAL_RECORD>>    {0:M}
#    0 <<MULTIMEDIA_RECORD>>    {0:M}
#    0 <<NOTE_RECORD>>          {0:M}
#    0 <<REPOSITORY_RECORD>>    {0:M}
#    0 <<SOURCE_RECORD>>        {0:M}
#    0 <<SUBMITTER_RECORD>>     {0:M}
#    0 TRLR                     {1:1} 
#
#Each of the classes attributes is an array of objects representing the level 0 GEDCOM records in the
#transmission. There is also an :index attribute defined in GEDCOMBase, with an associated 
#find method (see Transmission#find)


class  Transmission < TransmissionBase
 
  attr_accessor :header_record, :submitter_record, :family_record, :individual_record, :source_record
  attr_accessor :multimedia_record, :note_record, :repository_record, :submission_record, :trailer_record

  def initialize(*a)
    super(nil, *a[1..-1]) #don't need to put ourselves into @transmission.
    
    @this_level = [ [:walk, nil, :header_record],     #Recurse over the HEAD header records (should only be one)
                    [:walk, nil, :submission_record], #Recurse over the SUBN submission records
                    [:walk, nil, :submitter_record],  #Recurse over the SUBM submitter record(s)
                    [:walk, nil, :source_record],     #Recurse over the SOUR Source records
                    [:walk, nil, :repository_record], #Recurse over the REPO repository records
                    [:walk, nil, :family_record],     #Recurse over the FAM Family records
                    [:walk, nil, :individual_record], #Recurse over the INDI Individual records
                    [:walk, nil, :multimedia_record], #Recurse over the OBJE multimedia records
                    [:walk, nil, :note_record],       #Recurse over the NOTE records
                    [:walk, nil, :trailer_record],    #Recurse over the Trailer Record(s). (should only be the one).
                  ]
    @sub_level =  [#level + 1
                  ]

  end

  #Looks in a transmissions indexes for an index called index_name, returning the value associated with the key.
  #also used by xref_check to validate the XREF entries in a transmission really do point to valid level 0 records.
  #Standard indexes are the same as the level 0 types that have XREF values:
  #* :individual
  #* :family
  #* :note
  #* :source
  #* :repository
  #* :multimedia
  #* :submitter
  #* :submission
  #Keys in each of these indexes are the XREF values from the GEDCOM file.
  #The values stored in the indexes are the actual objects that they refer to.
  #* e.g. 
  #     if (f = find(:individual,"I14") ) != nil then print f.to_gedcom end
  #  will find the Individual's record with "0 @I14@ INDI" and print the record and its sub-records.
  def find(index_name, key)
    if @indexes != nil && (index = @indexes[index_name.to_sym]) != nil
      index[key]
    else
      nil
    end
  end
  
  #debugging code to show what indexes were created and what keys are in each
  #Printing out the index values generates too much output, so these are ignored.
  def dump_indexes
    @indexes.each do |key,value|
      puts "Index #{key}"
      value.each do |vkey, vvalue|
        puts "\t#{vkey}"
      end
    end
  end
  
  def self_check
    @family_record.each do |f|
      f.self_check
    end
    @individual_record.each do |i|
      i.self_check
    end
  end
=begin
  def summary
    @@tabs = true
    if (f = find(:individual,"PERSON7") ) != nil 
       s = f.to_gedcom
       puts s #output window copy gives an error.
       File.open('/tmp/xx.txt','w') { |fd| fd.print s } #file copy is correct
       puts s #output window copy gives an error.
    end 
    @@tabs = false
  end
=end
end
