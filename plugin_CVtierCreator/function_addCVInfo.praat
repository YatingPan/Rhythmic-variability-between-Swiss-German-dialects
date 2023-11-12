form Create cv tiers...
   positive Segment_tier 1
   positive Table_id 
endform

# Get textGrid information:
textGrid$ = selected$("TextGrid")
textGrid = Copy... 'textGrid$'_cv

# Get table information: 
table = table_id

select table
nRows = Get number of rows

# Add cv segment tier
select textGrid
cv_segment_tier = segment_tier+1
Duplicate tier... segment_tier cv_segment_tier cvSegments
nIntervals=Get number of intervals... segment_tier

   # loop through intervals: 
   for iInterval to nIntervals
      select textGrid
         label$=Get label of interval... segment_tier iInterval
      select table
         row = Search column... segment 'label$'

echo 'row'

         type$ = Get value... row type
      select textGrid
         Set interval text... cv_segment_tier iInterval 'type$'
   endfor

# Add cv segment interval tier
cv_segment_intervals_tier = cv_segment_tier+1
Duplicate tier... cv_segment_tier cv_segment_intervals_tier cvSegmentIntervals
nIntervals = Get number of intervals... cv_segment_tier

   # loop through intervals: 
   for iInterval to nIntervals-1
      label1$ = Get label of interval... cv_segment_intervals_tier iInterval
      label1$ = left$(label1$,1)
      label2$ = Get label of interval... cv_segment_intervals_tier iInterval+1
      if label1$ = label2$
         Remove right boundary... cv_segment_intervals_tier iInterval
         nIntervals-=1
         iInterval-=1
      endif
   endfor

# Add cv_tier
cv_intervals_tier = cv_segment_intervals_tier+1
Duplicate tier... cv_segment_intervals_tier cv_intervals_tier cvIntervals
nIntervals = Get number of intervals... cv_intervals_tier

   # loop through intervals:
   for iInterval to nIntervals
      label$=Get label of interval... cv_intervals_tier iInterval
      letter$=left$(label$,1)
      if label$ != "sil"
         Set interval text... cv_intervals_tier iInterval 'letter$'
      endif
   endfor



