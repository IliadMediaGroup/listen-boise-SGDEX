Sub init()
    print "PodcastLandingView: Entering init"
    
    m.description = m.top.findNode("description")
    m.description.font = m.top.findNode("font")
    m.buttons = m.top.findNode("buttons")
    m.buttons.observeField("buttonSelected", "onButtonSelected")
    
    m.buttons.setFocus(true)
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PodcastLandingView: Content set - " + content.title
        m.description.text = "Description for " + content.title ' Replace with RSS data
    end if
End Sub

Sub onButtonSelected()
    selected = m.buttons.buttonSelected
    content = m.top.content
    print "PodcastLandingView: Button selected - " + m.buttons.buttons[selected].text
    
    if selected = 0 ' Play Latest
        m.top.action = { type: "playLatest", content: content }
    else if selected = 1 ' Browse
        m.top.action = { type: "browse", content: content }
    end if
End Sub