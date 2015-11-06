$(function(){
  collasableSetupFlowForm()
  switchChannelStatus()
  channelWizardView('download-android-local-gateway-wizard')
})

function createChannel(){
  form = $('#form-create-channel');
  $.ajax({
    type: "POST",
    url: '/channels',
    data: form.serialize(),
    success: function(data) {
      channelWizardView('end-wizard');      
    },
    error: function(data){
      $('.error-field').text(data["responseText"]);
    }
  });  
}

function channelWizardView(view){
  $('.channel-wizard').hide();
  $("#"+view).show();
}

function collasableSetupFlowForm(){
  $(".setup-flow").on('click', function(){
    var $this = $(this)
    var $body = $this.parent().find(".panel-body")
    $body.toggle()
    $(".setup-flow").parent().find(".panel-body").not($body).hide()
    return false
  })
}

function switchChannelStatus(){
  $(".channel-status").bootstrapSwitch()
  $('.channel-status').on('switchChange.bootstrapSwitch', function(event, state) {
    var $this = $(this)
    var url = $this.attr('data-url')

    $.ajax({
      method: 'PUT',
      url: url,
      data: {state: state},
      success: function(){
        setNotification("notice", "Sucessfully updated")
        window.location.href = '/channels'
      },
      error: function() {
        setNotification("alert", "Failed to updated")
      }
    })
    return false
  })


}