require File.expand_path('../../test_helper', __FILE__)

describe 'DataSift' do

  before do
    auth      = DataSiftExample.new
    @datasift = auth.datasift
    @data     = OpenStruct.new

    @data.label = 'minitest'
  end

  ##
  # :POST /account/identity
  #
  describe 'successful :POST' do
    after do
      VCR.use_cassette('account/identity/after_create_success') do
        @datasift.account_identity.delete @identity_id
      end
    end

    it 'can_create_identity' do
      VCR.use_cassette('account/identity/create_success') do
        response = @datasift.account_identity.create(
          label: @data.label,
          status: 'active',
          master: false
        )
        assert_equal STATUS.created, response[:http][:status]
        @identity_id = response[:data][:id]
      end
    end
  end

  describe 'unsuccessful :POST' do
    it 'cannot_create_identity_without_label' do
      assert_raises ArgumentError do
        @datasift.account_identity.create
      end
    end
  end

  ##
  # :GET /account/identity
  #
  describe 'successful :GET' do
    before do
      VCR.use_cassette('account/identity/before_get_success') do
        identity = @datasift.account_identity.create(label: @data.label)
        @identity_id = identity[:data][:id]
      end
    end

    after do
      VCR.use_cassette('account/identity/after_create_success') do
        @datasift.account_identity.delete @identity_id
      end
    end

    it 'can_get_identity_by_id' do
      VCR.use_cassette('account/identity/get_success') do
        response = @datasift.account_identity.get @identity_id
        assert_equal STATUS.valid, response[:http][:status]
      end
    end

    it 'can_get_list_of_identities' do
      VCR.use_cassette('account/identity/list_success') do
        response = @datasift.account_identity.list
        assert_equal STATUS.valid, response[:http][:status]
      end
    end

    it 'can_get_list_of_identities_with_params' do
      VCR.use_cassette('account/identity/list_success_with_params') do
        response = @datasift.account_identity.list(
          label: @data.label,
          per_page: 1,
          page: 1
        )
        assert_equal STATUS.valid, response[:http][:status]
      end
    end
  end

  describe 'unsuccessful :GET' do
    it 'cannot_get_identities_without_id' do
      assert_raises ArgumentError do
        @datasift.account_identity.get
      end
    end
  end

  ##
  # :PUT /account/identity
  #
  describe 'successful :PUT' do
    before do
      VCR.use_cassette('account/identity/before_successful_update') do
        identity = @datasift.account_identity.create(label: @data.label)
        @identity_id = identity[:data][:id]
      end
    end

    after do
      VCR.use_cassette('account/identity/after_successful_update') do
        @datasift.account_identity.delete @identity_id
      end
    end

    it 'can_update_identity' do
      VCR.use_cassette('account/identity/update_success') do
        response = @datasift.account_identity.update(
          id: @identity_id,
          label: "#{@data.label}-update",
          status: 'active',
          master: false
        )
        assert_equal STATUS.valid, response[:http][:status]
      end
    end
  end

  describe 'unsuccessful :PUT' do
    it 'cannot_update_with_unknown_id' do
      VCR.use_cassette('account/identity/update_id_404') do
        response = @datasift.account_identity.update(
          id: "fake_id",
          label: "#{@data.label}-update",
          status: 'active',
          master: false
        )
      end
      assert_equal STATUS.not_found, response[:http][:status]
    end

    it 'cannot_update_without_id' do
      assert_raises ArgumentError do
        @datasift.account_identity.update(
          label: "#{@data.label}-update",
          status: 'active',
          master: false
        )
      end
    end
  end

  ##
  # :DELETE /account/identity
  #
  describe 'successful :DELETE' do
    before do
      VCR.use_cassette('account/identity/before_successful_delete') do
        identity = @datasift.account_identity.create(label: @data.label)
        @identity_id = identity[:data][:id]
      end
    end

    it 'can_delete_identity' do
      VCR.use_cassette('account/identity/delete_success') do
        @datasift.account_identity.delete @identity_id
      end
    end
  end

  describe 'unsuccessful :DELETE' do
    it 'cannot_delete_without_id' do
      assert_raises ArgumentError do
        @datasift.account_identity.delete
      end
    end
  end
end
