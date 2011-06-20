#coding: utf-8
class GeneralController < ApplicationController
  before_filter :login_required

  def home
  end

end

