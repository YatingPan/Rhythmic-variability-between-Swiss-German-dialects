# This extracts all different labels used in all 
# Text Grid files in a directory and writes them 
# into a table. 

form Get labels...
   positive tier 1
   word folder V:\Desktop
endform

table = Create Table with column names... segments 1 segment
fileList = Create Strings as file list... list 'folder$'/*.TextGrid
nFiles = Get number of strings
for iFile to nFiles
   select fileList
   file$=Get string... iFile
   textGrid = Read from file... 'folder$'/'file$'
   nIntervals=Get number of intervals... 'tier'
   for iInterval to nIntervals
      select textGrid
      label$=Get label of interval... tier iInterval 
      labelCheck=1
      select table
      nRows=Get number of rows
      for iRow to nRows      
         rowLabel$=Get value... iRow segment
         if rowLabel$=label$
            labelCheck=2
         endif
      endfor
      if labelCheck=1
         Append row
         Set string value... nRows segment 'label$'
      endif
   endfor
   select textGrid
   Remove
endfor
select table
nRows=Get number of rows
Remove row... nRows
Save as tab-separated file... segments.table

select fileList
Remove