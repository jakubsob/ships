#' Animated action button
#'
#' @description Creates an animated action button. It's value is initially zero
#'   and increments by one each time it's pressed.
#'
#' @param inputId The `input` slot that will be used to access the value
#' @param visible_content Content of button
#' @param hidden_content Content of button when mouse is on button
#' @param class Additional classes for the button
#' @param ... Attributes to pass to button
#'
action_button_animated <- function(
  inputId,
  visible_content,
  hidden_content,
  class = "basic fade",
  ...) {

  div(
    class = paste("ui vertical animated", class, "button"),
    id = inputId,
    ...,
    div(class = "visible content", visible_content),
    div(class = "hidden content", hidden_content)
  )
}
