require 'rails_helper'

RSpec.describe License, type: :model do

  subject { build(:license) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to define_enum_for(:status).with_values({ available: 1, in_use: 2, inactive: 3 }) }
  it { is_expected.to validate_presence_of(:platform) }
  it { is_expected.to define_enum_for(:platform).with_values({ game_on: 1 }) }
  it { is_expected.to validate_uniqueness_of(:key).case_insensitive.scoped_to(:platform) }

  it { is_expected.to belong_to :game }

  it_behaves_like "paginatable concern", :license
end
