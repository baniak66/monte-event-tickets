# frozen_string_literal: true

# == Schema Information
#
# Table name: tickets
#
#  id             :bigint           not null, primary key
#  price          :integer          not null
#  ticket_type    :enum             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :bigint           not null
#  reservation_id :bigint
#
# Indexes
#
#  index_tickets_on_event_id  (event_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#

class Ticket < ApplicationRecord
  TICKET_TYPES = {
    even:         'even',
    all_together: 'all_together',
    avoid_one:    'avoid_one'
  }.freeze

  belongs_to :event
  validates :price, :ticket_type, presence: true
  validates :ticket_type, inclusion: { in: TICKET_TYPES.values }
end
