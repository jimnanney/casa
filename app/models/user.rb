class User < ApplicationRecord
  has_paper_trail
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :casa_org

  has_many :case_assignments, foreign_key: "volunteer_id"
  has_many :casa_cases, through: :case_assignments

  ALL_ROLES = %w[inactive volunteer supervisor casa_admin].freeze
  enum role: ALL_ROLES.zip(ALL_ROLES).to_h

  # all contacts this user has with this casa case
  def case_contacts_for(casa_case_id)
    found_casa_case = casa_cases.find{|cc| cc.id == casa_case_id}
    found_casa_case.case_contacts.filter{|contact| contact.creator_id == self.id}
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("volunteer"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  casa_org_id            :bigint           not null
#
# Indexes
#
#  index_users_on_casa_org_id           (casa_org_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (casa_org_id => casa_orgs.id)
#
