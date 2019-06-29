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

require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { is_expected.to belong_to(:event) }
end
