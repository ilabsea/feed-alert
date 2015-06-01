$(function(){
  buildPermissionTypeahead()
  btnAddPermissionClick()
  inputPermissionRoleChange()
  updateSharedUsersTable()
  toggleCollapsableUser()
  toggleCollapsableProject()
})

function toggleCollapsableProject(){
  $('body').delegate(".project-collapsable", 'click', function(){
    var $this = $(this)
    $this.find(".glyphicon").toggle()
    $projectItems = $(".permission-" + $this.attr('data-user-id'))
    $projectItems.toggle()
  })
}

function toggleCollapsableUser(){
  $('body').delegate(".user-project-collapsable", 'click', function(){
    var $this = $(this)
    $this.find(".glyphicon").toggle()
    $projectTitle = $this.next()
    $projectTitle.toggle()
  })
}


function permissionRoleMatch(user, projectId, role) {
  if(typeof user.project_permissions != 'undefined') {
    for(var i=0; i< user.project_permissions.length; i++) {
      var projectPermission = user.project_permissions[i]

      if(projectPermission.project_id == projectId &&  projectPermission.user_id == user.id && projectPermission.role == role )
        return "checked"
    }
  }
  return ""
}

function updateSharedUsersTable(){
  if(permissionUsers) {
    for(var i=0; i< permissionUsers.length; i++) {
      console.log("user", permissionUsers[i])
      addPermissionToTable(permissionUsers[i])
    }
  }
}

function inputPermissionRoleChange() {
  $('body').delegate(".project-permission-role", 'change', function(){
    var $this = $(this)
    var data = $this.data()
    var params = {user_id: data.userId, project_id: data.projectId, role: data.role}
    var url = $("#project-permission").attr('data-url')
    console.log(params)

    $.ajax({
      data: params,
      url: url,
      method: 'POST',
      success: function(response){
        console.log('success', response)
      },

      error: function(response){
        console.log('error', response)
      }

    })
  })

  $('body').delegate(".project-permission-role", 'click', function(event){
    console.log('stop')
    event.stopPropagation()
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
    var data = {user: user, projects: myProjects}
    var template = $("#permission-tmpl").html()

    var result = tmpl(template, data)

    var $permission = $("#permission-items")
    var $userPermission = $(result)
    $permission.prepend($userPermission)
    userTables[user.id] = user.id
  }
}
