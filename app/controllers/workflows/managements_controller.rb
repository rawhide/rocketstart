# coding: utf-8
class Workflows::ManagementsController < Workflows::BaseController
  before_filter :login_required

  def index
  end

  def show
    @report = ::ApprovalForm.find(params[:id])
  end

  def new
    @approval_form = ::ApprovalForm.new
    @approval_form.workflow_templates.build
  end

  def edit
    @approval_form = ::ApprovalForm.find(params[:id])
  end

  def update
    answers = ::Approval.where :approval_form_id => params[:id]
    if answers.size == 0
      ActiveRecord::Base::transaction do
        @report = ::ApprovalForm.find params[:id]
        @report.update_attributes(params[:approval_form])
        @report.fields = Array.new
        params[:field].each do |f|
          f[1][:text] =~ /\[(.*)\]/
          @report.fields << ::ApprovalFormField.new(:form_type => f[1][:form_type], :title => f[1][:title], :item => $1)
        end
      end
    else
      ActiveRecord::Base::transaction do
        old_report = ::ApprovalForm.find params[:id]
        old_report.title = old_report.title + "(" + Time.now.strftime("%Y%m%d%H%M") + ")"
        if old_report.save
          #nested_attributesをつくりなおす
          @report = current_user.reports.build
          params[:approval_form][:workflow_templates_attributes].each{|k,v| v.delete("id") }
          @report = current_user.reports.build(params[:approval_form])
          if @report.save
            params[:field].each do |f|
              f[1][:text] =~ /\[(.*)\]/
              @report.fields << ::ApprovalFormField.new(:form_type => f[1][:form_type], :title => f[1][:title], :item => $1)
            end
          else
          end
        else
        end
      end
    end
    redirect_to complete_workflows_managements_path(@report)
  end

  def create
    @report = current_user.reports.build
    @report.attributes = params[:approval_form]
    
    if @report.save
      params[:field].each do |f|
        f[1][:text] =~ /\[(.*)\]/
        field = ::ApprovalFormField.new(:form_type => f[1][:form_type], :title => f[1][:title], :item => $1)
        @report.fields << field
      end
    else
    end
    redirect_to(complete_workflows_managements_path(@report))
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_to(reports_url, :notice => 'レポートを削除しました。')
  end

=begin
  def pincode_entry
    @report = Report.find(params[:report_id])
    if @report.pincode.nil?
      redirect_to(new_report_answer_path(:report_id => @report), :method => 'post')
    end
  end

  def pincode
    @report = Report.find(params[:report_id])
    if @report.pincode != params[:pincode]
      redirect_to report_pincode_entry_path(:report_id => @report), :notice => 'ピンコードが違います。'
    else
      redirect_to(new_report_answer_path(:report_id => @report, :pincode => params[:pincode]), :method => 'post')
    end
  end
=end
end
