### START ###

form Add CV info...
   word Read_directory V:/Desktop
   positive Segment_tier 1
endform

# create table with all labels in database:
execute function_makeLabelTable.praat 'segment_tier' 'read_directory$'

# attribute category information to segment labels: 
execute function_editTable.praat

### END ###