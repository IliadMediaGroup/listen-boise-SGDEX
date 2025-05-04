Sub init()
    print "MainMenuView: Entering init"
    m.rowList = m.top.findNode("RowList")
    m.rowList.visible = true
    print "MainMenuView: RowList visibility set to true"
    configureGrid()
    m.top.observeField("content", "onContentSet")
    m.top.observeField("selection", "onSelectionChanged")
    m.rowList.setFocus(true)
    print "MainMenuView: Focus set to RowList"
End Sub

Sub configureGrid()
    m.rowList.numColumns = 4
    m.rowList.itemSize = [400, 300]
    m.rowList.rowHeights = [300]
    m.rowList.itemSpacing = [20, 20]
    m.rowList.focusBitmapUri = "pkg:/images/focus_grid.9.png"
    print "MainMenuView: Grid configured"
End Sub

Sub show(args as Object)
    print "MainMenuView: Showing view with args: "; args
    m.rowList.visible = true
    m.rowList.setFocus(true)
    print "MainMenuView: RowList set to visible and focused in show"
End Sub

Sub onContentSet()
    print "MainMenuView: Content set on top.content"
    m.rowList.content = m.top.content
    m.rowList.setFocus(true)
End Sub

Sub onSelectionChanged()
    print "MainMenuView: Selection changed"
    ' Selection is handled by MainMenuLogic.brs via ObserveField
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "MainMenuView: Key event - "; key; " Press: "; press
    if press and key = "back"
        return false
    end if
    return true
End Function