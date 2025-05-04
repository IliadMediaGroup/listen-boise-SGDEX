Function GetSceneName() as String
    print "MainScene: GetSceneName called"
    return "MainScene"
End Function

Sub init()
    print "MainScene: Entering init"
    
    m.componentController = m.top.findNode("componentController")
    if m.componentController = invalid
        print "MainScene: ERROR - ComponentController not found"
        return
    end if
    print "MainScene: ComponentController found"
    
    showMainMenu()
End Sub

Sub showMainMenu()
    print "MainScene: Showing MainMenuView"
    view = m.componentController.callFunc("showView", { view: "MainMenuView", args: {} })
    if view = invalid
        print "MainScene: ERROR - Failed to show MainMenuView"
    else
        print "MainScene: MainMenuView shown successfully"
    end if
End Sub