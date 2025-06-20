[
  {
    key = "shift+delete";
    command = "editor.action.deleteLines";
    when = "textInputFocus && !editorReadonly";
  }
  {
    key = "ctrl+k j";
    command = "terminal.focus";
  }
  {
    key = "ctrl+r";
    command = "-workbench.action.reloadWindow";
    when = "isDevelopment";
  }
  {
    key = "ctrl+r";
    command = "-python.refreshTensorBoard";
    when = "python.hasActiveTensorBoardSession";
  }
  {
    key = "ctrl+r";
    command = "-workbench.action.quickOpenNavigateNextInRecentFilesPicker";
    when = "inQuickOpen && inRecentFilesPicker";
  }
  {
    key = "ctrl+m";
    command = "-editor.action.toggleTabFocusMode";
  }
  {
    key = "ctrl+k u";
    command = "workbench.action.focusActiveEditorGroup";
  }
  {
    key = "ctrl+shift+j";
    command = "workbench.panel.chat";
  }
]
