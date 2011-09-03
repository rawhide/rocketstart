#coding: utf-8
class Workflows::Managements::AcceptsController < ApplicationController
  def index; end

  #TODO:あとでcompanyでフィルター
  def edit
    @approval = ::Approval.find params[:id]
  end

  def update
    ActiveRecord::Base.transaction do
      @approval = ::Approval.find params[:id]
      if wf = @approval.workflows.where(user_type: current_user.user_type).first
        wf.accept = params.key?(:accept)
        wf.save ? redirect_to(complete_workflows_managements_accepts_path) : render("edit") and return 
      end
    end
  end
end
