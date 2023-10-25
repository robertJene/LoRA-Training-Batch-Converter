Set filesys = CreateObject("Scripting.FileSystemObject")

'Kohya Folder path ********** YOU NEED TO CHANGE THIS TO YOUR kohya_ss FOLDER *****
kohyaPath = "D:\AI_Stuff\Stable Diffusion\Kohya\kohya_ss"

currentDirectory = filesys.GetAbsolutePathName(".")

If Not filesys.FileExists("LoRA_training_command.txt") Then

    Set filetxt = filesys.CreateTextFile("LoRA_training_command.txt", True)
    
    WScript.Echo "NOTE: LoRA_training_command.txt did not exist, it has been created." & vbCrlf & _
                 "      copy-paste the training command" & chr(40) & "s" & chr(41) & " into it, and then save it."
    WScript.Quit

End If


' Check if python.exe exists in Kohya installation
pythonPath = kohyaPath & "\venv\Scripts\python.exe"
If Not filesys.FileExists(pythonPath) Then
    WScript.Echo "Error: python.exe does not exist in the kohyaPath folder."
    WScript.Quit
End If

hasTrainPy = False
hasTrainSDXLPy = False


' Read source.txt file, see how many training commands there are, and if they are regular or SDXL
Set objFile = filesys.OpenTextFile("LoRA_training_command.txt", 1) ' 1 for reading

Y  = int(0)
Do Until objFile.AtEndOfStream

  strLine = objFile.ReadLine

  If instr(lCase(strLine), "train_network.py") Then

    hasTrainPy = True
    Y = Y + 1

  ElseIf instr(lCase(strLine), "sdxl_train_network.py") Then

    hasTrainSDXLPy = True
    Y = Y + 1

  End If

Loop

objFile.Close

If hasTrainPy = False And hasTrainSDXLPy = False Then
    WScript.Echo "Error: The file does contain a train_network.py or sdxl_train_network.py command"
    WScript.Echo "       make sure use the 'Print training command' button in Kohya"
    WScript.Quit
End If

trainFile = kohyaPath & "\train_network.py"
If hasTrainPy = True Then

  If Not filesys.FileExists(trainFile) Then
    WScript.Echo "Error: train_network.py does not exist in the kohyaPath folder"
    WScript.Quit
  End If

End IF

trainFileSDXL = kohyaPath & "\sdxl_train_network.py"

If hasTrainSDXLPy = True Then

  If Not filesys.FileExists(trainFileSDXL) Then
    WScript.Echo "Error: sdxl_train_network.py does not exist in the kohyaPath folder"
    WScript.Quit
  End If

End IF


' Create Lora_training_batch.bat file for writing
Set filetxt = filesys.CreateTextFile("Lora_training_batch.bat", True) ' True for overwriting existing content


filetxt.WriteLine("@ECHO OFF")
filetxt.WriteLine()
filetxt.WriteLine("CD /D " & chr(34) & kohyaPath & chr(34))
filetxt.WriteLine()
filetxt.WriteLine(":: Deactivate the virtual environment")
filetxt.WriteLine("call .\venv\Scripts\deactivate.bat")
filetxt.WriteLine()
filetxt.WriteLine(":: Calling external python program to check for local modules")
filetxt.WriteLine("python .\setup\check_local_modules.py --no_question")
filetxt.WriteLine()
filetxt.WriteLine(":: Activate the virtual environment")
filetxt.WriteLine("call .\venv\Scripts\activate.bat")
filetxt.WriteLine("set PATH=%PATH%;%~dp0venv\Lib\site-packages\torch\lib")
filetxt.WriteLine()
filetxt.WriteLine(":: Validate requirements")
filetxt.WriteLine("python.exe .\setup\validate_requirements.py")
filetxt.WriteLine()
filetxt.WriteLine(":: Activate the virtual environment")
filetxt.WriteLine()
filetxt.WriteLine("call venv\scripts\activate.bat")
filetxt.WriteLine()
filetxt.WriteLine(">> Lora_training_batch_log.txt ECHO[")
filetxt.WriteLine(">> Lora_training_batch_log.txt ECHO ********** BATCH STARTED %Date% %Time% **********")
filetxt.WriteLine(">> Lora_training_batch_log.txt ECHO[")
filetxt.WriteLine()
filetxt.WriteLine("REM ********** formatted training commands go below this line **********")
filetxt.WriteLine()


Set objFile = filesys.OpenTextFile("LoRA_training_command.txt", 1) ' 1 for reading


' Read each line from source.txt and append to output text file
X  = int(0)
Do Until objFile.AtEndOfStream
    line = objFile.ReadLine()

    If instr(lCase(Line), "train_network.py") Or instr(lCase(Line), "sdxl_train_network.py") Then
       X = X + 1

       parts1 = split(line, "--output_name=" & chr(34))
       parts2 = split(parts1(1), chr(34) & " ")
       outputName = parts2(0)

       filetxt.WriteLine()
       fileTxt.WriteLine("ECHO[")
       fileTxt.WriteLine("TITLE [" & X & " of " & Y & "] " & outPutName)
       fileTxt.WriteLine("ECHO[")
       filetxt.WriteLine()
       fileTxt.WriteLine(line)
       filetxt.WriteLine()
       fileTxt.WriteLine("ECHO[")
       filetxt.WriteLine()

    End If

Loop


filetxt.WriteLine()
filetxt.WriteLine(">> Lora_training_batch_log.txt ECHO[")
filetxt.WriteLine(">> Lora_training_batch_log.txt ECHO ********** BATCH FINISHED %Date% %Time% **********")
filetxt.WriteLine(">> Lora_training_batch_log.txt ECHO[")
filetxt.WriteLine()



filetxt.WriteLine()
filetxt.WriteLine("REM ********** formatted training commands go above this line **********")
filetxt.WriteLine()
filetxt.WriteLine("CD /D " & chr(34) & currentDirectory & chr(34))
filetxt.WriteLine()
filetxt.WriteLine("TITLE DONE")
filetxt.WriteLine()
filetxt.WriteLine("PAUSE")
filetxt.WriteLine()

' Close the files
objFile.Close
filetxt.Close


