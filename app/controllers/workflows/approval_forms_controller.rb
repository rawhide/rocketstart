#coding: utf-8
#申請フォーム一覧
#ユーザー向け
class Workflows::ApprovalFormsController < ApplicationController
  def index
    @reports = ::ApprovalForm.all
  end
end
