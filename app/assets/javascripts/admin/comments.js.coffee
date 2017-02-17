ready = ->
  $('body').on 'submit', '.new_comment', (e) ->
    that = $(this)
    commentsContainer = that.closest(".comments-container")
    counterSpan = that.parents(".panel-body").find(".js-comments-counter")

    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'POST',
      data: $(this).serialize(),
      dataType: 'HTML',
      success: (data)->
        that.parents(".comments-container").find("textarea").val("")
        that.parents(".comments-container").find(".comment-insert").after(data)
        that.find("input[type='checkbox']").prop("checked", false)
        that.find(".comment-actions").removeClass("comment-flagged")

        amountComments = "(" + commentsContainer.find(".comment").length.toString() + ")"
        counterSpan.text(amountComments)

  $('body').on 'submit', '.destroy-comment', (e) ->
    e.preventDefault()

    commentsContainer = $(this).closest(".comments-container")
    counterSpan = $(this).parents(".panel-body").find(".js-comments-counter")

    $.ajax
      url: $(this).attr('action'),
      type: 'DELETE'
    $(this).parents('.comment').remove()

    amountComments = "(" + commentsContainer.find(".comment").length.toString() + ")"
    counterSpan.text(amountComments)

  toggleFlagged()
  deleteCommentAlert()

toggleFlagged = ->
  $(document).on "click", ".js-link-flag-comment", (e) ->
    e.preventDefault()
    flagged = "comment-flagged"
    newComment = $(this).closest(".comment-actions")
    newComment.toggleClass(flagged)
    toggleNewCommentFlag =(commentBox, flagged) ->
      checkbox = commentBox.find("input[type='checkbox']")
      checkbox.prop("checked", commentBox.hasClass(flagged))

    toggleNewCommentFlag(newComment, flagged)

    editComment = $(this).closest(".comment")
    editComment.toggleClass(flagged)
    state = editComment.is(flagged)
    editComment.find(".flag-comment-checkbox").
      prop("checked", editComment.hasClass(flagged))
    form = editComment.find(".edit_comment")
    form.submit()

deleteCommentAlert = ->
  $(document).on "click", ".link-delete-comment", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")
    $(this).closest(".comment").addClass("show-delete-comment")

  $(document).on "click", ".link-delete-comment-close", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")

$(document).ready(ready)
