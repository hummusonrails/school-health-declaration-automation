require_relative '../declare_antigen'

RSpec.describe DeclareAntigen do
  let(:declare_instance) do
    described_class.new(
      url: 'https://sample.url/school-form',
      parent_name: 'פלוני אלמוני',
      parent_tz: '000000000',
      childrens_tz: '000000000',
      childrens_names: 'ילד האלוף'
    )
  end

  context 'with correct parameters' do
    it 'creates an instance with the right attributes' do
      expect(declare_instance.url).to eql('https://sample.url/school-form')
      expect(declare_instance.parent_name).to eql('פלוני אלמוני')
      expect(declare_instance.parent_tz).to eql('000000000')
      expect(declare_instance.childrens_names).to eql('ילד האלוף')
      expect(declare_instance.childrens_tz).to eql('000000000')
    end
  end
end