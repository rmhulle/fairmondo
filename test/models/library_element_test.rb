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

describe LibraryElement do
  subject { LibraryElement.new }

  describe 'associations' do
    it { subject.must belong_to :article }
    it { subject.must belong_to :library }
  end

  describe 'model attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :article }
    it { subject.must_respond_to :library }
    it { subject.must_respond_to :library_id }
    it { subject.must_respond_to :article_id }
  end

  describe 'validations' do
    describe 'for library_id' do
      it { subject.must validate_presence_of(:library_id) }
      it { subject.must validate_uniqueness_of(:library_id).scoped_to(:article_id) }
    end
  end
end
