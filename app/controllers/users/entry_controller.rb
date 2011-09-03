class Users::EntryController < ApplicationController
  def new
    if params[:master_id].present?
      if master = ::Master::OfficialCompany.find_by_id(params[:master_id])
        @company = ::Company.new(
          :name => master.name,
          :address => master.address,
          :code => master.code,
          :expiration_date => master.expiration_date,
          :agency => master.agency,
          :jis_code => master.jis_code
        )
      else
        @company = ::Company.new
      end
    else
      @company = ::Company.new
    end
    @admin = ::User::Administrator.new
  end

  def create
    @company, @admin = [ ::Company.new, ::User::Administrator.new ]

    #TODO:ohat あとできれいに
    if master = ::Master::OfficialCompany.find_by_id(params[:master_id])
      @company = ::Company.new(
        :name => master.name,
        :address => master.address,
        :code => master.code,
        :expiration_date => master.expiration_date,
        :agency => master.agency,
        :jis_code => master.jis_code
      )
    end

    @admin.attributes = params[:company][:user_administrator]
    params[:company].delete(:user_administrator)

    @company.attributes = params[:company]

    ::Company::transaction do 
      if @company.valid? && @admin.valid?
        @company.save! and @company.reload
        @admin.company_id = @company.id
        @admin.save!
        @token = ActivationToken.create(email: @admin.email)
        DeliverMailer.entry(@token).deliver
        redirect_to complete_users_entry_path and return 
      else
        render "new"
      end
    end
  end
end
