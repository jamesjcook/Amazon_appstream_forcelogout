Dim WinScriptHost
' Get Args
ReDim arr(WScript.Arguments.Count-1)
' Convert Args
For i = 0 To WScript.Arguments.Count-1
  arr(i) = WScript.Arguments(i)
  'Wscript.echo arr(i)
Next
'join Args
'WScript.Echo Join(arr," ")
cmd = Join(arr," ")
' run cmd
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run cmd, 0, 1
Set WinScriptHost = Nothing
