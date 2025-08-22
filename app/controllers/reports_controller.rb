class ReportsController < ApplicationController


  def generate
    report_type = params[:report_type]
    email = params[:email]

    if %w[users_tweets companies_stats].include?(report_type)

      ReportGenerationJob.perform_later(report_type, email)

      render json: {
        message: "Relatório '#{report_type}' enfileirado para geração",
        job_enqueued: true
      }
    else
      render json: { error: "Tipo de relatório inválido" }, status: :unprocessable_entity
    end
  end

end
