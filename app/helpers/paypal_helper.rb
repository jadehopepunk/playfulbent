
module PaypalHelper
  
  def paypal_url(path)
    AppConfig.paypal_url + path
  end
  
  def paypal_cancel_url(user)
    return_url = (user ? user.profile_url : 'http://www.playfulbent.com')
    paypal_url "?cmd=_subscr-find&alias=#{AppConfig.paypal_email}&return=#{CGI.escape(return_url)}"
  end
  
end