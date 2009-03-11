class InvitationsController < ApplicationController
  before_filter :login_required

  def stripshow_invite
    @strip_show = StripShow.find(params[:id].to_s)
    @sample = get_sample_external_invitation("NAME", @strip_show)
  end
    
  def send_stripshow_invite
    @strip_show = StripShow.find(params[:id].to_s)
    @invitation = ExternalInvitation.new(params[:invitation])
    @invitation.user = current_user
    @invitation.strip_show = @strip_show
    @sample = get_sample_external_invitation("NAME", @strip_show)
    
    if @invitation.valid? 
      @invitation.save!

      begin
        StripshowMailer.deliver_invite(@invitation)
      rescue Net::SMTPSyntaxError
      end
            
      @saved = true
    end
  end

  def stripshow_invite_user
    @strip_show = StripShow.find(params[:id].to_s)
    @user = User.find(params[:user_id])
    @sample = get_sample_user_invitation(@user, current_user, @strip_show)
  end
  
  def send_invite_user
    @strip_show = StripShow.find(params[:id].to_s)
    @user = User.find(params[:user_id])
    return access_denied unless @strip_show.user == current_user
    
    @invitation = UserInvitation.new(:recipient => @user, :user => current_user)
    
    if @invitation.valid? 
      @invitation.save!

      begin
        StripshowMailer.deliver_invite_user(@strip_show, @invitation)
      rescue Net::SMTPSyntaxError
        delivered = false
      else
        delivered = true
      end
    else
      @sample = get_sample_user_invitation(@user, current_user, @strip_show)
    end
    
    respond_to do |format|
      format.html do
        if delivered
          redirect_to user_my_stripshows_path(@user)
        else
          render :action => 'stripshow_invite_user'      
        end
      end
    end
  end
  
  
private

  def get_sample_external_invitation(name, strip_show)
    invitation = (@invitation == nil ? ExternalInvitation.new : @invitation.clone)
    invitation.strip_show = strip_show
    invitation.name = name if invitation.name.blank?
    
    StripshowMailer.create_invite(invitation).parts[1].body
  end

  def get_sample_user_invitation(recipient, user, strip_show)
    invitation = (@invitation == nil ? UserInvitation.new : @invitation.clone)
    invitation.recipient = recipient if invitation.recipient.nil?
    invitation.user = user if invitation.user.nil?
    
    StripshowMailer.create_invite_user(strip_show, invitation).parts[1].body
  end
 


end
