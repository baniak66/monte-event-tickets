# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id         :bigint           not null, primary key
#  state      :enum             default("initialized")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_reservations_on_event_id  (event_id)
#  index_reservations_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#

class Reservation < ApplicationRecord
  NOT_PAID_RELEASE_TIME = 15
  STATE = {
    initialized: 'initialized',
    paid:        'paid',
    canceled:    'canceled'
  }.freeze

  belongs_to :event
  belongs_to :user
  has_many :tickets
  has_one :payment
end
