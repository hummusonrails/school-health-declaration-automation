require_relative '../declare'

RSpec.describe Declare do
  let(:declare_instance) do
    described_class.new(
      url: 'https://sample.url/school-form',
      username: 'jane_doe',
      password: 'password'
    )
  end

  context 'with correct parameters' do
    it 'creates an instance with the right attributes' do
      expect(declare_instance.url).to eql('https://sample.url/school-form')
      expect(declare_instance.username).to eql('jane_doe')
      expect(declare_instance.password).to eql('password')
    end
  end

  context 'with missing parameters' do
    it 'raises an exception without a password provided' do
      ENV['PASSWORD'] = nil
      expect { described_class.new(
        url: 'https://sample.url/school-form',
        username: 'jane_doe'
      ) }.to raise_error(ArgumentError, 'Missing PASSWORD environment variable')
    end

    it 'raises an exception without a username provided' do
      ENV['USERNAME'] = nil
      expect { described_class.new(
        url: 'https://sample.url/school-form',
        password: 'password'
      ) }.to raise_error(ArgumentError, 'Missing USERNAME environment variable')
    end

    it 'raises an exception without a url provided' do
      ENV['URL'] = nil
      expect { described_class.new(
        username: 'jane_doe',
        password: 'password'
      ) }.to raise_error(ArgumentError, 'Missing URL environment variable')
    end
  end
end