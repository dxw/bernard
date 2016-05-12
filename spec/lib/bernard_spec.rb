require 'spec_helper'

RSpec.describe Bernard do
  describe '#publish' do
    it 'publishes an event to keen.io' do

    end
  end

  describe '#write_key=' do
    it 'sets write_key with the passed in value' do
      valid_key = 'a' * 192

      b = Bernard.new
      b.write_key = valid_key

      expect(b.write_key).to eql valid_key
    end

    it 'throws a Bernard::Exception if it is not formatted correctly' do
      b = Bernard.new

      expect { b.write_key = 'BAD_KEY' }.to raise_error(Bernard::Exception)
    end
  end

  describe '#project_id=' do
    it 'sets project_id with the passed in value' do
      valid_project_id = '123456789abcdef012345678'

      b = Bernard.new
      b.project_id = valid_project_id

      expect(b.project_id).to eql valid_project_id
    end

    it 'throws a Bernard::Exception if it is not formatted correctly' do
      b = Bernard.new

      expect { b.project_id = 'BAD_KEY' }.to raise_error(Bernard::Exception)
    end
  end
end
