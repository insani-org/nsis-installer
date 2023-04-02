# insani.org Windows NSIS Installer Script
## Introduction
This is a working NSIS installer script -- indeed it is the exact installer script that was used in the *Radiata* (http://insani.org/radiata.html) project.  It will work on any modern version of NSIS, and is confirmed working on the latest NSIS release (3.03 as of the time of this writing).

## File Structure
This installer script requires the following directory structure (directories in **bold**, files in *italics*):

- **STAGING_DIR** (C:\staging by default).
  - *icon.ico*: a 32x32 Windows icon file for the main executable.
  - *unicon.ico*: a 32x32 Windows file for the uninstaller.
  - *insani License.rtf*: an RTF file with license terms.
  - *header.bmp*: a 150x57 BMP that serves as a graphical header.
  - *side.bmp*: a 164x314 BMP that serves as a graphical side element.
  - **PRODUCT_NAME** (in this case, the full file path is C:\staging\Radiata)
    - all executable files and asset files for the completed translation reside here; for instance, for an ONScripter-insani-based translation, you would have PRODUCT_NAME.exe, 0.txt/nscript.dat, arc.nsa, etc.

We have provided examples of all of the files, except for the files in PRODUCT_NAME, in this repository.  These examples are, just like the script itself, from our *Radiata* translation project.

## Output
Once this script has run, you will get an installer executable called:

- *PRODUCT_NAMESetup.Windows.x86-64.exe*

For instance, for *Radiata*, that's *RadiataSetup.Windows.x86-64.exe*.

## Legalese
We hereby place Installer.nsi itself in the **public domain**.  It is licensed as CC0 1.0 Universal for that reason.  However, this is not true of the other files:

- *icon.ico*
- *icon.png*
- *unicon.ico*
- *unicon.png*
- *insani License.rtf*
- *header.bmp*
- *side.bmp*

They are simply there to provide you with a reference, and you should *never* use them in your project.  The image files, specifically, include material that are (c) 2006 PANDAPENGUINS and (c) 2023 insani; these are explicitly **not in the public domain**.

If you use this script in one of your translation projects, it is customary to, but not required to, credit insani.

## History
This installer script has a certain historical significance to the English novel game community, as it is the installer script that most early novel game translation projects used, when they had installers at all.  We widely shared earlier versions of this script with the community, and often participated in packaging other translation projects' RTM installer files for them.  We are now pleased to share this script more broadly.
