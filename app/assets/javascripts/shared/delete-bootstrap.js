$(function(){
  initBtnDelete()
})

function initBtnDelete(){
  $('.btn-delete').on('click', function(){

    var $this = $(this)
    var btnText =  $this.attr("data-btn-confirm") || "Confirm Delete"
    var confirmData = {
      title: $this.attr("data-confirm-title") || "Warning!",
      message: $this.attr("data-confirm"),
      messageExplain: $this.attr("data-confirm-explain") || "If you click on " + btnText + " , your data will be lost and it can not be undone.",
      btnText: btnText

    } 

    if(!confirmData.message)
      return true

    var $btnClone = $this.clone().addClass("btn btn-app btn-danger").removeClass("btn-delete").removeAttr("data-confirm")
    $btnClone.text(confirmData.btnText)

    var $container = $("#wapper-modal-confirm-delete")

    $container.html(tmpl('tmpl-modal-confirm-delete', confirmData))
    $container.find('.modal-footer').append($btnClone)
    $container.find('.modal').modal('show')

    return false
  })
}

