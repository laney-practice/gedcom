require 'gedcom_base.rb'

#Internal representation of the GEDCOM PLAC record type. Sub-record of HEAD and EVENT
#
#=PLACE_STRUCTURE:=
#  n PLAC <PLACE_VALUE>         {1:1}
#    +1 FORM <PLACE_HIERARCHY>  {0:1}
#    +1 <<SOURCE_CITATION>>     {0:M}
#    +1 <<NOTE_STRUCTURE>>      {0:M}
#
#==PLACE_VALUE:= {Size=1:120}
# 
#  <TEXT> | <TEXT>, <PLACE_VALUE>
#
#  The jurisdictional name of the place where the event took place. Jurisdictions are separated by
#  commas, for example, "Cove, Cache, Utah, USA." If the actual jurisdictional names of these places
#  have been identified, they can be shown using a PLAC.FORM structure either in the HEADER or in
#  the event structure. (See <PLACE_HIERARCHY>, page 47.)
#
#The attributes are all arrays for the level +1 tags/records. 
#* Those ending in _record are array of classes of that type.
#* The remainder are arrays of attributes that could be present in the PLAC records.
class Place_record < GEDCOMBase
  attr_accessor :place_value, :place_hierachy, :source_citation_record, :note_citation_record

  ClassTracker <<  :Place_record
  
  def to_gedcom(level=0)
    if @place_value != nil
      @this_level = [  [:print, "PLAC", :place_value] ]
      @sub_level =  [ #level + 1
                      [:print, "FORM", :place_hierachy],
                      [:walk, nil,    :source_citation_record],
                      [:walk, nil,    :note_citation_record],
                    ]
    else
      @this_level = [  [:nodata, "PLAC", nil] ]
      @sub_level =  [ #level + 1
                      [:print, "FORM", :place_hierachy],
                      [:walk, nil,    :source_citation_record],
                      [:walk, nil,    :note_citation_record],
                    ]
    end
    super(level)
  end
end
