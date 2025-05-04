Sub init()
    m.title = m.top.findNode("title")
    m.title.font = m.top.findNode("font")
End Sub

Sub onContentChange()
    content = m.top.itemContent
    if content <> invalid
        m.title.text = content.title
    end if
End Sub