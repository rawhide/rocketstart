class Users::Entry::SearchController < ApplicationController
  def index
  end

  def create
    if params[:name].present?
      @result = ::Master::OfficialCompany.where(["name like ? ","%#{params[:name]}%"])
    else
      code = "#{params[:code]}(#{params[:suffix]})"
      @result = ::Master::OfficialCompany.where(code: code)
    end
    flash[:notice] = "1" unless @result.present?
    render "index"
  end
end
