class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.all
  end

  def show
    # Já tem @company from before_action
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to @company, notice: 'Empresa criada com sucesso!'
    else
      render :new
    end
  end

  def edit
    # Já tem @company from before_action
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Empresa atualizada com sucesso!'
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Empresa excluída com sucesso!'
  end

  private

  def set_company
    @company = Company.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to companies_path, alert: 'Empresa não encontrada.'
  end

  def company_params
    params.require(:company).permit(:name, :website)
  end
end
