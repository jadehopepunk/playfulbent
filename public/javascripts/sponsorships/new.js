function updateOtherSponsorship(user_text)
{
  if (IsInteger(user_text))
  {
    $('paypal_a3').value = user_text;
    $('other_sponsorship').removeClassName('invalid');
    $('submit_to_paypal').disabled = false;
  }
  else
  {
    $('other_sponsorship').addClassName('invalid');
    $('submit_to_paypal').disabled = true;
  }
}