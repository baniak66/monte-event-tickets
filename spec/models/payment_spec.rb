# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id             :bigint           not null, primary key
#  amount         :integer          not null
#  currency       :string           default("EUR")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  reservation_id :bigint           not null
#
# Indexes
#
#  index_payments_on_reservation_id  (reservation_id)
#
# Foreign Keys
#
#  fk_rails_...  (reservation_id => reservations.id)
#

require 'rails_helper'

RSpec.describe Payment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
