#
# This script help to get the head dump
#
# appName = give your app name from command line
# homepath = where you want to write file
# output will be like = "headdump_BAUAT11_11380_20200625.bin"
#                        headdump_<APP NAME>_<PID>_<YYYYMMDD>.bin
 

cls

$appName = "JDACONNECT"
$filter = "CommandLine like '%"+$appName+"%'"
$homepath = "E:\JDA\MuleTool\HeadDump"


cd $homepath

#del *

Get-WmiObject win32_process -Filter $filter | Select-Object ParentProcessId,ProcessId,ProcessName,CommandLine 


$procs = Get-WmiObject win32_process -Filter $filter
$i = 0


foreach($proc in $procs)
{

   
   $processId = $proc.ProcessId
   $processName = $proc.ProcessName
   $commandLine = $procs.CommandLine[$i]
   
 
   $paramArray = iex "echo $commandLine"
   $ConnectInstance = $paramArray[9]
   $length = $ConnectInstance.length
   $result = $ConnectInstance.substring($length -7)

   

   $filename = "headdump_" + $result + "_"+ $processId + "_" + $(get-date -f yyyyMMdd)
   
            
   Start-Process jmap -ArgumentList "-dump:format=b,file=$filename.bin $processId "


  $i++

}
