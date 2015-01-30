$(function(){
  handleForm()
})

function handleForm(){
  $("#form-alert").on('submit', function(){
    var $markSelected = $(".mark_selected")
    var $markDestroy  = $(".mark_destroy")

    $.each($markSelected, function(index){
      markSelected = $markSelected[index]
      markDestroy  = $markDestroy[index]
      markDestroy.checked = !markSelected.checked
    })
  })
}