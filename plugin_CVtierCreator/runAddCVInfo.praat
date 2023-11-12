### START ###

form Add CV info...
   word Read_directory V:/Desktop/speaker
   word Write_directory V:/Desktop/test
   positive Segment_tier 1
endform

# create CV tiers: 
table = Read from file... segmentsEdited.Table
fileList = Create Strings as file list... list 'read_directory$'/*.TextGrid
nFiles = Get number of strings
for iFile to nFiles

   select fileList
   file$ = Get string... iFile
   name$ = file$-".TextGrid"
   textGrid = Read from file... 'read_directory$'/'name$'.TextGrid

   # create CV tiers:
   select textGrid
   execute function_addCVInfo.praat 'segment_tier' 'table'
   cv_grid = selected("TextGrid")

   # Save output: 
   select cv_grid
   Write to text file... 'write_directory$'/'file$'

   # clean up: 
   select textGrid
   plus cv_grid
   Remove

endfor

# clean up
select fileList
plus table
Remove

### END ###