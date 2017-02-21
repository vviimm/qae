ready = ->
  $('body').on 'submit', '.new_comment', (e) ->
    that = $(this)

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

        updateCommentsCounter(that.closest(".comments-container"))

  $('body').on 'submit', '.destroy-comment', (e) ->
    e.preventDefault()
    commentsContainer = $(this).closest(".comments-container")

    $.ajax
      url: $(this).attr('action'),
      type: 'DELETE'
    $(this).parents('.comment').remove()

    updateCommentsCounter(commentsContainer)

  toggleFlagged()
  deleteCommentAlert()

updateCommentsCounter = (commentsContainer) ->
  counterSpan = commentsContainer.parents(".panel-body").find(".js-comments-counter")
  amountComments = "(" + commentsContainer.find(".comment").length.toString() + ")"
  counterSpan.text(amountComments)

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
