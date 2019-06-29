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
#  reservation_id :bigint           not null
#
# Indexes
#
#  index_tickets_on_event_id        (event_id)
#  index_tickets_on_reservation_id  (reservation_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (reservation_id => reservations.id)
#

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
