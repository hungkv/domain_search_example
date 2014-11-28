# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'submit', 'form.enter_website_form', (event) ->

  formObj = $(this)
  formURL = formObj.attr("action")
  formData = new FormData(this)
  website_url = $(this).find('#website_url').val()

  if window.learnRegExp(website_url)
    console.log "website url: " + website_url 
    $.ajax
      url: formURL
      beforeSend : (xhr) -> 
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      type: 'POST'
      dataType: "script"
      data:  formData
      contentType: false
      cache: false
      processData: false
      success: (response) ->

  else
    console.log "Invalid website url!"

  event.preventDefault() 

window.learnRegExp = (s) ->    
  
  pattern = new RegExp('^(https?:\\/\\/)?((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|((\\d{1,3}\\.){3}\\d{1,3}))(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*(\\?[;&a-z\\d%_.~+=-]*)?(\\#[-a-z\\d_]*)?$','i')
  return pattern.test(s)


window.synchronize_websites_function = () ->
  formURL = "/websites/refresh?last_synchronized_at=" + $('#website_last_synchronized_at').val()

  $.ajax
    url: formURL
    beforeSend : (xhr) -> 
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    type: 'PUT'
    dataType: "script"
    contentType: false
    cache: false
    processData: false
    success: (response) ->

  return false