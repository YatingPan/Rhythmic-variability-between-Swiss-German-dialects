form Calculate CCI...
   word label v
   positive tier 3
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

for iInterval from (1+exclude_intervals_from_start) to (nIntervals-exclude_intervals_from_end)
   interval$ = Get label of interval... tier iInterval
   segment$ = left$(interval$, 1)
   if segment$ = label$ 

		start = Get starting point... tier iInterval
		end = Get end point... tier iInterval
		duration = (end-start)*1000

		if duration>critical_value

	         number+=1		;count number of intervals
			interval_duration[number] = duration
			interval_nSeg[number] = length(interval$)
			temp = length(interval$)
		
		endif 

   endif
endfor

sumOfCCI_intervals = 0
for iInterval to number-1 
	
	duration1 = interval_duration[iInterval]
	duration2 = interval_duration[iInterval+1]
	nSeg1 = interval_nSeg[iInterval]
	nSeg2 = interval_nSeg[iInterval+1]
	
	cci_interval_characteristics = sqrt(((duration1/nSeg1)-(duration2/nSeg2))^2)
	sumOfCCI_intervals+= cci_interval_characteristics

endfor
cci = ((sumOfCCI_intervals)/(number-1))

# Print output if wanted:
if print_to_info = 1
   clearinfo
   printline cci:'tab$''cci'
endif

# Print output to table if wanted:
if table > 0
   select table 
   Set numeric value... row 'column$' 'transfer$'
endif