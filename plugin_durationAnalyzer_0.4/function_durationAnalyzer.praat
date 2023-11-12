form Rate of intervals...
   comment Write 'non-pause' (without inverted commas) in the following 
   comment if you want everything but pauses.
   word label v
   positive tier 2
   positive critical_value 0.01
   integer Exclude_intervals_from_start 0
   integer Exclude_intervals_from_end 0
   comment Leave following empty if pauses should be included:
   word pause_label sil
   boolean print_to_info 1
   comment Leave the following empty (only for script use):
   integer table 0
   word column none
   integer row 0
   word transfer none
endform

# Criterion for determining empty labels:
if label$="non-pause"
   equal$ = "<>"
   label$ = pause_label$
else 
   equal$ = "="
endif

# Get total number of eligible intervals
nIntervals = Get number of intervals... tier
startLabel$ = Get label of interval... tier 1
if startLabel$ = pause_label$
   exclude_intervals_from_start+=1
endif
endLabel$ = Get label of interval... tier nIntervals
if endLabel$ = pause_label$
   exclude_intervals_from_end+=1
endif

# Loop through intervals:
number = 0		;number of intervals
sum = 0			;sum of interval durations
sumOfSqr = 0		;sum of squared interval durations
sumLn = 0		;sum of ln transformed durations
sumOfSqrLn = 0		;sum of ln transformed squared durations
filledDuration = 0	;total duration of non-pausal speech signal
rPVI=0			;raw Pairwise Variability Index
nPVI=0			;normalized Pairwise Variability Index
cci_v=0			;vocalic control and compensation index 
cci_c=0			;consonantal control and compensation index
for iInterval from (1+exclude_intervals_from_start) to (nIntervals-exclude_intervals_from_end)
   interval$ = Get label of interval... tier iInterval
   start = Get starting point... tier iInterval
   end = Get end point... tier iInterval
   duration = end-start
   durationLn = ln(duration)
   if duration>critical_value

      if interval$ 'equal$' label$
         number+=1		;count number of intervals
         sum+=duration
         sqrInt=duration^2
         sumOfSqr+=sqrInt
		 sumLn+=durationLn
         sqrIntLn=durationLn^2
         sumOfSqrLn+=sqrIntLn
         duration[number]=duration
      endif 

      if interval$ <> pause_label$
         filledDuration+=duration
      endif

   endif
endfor

# Calculate values: 
rate = number/sum							;rate of interval
sumSqr = sum^2								;sum of durations squared	
sumSqrLn = sumLn^2							;sum of ln transformed durations squared
mean = sum/number							;mean interval duration
meanLn = sumLn/number							;mean of ln transformed interval durations
stdev = sqrt((number*sumOfSqr-sumSqr)/(number*(number-1)))		;standard deviation of interval durations
stdevLn = sqrt((number*sumOfSqrLn-sumSqrLn)/(number*(number-1)))	;standard deviation of ln transformed durations
varco = stdev/mean							;the coefficient of variation of the standard deviation
percentOfTotal = sum*100/filledDuration					;the percentage of the chosen interval of the total filled duration (necessary to calculate %V for example)

# PVI:
for iNumber to number-1
   d1=duration[iNumber]
   d2=duration[iNumber+1]
   rPVI+=sqrt((d1-d2)^2)
   nPVI+=sqrt((d1-d2)^2)/((d1+d2)/2)
endfor
rPVI = 100*(rPVI/(number-1))						;raw Pairwise Variability Index
nPVI = 100*(nPVI/(number-1))						;normalized Pairwise Variability Index

# Print output if wanted:
if print_to_info = 1
   clearinfo
   printline for 'label$' in 'tier':
   printline number:'tab$''number'
   printline rate:'tab$''rate'
   printline mean duration:'tab$''mean' 
   printline mean duration ln:'tab$''meanLn'
   printline stdev:'tab$''stdev' 
   printline stdev ln:'tab$''stdevLn'
   printline varco:'tab$''varco'
   printline %Segment:'tab$''percentOfTotal'
   printline rPVI:'tab$''rPVI'
   printline nPVI:'tab$''nPVI'
endif

# Print output to table if wanted:
if table > 0
   select table 
   Set numeric value... row 'column$' 'transfer$'
endif