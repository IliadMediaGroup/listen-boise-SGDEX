sub init()
    print "MainScene: Entering init"
    
    m.global = m.top.getScene().global
    if m.global = invalid
        print "MainScene: ERROR - Global node invalid"
        return
    end if
    
    m.viewStack = createObject("roSGNode", "ViewStack")
    if m.viewStack = invalid
        print "MainScene: ERROR - ViewStack creation failed"
        return
    end if
    m.top.appendChild(m.viewStack)
    print "MainScene: ViewStack created and appended"
    
    showMainMenuView()
end sub

sub showMainMenuView()
    print "MainScene: Showing MainMenuView"
    
    mainMenuView = createObject("roSGNode", "MainMenuView")
    if mainMenuView = invalid
        print "MainScene: ERROR - MainMenuView creation failed"
        return
    end if
    
    m.viewStack.callFunc("pushView", mainMenuView)
    print "MainScene: MainMenuView pushed to ViewStack"
    
    mainMenuView.setFocus(true)
    print "MainScene: Focus set to MainMenuView"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    print "MainScene: Key event - " + key + ", press: " + press.toStr()
    handled = false
    if press and key = "back"
        print "MainScene: Back key pressed, ignoring to prevent exit"
        handled = true
    end if
    return handled
end function