$(function(){
  modalContentUrl()
})

function modalContentUrl() {
  $('a.content-url').click(function(){
    var $this = $(this)
    var url = $this.attr('href')

    $.get(url, function(html){
      $('#content-url-modal .modal-body').html(html)
      $('#content-url-modal').modal('show', {backdrop: 'static'})
    })

    return false
  });
}