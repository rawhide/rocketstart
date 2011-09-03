# coding: utf-8
# TODO:ohta あとで全部company
class Workflows::ApprovalsController < Workflows::BaseController
  def show
    @report = ::ApprovalForm.find(params[:approval_form_id])
  end

  def new
    @approval = ::Approval.new
    @report = ::ApprovalForm.find(params[:approval_form_id])
    render "new"
  end

  def create
    #TODO:transaction workflowを作成
    @answer = ::Approval.new(params[:answer])
    @answer.user_id = current_user.id
    template_form = ::ApprovalForm.find(params[:approval_form_id])
    @answer.approval_form = template_form

    #TODO:きたないのでservicesにうつしたい

    ActiveRecord::Base::transaction do
      if @answer.save
        @answer.workflows= template_form.workflow_templates
        params[:field].each do |k,v|
          if v.class.to_s == "Array"
            text = ""
            v.each do |a|
              text += a + "-"
            end
            v = text.sub(/-\Z/, '')
          end
          af = ::Relations::ApprovalValues.new :approval => @answer, :approval_form_field_id => ::ApprovalFormField.find(k).id, :value => v
          af.save
        end
      end

      @complete_text = "completed"
      redirect_to complete_workflows_approvals_path(aproval_form_id: params[:approval_form_id])
    end
  end

end
