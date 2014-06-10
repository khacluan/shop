class UserMailer < ActionMailer::Base
  default from: APP_CONFIG['email_sender']

  def send_order_information(user, order_id)
    @user = user
    @url = "#{APP_CONFIG['domain']}/frontends/order"
    @order = Order.find_by(id: order_id)
    mail(to: @user.email, subject: 'ZIGExN VeNtura Shopping Order Information')
  end
end
