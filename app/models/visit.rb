class Visit < ApplicationRecord
  TELEGRAM_KEY_PREFIX = 'v_'
  belongs_to :visitor

  before_create do
    self.key = Nanoid.generate
  end

  after_create do
    if visitor.first_visit_id.nil?
      Visitor.where(id: visitor_id, first_visit_id: nil).update_all first_visit_id: id
      visitor.reload
    end
    self.visitor.update_column: :last_visit_id, id
  end

  def telegram_key
    TELEGRAM_KEY_PREFIX + key
  end

  def project
    Project.find_or_create_by!(owner: User.first, domain: '3003.brandymint.ru')
  end

  def topic_title
    remote_ip
  end
end
