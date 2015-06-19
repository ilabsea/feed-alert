$(function(){
  buildPermissionTypeahead()
  btnAddPermissionClick()
  inputPermissionRoleChange()
  updateSharedUsersTable()
  toggleCollapsableUser()
  toggleCollapsableProject()
})

function toggleCollapsableProject(){
  $('body').delegate(".kind-collapsable", 'click', function(){
    var $this = $(this)
    $this.find(".glyphicon").toggle()
    $this.parent().find(".permission-item").toggle()
  })
}

function toggleCollapsableUser(){
  $('body').delegate(".user-collapsable", 'click', function(){
    var $this = $(this)
    $this.find(".glyphicon").toggle()
    $this.next().toggle()
    $this.next().next().toggle()

  })
}


function permissionRoleMatchProjectPermission(user, projectId, role) {
  if(typeof user.project_permissions != 'undefined') {
    for(var i=0; i< user.project_permissions.length; i++) {
      var projectPermission = user.project_permissions[i]

      if(projectPermission.project_id == projectId &&  projectPermission.user_id == user.id && projectPermission.role == role )
        return "checked"
    }
  }
  return ""
}

function permissionRoleMatchChannelPermission(user, channelId, role) {
  if(typeof user.channel_permissions != 'undefined') {
    for(var i=0; i< user.channel_permissions.length; i++) {
      var channelPermission = user.channel_permissions[i]

      if(channelPermission.channel_id == channelId &&  channelPermission.user_id == user.id && channelPermission.role == role )
        return "checked"
    }
  }
  return ""
}



function updateSharedUsersTable(){
  if(typeof permissionUsers != 'undefined') {
    for(var i=0; i< permissionUsers.length; i++) {
      addPermissionToTable(permissionUsers[i])
    }
  }
}

function inputPermissionRoleChange() {
  $('body').delegate(".permission-role", 'change', function(){
    var $this = $(this)
    var data = $this.data()
    var params = {user_id: data.userId, role: data.role}

    if(data.projectId)
      params.project_id = data.projectId
    else if (data.channelId)
      params.channel_id = data.channelId
    
    var url = $this.attr('data-url')

    $.ajax({
      data: params,
      url: url,
      method: 'POST',
      success: function(response){

      },

      error: function(response){
      }

    })
  })
}

function buildPermissionTypeahead(){
  var $permissionUserId = $("#permission-user-id")

  var $typeAheadInput = $("#permission_user")
  var urlSearch = $typeAheadInput.attr("data-url")
  var sources = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('email'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: urlSearch + '?q=%QUERY'
  });

  // initialize the bloodhound suggestion engine
  sources.initialize();

  // instantiate the typeahead UI
  $typeAheadInput.typeahead({ hint: true, highlight: true, minLength: 1 }, {
    displayKey: 'email',
    source: sources.ttAdapter(),
    templates: {
      empty: '<div class="empty-message">No result found, please retry</div>'
    }
  }).
  on('typeahead:selected', function(event, data){
    setPermissionData(data)
  }).
  on('typeahead:autocompleted', function(e, data){
    setPermissionData(data)
  });
}

function setPermissionData(data) {
  window.permissionData = data
}

function btnAddPermissionClick() {
  $("#add-permission").on('click', function(){
    addPermissionToTable(window.permissionData)
  })
}

function addPermissionToTable(user) {
  if(typeof userTables[user.id] == 'undefined' ) {
    var data = {user: user, projects: myProjects, channels: myChannels}
    var template = $("#permission-tmpl").html()

    var result = tmpl(template, data)

    var $permission = $("#permission-items")
    var $userPermission = $(result)
    $permission.prepend($userPermission)
    userTables[user.id] = user.id
  }
}
