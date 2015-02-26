class PasswordStrengthMeter
  constructor: (@input) ->
    @$input = $(@input)
    @appendMeter()
    @listener()
    @resultChanged 0

  appendMeter: ->
    if !@$input.parent().find(".password-meter").size() > 0
      @$meter = $("<div />", class: "password-meter inline-hints")
      @$meter.append $("<span />", class: "password-meter-bar")
      @$meter.find(".password-meter-bar").append $("<span />", class: "password-meter-bar-inner")
      @$meter.append $("<span />", class: "password-meter-text")
      @$input.after @$meter

  listener: ->
    @$input.on "keyup", (e) =>
      @resultChanged zxcvbn(e.target.value).score

  resultChanged: (score) ->
    switch score
      when 0
        text = "Weak"
      when 1
        text = "Weak"
      when 2
        text = "Medium"
      when 3
        text = "Medium"
      when 4
        text = "Strong"
    @$meter.find(".password-meter-text").text text
    @$meter.removeClass "level-0"
    @$meter.removeClass "level-1"
    @$meter.removeClass "level-2"
    @$meter.removeClass "level-3"
    @$meter.removeClass "level-4"
    @$meter.addClass "level-#{score}"

passwordSelector = ->
  $("input[type='password'].password-strength-meter")

window.zxcvbn_load_hook = ->
  for input in passwordSelector()
    new PasswordStrengthMeter(input)

jQuery ->
  if passwordSelector().length > 0
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src = "/password_strength/password-strength.js"
    $("body").append(script)
