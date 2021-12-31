// csc.exe /win32icon:WSLNotify.ico WSLNotify.cs
// csc.exe /platform:x64 /win32icon:WSLNotify.ico WSLNotify.cs

using System;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;

class WSLNotify
{
    const string BallonTipIconOption = "-i";
    ToolTipIcon BalloonTipIcon;

    string BalloonTipTitle = " ";
    string BalloonTipText = " ";

    ///////////////////////////////////////////////////////////////////////////
    // Method
    // Set the contents of the notification balloon.
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
            Console.WriteLine("Invalid number of options.");
            Environment.Exit(1);
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    // Method
    // Set an icon for the notification balloon.
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
    // Method
    // Read the command line arguments into class member variables. Apparently,
    // there is no out-of-the-box support for parsing command line arguments.
    // But there aren't too many arguments to process, so a quick-and-dirty
    // implementation shouldn't hurt.
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
                    i += 1;
                    setBalloonTipIcon(args[i]);
                    break;

                default:
                    break;
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    // Method
    // Check the parsed information for errors.
    ///////////////////////////////////////////////////////////////////////////
    void validateParsed()
    {
        if(BalloonTipTitle == " ")
        {
            Console.WriteLine("No summary specified.");
            Environment.Exit(1);
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    // Main function.
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
            Console.WriteLine("Missing argument.");
            Environment.Exit(1);
        }

        wNotify.validateParsed();

        NotifyIcon notifyIcon = new NotifyIcon
        {
            Visible = true,
            Icon = Icon.ExtractAssociatedIcon(Application.ExecutablePath),
            BalloonTipTitle = wNotify.BalloonTipTitle,
            BalloonTipText = wNotify.BalloonTipText,
            BalloonTipIcon = wNotify.BalloonTipIcon,
            Text = "WSLNotify"
        };
        notifyIcon.ShowBalloonTip(8000);
    }
}

