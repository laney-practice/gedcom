require 'gedcom_base.rb'

#Internal representation of the GEDCOM SUBM record type
#
#=SUBMITTER_RECORD:=
#  0 @<XREF:SUBM>@ SUBM                 {0:M}
#    +1 NAME <SUBMITTER_NAME>           {1:1}
#    +1 <<ADDRESS_STRUCTURE>>           {0:1}
#    +1 PHON <PHONE_NUMBER>             {0:3} (defined in the Address structure)
#    +1 <<MULTIMEDIA_LINK>>             {0:M}
#    +1 LANG <LANGUAGE_PREFERENCE>      {0:3}
#    +1 RFN <SUBMITTER_REGISTERED_RFN>  {0:1}
#    +1 RIN <AUTOMATED_RECORD_ID>       {0:1}
#    +1 <<CHANGE_DATE>>                 {0:1}
#
#  I also recognise notes in this record, so I can handle user tags as notes.
#    +1 <<NOTE_STRUCTURE>>              {0:M}
#
#  The submitter record identifies an individual or organization that contributed information contained
#  in the GEDCOM transmission. All records in the transmission are assumed to be submitted by the
#  SUBMITTER referenced in the HEADer, unless a SUBMitter reference inside a specific record
#  points at a different SUBMITTER record.
#
#The attributes are all arrays. 
#* Those ending in _ref are GEDCOM XREF index keys
#* Those ending in _record are array of classes of that type.
#* The remainder are arrays of attributes that could be present in the SUBM records.
#
# GEDCOM 5.5.1 Draft adds (at same level as ADDR)
#  I have not included these in the Address_record, but include them in the parent
#  records that include ADDRESS_STRUCTURE. This is functionally equivalent, as they are not
#  sub-records of ADDR, but at the same level.
#
#  n EMAIL <ADDRESS_EMAIL>               {0:3}
#  n FAX <ADDRESS_FAX>                   {0:3}
#  n WWW <ADDRESS_WEB_PAGE>              {0:3}
#
#==ADDRESS_EMAIL:= {SIZE=5:120}
#  An electronic address that can be used for contact such as an email address.
#
#== ADDRESS_FAX:= {SIZE=5:60}
#  A FAX telephone number appropriate for sending data facsimiles.
#
#==ADDRESS_WEB_PAGE:= {SIZE=5:120}
#  The world wide web page address.
#

class Submitter_record < GEDCOMBase
  attr_accessor :submitter_ref, :name_record, :address_record, :phone, :multimedia_citation_record
  attr_accessor :language_list, :lds_submitter_id, :automated_record_id, :change_date_record, :note_citation_record
  attr_accessor :address_email, :address_fax, :address_web_page #GEDCOM 5.5.1 Draft

  ClassTracker <<  :Submitter_record
   
  #new sets up the state engine arrays @this_level and @sub_level, which drive the to_gedcom method generating GEDCOM output.
  def initialize(*a)
    super(*a)
    @this_level = [ [:xref, "SUBM", :submitter_ref] ]
    @sub_level =  [ #level + 1
                    [:walk, nil,    :name_record ],
                    [:walk, nil,    :address_record ],
                    [:print, "PHON",    :phone ],
                    [:print, "EMAIL",    :address_email ],
                    [:print, "FAX",    :address_fax ],
                    [:print, "WWW",    :address_web_page ],
                    [:print, "LANG",    :language_list ],
                    [:walk, nil,    :multimedia_citation_record ],
                    [:walk, nil,    :note_citation_record ],
                    [:print, "RFN",    :lds_submitter_id ],
                    [:print, "RIN",    :automated_record_id ],
                    [:walk, nil,    :change_date_record ],
                  ]
  end 
  
end

