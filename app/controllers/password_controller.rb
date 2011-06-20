class PasswordController < ApplicationController

  def remined
    @entry = ActivationToken.new
  end

  def remined_complete
    @entry = ActivationToken.new
    @entry.attributes = params[:activation_token]
    @entry.save!
    DeliverMailer.entry(@entry).deliver
    render (@entry.new_record? ? :new : :edit)



    user = User.find_by_email params[:email]
    if user
    else
    end


  end

end
