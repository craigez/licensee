RSpec.describe Licensee do
  let(:project_path) { fixture_path('mit') }
  let(:license_path) { fixture_path('mit/LICENSE.txt') }
  let(:mit_license) { Licensee::License.find('mit') }

  it 'exposes licenses' do
    expect(described_class.licenses).to be_an(Array)
    expect(described_class.licenses(hidden: true).count).to eql(32)
    expect(described_class.licenses.first).to be_a(Licensee::License)
  end

  it "detects a project's license" do
    expect(Licensee.license(project_path)).to eql(mit_license)
  end

  it "detect a file's license" do
    expect(Licensee.license(license_path)).to eql(mit_license)
  end

  it 'inits a project' do
    expect(Licensee.project(project_path)).to be_a(Licensee::Projects::Project)
  end

  context 'confidence threshold' do
    it 'exposes the confidence threshold' do
      expect(described_class.confidence_threshold).to eql(98)
    end

    it 'exposes the inverse of the confidence threshold' do
      expect(described_class.inverse_confidence_threshold).to eql(0.02)
    end

    context 'user overridden' do
      before { Licensee.confidence_threshold = 50 }
      after { Licensee.confidence_threshold = nil }

      it 'lets the user override the confidence threshold' do
        expect(described_class.confidence_threshold).to eql(50)
      end
    end
  end
end
