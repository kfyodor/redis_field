require_relative './spec_helper.rb'

describe RedisField do
  describe RedisField::ActiveRecord do
   TestUser.has_redis_fields :test_field1, :test_field2
   TestUser.has_redis_field :test_field3

    def get_from_redis(id, key)
      data = Redis::Namespace.new("ar_redis_field:test:test_user:#{id}", redis: RedisField::Base.redis)[key]
      Marshal.load data if data
    end

    let(:klass) { TestUser }
    subject { klass.new }

    after(:all) do
      RedisField::Testing.reset_keys!
    end

    it 'klass has redis fields' do
      expect(
        klass.instance_variable_get('@redis_fields').field_names
      ).to eq([:test_field1, :test_field2, :test_field3])
    end

    it 'klass\' redis fields are an instance of DirtyFieldSet' do
      expect(
        klass.instance_variable_get('@redis_fields')
      ).to be_instance_of(RedisField::DirtyFieldSet)
    end 

    it { should respond_to :test_field1 }
    it { should respond_to :test_field2 }
    it { should respond_to :test_field3 }
    it { should respond_to :test_field1= }
    it { should respond_to :test_field2= }
    it { should respond_to :test_field3= }
    it { should respond_to :test_field1_redis_value }
    it { should respond_to :test_field2_redis_value }
    it { should respond_to :test_field3_redis_value }
    it { should respond_to :test_field1_redis_value= }
    it { should respond_to :test_field2_redis_value= }
    it { should respond_to :test_field3_redis_value= }
    it { should respond_to :sync_redis_fields! }
    it { should respond_to :get_redis_fields }

    it 'runs save callbacks' do
      subject.run_callbacks(:save) do
        subject.should_receive(:sync_redis_fields!).once
      end
    end

    it 'runs create callbacks' do
      subject.run_callbacks(:create) do
        subject.should_receive(:sync_redis_fields!).once
      end
    end

    it 'runs initialize callbacks' do
      subject.run_callbacks(:initialize) do
        subject.should_receive(:get_redis_fields).once
      end
    end

    describe 'saving' do
      before(:each) do
        subject.save
        @user = subject
      end

      it 'should not save in redis until the record is saved' do
        @user.test_field1 = 'test'
        get_from_redis(@user, 'test_field1').should be_nil
      end

      it 'should save to redis when the record is saved' do
        @user.test_field1 = 'test1'
        @user.test_field2 = 'test2'
        @user.test_field3 = 'test3'

        @user.save

        get_from_redis(@user.id, 'test_field1').should eq('test1')
        get_from_redis(@user.id, 'test_field2').should eq('test2')
        get_from_redis(@user.id, 'test_field3').should eq('test3')

        @user.reload.test_field1.should eq('test1')
        @user.reload.test_field2.should eq('test2')
        @user.reload.test_field3.should eq('test3')
      end
    end
  end
end