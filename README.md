HTML Resource Compiler (htmlres)
================================


Description
-----------

HTML Resource Compiler is a simple Windows command line application for creating or updating Windows 32 bit binary resource files that contain HTML code that can be displayed using Internet Explorer's `res://` protocol.

> For details on how to use the protocol see the article [How to create and use HTML resource files](http://delphidabbler.com/articles?article=10).

HTMLRes takes a list of HTML and related support files and copies the content of each file into a separate HTML resource within a binary resource file. Each resource has the same name as the source file. This makes porting standard HTML files to embedded resources very easy – and it is something that the Embarcadero (née Borland) BRCC32 resource compiler won't allow!

HTMLRes is particularly useful for embedding HTML files in the executable file of programs that display information using the Microsoft web browser control. Including HTML files in the program's resources means that is is not necessary to distribute the HTML files separately.


Source Code
-----------

HTMLRes is written in Object Pascal and targeted at Delphi 7, although any later non-Unicode compiler should suffice.

See `Build.html` in the repo root for information about how to build the program from code.

Each release from v1.2.0 is has a tag in the form vX.X.X where X.X.X is the release version number.


Releases
--------

Each release of HTMLRes from v1.2.1 is available from the program's GitHub repository's [Releases section](https://github.com/delphidabbler/htmlres/releases).

The program is distributed in a zip archive which contains two files:

1. `ReadMe.txt` - contains an explanation about how to install the program
2. `HTMLRes-Setup-x.x.x.exe`, where `x.x.x` is the program's version number, is the program's Windows installer.

### System Requirements

HTMLRes itself should be able to run on just about any 32 or 64 bit version of Windows from Windows 95 onwards. However the installer requires Windows 2000 and later.

In the unlikely event you need to run HTMLRes on an operating system earlier than Windows 2000 you will need to build it from source (see above).


Documentation
-------------

User guide: `Docs/UserGuide.md`.

Installation notes etc.: `Docs/ReadMe.txt`.

Change log: `CHANGELOG.md`.


Bugs and Feature Requests
-------------------------

An bug reports and feature requests via the GitHub issue tracker please.


License
-------

See `LICENSE.md` for details.


A Little History
----------------

Up to and including the release of v1.2.0, HTMLRes was not under version control. Known changes up until then are logged in the file `PreSVNHistory.txt` in the `Docs` sub-directory.

On 1st August 2009 the v1.2.0 development tree was moved into a Subversion repository. Some development work took place in that repo, but no releases were made from it.

Finally, the Subversion repo was converted to Git on 18th February 2014 and the repo was made public on GitHub.

Release 1.2.1 was the first release from the Git repo on 20th February 2014.


To Do
-----

* Get a Unicode compatible version to work.

* Update source license to MPL 2.0 and simplify the EULA.
