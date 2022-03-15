/*
 * Microsoft (R) Visual C# Compiler version 4.8.4084.0 for C# 5
 * csc /platform:x64 /win32icon:WSLNotify.ico /o+ /w:4 /nologo WSLNotify.cs
 */

using System;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;

///////////////////////////////////////////////////////////////////////////////
/// <summary>
/// Emulates some features of <c>notify-send</c>, a Linux program which is used
/// to send desktop notifications.
/// </summary>
///////////////////////////////////////////////////////////////////////////////
class WSLNotify
{
    const string helpOption = "-?";

    const string BallonTipIconOption = "-i";
    ToolTipIcon BalloonTipIcon;

    string BalloonTipTitle = " ";
    string BalloonTipText = " ";

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Set the contents of the notification balloon.
    /// </summary>
    ///////////////////////////////////////////////////////////////////////////
    void setBalloonTip(string text)
    {
        if(text == "")
        {
            return;
        }

        if(BalloonTipTitle == " ")
        {
            BalloonTipTitle = text;
        }
        else if(BalloonTipText == " ")
        {
            BalloonTipText = text;
        }
        else
        {
            Console.WriteLine("Invalid number of options");
            Environment.Exit(1);
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Set an icon for the notification balloon.
    /// </summary>
    ///////////////////////////////////////////////////////////////////////////
    void setBalloonTipIcon(string text)
    {
        switch(text)
        {
            case "dialog-error":
                BalloonTipIcon = ToolTipIcon.Error;
                break;

            case "dialog-warning":
                BalloonTipIcon = ToolTipIcon.Warning;
                break;

            case "dialog-information":
                BalloonTipIcon = ToolTipIcon.Info;
                break;

            default:
                BalloonTipIcon = ToolTipIcon.None;
                break;
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Display usage information.
    /// <summary>
    ///////////////////////////////////////////////////////////////////////////
    void showHelp()
    {
        Console.WriteLine("Usage:");
        Console.WriteLine("  " + Assembly.GetExecutingAssembly().GetName().Name + " [OPTIONS] <SUMMARY> [BODY]\n");
        Console.WriteLine("Help Options:");
        Console.WriteLine("  -?         Show help\n");
        Console.WriteLine("Application Options:");
        Console.WriteLine("  -i ICON    Stock icon (\"dialog-information\", \"dialog-warning\", \"dialog-error\")\n");
        Environment.Exit(0);
    }

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Read the command line arguments into class member variables.
    /// Apparently, there is no out-of-the-box support for parsing command line
    /// arguments. But there aren't too many arguments to process, so a
    // quick-and-dirty implementation shouldn't hurt.
    /// </summary>
    ///////////////////////////////////////////////////////////////////////////
    void parseArguments(string[] args)
    {
        for(int i = 0; i < args.Length; ++i)
        {
            if(!args[i].StartsWith("-"))
            {
                setBalloonTip(args[i]);
                continue;
            }

            switch(args[i])
            {
                case BallonTipIconOption:
                    ++i;
                    setBalloonTipIcon(args[i]);
                    break;

                case helpOption:
                    showHelp();
                    break;

                default:
                    Console.WriteLine("Unknown option " + args[i]);
                    Environment.Exit(1);
                    break;
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Check the parsed information for errors.
    /// </summary>
    ///////////////////////////////////////////////////////////////////////////
    void validateParsed()
    {
        if(BalloonTipTitle == " ")
        {
            Console.WriteLine("No summary specified");
            Environment.Exit(1);
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Main function.
    /// <summary>
    ///////////////////////////////////////////////////////////////////////////
    static void Main(string[] args)
    {
        WSLNotify wNotify = new WSLNotify();
        try
        {
            wNotify.parseArguments(args);
        }
        catch(IndexOutOfRangeException)
        {
            Console.WriteLine("Missing argument");
            Environment.Exit(1);
        }

        wNotify.validateParsed();

        NotifyIcon notifyIcon = new NotifyIcon
        {
            Visible = true,
            Icon = Icon.ExtractAssociatedIcon(Assembly.GetEntryAssembly().Location),
            BalloonTipTitle = wNotify.BalloonTipTitle,
            BalloonTipText = wNotify.BalloonTipText,
            BalloonTipIcon = wNotify.BalloonTipIcon,
            Text = "WSLNotify"
        };
        notifyIcon.ShowBalloonTip(8000);
    }
}
