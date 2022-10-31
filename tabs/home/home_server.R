observeEvent(input$btn_presidenciais, {
  updateTabsetPanel(session = session, inputId = "navbar", selected = "presidenciais")
})

observeEvent(input$btn_estaduais, {
  updateTabsetPanel(session = session, inputId = "navbar", selected = "estaduais")
})