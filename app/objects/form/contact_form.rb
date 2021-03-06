class ContactForm
  include ActiveData::Model

  attribute :email_transfer_accepted, type: Boolean, default: true
  attribute :text, type: String

  validates :email_transfer_accepted, acceptance: { accept: true }
  validates :text, length: { maximum: 2000 }, presence: true

  def mail(sender, resource_id, resource_type)
    mailer = get_mailer_for resource_type
    mailer.delay.contact(sender: sender, resource_id: resource_id, text: self.text) if mailer
  end

  def get_mailer_for resource_type
    return ArticleMailer if resource_type == 'article'
    return UserMailer if resource_type == 'user'
  end
end
