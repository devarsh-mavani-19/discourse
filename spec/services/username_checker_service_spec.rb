# frozen_string_literal: true

RSpec.describe UsernameCheckerService do

  describe 'check_username' do

    before do
      @service = UsernameCheckerService.new
      @nil_email = nil
      @email = 'vincentvega@example.com'
    end

    context 'Username invalid' do
      it 'rejects too short usernames' do
        result = @service.check_username('a', @nil_email)
        expect(result).to have_key(:errors)
      end

      it 'rejects too long usernames' do
        result = @service.check_username('a123456789b123456789c123456789', @nil_email)
        expect(result).to have_key(:errors)
      end

      it 'rejects usernames with invalid characters' do
        result = @service.check_username('vincent-', @nil_email)
        expect(result).to have_key(:errors)
      end

      it 'rejects usernames that do not start with an alphanumeric character' do
        result = @service.check_username('.vincent', @nil_email)
        expect(result).to have_key(:errors)
      end

      describe 'reserved usernames' do
        before do
          SiteSetting.reserved_usernames = 'test|donkey'
        end

        it 'rejects usernames that are reserved' do
          result = @service.check_username("test", @nil_email)
          expect(result[:available]).to eq(false)
        end

        it 'allows reserved username checker to be skipped' do
          @service = UsernameCheckerService.new(allow_reserved_username: true)
          result = @service.check_username("test", @nil_email)
          expect(result[:available]).to eq(true)
        end
      end
    end

    it 'username not available locally' do
      User.stubs(:username_available?).returns(false)
      UserNameSuggester.stubs(:suggest).returns('einar-j')
      result = @service.check_username('vincent', @nil_email)
      expect(result[:available]).to eq(false)
      expect(result[:suggestion]).to eq('einar-j')
    end

    it 'username available locally' do
      User.stubs(:username_available?).returns(true)
      result = @service.check_username('vincent', @nil_email)
      expect(result[:available]).to eq(true)
    end
  end

end
