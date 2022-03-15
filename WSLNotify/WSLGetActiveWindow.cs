/*
 * Microsoft (R) Visual C# Compiler version 4.8.4084.0 for C# 5
 * csc /platform:x64 /win32icon:WSLNotify.ico /o+ /w:4 /nologo WSLGetActiveWindow.cs
 */

using System;
using System.Runtime.InteropServices;

///////////////////////////////////////////////////////////////////////////////
/// <summary>
/// Emulates the <c>getactivewindow</c> feature of <c>xdotool</c>, a Linux
/// program which is used for automation.
/// </summary>
///////////////////////////////////////////////////////////////////////////////
class WSLGetActiveWindow
{
    [DllImport("user32.dll")]
    static extern IntPtr GetForegroundWindow();

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Main function.
    /// <summary>
    ///////////////////////////////////////////////////////////////////////////
    static void Main(string[] args)
    {
        IntPtr handle = GetForegroundWindow();
        
        // Not using `WriteLine', because that would also print a carriage
        // return character. Bash complains about that when it tries to get the
        // active window ID using this program.
        Console.Write(handle);
    }
}
