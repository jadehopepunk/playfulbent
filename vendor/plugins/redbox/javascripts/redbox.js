
function RB_show_inline_redbox(id)
{
  RB_show_overlay();
  new Effect.Appear('RB_window', {duration: 0.4, queue: 'end'});        
  RB_clone_window_contents_from_id(id);
}

function RB_show_loading_redbox()
{
  RB_show_overlay();
  Element.show('RB_loading');
  RB_set_window_position();
}

function RB_move_window_contents_from_id(id)
{
  RB_remove_children_from_node($('RB_window'));
  RB_move_children($(id), $('RB_window'));
  Element.hide('RB_loading');
  new Effect.Appear('RB_window', {duration: 0.4, queue: 'end'});        
  RB_set_window_position();
}

function RB_remove_children_from_node(node)
{
  while (node.hasChildNodes())
  {
    node.removeChild(node.firstChild);
  }
}

function RB_move_children(source, destination)
{
  while (source.hasChildNodes())
  {
    destination.appendChild(source.firstChild);
  }
}

function RB_clone_window_contents_from_id(id)
{
  var content = $(id).cloneNode(true);
  content.style['display'] = 'block';
  $('RB_window').appendChild(content);  

  RB_set_window_position();
}

function RB_show_overlay()
{
  if ($('RB_redbox'))
  {
    Element.update('RB_redbox', "");
    new Insertion.Top($('RB_redbox'), '<div id="RB_window" style="display: none;"></div><div id="RB_overlay" style="display: none;"></div>');  
  }
  else
  {
    new Insertion.Bottom(document.body, '<div id="RB_redbox" align="center"><div id="RB_window" style="display: none;"></div><div id="RB_overlay" style="display: none;"></div></div>');      
  }
  new Insertion.Top('RB_overlay', '<div id="RB_loading" style="display: none"></div>');  

  RB_set_overlay_size();
  new Effect.Appear('RB_overlay', {duration: 0.4, to: 0.6, queue: 'end'});
}

function RB_close()
{
  new Effect.Fade('RB_window', {duration: 0.4});
  new Effect.Fade('RB_overlay', {duration: 0.4});
}

function RB_set_overlay_size()
{
  if (window.innerHeight && window.scrollMaxY)
  {  
    yScroll = window.innerHeight + window.scrollMaxY;
  } 
  else if (document.body.scrollHeight > document.body.offsetHeight)
  { // all but Explorer Mac
    yScroll = document.body.scrollHeight;
  }
  else
  { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
    yScroll = document.body.offsetHeight;
  }
  $("RB_overlay").style['height'] = yScroll +"px";
}

function RB_set_window_position()
{
  var pagesize = RB_get_page_size();  
  var arrayPageScroll = RB_get_page_scroll_top();
  
  $("RB_window").style['width'] = 'auto';
  $("RB_window").style['height'] = 'auto';

  var dimensions = Element.getDimensions($("RB_window"));
  var width = dimensions.width;
  var height = dimensions.height;        
    
  $("RB_window").style['left'] = ((pagesize[0] - width)/2) + "px";
  $("RB_window").style['top'] = (arrayPageScroll[1] + ((pagesize[1] - height)/2)) + "px";
}


function RB_get_page_size(){
  var de = document.documentElement;
  var w = window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
  var h = window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;
  
  arrayPageSize = new Array(w,h) 
  return arrayPageSize;
}

function RB_get_page_scroll_top()
{
  var yScrolltop;
  if (self.pageYOffset) {
    yScrolltop = self.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop){   // Explorer 6 Strict
    yScrolltop = document.documentElement.scrollTop;
  } else if (document.body) {// all other Explorers
    yScrolltop = document.body.scrollTop;
  }
  arrayPageScroll = new Array('',yScrolltop) 
  return arrayPageScroll;
}

