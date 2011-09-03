class Workflows::BaseController < ApplicationController
  class CompanyNotFound < StandardError; end

  protected
  def current_company
    current_user.company
  rescue
    raise CompanyNotFound
  end
end
