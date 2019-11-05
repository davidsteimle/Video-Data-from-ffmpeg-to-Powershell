ffprobe -i furiadeloskaratecas1983.mp4 | grep Duration


  Id CommandLine
  -- -----------
   1 cat $PROFILE
   2 $PROFILE
   3 New-ScriptFileInfo -Path $PROFILE -Author "Steimle, David B." -Descripti…
   4 New-ScriptFileInfo -Path $PROFILE -Author "Steimle, David B." -Descripti…
   5 cat $PROFILE
   6 vi $PROFILE
   7 $PROFILE
   8 $test = ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4
   9 $test | Select-String Duration
  10 $test | Select-String 'Duration'
  11 $test = $test -split ("`n")
  12 $test
  13 $test = ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4
  14 $test
  15 $test = $(ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4)
  16 $test
  17 ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4
  18 $test = Invoke-Command ffprobe -i /home/david/Videos/furiadeloskaratecas…
  19 $test = Invoke-Expression "ffprobe -i /home/david/Videos/furiadeloskarat…
  20 $test
  21 bash ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4
  22 $test = ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4 | Out-…
  23 $test
  24 $test = ffprobe -i /home/david/Videos/furiadeloskaratecas1983.mp4 2>&1
  25 $test
  26 $test[0]
  27 $test[1]
  28 $test -contains "Duration"
  29     class Time{…
  30     }
  31     class Time{…
  32 [Time]$x = @(1,2,3,4)
  33 $test.foreach({if($PSItem -match "Duration"){$PSItem}})
  34 $x = $test.foreach({if($PSItem -match "Duration"){$PSItem}})
  35 $x
  36 $x -match "[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{1,}"
  37 $Matches
  38 [regex]::Match($x,"[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{1,}")
  39 ([regex]::Match($x,"[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{1,}")).Value
  40 $y = ([regex]::Match($x,"[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{1,}")).Value
  41 $y = $y -replace '.',':'
  42 $y
  43 $y = ([regex]::Match($x,"[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{1,}")).Value
  44 $y = $y -replace '\.',':'
