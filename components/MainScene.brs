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
    
    m.viewManager = m.componentController.callFunc("getViewManager")
    if m.viewManager = invalid
        print "MainScene: ERROR - ViewManager initialization failed"
        return
    end if
    print "MainScene: ViewManager initialized"
    
    showMainMenu()
End Sub

Sub showMainMenu()
    print "MainScene: Showing MainMenuView"
    if m.componentController <> invalid
        m.componentController.callFunc("showView", { view: "MainMenuView", args: {} })
    else
        print "MainScene: ERROR - ComponentController invalid"
    end if
End Sub