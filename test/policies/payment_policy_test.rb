#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe PaymentPolicy do
  include PunditMatcher

  subject { PaymentPolicy.new(user, payment)  }
  let(:lig) { payment.line_item_group }
  let(:payment) { FactoryGirl.create(:payment) }

  describe 'for a visitor' do
    let(:user) { nil }
    it { subject.must_deny(:show)   }
    it { subject.must_deny(:create) }
  end

  describe 'for a random logged-in user' do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:show)         }
    it { subject.must_deny(:create)       }
  end

  describe 'for the buying user' do
    let(:user) { payment.line_item_group_buyer }
    it { subject.must_permit(:show)        }
    it { subject.must_permit(:create)      }
  end
end
