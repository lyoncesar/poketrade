class TradeMailer < ApplicationMailer
  default from: 'notification@poketrade.com'

  def new_email
    @trade = params[:trade]
    mail(
      to: @trade.coach_email,
      subject: t('mailers.trade.new_email.subject')
    )
  end
end
