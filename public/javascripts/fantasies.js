var Fantasies = {
  
  descriptionChanged: function(textarea) {
    var description = (textarea.value || '');
    var roles = this.getRoles(description);

    if (roles.length > 0) {
      this.setRoles(roles);
      if (roles.length > 1) {
        Element.show('too_many_roles');
      }
    } else {
      this.clearRoles();
    }
  },
  
  setRoles: function(roles) {
    Element.show('roles_form_section');
    this.replaceRoleDescriptions(roles);
  },
  
  replaceRoleDescriptions: function(roles) {
    Element.update('roles_list', this.getRolesListItems(roles));
  },
  
  getRolesListItems: function(roles) {
    return roles.collect(function(role){
      return '<li>' + role + '</li>'
    }).join('\n');
  },
  
  clearRoles: function() {
    Element.hide('too_many_roles');
    Element.hide('roles_form_section');
  },
  
  getRoles: function(description) {
    var roles = this.getYourRole(description);
    roles = roles.concat(this.getThirdPartyRoles(description));
    return roles.uniq();
  },
  
  getThirdPartyRoles: function(description) {
    var matches = description.match(/\[([^\]]*)\]/g);
    var roles = [];
    if (matches) {
      roles = matches.collect(Fantasies.stripBrackets).reject(function(role){
        return role.match(/^(i|me|i'm|i've)$/i)
      });
    }
    return roles.uniq();
    
  },
  
  getYourRole: function(description) {
    if (description.match(/([ \n\[]|^)(i|me|i'm|i've)([ \n]|$)/i)) {
      return ['Myself'];
    }
    return [];
  },
  
  stripBrackets: function(with_brackets) {
    return with_brackets.match(/\[(.*)\]/)[1].strip();
  }

  
};
