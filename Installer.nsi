; -*- insani NSIS Windows Installer Script -*-
; 
; This is a working NSIS installer script -- indeed it is the exact installer
; script that was used in the Radiata (http://insani.org/radiata.html) project.
; It will work on any modern version of NSIS, and is confirmed working on the 
; latest NSIS release (3.03 as of the time of this writing).  It requires the 
; following directory structure (- denotes a file; + denotes a directory):
;
; + STAGING_DIR (C:\staging by default).
;   - icon.ico: a 32x32 Windows icon file for the main executable.
;   - unicon.ico: a 32x32 Windows file for the uninstaller.
;   - insani License.rtf: an RTF file with license terms.
;   - header.bmp: a 150x57 BMP that serves as a graphical header.
;   - side.bmp: a 164x314 BMP that serves as a graphical side element.
;   + PRODUCT_NAME (in this case, the full file path is C:\staging\Radiata)
;     - all executable files and asset files for the completed translation
;       reside here; for instance, for an ONScripter-insani-based translation,
;       you would have PRODUCT_NAME.exe, 0.txt/nscript.dat, arc.nsa, etc.
;
; We have provided examples of all of the files, except for the files in 
; PRODUCT_NAME, in this repository.  These examples are, just like the script 
; itself, from our Radiata translation project.
;
; Once this script has run, you will get an installer executable called:
;
; - PRODUCT_NAMESetup.Windows.x86-64.exe 
;
; For instance, for Radiata, that's RadiataSetup.Windows.x86-64.exe.
;
; If you use this script in one of your translation projects, it is customary 
; to, but not required to, credit insani.

; Define block
!define STAGING_DIR "C:\staging"
!define PRODUCT_NAME "Radiata"
!define PRODUCT_VERSION "1.12E"
!define PRODUCT_PUBLISHER "insani"
!define PRODUCT_WEB_SITE "http://www.insani.org/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Radiata.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"

SetCompressor lzma

; MUI 1.67 compatible
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${STAGING_DIR}\icon.ico"
!define MUI_UNICON "${STAGING_DIR}\unicon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${STAGING_DIR}\header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${STAGING_DIR}\side.bmp"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "${STAGING_DIR}\insani License.rtf"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_NAME}.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\Manual.pdf"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${STAGING_DIR}\${PRODUCT_NAME}Setup.Windows.x86-64.exe"
InstallDir "$LOCALAPPDATA\insani.org\${PRODUCT_NAME}"
InstallDirRegKey HKCU "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin

; Take close note of this section below.  If your RTM translation files have 
; subdirectories, you will also have to do CreateDirectory and explicitly make 
; those directories, then SetOutPath to each directory and add the files.  For 
; instance, if you had a subdirectory called "Music", you would have additional 
; scripting that went something to the point of:
;
; - CreateDirectory "$LOCALAPPDATA\insani.org\${PRODUCT_NAME}\Music"
; - SetOutPath "$INSTDIR\Music"
; - SetOverwrite try 
; - File "${STAGING_DIR}\${PRODUCT_NAME}\Music\*.*"
; - SetOutPath "$INSTDIR"
;
; The last SetOutPath is not necessary, but I always add it simply so you don't 
; accidentally dump something you should not into that subdirectory.
;
; Also remember to delete the contents of any subdirectory you create here, then 
; delete the subdirectories themselves, in your Uninstaller section.

Section "MainSection" SEC01
  CreateDirectory "$LOCALAPPDATA\insani.org\${PRODUCT_NAME}"
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "${STAGING_DIR}\${PRODUCT_NAME}\*.*"
  SetOutPath "$INSTDIR"
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Manual.lnk" "$INSTDIR\Manual.pdf"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe" "" "$INSTDIR\icon.ico" 0
SectionEnd

Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\Radiata\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKCU "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\icon.ico"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\*.*"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Manual.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
  
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKCU "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd