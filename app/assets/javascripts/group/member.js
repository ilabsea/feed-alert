$(function(){
  buildMemberTypeahead()
  addMember()
  removeMember()
})

function buildMemberTypeahead(){
  var urlSearch = $("#member-typeahead").attr("data-url")
  var sources = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('full_name', 'email', 'phone'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: urlSearch + '?q=%QUERY'
  });

  // initialize the bloodhound suggestion engine
  sources.initialize();

  // instantiate the typeahead UI
  $('#member-typeahead').typeahead({ hint: true, highlight: true, minLength: 1 }, {
    displayKey: 'full_name',
    source: sources.ttAdapter(),
    templates: {
      empty: '<div class="empty-message">No result found, please retry</div>'
    }
  }).
  on('typeahead:selected', function(event, data){
    $("#member-value").val(data.id)
  }).
  on('typeahead:autocompleted', function(e, data){
    $("#member-value").val(data.id)
  });
}

function addMember(){
  $("#add-member-group").on('click', function(){

    var memberId = $("#member-value").val()
    var groupId = $("#member-value").attr("data-group-id")
    var url = $("#member-value").attr("data-url")

    var data = {member_id: memberId, group_id: groupId, is_member: true }
    $.ajax({
      method: 'POST',
      url: url,
      data: data,
      success: function(res){
        updateMemberList(res)
      },
      error: function(){
        alert("Could not be able to add this member to the group")
        //clean
        $("#member-typeahead").val("")
        $("#member-value").val("")
      }
    })
  });
}

function updateMemberList(res){
  $("#member-list").html(res)

  //clean
  $("#member-typeahead").val("")
  $("#member-value").val("")
}

function removeMemberRow(membershipId){
  $membershipRow = $("#membership-" + membershipId)
  $membershipRow.fadeOut(1000, function(){
    $membershipRow.remove()
  })

  //clean
  $("#member-typeahead").val("")
  $("#member-value").val("")
}

function removeMember(){
  $(document).on("click", ".remove-member", function(){
    var membershipId = $(this).attr("data-id")

    if(!confirm("Are you sure to remove this member"))
      return false

    $this = $(this)
    var url = $this.attr("href")
    $.ajax({
      data: {is_member: true},
      url: url,
      method: 'DELETE',
      success: function(res) {
        removeMemberRow(membershipId)
      },
      error: function(){

      }
    })

    return false
  })
}