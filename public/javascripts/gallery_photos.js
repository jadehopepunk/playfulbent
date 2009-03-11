function startSortingGalleryPhotos(url)
{
  Sortable.create(
    'reorderable_photo_thumbnails', 
    {
      onUpdate:function()
      {
        new Ajax.Request(
          url, 
          {
            asynchronous:true, 
            evalScripts:true, 
            parameters:Sortable.serialize('reorderable_photo_thumbnails')
          }
        )
      }
    }
  );
 
  Element.hide('photo_thumbnails');
  Element.show('reorderable_photo_section');
  Element.hide('photo_edit_links');
  Element.show('done_reordering_link');
}

function stopSortingGalleryPhotos()
{
  Sortable.destroy('reorderable_photo_thumbnails');
  
  Element.hide('reorderable_photo_section');
  Element.show('photo_edit_links');
  Element.hide('done_reordering_link');
  Element.show('photo_thumbnails')
}

function galleryPhotosToDeleteMode()
{
  Element.hide('photo_thumbnails');
  Element.show('deletable_photo_section');
  Element.hide('photo_edit_links');
  Element.show('done_deleting_link'); 
}

function galleryPhotosStopDeleteMode()
{
  Sortable.destroy('reorderable_photo_thumbnails');
  
  Element.hide('deletable_photo_section');
  Element.show('photo_edit_links');
  Element.hide('done_deleting_link');
  Element.show('photo_thumbnails')  
}