# This scripts edits the table in that it asks the user
# to add the category information (c, v, or silence) to each label

Read Table from tab-separated file... segments.Table
Append column... type
nRows = Get number of rows
for iRow from 1 to nRows
   label$ = Get value... iRow segment
   beginPause ("Get segment category")
      comment ("Label: - 'label$' -")
      word ("insert_category", "")
      nocheck endPause ("Proceed", 1)
   Set string value... iRow type 'insert_category$'
endfor
filedelete segmentsEdited.Table
Save as tab-separated file... segmentsEdited.Table
Remove