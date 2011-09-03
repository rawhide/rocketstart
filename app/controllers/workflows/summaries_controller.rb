# coding: utf-8
require "kconv"
require "csv"
class Workflows::SummariesController < ApplicationController
  before_filter :login_required

  def index
    @form = ::ApprovalForm.find(params[:approval_form_id])
    @answers = ::Approval.where(approval_form_id: params[:approval_form_id])
    @fields = ::ApprovalFormField.where(approval_form_id: params[:approval_form_id])
    respond_to do |format|
      format.html do
        render 'index'
      end
      format.csv do
        csv and return
      end
    end
  end

  private
  def csv
    file_name = Time.now.to_s + "_summary.csv"
    csv_text = CSV.generate do |csv|
      header = ['回答者', '回答日時']
      @fields.each do |f|
        header << f.title
      end

      csv << header.map{|val| val.tosjis }
      @answers.each do |a|
        ans = [a.user.name, a.created_at.to_s]
        @fields.each do |f|
          af = ::Relations::ApprovalValues.where(approval_id: a.id, approval_form_field_id: f.id).first
          af.nil? ? ans << "" : ans << af.value
        end
        csv << ans.map{|val| val.tosjis }
      end
    end
    send_data(csv_text, :type => 'text/csv; charset=Shift_JIS', :filename => file_name )
  end
end
