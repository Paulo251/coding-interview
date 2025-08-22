class ReportMailer < ApplicationMailer
  default from: 'reports@seuapp.com'

  def report_email(to, subject, data)
    @data = data
    @subject = subject

    mail(
      to: to,
      subject: "Relatório: #{subject}"
    )
  end
end
