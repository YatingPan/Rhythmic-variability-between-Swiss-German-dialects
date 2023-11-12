# 1 # Get user information: ############################################################

# 1.1 # Get settings from previous usage and delet old settings:

include settings.txt

# 1.2 # Ask for general information: 

   beginPause ("Get directory details...")
      comment ("Insert where you keep your TextGrids:")
       text ("directory", directory$)
       text ("file_name_specification", file_name_specification$) 
      comment ("Insert number of tiers you wish to analyze (minimum=1):")
       if previous_number_of_tiers=0
          integer ("Number of tiers", 1)
       else 
          integer ("Number of tiers", previous_number_of_tiers)
       endif
      comment ("Insert number of independent variables to be created from file-name:")
       integer ("Number of variables", previous_number_of_variables)
      comment ("What is the minimum duration of an interval?")
       integer ("Minimum duration", minimum_duration)
      comment ("What is the label for pauses?")
       word ("Pause label", pause_label$)
      optionMenu ("Process files:", process_files) 
         option ("all (might take time)")
         option ("10 examples (faster)")
   nocheck endPause ("Next", 1)

   # Remember settings:
   filedelete settings.txt
   fileappend settings.txt directory$="'directory$'"'newline$'
   fileappend settings.txt file_name_specification$="'file_name_specification$'"'newline$'
   fileappend settings.txt previous_number_of_tiers='number_of_tiers''newline$'
   fileappend settings.txt previous_number_of_variables='number_of_variables''newline$'
   fileappend settings.txt minimum_duration='minimum_duration''newline$'
   fileappend settings.txt pause_label$="'pause_label$'"'newline$'
   fileappend settings.txt process_files='process_files''newline$'

# 1.3 # Ask user for tier information: 

   # Fill empty tiers in case fewer ones were used previously: 
   for iTier from previous_number_of_tiers+1 to number_of_tiers
      tier_type_'iTier'=0
      tier_number_in_TextGrid_of_'iTier'=0
      exclude_intervals_from_start_in_'iTier'=0
      exclude_intervals_from_end_in_'iTier'=0
   endfor

   # Get information about tiers from user: 
   beginPause ("Specify tiers for analysis...")
      for iTier to number_of_tiers
         comment ("Specify your tier for analysis 'iTier':")
         optionMenu ("Tier type 'iTier'", tier_type_'iTier') 
            option ("Segment tier")
            option ("Syllable tier")
            option ("CV interval tier")
            option ("CV segment tier")
            option ("Voicing tier")
            option ("Peak tier")
			option ("CCI tier")
         positive ("Tier number in TextGrid of 'iTier'", tier_number_in_TextGrid_of_'iTier')
         integer ("Exclude intervals from start in 'iTier'", exclude_intervals_from_start_in_'iTier')
         integer ("Exclude intervals from end in 'iTier'", exclude_intervals_from_end_in_'iTier')
      endfor
   nocheck endPause ("Next", 1)

   # Remember settings: 
   for iTier to number_of_tiers
      fillIn=tier_type_'iTier'
       fileappend settings.txt tier_type_'iTier'='fillIn''newline$'
      fillIn=tier_number_in_TextGrid_of_'iTier'
       fileappend settings.txt tier_number_in_TextGrid_of_'iTier'='fillIn''newline$'
      fillIn=exclude_intervals_from_start_in_'iTier'
       fileappend settings.txt exclude_intervals_from_start_in_'iTier'='fillIn''newline$'
      fillIn=exclude_intervals_from_end_in_'iTier'
       fileappend settings.txt exclude_intervals_from_end_in_'iTier'='fillIn''newline$'
   endfor

# 1.4 #  Ask for independent variables: 

   if number_of_variables > 0
 
      # Fill empty variables in case fewer ones were used previously
      for i from previous_number_of_variables+1 to number_of_variables
         variable_name_'i'$="(insert name)"
         position_'i'=0
         length_'i'=0
      endfor

      # Get information about variables from user: 
      beginPause ("Specify independent variables")
         comment ("Insert name position and length of each independent variable")
         for i to number_of_variables
            word ("variable_name 'i'", variable_name_'i'$)
            integer ("position 'i'", position_'i')
            integer ("length 'i'", length_'i')
         endfor
      nocheck endPause ("Next",1)  

   # Remember settings: 
      for i to number_of_variables
         fillIn$=variable_name_'i'$
         fileappend settings.txt variable_name_'i'$="'fillIn$'"'newline$'
         fillIn=position_'i'
         fileappend settings.txt position_'i'='fillIn''newline$'
         fillIn=length_'i'
         fileappend settings.txt length_'i'='fillIn''newline$'
      endfor

   endif

# 2. # Create Table for results ########################################################


   # 2.1 # Create empty table with one row and one column:
   table = Create Table without column names... table 1 1

   # 2.2 # Fill columns and labels for independent variables into table:
   Set column label (index)... 1 file
   for i to number_of_variables
      Append column... newcolumn
      name$ = variable_name_'i'$
      Set column label (index)... i+1 'name$'
   endfor

   # 2.3 # Create columns for dependent variables: 
   dependentVariables = Read from file... dependentVariables.table
   nRows = Get number of rows
   for iTier to number_of_tiers
      tierName$ = tier_type_'iTier'$
      for iRow to nRows
         select dependentVariables
         include$ = Get value... iRow tier
         if include$ = tierName$
            variableName$ = Get value... iRow variableName
            select table
            Append column... 'variableName$'_tier'iTier'
         endif
      endfor
   endfor

# 3. # Analyze TextGrids in read directory #############################################

   # 3.1 # Get number and list of files to be analyzed
   list = Create Strings as file list... list 'directory$'/'file_name_specification$'
   nFiles = Get number of strings
   if process_files = 2
      nFiles = 10
   endif

   # 3.2 # Loop through all files: 
   row = 0
   for iFile to nFiles
      row+=1
      select list
      file$ = Get string... iFile
      name$ = file$-".TextGrid"
      textGrid = Read from file... 'directory$'/'file$'

      # 3.2.1 # Insert values for independent variables:
      select table 
      Set string value... row file 'name$'
      for iVariable to number_of_variables
         position = position_'iVariable'
         length = length_'iVariable'
         value$ = mid$(name$, position, length)
         column$ = Get column label... iVariable+1
         Set string value... row 'column$' 'value$'
      endfor

      # 3.2.2 # Insert values for dependent variables:
      select dependentVariables
      nDependentVariables = Get number of rows
      for iTier to number_of_tiers
         tierName$ = tier_type_'iTier'$
         for iRow to nRows
            select dependentVariables
            include$ = Get value... iRow tier
            if include$ = tierName$
         
               # Get dependent variable details
               variableName$ = Get value... iRow variableName
               variable$ = Get value... iRow variable
               segment$ = Get value... iRow segment
               tier = tier_number_in_TextGrid_of_'iTier'
               exclude_from_start = exclude_intervals_from_start_in_'iTier'
               exclude_from_end = exclude_intervals_from_end_in_'iTier'

               # Execute the analysis function with the analysis parameters for the variable
               select textGrid

               if variable$ <> "cci"
	               execute function_durationAnalyzer.praat 'segment$' 'tier' 'minimum_duration' 'exclude_from_start' 'exclude_from_end' 'pause_label$' 0 'table' 'variableName$'_tier'iTier' 'row' 'variable$'
               else 
                    execute function_CCI.praat 'segment$' 'tier' 'minimum_duration' 'exclude_from_start' 'exclude_from_end' 'pause_label$' 0 'table' 'variableName$'_tier'iTier' 'row' 'variable$'
			  endif

            endif
         endfor
      endfor

      # Add another row to the table: 
      select table
      Append row

      # clean up: 
      select textGrid
      Remove

   endfor   

# 4. # Clean up: 

   select table
   Remove row... row+1
   select list
   plus dependentVariables
   Remove

### END PROGRAM ####################