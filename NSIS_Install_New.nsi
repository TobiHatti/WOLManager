; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Surgit"
!define PRODUCT_VERSION "1.1.6"
!define PRODUCT_PUBLISHER "Endix Development"
!define PRODUCT_WEB_SITE "https://endev.at/projects/surgit"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Surgit_NetworkManager.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "Surgit-NetworkManager\surgitLogo.ico"
!define MUI_UNICON "Surgit-NetworkManager\uninst.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "LICENSE"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\Surgit_NetworkManager.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Surgit_Setup.exe"
InstallDir "$DOCUMENTS\Endix Development\Surgit"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "Hauptgruppe" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "Surgit-NetworkManager\bin\Release\EnvDTE.dll"
  File "Surgit-NetworkManager\bin\Release\MarkdownSharp.dll"
  File "Surgit-NetworkManager\bin\Release\stdole.dll"
  File "Surgit-NetworkManager\bin\Release\surgitBlank.db"
  File "Surgit-NetworkManager\bin\Release\Surgit_NetworkManager.exe"
  CreateDirectory "$SMPROGRAMS\Surgit"
  CreateShortCut "$SMPROGRAMS\Surgit\Surgit.lnk" "$INSTDIR\Surgit_NetworkManager.exe"
  CreateShortCut "$DESKTOP\Surgit.lnk" "$INSTDIR\Surgit_NetworkManager.exe"
  CreateDirectory "$INSTDIR"
  CreateShortCut "$INSTDIR\Surgit.lnk" "$INSTDIR\Surgit_NetworkManager.exe"
  File "Surgit-NetworkManager\bin\Release\Surgit_NetworkManager.exe.config"
  File "Surgit-NetworkManager\bin\Release\Surgit_NetworkManager.pdb"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Compression.Base.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Core.WinForms.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.DataSource.WinForms.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Grid.Base.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Grid.Windows.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Grid.Windows.XmlSerializers.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.GridCommon.WinForms.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.SfListView.WinForms.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Shared.Base.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Shared.Windows.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.SpellChecker.Base.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Spreadsheet.Windows.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Tools.Base.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.Tools.Windows.dll"
  File "Surgit-NetworkManager\bin\Release\Syncfusion.XlsIO.Base.dll"
  File "Surgit-NetworkManager\bin\Release\System.Data.SQLite.dll"
  File "Surgit-NetworkManager\bin\Release\System.Data.SQLite.dll.config"
  SetOutPath "$INSTDIR\x64"
  File "Surgit-NetworkManager\bin\Release\x64\SQLite.Interop.dll"
  File "Surgit-NetworkManager\bin\Release\x64\sqlite3.dll"
  SetOutPath "$INSTDIR\x86"
  File "Surgit-NetworkManager\bin\Release\x86\SQLite.Interop.dll"
  File "Surgit-NetworkManager\bin\Release\x86\sqlite3.dll"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\Surgit\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\Surgit\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Surgit_NetworkManager.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Surgit_NetworkManager.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) wurde erfolgreich deinstalliert."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "M�chten Sie $(^Name) und alle seinen Komponenten deinstallieren?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\x86\sqlite3.dll"
  Delete "$INSTDIR\x86\SQLite.Interop.dll"
  Delete "$INSTDIR\x64\sqlite3.dll"
  Delete "$INSTDIR\x64\SQLite.Interop.dll"
  Delete "$INSTDIR\System.Data.SQLite.dll.config"
  Delete "$INSTDIR\System.Data.SQLite.dll"
  Delete "$INSTDIR\Syncfusion.XlsIO.Base.dll"
  Delete "$INSTDIR\Syncfusion.Tools.Windows.dll"
  Delete "$INSTDIR\Syncfusion.Tools.Base.dll"
  Delete "$INSTDIR\Syncfusion.Spreadsheet.Windows.dll"
  Delete "$INSTDIR\Syncfusion.SpellChecker.Base.dll"
  Delete "$INSTDIR\Syncfusion.Shared.Windows.dll"
  Delete "$INSTDIR\Syncfusion.Shared.Base.dll"
  Delete "$INSTDIR\Syncfusion.SfListView.WinForms.dll"
  Delete "$INSTDIR\Syncfusion.GridCommon.WinForms.dll"
  Delete "$INSTDIR\Syncfusion.Grid.Windows.XmlSerializers.dll"
  Delete "$INSTDIR\Syncfusion.Grid.Windows.dll"
  Delete "$INSTDIR\Syncfusion.Grid.Base.dll"
  Delete "$INSTDIR\Syncfusion.DataSource.WinForms.dll"
  Delete "$INSTDIR\Syncfusion.Core.WinForms.dll"
  Delete "$INSTDIR\Syncfusion.Compression.Base.dll"
  Delete "$INSTDIR\Surgit_NetworkManager.pdb"
  Delete "$INSTDIR\Surgit_NetworkManager.exe.config"
  Delete "$INSTDIR\Surgit_NetworkManager.exe"
  Delete "$INSTDIR\surgitBlank.db"
  Delete "$INSTDIR\stdole.dll"
  Delete "$INSTDIR\MarkdownSharp.dll"
  Delete "$INSTDIR\EnvDTE.dll"

  Delete "$SMPROGRAMS\Surgit\Uninstall.lnk"
  Delete "$SMPROGRAMS\Surgit\Website.lnk"
  Delete "$INSTDIR\Surgit.lnk"
  Delete "$DESKTOP\Surgit.lnk"
  Delete "$SMPROGRAMS\Surgit\Surgit.lnk"

  RMDir "$SMPROGRAMS\Surgit"
  RMDir "$INSTDIR\x86"
  RMDir "$INSTDIR\x64"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd