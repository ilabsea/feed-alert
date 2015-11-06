$(function(){
  buildAlertGroupTypeahead()
  addAlertGroup()
  removeAlertGroup()
})

function buildAlertGroupTypeahead(){
  var $typeAheadInput = $("#alert-group-typeahead")
  var urlSearch = $typeAheadInput.attr("data-url")
  var sources = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name', 'description'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: { url: urlSearch + '?q=%QUERY', cache: false }
  });

  // initialize the bloodhound suggestion engine
  sources.initialize();

  var $alertGroupValue = $("#alert-group-value")

  // instantiate the typeahead UI
  $typeAheadInput.typeahead({ hint: false, highlight: true, minLength: 0}, {
    displayKey: 'name',
    source: sources.ttAdapter(),
    templates: {
      empty: '<div class="empty-message">No result found, please retry</div>'
    }
  }).
  on('typeahead:selected', function(event, data){
    $alertGroupValue.val(data.id)
  }).
  on('typeahead:autocompleted', function(e, data){
    $alertGroupValue.val(data.id)
  }).on( 'focus', function() {
    if($(this).val() === '') // you can also check for minLength
      $(this).data().ttTypeahead.input.trigger('queryChanged', '');
  });
}

function addAlertGroup(){
  $("#add-alert-group").on('click', function(){

    var $alertGroupValue = $("#alert-group-value")
    var groupId = $alertGroupValue.val()
    var url = $(this).attr("href")
    if(!groupId){
      setNotification("alert", "Please enter a valid group")
      return false;
    }

    var data = {group_id: groupId }

    $.ajax({
      method: 'POST',
      url: url,
      data: data,
      success: function(res){
        setNotification("notice", "Group added")
        updateAlertGroupList(res)
      },

      error: function(){
        setNotification("alert", "Could not add this group to alert")
        cleanAlertGroupTypeAhead()
      }
    })
    return false
  });
}

function updateAlertGroupList(res){
  $("#alert-group-list").html(res)
  cleanAlertGroupTypeAhead()
}

function removeAlertGroupRow(alertGroupId){
  $alertGroupRow = $("#alert-group-" + alertGroupId)
  $alertGroupRow.fadeOut(1000, function(){
    $alertGroupRow.remove()
  })
}

function cleanAlertGroupTypeAhead(){
  $("#alert-group-value").val("")
  $("#alert-group-typeahead").val("")
}

function removeAlertGroup(){
  $(document).on("click", ".remove-alert-group", function(){
    var alertGroupId = $(this).attr("data-id")

    if(!confirm("Are you sure to remove this group ?"))
      return false

    $this = $(this)
    var url = $this.attr("href")
    $.ajax({
      url: url,
      method: 'DELETE',
      success: function(res) {
        removeAlertGroupRow(alertGroupId)
      },
      error: function(){
        alert("Failed to remove group")
      }
    })
    return false
  })
}