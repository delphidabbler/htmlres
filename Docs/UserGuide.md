# DelphiDabbler HTML Resource Compiler User Guide

## Introduction

_HTMLRes_ is a Windows command line program that is used to create resource files containing the contents of HTML, CSS, image etc. files as resources.

Each file is stored as a separate resource. Each resources is of type `HTML` (`#23`) and is named after the source file.

## Scope

This document relates to _HTMLRes_ v2.1.x.

## Command Line

The command line syntax of the application is:

    HTMLRes <in-file-list> [-m<manifest-file>] [-o<out-file>] [options]

where:

`<in-file-list>` is a sequence of zero or more file names. These files will be stored in the resource file. Relative file names are relative to the folder from where _HTMLRes_ was started. The `-r` option may be used to change this behaviour (see below).

`<manifest-file>` is the name of a file that contains a list of files to be stored in the resource file. Each file name is placed on a separate line in the manifest file. Blank lines are ignored. Lines beginning with `#` are treated as comments and are also ignored. Comments cannot be placed on the same line as a file name. Here's an example manifest file: 

    # Files required for demo
    index.html
    page2.html
    arrow.gif
    style.css

Spaces are not allowed between the `-m` command and the manifest file name. The file names specified in the manifest are, by default, relative to the folder from where _HTMLRes_ was executed. The `-r` option can be used to change this behaviour so that filenames are relative to the manifest file folder instead (see below).

`<out-file>` is the name of the generated resource file. Spaces are not allowed between the `-o` command and the output file name. This command is optional. If no output file name is specified then the default name `out.res` is used. The `-u` option controls how pre-existing output files are handled (see below).

`options` is a sequence of zero or more of space separated options from the following list: 

* `-q` - Quite mode. Does not display any normal output. Any error messages are displayed. 

* `-Q` - Silent mode. No normal or error messages are displayed.

* `-p` or `-P` - Causes the program to pause on completion and prompts the user to press return before closing the program. The prompt is always displayed, regardless of whether the `-q` or `-Q` options have been used. 

* `-r` or `-R` - Causes all relative file names to be taken as relative to the manifest file's directory. If this option is not specified then file names are relative to the directory where _HTMLRes_ was executed. The option applies to the preceding `-m` manifest file command. If there is no `-m` command then this option is ignored. `-r` applies to all relative file names, i.e. input file, output file and all files listed in a manifest file. 

* `-u:param` or `-U:param` - Specifies the action to be taken if an output file already exists. `param` indicates the action to take:

  * `-u:fail` - The program fails with an error if the output file does not exist. The output file is not changed.

  * `-u:overwritefile` - The output file is overwritten (default).

  * `-u:insertres` - Inserts HTML resources into the existing file. An error is reported if the output file is not a valid resource file or if any resource name already exists in the file. The output file is not modified if an error occurs.

  * `-u:overwriteres` - Inserts HTML resources into the existing file, overwriting existing resources if there is a name clash. It is an error if the output file is not a valid resource file. In the event of an error the output file is not modified.

* `-H`, `-h` or `-?` - Displays a help screen. The `-q` and `-Q` options are ignored. 

At least one input file must be provided, either directly on the command line or in a manifest file, unless the `-H`, `-h` or `-?` options are used.  See below for restrictions placed on file names.

## Error Codes

The program returns `0` on success or a positive error code on failure. The error codes are explained in the following table.

| Error code | Explanation |
|------------|-------------|
| `1`        | Command line error. |
| `2`        | Manifest file expected but doesn't exist. |
| `3`        | One or more source files don't exist. |
| `4`        | Duplicate file name. |
| `5`        | Output file exists (the `-u:fail` option has been used). |
| `6`        | Output file exists but is not a valid resource file (the `-u:insertres` or `-u:overwriteres` option has been used). |
| `7`        | Resource name already exists in output file (the `-u:insertres` option has been used). |
| `255`      | Unexpected / unknown error. |

## File Name Restrictions

Since resource names cannot be duplicated in a resource file, and since base file names (without the path) are used as resource names, it follows that duplicate base file names cannot be specified either on the command line or in a manifest file. For example you can't specify both `C:\Foo\MyFile.htm` and `C:\Bar\MyFile.htm`.

If you are intending to use the `res://` protocol to access the HTML resources from Internet Explorer or an embedded Web Browser control there are some restrictions on the resource names, and hence the files names, that you can use. Certain file names that begin with a digit or a punctuation character are not recognised and not loaded. Examples of names to avoid are:

* `42.html`
* `%3.css`
* `4-a.jpg`

## Example

An example Delphi project is supplied with the program. The demo files are installed in the `Demo` sub-folder of the main program installation folder.

The demo project simply creates a resource only DLL that stores some HTML, CSS and GIF files that can be displayed in Internet Explorer. 

The demo files are: 

| File Name | Description |
|-----------|-------------|
| `index.html` | The main demo web page. |
| `page2.html` | A subsidiary web page. |
| `style.css` | A style sheet for the web pages. |
| `arrow.gif` | A GIF displayed in `index.html`. |
| `Demo.hmfst` | A manifest file that lists the demo files to be built by _HTMLRes_. |
| `HTMLLib.dpr` | The Delphi source code for the resource-only DLL. |
| `DemoReadMem.txt` | ReadMe file for demo code. Please read before using the demo code. |

Before building the demo project using Delphi you must first start a command console window and navigate to the demo directory. Now run _HTMLRes_ as follows: 

    HTMLRes -mDemo.hmfst -oHTML.res

This compiles the files specified in `Demo.hmfst` into the resource file `HTML.res`.

The project file, `HTMLLib.dpr`, contains a resource statement that includes `HTML.res`. The project can now be compiled with Delphi to create the required resource DLL.

If the demo DLL is stored in the `C:\HTMLRes\Demo` folder we can display the main page in Internet Explorer by entering the following URL in the browser's address bar: 

    res://C:\HTMLRes\Demo\HTMLLib.dll/index.html

The HTML file, its style sheet and the graphic are all stored in the DLL's resources along with a second page that can be displayed by clicking the link on the index page. 

----


This user guide is copyright © 2007-2021, [Peter D Johnson](https://gravatar.com/delphidabbler) and is licensed under a [Creative Commons CC BY-NC-SA 2.5 License](http://creativecommons.org/licenses/by-nc-sa/2.5).
