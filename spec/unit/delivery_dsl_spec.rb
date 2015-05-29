require 'spec_helper'

describe DeliverySugar::DSL do
  subject do
    Object.new.extend(described_class)
  end

  describe '.changed_cookbooks' do
    it 'gets a list of changed cookbook from the change object' do
      expect(subject).to receive_message_chain(:change,
                                               :changed_cookbooks)
      subject.changed_cookbooks
    end
  end

  describe '.changed_files' do
    it 'gets a list of changed files from the change object' do
      expect(subject).to receive_message_chain(:change, :changed_files)
      subject.changed_files
    end
  end

  describe '.delivery_chef_server' do
    let(:chef_server_configuration) { double 'a configuration hash' }

    it 'returns a cheffish configuration for interacting with the chef server' do
      expect(subject).to receive_message_chain(:chef_server, :cheffish_details)
        .and_return(chef_server_configuration)

      expect(subject.delivery_chef_server).to eql(chef_server_configuration)
    end
  end

  describe '.delivery_environment' do
    it 'get the current environment from the Change object' do
      expect(subject).to receive_message_chain(:change,
                                               :environment_for_current_stage)
      subject.delivery_environment
    end
  end

  describe '.get_acceptance_environment' do
    it 'gets the acceptance environment for the pipeline from the change object' do
      expect(subject).to receive_message_chain(:change,
                                               :acceptance_environment)
      subject.get_acceptance_environment
    end
  end

  describe '.project_slug' do
    it 'gets slug from Change object' do
      expect(subject).to receive_message_chain(:change, :project_slug)
      subject.project_slug
    end
  end

  describe '.get_project_secrets' do
    let(:project_slug) { 'ent-org-proj' }
    let(:data_bag_contents) do
      {
        'id' => 'ent-org-proj',
        'secret' => 'password'
      }
    end

    it 'gets the secrets from the Change object' do
      expect(subject).to receive_message_chain(:change, :project_slug)
        .and_return(project_slug)
      expect(subject)
        .to receive_message_chain(:chef_server, :encrypted_data_bag_item)
        .with('delivery-secrets', project_slug).and_return(data_bag_contents)

      expect(subject.get_project_secrets).to eql(data_bag_contents)
    end
  end
end