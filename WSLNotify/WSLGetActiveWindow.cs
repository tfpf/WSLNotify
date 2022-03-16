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
        // The text this program writes on the terminal is supposed to be
        // stored in a Bash variable. However, Bash doesn't like carriage
        // return characters. Hence, the line ending is changed.
        Console.Out.NewLine = "\n";
        IntPtr handle = GetForegroundWindow();
        Console.WriteLine(handle);
    }
}
