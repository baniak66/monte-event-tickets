# frozen_string_literal: true

# == Schema Information
#
# Table name: tickets
#
#  id             :bigint           not null, primary key
#  price          :integer          not null
#  type           :enum             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :bigint           not null
#  reservation_id :bigint
#
# Indexes
#
#  index_tickets_on_event_id        (event_id)
#  index_tickets_on_reservation_id  (reservation_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#

class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :reservation
end
