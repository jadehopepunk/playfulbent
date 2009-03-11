require File.dirname(__FILE__) + '/../test_helper'
require 'gallery_photo_files_controller'

# Re-raise errors caught by the controller.
class GalleryPhotoFilesController; def rescue_action(e) raise e end; end

class GalleryPhotoFilesControllerTest < Test::Unit::TestCase
  def setup
    @controller = GalleryPhotoFilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
