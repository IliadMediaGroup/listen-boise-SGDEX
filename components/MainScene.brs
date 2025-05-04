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
End Sub

Sub show(args as Object)
    print "MainScene: Showing with args: "; args
    if IsDeepLinking(args)
        PerformDeepLinking(args)
    else
        ShowMainMenuView()
    end if
    m.top.signalBeacon("AppLaunchComplete")
End Sub

Sub Input(args as Object)
    print "MainScene: Handling input: "; args
    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if
End Sub