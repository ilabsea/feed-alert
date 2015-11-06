$(function(){
  buildGroupTypeahead()
  addGroup()
  removeGroup()
})

function buildGroupTypeahead(){
  var urlSearch = $("#group-typeahead").attr("data-url")
  var sources = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name', 'description'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: { url:  urlSearch + '?q=%QUERY', cache: false }
  });

  // initialize the bloodhound suggestion engine
  sources.initialize();

  // instantiate the typeahead UI
  $('#group-typeahead').typeahead({ hint: false, highlight: true, minLength: 0 }, {
    displayKey: 'name',
    source: sources.ttAdapter(),
    templates: {
      empty: '<div class="empty-message">No result found, please retry</div>'
    }
  }).
  on('typeahead:selected', function(event, data){
    $("#group-value").val(data.id)
  }).
  on('typeahead:autocompleted', function(e, data){
    $("#group-value").val(data.id)
  }).on( 'focus', function() {
    if($(this).val() === '') // you can also check for minLength
      $(this).data().ttTypeahead.input.trigger('queryChanged', '');
  });
}

function addGroup(){
  $("#add-group").on('click', function(){

    var groupId = $("#group-value").val()
    var memberId = $("#group-value").attr("data-member-id")
    var url = $("#group-value").attr("data-url")

    if(!groupId) {
      setNotification("alert", "Please enter a valid group")
      return false;
    }

    var data = {member_id: memberId, group_id: groupId }

    $.ajax({
      method: 'POST',
      url: url,
      data: data,
      success: function(res){
        setNotification("notice", "Group added")
        updateGroupList(res)
      },

      error: function(){
        setNotification("alert", "Please enter a valid group")
        //clean
        $("#group-typeahead").val("")
        $("#group-value").val("")
      }
    })

  });
}

function updateGroupList(res){
  $("#group-list").html(res)

  //clean
  $("#group-typeahead").val("")
  $("#group-value").val("")
}

function removeGroupRow(membershipId){
  $membershipRow = $("#membership-" + membershipId)
  $membershipRow.fadeOut(1000, function(){
    $membershipRow.remove()
  })

  //clean
  $("#member-typeahead").val("")
  $("#member-value").val("")
}

function removeGroup(){
  $(document).on("click", ".remove-group", function(){
    var membershipId = $(this).attr("data-id")

    $this = $(this)
    var url = $this.attr("href")
    $.ajax({
      url: url,
      method: 'DELETE',
      success: function(res) {
        removeGroupRow(membershipId)
      },
      error: function(){

      }
    })

    return false
  })
}