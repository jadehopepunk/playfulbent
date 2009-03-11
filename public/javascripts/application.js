// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function stripeList(list_id)
{
  $$("ol#" + list_id).each(function(ul) {
    Selector.findChildElements(ul, ["li"])
      .invoke('removeClassName', 'odd')
      .invoke('removeClassName', 'even')
  });  


  $$("ol#" + list_id).each(function(ul) {
    Selector.findChildElements(ul, ["li"])
      .findAll(function(li,i) { return i % 2 == 1; })
      .invoke("addClassName", 'odd');
  });  
}


function IsInteger(sText)
{
  var ValidChars = "0123456789";
  var Char;
  
  if (sText == '0' || sText == '') return false;

  for (i = 0; i < sText.length; i++) 
  { 
    Char = sText.charAt(i); 
    if (ValidChars.indexOf(Char) == -1) 
    {
      return false
    }
  }
  return true;
}

var DareLevelSelector = {
  
  updateClasses: function() {
    $$("div.dare_level_selector div.dare_level_description input").each(function(input) {
      var container = input.up("div.dare_level_description");
      if (input.checked) {
        container.removeClassName('inactive_dare_level');        
      } else {
        container.addClassName('inactive_dare_level');
      }
    });
  },
  
  setup: function() {
    $$("div.dare_level_selector div.dare_level_description input").each(function(input) {
      Event.observe(input, 'click', function(event) {
        Event.element(event).checked = true;
        DareLevelSelector.updateClasses();
      });
    });
    
    $$("div.dare_level_selector div.dare_level_description").each(function(input) {
      Event.observe(input, 'click', function(event) {
        Event.stop(event);
        
        var eventElement = Event.element(event);
        var container = null;
        if (eventElement.hasClassName('dare_level_description')) {
          container = eventElement;
        } else {
          container = eventElement.up('div.dare_level_description')
        }
        var radioButton = container.down('input[type=radio]');
        radioButton.checked = true;
        DareLevelSelector.updateClasses();
      });
    });
    
    this.updateClasses();
  }
    
}

